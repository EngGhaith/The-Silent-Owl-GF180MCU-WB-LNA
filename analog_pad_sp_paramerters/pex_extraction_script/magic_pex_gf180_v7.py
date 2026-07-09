#!/usr/bin/env python3
"""
*****************************************************************************************
*****************************************************************************************
* SSCS-Chipathon 2026, Team A38: The Silent Owl
* File Version: Ver 1.0
* editor: Ahmed M. Elnaggar, elnaggar@email.sc.edu
* github: @elnaggar
*****************************************************************************************
*This Python script aim to automate and check the parasitic extraction using magic layout
*****************************************************************************************
*****************************************************************************************
Requires Python 3.10+.
*****************************************************************************************
Terminal input example:
python3 magic_pex_gf180_v7.py gf180mcu_fd_io__asig_5p0.mag \
  --pdk gf180mcuD \
  --mode rcx \
  --flatten \
  --cthresh 0.1 \
  --extresist-thresh-ohm 10 \
  --merge none \
  --no-wrapper \
  --check-junctions \
  --keep-temp \
  --log asig_5p0_rcx_magic.log \
  --live \
  --progress-interval 15
*****************************************************************************************
Help:
python3 magic_pex_gf180_v7.py -h
*****************************************************************************************
"""
from __future__ import annotations

import argparse
import datetime as dt
import glob
import hashlib
import os
import re
import shutil
import subprocess
import sys
import tempfile
import threading
import time
from pathlib import Path
from typing import Iterable

SCRIPT_NAME = "magic_pex_gf180_v7.py"
MIN_PYTHON = (3, 10)

# -----------------------------------------------------------------------------
# Console / filesystem helpers
# -----------------------------------------------------------------------------

def die(msg: str, code: int = 1) -> None:
    print(f"[ERROR] {msg}", file=sys.stderr, flush=True)
    sys.exit(code)


def warn(msg: str) -> None:
    print(f"[WARN] {msg}", file=sys.stderr, flush=True)


def info(msg: str) -> None:
    print(f"[INFO] {msg}", flush=True)


def ok(msg: str) -> None:
    print(f"[OK] {msg}", flush=True)


def require_python() -> None:
    if sys.version_info < MIN_PYTHON:
        die(f"Python {MIN_PYTHON[0]}.{MIN_PYTHON[1]}+ required; found {sys.version.split()[0]}")


def tcl_brace(x: str | Path) -> str:
    s = str(x)
    return "{" + s.replace("\\", "\\\\").replace("}", "\\}") + "}"


def slug(x: object) -> str:
    s = str(x).replace(".", "p").replace("-", "m").replace("/", "_")
    s = re.sub(r"[^A-Za-z0-9_]+", "_", s)
    return s.strip("_") or "none"


def ensure_parent(path: str | Path) -> None:
    Path(path).expanduser().resolve().parent.mkdir(parents=True, exist_ok=True)


def sha256_file(path: str | Path) -> str:
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for block in iter(lambda: f.read(1024 * 1024), b""):
            h.update(block)
    return h.hexdigest()


def tail_text(path: str | Path, n: int = 80) -> str:
    try:
        return "".join(Path(path).read_text(errors="replace").splitlines(True)[-n:])
    except Exception as e:
        return f"<could not read log: {e}>"


def human_elapsed(seconds: float) -> str:
    seconds = int(seconds)
    h = seconds // 3600
    m = (seconds % 3600) // 60
    s = seconds % 60
    return f"{h:02d}:{m:02d}:{s:02d}"


def dir_stats(path: Path) -> tuple[int, int]:
    if not path.exists():
        return 0, 0
    nfiles = 0
    nbytes = 0
    for p in path.rglob("*"):
        if p.is_file():
            nfiles += 1
            try:
                nbytes += p.stat().st_size
            except OSError:
                pass
    return nfiles, nbytes

# -----------------------------------------------------------------------------
# PDK / Magic / KLayout helpers
# -----------------------------------------------------------------------------

def detect_input_type(path: str | Path) -> str:
    ext = Path(path).suffix.lower()
    if ext in (".gds", ".gds2", ".gdsii"):
        return "gds"
    if ext == ".mag":
        return "mag"
    die(f"Unsupported input extension '{ext}'. Use .gds/.gds2/.gdsii/.mag")


