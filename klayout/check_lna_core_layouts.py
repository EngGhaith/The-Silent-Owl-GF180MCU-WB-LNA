#!/usr/bin/env python3
"""
DRC + LVS of the lna_core sub-cell layouts (klayout/lna_core_*.gds) with the gf180mcuD KLayout decks.

Usage:  python3 check_lna_core_layouts.py [cg cs input_match output_match parts] [--no-drc] [--no-lvs] [--run_dir DIR]

DRC: run_drc.py --variant=D (5LM, 11 kA top metal, MIM option B), deep mode, density off (block level).
LVS: reference = xschem netlist of xschem/<cell>.sch (netlisted here, then PDK spice converter) with
  - spirals and their ideal loss resistors removed (no inductor device in the PDK LVS deck); the spiral cells
    (<cell>__L*) are removed from the layout copy as well, so both spiral terminals stay separate nets
  - RS_EQ1 (0.05 ohm M3 source model) shorted: net1 -> vss
  - MIM W/L rounded to 10 nm like the layout, cap_mim_2f0_m4m5_noshield -> cap_mim_2f0fF
  - ideal capa.sym capacitors (C1 of the input / output match) -> cap_mim_2f0fF with the drawn W/L
    (klayout/lna_core_layouts.json, written by make_lna_core_layouts.py)
  gf180mcu.lvs with the switches of run_lvs.py --variant=D --combine --top_lvl_pins --lvs_sub=vss, plus
  implicit_connect: equally named nets (vss pieces that the macro vss ring joins later) count as one net
lna_core_parts: reference = lna_core_parts.sch with the four blocks mapped as above, plus the MIM decaps of the
  supply tiles (CDCPL*, vdd / vss, counted from the layout - they are not in the schematic); the layout copy is
  flattened and implicit_connect is off, so every net (incl. vss / vdd between the blocks) must be joined by metal
GUI: every LVS run also writes klayout/lvs/<cell>_lvs.gds (layout copy as checked) + <cell>_lvs.spice (reference);
  open the .gds in KLayout and use "gf180mcu PDK > Run Klayout LVS" (it picks up the .spice of the same name)
"""
import glob
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
XSCHEM = os.path.join(HERE, "..", "xschem")
PDK_KL = "/foss/pdks/gf180mcuD/libs.tech/klayout/tech"
CELLS = ["input_match", "cg", "cs", "output_match", "parts"]
SHORTS = {"lna_core_cs": {"net1": "vss"}}  # RS_EQ1


def snap(v_um):
    """MIM W/L as drawn (make_lna_core_layouts.um_grid): rounded to 10 nm"""
    return round(v_um, 2)


def ref_netlist(cell, out_dir):
    raw = os.path.join(out_dir, cell + "_xschem.spice")
    subprocess.run(["xschem", "-q", "-x", "-n", "-s", "-o", out_dir, "--netlist_filename", os.path.basename(raw),
                    os.path.join(XSCHEM, cell + ".sch")], cwd=XSCHEM, check=True, capture_output=True)
    conv = os.path.join(out_dir, cell + "_conv.spice")
    subprocess.run(["python3", os.path.join(PDK_KL, "lvs", "gf180_xschem_klayout_spice_convert.py"), raw, "-o", conv],
                   check=True, capture_output=True)
    # sub-circuits: the netlisted schematic ("**.subckt" comment header) and, for lna_core_parts, its blocks
    subs, cur = {}, None
    for ln in (ln.strip() for ln in open(conv)):
        if ln.lstrip("*").lower().startswith(".subckt"):
            tok = ln.lstrip("*").split()
            cur = tok[1]
            subs[cur] = (tok[2:], [])
        elif ln.lstrip("*").lower().startswith(".ends"):
            cur = None
        elif cur and ln and not ln.startswith(("*", ".")):
            subs[cur][1].append(ln)
    text = ""
    for name, (pins, body) in subs.items():
        pins, out = map_subckt(name, pins, body)
        if name == cell == "lna_core_parts":
            out += decap_lines()
        text += f".SUBCKT {name} {' '.join(pins)}\n" + "\n".join(out) + "\n.ENDS\n"
    ref = os.path.join(out_dir, cell + "_ref.spice")
    open(ref, "w").write(text)
    return ref