def resolve_magic_rc(pdk_root: str | None, pdk: str, rcfile: str | None) -> Path:
    if rcfile:
        p = Path(rcfile).expanduser().resolve()
        if not p.exists():
            die(f"--rcfile not found: {p}")
        if p.name.endswith("GDS.tech"):
            warn("GDS-exact Magic tech files are for viewing, not extraction. Prefer the PDK .magicrc startup script.")
        return p
    if not pdk_root:
        die("PDK_ROOT is not set. Use $PDK_ROOT, --pdk-root, or --rcfile.")
    root = Path(pdk_root).expanduser().resolve()
    candidates = [root / pdk / "libs.tech" / "magic" / f"{pdk}.magicrc", root / "libs.tech" / "magic" / f"{pdk}.magicrc"]
    for c in candidates:
        if c.exists():
            return c
    die("Could not find Magic rcfile. Searched:\n  " + "\n  ".join(map(str, candidates)))


def find_magic() -> str:
    preferred = Path("/usr/local/bin/magic")
    if preferred.exists():
        return str(preferred)
    found = shutil.which("magic")
    if found:
        return found
    die("Magic binary not found in PATH")


def magic_version(magic_bin: str) -> str:
    try:
        r = subprocess.run([magic_bin, "--version"], stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                           text=True, timeout=15, check=False)
        return r.stdout.strip().splitlines()[0] if r.stdout.strip() else "unknown"
    except Exception:
        return "unknown"


def find_top_cell_klayout(gds: str | Path) -> str:
    gds = Path(gds).expanduser().resolve()
    script = f"""
import sys
try:
    import klayout.db as kdb
except ImportError as e:
    print('IMPORT_ERROR:' + str(e), file=sys.stderr)
    sys.exit(2)
ly = kdb.Layout()
ly.read({str(gds)!r})
tops = [c.name for c in ly.top_cells() if not c.name.startswith('$$$')]
for t in tops:
    print(t)
"""
    helper = None
    last = "unknown"
    try:
        with tempfile.NamedTemporaryFile("w", suffix="_find_top.py", delete=False) as f:
            helper = f.name
            f.write(script)
        for runner in (["uv", "run", "python"], ["python3"], ["python"]):
            try:
                r = subprocess.run(runner + [helper], stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                                   text=True, timeout=120, check=False)
            except Exception as e:
                last = str(e)
                continue
            if r.returncode:
                last = r.stderr.strip() or r.stdout.strip()
                continue
            tops = [x.strip() for x in r.stdout.splitlines() if x.strip()]
            if len(tops) == 1:
                return tops[0]
            if len(tops) > 1:
                die("Multiple GDS top cells found; rerun with --cell.\n  " + "\n  ".join(tops))
            last = "no top cell found"
    finally:
        if helper and os.path.exists(helper):
            os.remove(helper)
    die(f"Could not auto-detect top cell with KLayout. Last error: {last}")

# -----------------------------------------------------------------------------
# SPICE parsing / wrapper helpers
# -----------------------------------------------------------------------------

def spice_continued_lines(lines: Iterable[str]) -> Iterable[str]:
    cur = ""
    for raw in lines:
        line = raw.rstrip("\n")
        if line.lstrip().startswith("+") and cur:
            cur += " " + line.lstrip()[1:].strip()
        else:
            if cur:
                yield cur
            cur = line
    if cur:
        yield cur


def parse_subckt_pins(spice: str | Path, subckt: str) -> list[str] | None:
    target = subckt.lower()
    with open(spice, "r", errors="replace") as f:
        for line in spice_continued_lines(f):
            s = line.strip()
            if not s or s.startswith("*"):
                continue
            tok = s.split()
            if len(tok) >= 2 and tok[0].lower() == ".subckt" and tok[1].lower() == target:
                pins = []
                for t in tok[2:]:
                    if "=" in t or t.lower().startswith("params:"):
                        break
                    pins.append(t)
                return pins
    return None


def strip_dot_end(spice: str | Path) -> list[str]:
    with open(spice, "r", errors="replace") as f:
        return [line for line in f if not re.match(r"^\s*\.end\s*$", line, re.I)]


def map_pin_by_suffix(extracted_pin: str, clean_pins: list[str]) -> str | None:
    if extracted_pin in clean_pins:
        return extracted_pin
    suffix = extracted_pin.split(".")[-1]
    if suffix in clean_pins:
        return suffix
    return None


def validate_exact_wrapper(raw: str | Path, extract_cell: str, pins: str, force: bool) -> None:
    user = pins.split()
    if not user:
        die("--pins was provided but no pins were parsed")
    got = parse_subckt_pins(raw, extract_cell)
    if got is None:
        msg = f"Could not find .subckt {extract_cell}; cannot validate wrapper pins."
        if force:
            warn(msg + " Continuing due to --force-wrapper.")
            return
        die(msg + " Use --no-wrapper, --force-wrapper, or --clean-wrapper-by-suffix.")
    if got != user:
        msg = f"Wrapper pin mismatch.\nUser --pins       : {' '.join(user)}\nExtracted .subckt : {' '.join(got)}"
        if force:
            warn(msg + "\nContinuing due to --force-wrapper.")
        else:
            die(msg + "\nUse exact extracted pin order, --no-wrapper, --force-wrapper, or --clean-wrapper-by-suffix.")


def build_clean_wrapper(raw: str | Path, top: str, extract_cell: str, clean_pins: str, force: bool) -> str:
    clean = clean_pins.split()
    if not clean:
        die("--clean-wrapper-by-suffix requires a non-empty pin list")
    extracted = parse_subckt_pins(raw, extract_cell)
    if extracted is None:
        die(f"Could not find .subckt {extract_cell}; cannot build clean wrapper")
    mapped: list[str] = []
    unmapped: list[str] = []
    for p in extracted:
        m = map_pin_by_suffix(p, clean)
        if m is None:
            unmapped.append(p)
            mapped.append(p)
        else:
            mapped.append(m)
    if unmapped and not force:
        die("Cannot suffix-map all extracted pins. Unmapped examples:\n  " +
            "\n  ".join(unmapped[:20]) +
            "\nUse --force-wrapper to pass unmapped pins through unchanged, or do not use --clean-wrapper-by-suffix.")
    if unmapped:
        warn("Some extracted pins could not be suffix-mapped and will be passed through unchanged: " + ", ".join(unmapped[:10]))
    return f"""
* -----------------------------------------------------------------------------
* Clean suffix-mapped wrapper for Xschem/ngspice
* -----------------------------------------------------------------------------
.subckt {top} {' '.join(clean)}
X_{top}_pex {' '.join(mapped)} {extract_cell}
.ends {top}

.end
"""

# -----------------------------------------------------------------------------
# Junction report
# -----------------------------------------------------------------------------

def analyze_junctions(spice: str | Path) -> dict[str, object]:
    mos = mos_geom = dcnt = xdio = 0
    missing: list[tuple[str, list[str]]] = []
    bulk: dict[str, int] = {}
    diode_re = re.compile(r"(diode|dio|pn|ndio|pdio|schottky|antenna)", re.I)
    with open(spice, "r", errors="replace") as f:
        for line in spice_continued_lines(f):
            s = line.strip()
            if not s or s[0] in "*.":
                continue
            tok = s.split()
            lead = tok[0][0].upper()
            if lead == "D":
                dcnt += 1
            elif lead == "M":
                mos += 1
                keys = {t.split("=", 1)[0].upper() for t in tok if "=" in t}
                miss = [k for k in ("AS", "AD", "PS", "PD") if k not in keys]
                if miss:
                    missing.append((tok[0], miss))
                else:
                    mos_geom += 1
                if len(tok) >= 5:
                    bulk[tok[4]] = bulk.get(tok[4], 0) + 1
            elif lead == "X":
                sub = next((t for t in reversed(tok[1:]) if "=" not in t), "")
                if diode_re.search(sub):
                    xdio += 1
    return dict(mos=mos, mos_geom=mos_geom, mos_missing=len(missing),
                missing_examples=missing[:10], d=dcnt, xdio=xdio, bulk=bulk)


def print_junction_report(spice: str | Path) -> None:
    r = analyze_junctions(spice)
    print("=" * 72)
    print("  Junction / Diode Sanity Check")
    print("=" * 72)
    info(f"Explicit D devices       : {r['d']}")
    info(f"Diode-like X subckts     : {r['xdio']}")
    info(f"MOS devices              : {r['mos']}")
    info(f"MOS with AS/AD/PS/PD     : {r['mos_geom']}")
    info(f"MOS missing any geometry : {r['mos_missing']}")
    if r["missing_examples"]:
        print("\nExample MOS missing geometry:")
        for name, miss in r["missing_examples"]:
            print(f"    {name}: missing {','.join(miss)}")
    if r["bulk"]:
        print("\nMOS bulk nodes:")
        for node, count in sorted(r["bulk"].items(), key=lambda kv: (-kv[1], kv[0]))[:20]:
            print(f"    {node}: {count}")
    print("\nInterpretation: D/X diode lines are explicit diodes; MOS junctions are usually implicit via AS/AD/PS/PD.")

# -----------------------------------------------------------------------------
# Live Magic runner
# -----------------------------------------------------------------------------