def map_subckt(cell, pins, body):
    """schematic -> drawn devices (see module doc); returns (pins, element lines)"""
    # inductors + the ideal resistors in series with them (loss models): drop
    ind_nets = set()
    for ln in body:
        if ln[0] in "Ll":
            ind_nets.update(ln.split()[1:3])
    out = []
    short = SHORTS.get(cell, {})
    for ln in body:
        tok = ln.split()
        if tok[0][0] in "Ll":
            continue
        if tok[0][0] in "Rr" and len(tok) == 4:  # ideal R: name n1 n2 value
            if set(tok[1:3]) & (ind_nets | set(short)):
                continue
        tok = [short.get(t, t) for t in tok]
        if tok[0][0] in "Cc" and len(tok) == 4:  # ideal C: name n1 n2 value -> MIM as drawn
            mim = json.load(open(os.path.join(HERE, "lna_core_layouts.json")))[cell][tok[0]]
            tok = tok[:3] + ["cap_mim_2f0fF", f"W={mim['W']}u", f"L={mim['L']}u"]
        if "cap_mim_2f0_m4m5_noshield" in tok:
            tok = ["cap_mim_2f0fF" if t == "cap_mim_2f0_m4m5_noshield" else t for t in tok]
            tok = [re.sub(r"^([WL])=([\d.]+)u$", lambda m_: f"{m_.group(1)}={snap(float(m_.group(2)))}u", t) for t in tok]
        out.append(" ".join(tok))
    pins = [short.get(p, p) for p in pins]
    return list(dict.fromkeys(pins)), out


def decap_lines():
    """supply-tile MIM decaps of lna_core_parts.gds (not in the schematic): one capacitor per plate size between
    vdd (top plate) and vss (bottom plate), multiplicity = number of plates found in the layout"""
    import klayout.db as kdb
    ly = kdb.Layout()
    ly.read(os.path.join(HERE, "lna_core_parts.gds"))
    top = ly.cell("lna_core_parts")
    ft = kdb.Region(top.begin_shapes_rec(ly.layer(75, 0))).merged()  # FuseTop = MIM top plates
    blocks = kdb.Region()
    for inst in top.each_inst():
        if inst.cell.name.startswith("lna_core_") and inst.cell.name != "lna_core_supply":
            blocks += kdb.Region(inst.cell.begin_shapes_rec(ly.layer(75, 0))).transformed(inst.cplx_trans)
    sizes = {}
    for p in (ft - blocks.merged()).each():
        b = p.bbox()
        k = (round(b.width() * ly.dbu, 3), round(b.height() * ly.dbu, 3))
        sizes[k] = sizes.get(k, 0) + 1
    return [f"CDCPL{i} vdd vss cap_mim_2f0fF W={w}u L={l}u M={n}" for i, ((w, l), n) in enumerate(sorted(sizes.items()))]


def lvs_layout(cell, out_dir):
    """copy of the layout without the spiral inductor cells; lna_core_parts is flattened (strict top-level check:
    the blocks' vss / vdd pieces must be joined by real metal, see run_lvs)"""
    gds = os.path.join(HERE, cell + ".gds")
    scr = os.path.join(out_dir, "strip.py")
    open(scr, "w").write(
        "import pya\nly = pya.Layout()\nly.read(src)\n"
        "for c in list(ly.each_cell()):\n"
        "    if c.name.split('__')[-1][:1] == 'L' and '__' in c.name:\n"
        "        ly.delete_cell_rec(c.cell_index())\n"
        "if flat == '1':\n"
        "    ly.top_cell().flatten(True)\n"
        "ly.write(dst)\n")
    dst = os.path.join(out_dir, cell + "_lvs.gds")
    flat = "1" if cell == "lna_core_parts" else "0"
    subprocess.run(["klayout", "-b", "-r", scr, "-rd", f"src={gds}", "-rd", f"dst={dst}", "-rd", f"flat={flat}"],
                   check=True, capture_output=True)
    return dst