def run_magic_live(cmd: list[str], env: dict[str, str], log_path: Path, temp_dir: Path,
                   interval: int = 30, timeout_min: float | None = None) -> int:
    start = time.time()
    stop = threading.Event()
    extdir = temp_dir / "extfiles"

    def heartbeat() -> None:
        while not stop.wait(max(1, interval)):
            elapsed = time.time() - start
            log_size = log_path.stat().st_size if log_path.exists() else 0
            nfiles, nbytes = dir_stats(extdir)
            print(
                f"[LIVE] Magic running {human_elapsed(elapsed)}; "
                f"log={log_size:,} bytes; extfiles={nfiles} files, {nbytes:,} bytes",
                flush=True,
            )

    hb = threading.Thread(target=heartbeat, daemon=True)
    hb.start()
    proc = subprocess.Popen(cmd, env=env, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                            text=True, bufsize=1)
    assert proc.stdout is not None
    timed_out = False
    with open(log_path, "w", buffering=1) as log:
        while True:
            line = proc.stdout.readline()
            if line:
                print(line, end="", flush=True)
                log.write(line)
                log.flush()
                if ("Error parsing" in line) or ("invalid command name" in line):
                    warn("Magic reported a Tcl parse error; terminating Magic instead of waiting at interactive prompt.")
                    proc.terminate()
                    try:
                        proc.wait(timeout=15)
                    except subprocess.TimeoutExpired:
                        warn("Magic did not terminate cleanly; killing it.")
                        proc.kill()
                    break
            elif proc.poll() is not None:
                break
            if timeout_min is not None and (time.time() - start) > timeout_min * 60.0:
                timed_out = True
                warn(f"Timeout reached ({timeout_min:g} min). Terminating Magic...")
                proc.terminate()
                try:
                    proc.wait(timeout=15)
                except subprocess.TimeoutExpired:
                    warn("Magic did not terminate cleanly; killing it.")
                    proc.kill()
                break
        # Drain any remaining output
        for line in proc.stdout:
            print(line, end="", flush=True)
            log.write(line)
    stop.set()
    hb.join(timeout=1)
    rc = proc.wait()
    elapsed = human_elapsed(time.time() - start)
    if timed_out:
        print(f"[LIVE] Magic timed out after {elapsed}", flush=True)
        return 124
    print(f"[LIVE] Magic finished with exit code {rc} after {elapsed}", flush=True)
    return rc

# -----------------------------------------------------------------------------
# Magic Tcl generation
# -----------------------------------------------------------------------------

def progress_puts(label: str) -> list[str]:
    # Magic-safe progress marker. Do not use Tcl [clock]; some Magic/Tcl builds
    # report: invalid command name "clock" in command files. Python --live
    # already prints elapsed time.
    return [f'puts "###PROGRESS {label}"', "flush stdout"]


def build_tcl(*, input_type: str, input_path: str, top_cell: str, layout_dir: str,
              mode: str, flatten: bool, port_makeall: bool, cthresh: float | None,
              rthresh: float | None, extresist_mohm: int | None,
              subcircuit_top: bool, hierarchy_off: bool, output_format: str,
              merge_mode: str, short_resistor: bool) -> tuple[list[str], str]:
    c = ["# Housekeeping", "drc off", "locking disable", "crashbackups stop", "box 0 0 0 0", ""]

    c += progress_puts("01_LOAD_START")
    c += ["# Load design"]
    if input_type == "gds":
        c += [f"gds read {tcl_brace(input_path)}", f"load {tcl_brace(top_cell)}"]
    else:
        c += [f"path search +{tcl_brace(layout_dir)}", f"load {tcl_brace(top_cell)}"]
    c += ["select top cell"]
    if port_makeall:
        c.append("port makeall")
    c += progress_puts("01_LOAD_DONE")

    extract_cell = top_cell
    if flatten:
        extract_cell = f"{top_cell}_flat"
        c += ["", *progress_puts("02_FLATTEN_START"), "# Flatten",
              f"flatten {tcl_brace(extract_cell)}", f"load {tcl_brace(extract_cell)}", "select top cell"]
        if port_makeall:
            c.append("port makeall")
        c.append(f"save {tcl_brace(extract_cell)}")
        c += progress_puts("02_FLATTEN_DONE")

    c += ["", *progress_puts("03_EXTRACT_SETUP_START"), "# Extraction setup", "extract path {extfiles}", "extract do unique"]
    if mode in ("pex", "rcx"):
        c.append("extract do capacitance")
    if mode == "rcx":
        c.append("extract do resistance")
        c.append(f"extresist threshold {extresist_mohm}")
    c += progress_puts("03_EXTRACT_ALL_START")
    c.append("extract all")
    c += progress_puts("03_EXTRACT_ALL_DONE")

    c += ["", *progress_puts("04_EXT2SPICE_SETUP_START"), "# ext2spice setup", "ext2spice default", "ext2spice lvs"]
    c += [f"ext2spice format {output_format}", f"ext2spice merge {merge_mode}"]
    if mode in ("pex", "rcx") and cthresh is not None:
        c.append(f"ext2spice cthresh {cthresh:g}")
    if rthresh is not None:
        c.append(f"ext2spice rthresh {rthresh:g}")
    if short_resistor:
        c.append("ext2spice short resistor")
    if mode == "rcx":
        c += ["ext2spice extresist on", "ext2spice resistor tee on"]
    c.append("ext2spice subcircuit top on" if subcircuit_top else "ext2spice subcircuit on")
    if hierarchy_off:
        c.append("ext2spice hierarchy off")
    c += progress_puts("04_EXT2SPICE_SETUP_DONE")

    c += ["", *progress_puts("05_EXT2SPICE_RUN_START"), "# Generate SPICE. Must match extract path above.", "ext2spice -p {extfiles}"]
    c += progress_puts("05_EXT2SPICE_RUN_DONE")
    c += ["", "quit -noprompt"]
    return c, extract_cell

# -----------------------------------------------------------------------------
# Output helpers
# -----------------------------------------------------------------------------

def output_name(base: str, out_dir: Path, pdk: str, mode: str, flat: bool,
                cthresh: float | None, rthresh: float | None, ext_mohm: int | None,
                output: str | None) -> str:
    if output:
        return str(Path(output).expanduser().resolve())
    tags = [f"pdk_{slug(pdk)}", mode, "flat" if flat else "hier"]
    if cthresh is not None:
        tags.append(f"cthresh_{slug(f'{cthresh:g}')}")
    if rthresh is not None:
        tags.append(f"rthresh_{slug(f'{rthresh:g}')}")
    if mode == "rcx":
        tags.append(f"extresist_{ext_mohm}mohm")
    return str(out_dir / f"{base}_pex__{'__'.join(tags)}.spice")


def header(**k) -> str:
    pins = f"* Pins          : {k['pins']}\n" if k.get("pins") else ""
    return f"""* -----------------------------------------------------------------------------
* Magic PEX Netlist
* Generated by   : {SCRIPT_NAME}
* Date           : {dt.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
* Original cell  : {k['top_cell']}
* Extract cell   : {k['extract_cell']}
* Mode           : {k['mode']}
* PDK variant    : {k['pdk']}
* PDK_ROOT       : {k['pdk_root']}
* Magic rcfile   : {k['rcfile']}
* Magic version  : {k['magic_version']}
* Input file     : {k['input_file']}
* Input SHA256   : {k['input_sha']}
* Command        : {k['command']}
{pins}* Options        : {k['options']}
* -----------------------------------------------------------------------------

"""


def write_final(raw: str | Path, final: str | Path, head: str, top: str,
                extract_cell: str, pins: str | None, no_wrapper: bool, force: bool,
                clean_wrapper_by_suffix: str | None) -> None:
    ensure_parent(final)
    if clean_wrapper_by_suffix:
        cleaned = strip_dot_end(raw)
        wrapper = build_clean_wrapper(raw, top, extract_cell, clean_wrapper_by_suffix, force)
        Path(final).write_text(head + "".join(cleaned) + wrapper)
        return
    if pins and not no_wrapper:
        validate_exact_wrapper(raw, extract_cell, pins, force)
        cleaned = strip_dot_end(raw)
        if top.lower() == extract_cell.lower():
            warn("Wrapper requested but extract cell equals top cell; skipping duplicate wrapper. For library cells, --no-wrapper is often better.")
            Path(final).write_text(head + "".join(cleaned) + "\n.end\n")
            return
        wrapper = f"""
* -----------------------------------------------------------------------------
* Top-level wrapper for Xschem/ngspice
* -----------------------------------------------------------------------------
.subckt {top} {pins}
X_{top}_pex {pins} {extract_cell}
.ends {top}

.end
"""
        Path(final).write_text(head + "".join(cleaned) + wrapper)
    else:
        Path(final).write_text(head + Path(raw).read_text(errors="replace"))


def count_spice(spice: str | Path) -> dict[str, int]:
    d = dict(lines=0, subckts=0, resistors=0, capacitors=0)
    with open(spice, "r", errors="replace") as f:
        for line in f:
            d["lines"] += 1
            s = line.strip()
            if not s or s.startswith("*"):
                continue
            lo = s.lower()
            if lo.startswith(".subckt"):
                d["subckts"] += 1
            elif s[0] in "Rr" and not lo.startswith(".model"):
                d["resistors"] += 1
            elif s[0] in "Cc" and not lo.startswith(".control"):
                d["capacitors"] += 1
    return d