def run_drc(cell, run_dir):
    d = os.path.join(run_dir, "drc_" + cell)
    os.makedirs(d, exist_ok=True)
    for f in glob.glob(os.path.join(d, "*.lyrdb")):
        os.remove(f)
    r = subprocess.run(["python3", os.path.join(PDK_KL, "drc", "run_drc.py"), f"--path={os.path.join(HERE, cell + '.gds')}",
                        "--variant=D", f"--run_dir={d}", "--mp=8", "--run_mode=deep"], capture_output=True, text=True)
    viol = {}
    for t in re.findall(r"\| ERROR\s+\| (\w+) generated an exception", r.stdout + r.stderr):
        if t == "mslot":  # PDK deck bug: the mslot table does not load contact / via layers -> rerun as "main"
            sw = ["thr=4", "metal_top=11K", "mim_option=B", "metal_level=5LM", "verbose=false", "feol=true",
                  "beol=true", "offgrid=true", "conn_drc=true", "density=false", "split_deep=false", "slow_via=false",
                  f"topcell={cell}", f"input={os.path.join(HERE, cell + '.gds')}",
                  f"report={os.path.join(d, cell + '_mslot.lyrdb')}", "run_mode=deep", "table_name=main"]
            rr = subprocess.run(["klayout", "-b", "-r", os.path.join(d, "mslot.drc")] + sum([["-rd", x] for x in sw], []),
                                capture_output=True, text=True)
            if rr.returncode == 0:
                continue
        viol[f"{t} deck crashed"] = 1
    for f in glob.glob(os.path.join(d, "*.lyrdb")):
        txt = open(f).read()
        for cat in re.findall(r"<item>.*?<category>'?([^<']+?)'?</category>", txt, re.S):
            viol[cat] = viol.get(cat, 0) + 1
    return viol, d


def run_lvs(cell, run_dir):
    d = os.path.join(run_dir, "lvs_" + cell)
    os.makedirs(d, exist_ok=True)
    ref = ref_netlist(cell, d)
    lay = lvs_layout(cell, d)
    # same pair for the KLayout menu "gf180mcu PDK > Run Klayout LVS": it takes <gds>.spice next to the opened GDS
    gui = os.path.join(HERE, "lvs")
    os.makedirs(gui, exist_ok=True)
    shutil.copy(lay, os.path.join(gui, cell + "_lvs.gds"))
    shutil.copy(ref, os.path.join(gui, cell + "_lvs.spice"))
    sw = {"thr": 4, "run_mode": "deep", "metal_top": "11K", "mim_option": "B", "metal_level": "5LM", "poly_res": "1k",
          "mim_cap": "2", "lvs_sub": "vss", "verbose": "false", "spice_net_names": "true", "spice_comments": "false",
          "scale": "false", "schematic_simplify": "false", "net_only": "false", "top_lvl_pins": "true", "combine": "true",
          "purge": "false", "purge_nets": "false", "implicit_connect": "false" if cell == "lna_core_parts" else "true", "topcell": cell, "input": lay,
          "schematic": ref, "report": os.path.join(d, cell + ".lvsdb"), "target_netlist": os.path.join(d, cell + ".cir")}
    cmd = ["klayout", "-b", "-r", os.path.join(PDK_KL, "lvs", "gf180mcu.lvs")]
    for k, v in sw.items():
        cmd += ["-rd", f"{k}={v}"]
    r = subprocess.run(cmd, capture_output=True, text=True, cwd=d)
    log = r.stdout + r.stderr
    ok = "Congratulations! Netlists match" in log
    return ok, d, log


def main():
    args = sys.argv[1:]
    run_dir = os.path.join(tempfile.gettempdir(), "lna_core_checks")
    if "--run_dir" in args:
        i = args.index("--run_dir")
        run_dir = args[i + 1]
        del args[i:i + 2]
    cells = [a for a in args if not a.startswith("--")] or CELLS
    for c in cells:
        cell = "lna_core_" + c
        if "--no-drc" not in args:
            viol, d = run_drc(cell, run_dir)
            print(f"{cell:24s} DRC {'clean' if not viol else 'VIOLATIONS ' + str(viol)}   ({d})", flush=True)
        if "--no-lvs" not in args:
            ok, d, log = run_lvs(cell, run_dir)
            print(f"{cell:24s} LVS {'match' if ok else 'MISMATCH'}   ({d})", flush=True)
            if not ok:
                print("\n".join(log.splitlines()[-15:]))


main()