# -----------------------------------------------------------------------------
# CLI / normalization
# -----------------------------------------------------------------------------

def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(
        description="Magic GF180/Open-PDK extraction script v6 with live progress.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Reasonable IO pad RCX with live progress:
  %(prog)s gf180mcu_fd_io__asig_5p0.mag --mode rcx --flatten --cthresh 0.1 --extresist-thresh-ohm 10 --merge none --no-wrapper --check-junctions --keep-temp --live --progress-interval 15

Coarser IO pad RCX if the first run is too slow:
  %(prog)s gf180mcu_fd_io__asig_5p0.mag --mode rcx --flatten --cthresh 1 --extresist-thresh-ohm 50 --merge none --no-wrapper --live

Clean PEX first pass:
  %(prog)s gf180mcu_fd_io__asig_5p0.mag --mode pex --flatten --cthresh 0.1 --merge aggressive --no-wrapper --check-junctions
""",
    )
    p.add_argument("input_file")
    p.add_argument("--pdk-root", default=os.environ.get("PDK_ROOT"))
    p.add_argument("--pdk", default=os.environ.get("PDK", "gf180mcuD"))
    p.add_argument("--rcfile")
    p.add_argument("--cell")
    p.add_argument("--mode", choices=["lvs", "pex", "rcx"], default="pex")
    p.add_argument("--rcx", action="store_true", help="Alias for --mode rcx")
    p.add_argument("--flatten", action="store_true")
    p.add_argument("--port-makeall", action="store_true", help="Opt-in: run Magic 'port makeall'. Off by default.")
    p.add_argument("--allow-hier-rcx", action="store_true")
    p.add_argument("--cthresh", type=float)
    p.add_argument("--rthresh", type=float)
    p.add_argument("--extresist-thresh-ohm", type=float)
    p.add_argument("--extresist-thresh-mohm", type=int)
    p.add_argument("--extresist-thresh", type=int, help="Deprecated alias for --extresist-thresh-mohm")
    p.add_argument("--short-resistor", action="store_true", help="Opt-in: emit 'ext2spice short resistor'.")
    p.add_argument("--no-short-resistor", action="store_true", help="Compatibility option; short resistor is already off by default.")
    p.add_argument("--subcircuit-top", action="store_true")
    p.add_argument("--hierarchy-off", action="store_true")
    p.add_argument("--format", dest="fmt", choices=["ngspice", "spice3"], default="ngspice")
    p.add_argument("--merge", choices=["none", "conservative", "aggressive"], default="none")
    p.add_argument("--output")
    p.add_argument("--pins")
    p.add_argument("--no-wrapper", action="store_true")
    p.add_argument("--force-wrapper", action="store_true")
    p.add_argument("--clean-wrapper-by-suffix")
    p.add_argument("--check-junctions", action="store_true")
    p.add_argument("--log")
    p.add_argument("--keep-temp", action="store_true")
    p.add_argument("--dry-run", action="store_true")
    p.add_argument("--live", action="store_true", help="Stream Magic output to terminal and log in real time.")
    p.add_argument("--progress-interval", type=int, default=30, help="Heartbeat interval in seconds for --live. Default: 30.")
    p.add_argument("--timeout-min", type=float, help="Optional timeout in minutes for Magic run.")
    return p.parse_args()


def normalize(a: argparse.Namespace) -> argparse.Namespace:
    if a.rcx:
        if a.mode != "pex":
            die("Use either --rcx or --mode, not both. (--rcx is an alias for --mode rcx.)")
        a.mode = "rcx"
    for name in ("cthresh", "rthresh", "extresist_thresh_ohm", "extresist_thresh_mohm", "extresist_thresh", "timeout_min"):
        v = getattr(a, name, None)
        if v is not None and v < 0:
            die(f"--{name.replace('_', '-')} must be >= 0")
    if a.progress_interval < 1:
        die("--progress-interval must be >= 1 second")
    thresh_sources = [a.extresist_thresh_ohm is not None, a.extresist_thresh_mohm is not None, a.extresist_thresh is not None]
    if sum(thresh_sources) > 1:
        die("Use only one extresist threshold option")
    if a.extresist_thresh is not None:
        warn("--extresist-thresh is deprecated and interpreted as milliohms. Use --extresist-thresh-mohm or --extresist-thresh-ohm.")
    if any(thresh_sources) and a.mode != "rcx":
        die("extresist threshold options require RCX mode. Use --mode rcx / --rcx, or remove the extresist threshold option.")
    if a.extresist_thresh_ohm is not None:
        a.ext_mohm = int(round(a.extresist_thresh_ohm * 1000.0))
    elif a.extresist_thresh_mohm is not None:
        a.ext_mohm = a.extresist_thresh_mohm
    elif a.extresist_thresh is not None:
        a.ext_mohm = a.extresist_thresh
    else:
        a.ext_mohm = 10000 if a.mode == "rcx" else None
    if a.rthresh is not None and a.mode != "rcx":
        info("--rthresh only emits 'ext2spice rthresh'. It does not enable distributed RCX/extresist.")
    if a.mode == "rcx" and not a.flatten and not a.allow_hier_rcx:
        warn("RCX mode requested; auto-enabling --flatten. Use --allow-hier-rcx to override.")
        a.flatten = True
    if a.short_resistor and a.no_short_resistor:
        die("Use only one of --short-resistor and --no-short-resistor")
    a.use_short_resistor = bool(a.short_resistor)
    if a.merge != "none":
        warn("Device merging is user-requested. For high-accuracy analog PEX/RCX, --merge none is usually safer.")
    is_lib = re.match(r"^(gf180mcu|sky130|ihp)[A-Za-z0-9_]*_fd_", Path(a.input_file).stem)
    if is_lib and a.flatten:
        warn("This looks like a PDK/library cell and --flatten is set. Avoid --port-makeall unless you want internal labels exposed as ports.")
    if is_lib and a.port_makeall:
        warn("--port-makeall on a flattened PDK/library cell may expose internal labels as .subckt pins.")
    if is_lib and a.short_resistor:
        warn("--short-resistor on PDK/library cells may add zero-ohm alias resistors; use only if you need port preservation.")
    if is_lib and a.pins and not a.no_wrapper and not a.clean_wrapper_by_suffix:
        warn("PDK/library cell with --pins: consider --no-wrapper first and inspect extracted .subckt pin order.")
    if a.clean_wrapper_by_suffix and a.no_wrapper:
        die("--clean-wrapper-by-suffix conflicts with --no-wrapper")
    return a

# -----------------------------------------------------------------------------
# Run helpers / main
# -----------------------------------------------------------------------------

def link_or_copy(src: Path, dst: Path) -> None:
    try:
        os.symlink(src, dst)
    except OSError:
        shutil.copy2(src, dst)


def locate_spice(extract_cell: str, top: str) -> str | None:
    for n in (f"{extract_cell}.spice", f"{top}.spice"):
        if Path(n).exists():
            return n
    fs = sorted(glob.glob("*.spice"), key=lambda x: Path(x).stat().st_mtime, reverse=True)
    return fs[0] if fs else None


def main() -> None:
    require_python()
    a = normalize(parse_args())
    inp = Path(a.input_file).expanduser().resolve()
    if not inp.exists():
        die(f"Input not found: {inp}")
    itype = detect_input_type(inp)
    base = inp.stem
    rc = resolve_magic_rc(a.pdk_root, a.pdk, a.rcfile)
    mbin = find_magic()
    mver = magic_version(mbin)
    pdkroot = str(Path(a.pdk_root).expanduser().resolve()) if a.pdk_root else "<rcfile override>"
    top = a.cell or (base if itype == "mag" else find_top_cell_klayout(inp))
    final = output_name(base, inp.parent, a.pdk, a.mode, a.flatten, a.cthresh, a.rthresh, a.ext_mohm, a.output)

    opts = []
    if a.flatten: opts.append("flatten")
    if a.port_makeall: opts.append("port_makeall")
    opts.append(f"mode={a.mode}")
    if a.cthresh is not None: opts.append(f"cthresh={a.cthresh:g}")
    if a.rthresh is not None: opts.append(f"rthresh={a.rthresh:g}")
    if a.mode == "rcx": opts.append(f"extresist={a.ext_mohm}mohm")
    opts += [f"format={a.fmt}", f"merge={a.merge}"]
    if a.use_short_resistor: opts.append("short_resistor")
    if a.clean_wrapper_by_suffix: opts.append("clean_wrapper_by_suffix")
    if a.live: opts.append("live")
    optstr = ", ".join(opts)

    print("=" * 72)
    print("  Magic GF180/Open-PDK v7 Extraction")
    print("=" * 72)
    for k, v in [
        ("Input file", inp), ("Input type", itype.upper()), ("Top cell", top),
        ("Mode", a.mode.upper()), ("PDK_ROOT", pdkroot), ("PDK", a.pdk),
        ("Magic rcfile", rc), ("Magic binary", mbin), ("Magic version", mver),
        ("Flatten", "yes" if a.flatten else "no"),
        ("port makeall", "yes" if a.port_makeall else "no"),
        ("short resistor", "yes" if a.use_short_resistor else "no"),
        ("RCX/extresist", f"on, {a.ext_mohm} mOhm" if a.mode == "rcx" else "off"),
        ("Live output", "yes" if a.live else "no"),
        ("Output", final),
    ]:
        info(f"{k:14}: {v}")
    print("=" * 72)

    temp = tempfile.mkdtemp(prefix="magic_pex_")
    orig = Path.cwd()
    try:
        os.chdir(temp)
        Path("extfiles").mkdir(exist_ok=True)
        if itype == "gds":
            tin = Path(temp) / f"{base}.gds"
            link_or_copy(inp, tin)
            layout_dir = temp
            tcl_input = str(tin)
        else:
            layout_dir = str(inp.parent)
            tcl_input = top
        cmds, extract_cell = build_tcl(
            input_type=itype, input_path=tcl_input, top_cell=top, layout_dir=layout_dir,
            mode=a.mode, flatten=a.flatten, port_makeall=a.port_makeall,
            cthresh=a.cthresh, rthresh=a.rthresh, extresist_mohm=a.ext_mohm,
            subcircuit_top=a.subcircuit_top, hierarchy_off=a.hierarchy_off,
            output_format=a.fmt, merge_mode=a.merge, short_resistor=a.use_short_resistor)
        tcl = Path(temp) / "magic_pex_extract.tcl"
        tcl.write_text("# Auto-generated by magic_pex_gf180_v7.py\n" + "\n".join(cmds) + "\n")
        info(f"Generated TCL script: {tcl}")
        print("-" * 72)
        print(tcl.read_text())
        print("-" * 72)
        if a.dry_run:
            ok("Dry run complete; Magic was not executed.")
            return
        env = os.environ.copy()
        env["PDK"] = a.pdk
        if a.pdk_root:
            env["PDK_ROOT"] = pdkroot
        log = Path(temp) / "magic_stdout.log"
        cmd = [mbin, "-dnull", "-noconsole", "-rcfile", str(rc), str(tcl)]
        info(f"Magic log path: {log}")
        info("Starting Magic...")
        if a.live:
            result_code = run_magic_live(cmd, env, log, Path(temp), a.progress_interval, a.timeout_min)
        else:
            with open(log, "w") as lf:
                res = subprocess.run(cmd, env=env, stdout=lf, stderr=subprocess.STDOUT, check=False)
            result_code = res.returncode
        if a.log:
            ul = Path(a.log).expanduser()
            ul = ul if ul.is_absolute() else orig / ul
            ensure_parent(ul)
            shutil.copy2(log, ul)
            info(f"Magic log copied to: {ul}")
        else:
            info(f"Magic log saved in temp directory: {log}")
        if result_code:
            print("\nLast lines of Magic log:\n" + "-" * 72)
            print(tail_text(log))
            print("-" * 72)
            die(f"Magic failed with exit code {result_code}")
        raw = locate_spice(extract_cell, top)
        if raw is None:
            print("\nLast lines of Magic log:\n" + "-" * 72)
            print(tail_text(log))
            print("-" * 72)
            die("Magic did not produce a SPICE file")
        head = header(top_cell=top, extract_cell=extract_cell, mode=a.mode, pdk=a.pdk,
                      pdk_root=pdkroot, rcfile=rc, magic_version=mver, input_file=inp,
                      input_sha=sha256_file(inp), command=" ".join([Path(sys.argv[0]).name] + sys.argv[1:]),
                      options=optstr, pins=a.pins or a.clean_wrapper_by_suffix)
        write_final(raw, final, head, top, extract_cell, a.pins, a.no_wrapper, a.force_wrapper, a.clean_wrapper_by_suffix)
        cnt = count_spice(final)
        print("=" * 72)
        print("  Extraction Complete")
        print("=" * 72)
        ok(f"Output file : {final}")
        for k in ("lines", "subckts", "resistors", "capacitors"):
            info(f"{k.capitalize():11}: {cnt[k]:,}")
        if a.check_junctions:
            print()
            print_junction_report(final)
    finally:
        os.chdir(orig)
        if a.keep_temp:
            warn(f"Temp directory preserved: {temp}")
        else:
            shutil.rmtree(temp, ignore_errors=True)

if __name__ == "__main__":
    main()
