#!/usr/bin/env python3
"""
Post-layout (PEX) simulation of lna_core_parts: schematic vs. extracted layout, same testbench.

  python3 make_lna_core_pex.py                      # all steps, C and RC extraction, coil models "rl"
  python3 make_lna_core_pex.py --extract none       # re-simulate only (extracted netlists in pex/ are reused)
  python3 make_lna_core_pex.py --model snp2le       # broadband EM coil models instead of L + R

Steps (all output in klayout/pex/):
  1 gds      make_lna_core_pex_gds.py: lna_core_parts.gds without the coils, port labels at the coil terminals on
             internal nets (pex_vm2, pex_vx, pex_input_cg)
  2 extract  team script analog_pad_sp_paramerters/pex_extraction_script/magic_pex_gf180_v7.py (magic, flat)
               c  : devices + parasitic C (to vss and coupling), cthresh 0.1 fF     -> lna_core_parts_pex_c.spice
               rc : + distributed wire R of the signal / bias nets (own magic script, extresist all; vss / vdd
                    lumped)                                                       -> lna_core_parts_pex_rc.spice
  3 wrapper  lna_core_parts_pex_<c|rc>_wrap.spice: subckt lna_core_parts with the pin order of the schematic =
             extracted netlist + the five EM coil models (xschem/*_model.lib) on the coil terminals
  4 sim      testbench taken from xschem/lna-core_tb.sch (netlisted here: same .param values, bond wires, pads
             gf180mcu_fd_io__asig_5p0 PEX, bias sources, g_cg source), DUT = lna_core_parts as
               sch : xschem subcircuits (lna_core_parts.sch and its four blocks)
               c / rc : the PEX wrappers
             op, sp (S-parameters) and .noise (NF; sp noise of ngspice is ~2 dB off). NF uses a 50 ohm source /
             load resistor instead of the ports: NF = 10 log10((onoise^2 - onoise_rl^2) / onoise_rsrc^2)
  5 report   sim/pex_compare.txt (table) + sim/pex_compare.png (S11, S21, S22, NF over frequency)
Note: the PDK poly resistors have no thermal noise in ngspice (same for all variants, only bias resistors here).
"""
import argparse
import math
import os
import re
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
XSCHEM = os.path.join(ROOT, "xschem")
PEX = os.path.join(HERE, "pex")
SIM = os.path.join(PEX, "sim")
TB = "lna-core_tb.sch"
MAGIC_PEX = os.path.join(ROOT, "analog_pad_sp_paramerters", "pex_extraction_script", "magic_pex_gf180_v7.py")
GDS = os.path.join(PEX, "lna_core_parts_pex.gds")
MAGICRC = "/foss/pdks/gf180mcuD/libs.tech/magic/gf180mcuD.magicrc"
# RC: own magic script (the team script's rcx mode only splits nets above the extresist delay tolerance, here 1 of
# 11); vss / vdd are left lumped (supply mesh + decap tiles: 180 000 resistors, no RF information)
RC_TCL = """drc off
locking disable
crashbackups stop
gds read {gds}
load lna_core_parts
flatten lna_core_parts_flat
load lna_core_parts_flat
select top cell
extract path {ext}
extract do unique
extract do capacitance
extract do resistance
extract all
ext2sim labels on
ext2sim -p {ext}
extresist tolerance 1
extresist ignore vss
extresist ignore vdd
extresist all
ext2spice default
ext2spice lvs
ext2spice format ngspice
ext2spice merge none
ext2spice cthresh 0.1
ext2spice extresist on
ext2spice resistor tee on
ext2spice subcircuit on
ext2spice -p {ext} -o {out}
quit -noprompt
"""
BLOCKS = ("lna_core_parts", "lna_core_cg", "lna_core_cs", "lna_core_input_match", "lna_core_output_match")
# coil models on the extracted netlist: (instance, node 1, node 2, model); pex_* = port labels of step 1
COILS = (("XLEQ", "rf_in_pad", "vss", "LEQ_model"), ("XL1", "pex_input_cg", "vss", "LSHUNT_OUT_model"),
         ("XLD4", "vdd", "pex_vm2", "LD4_model"), ("XLD2", "vdd", "pex_vx", "LD2_model"),
         ("XLSHUNT_OUT", "rf_out_pad", "vss", "LSHUNT_OUT_model"))
FSTART, FSTOP, NPTS = 0.5e9, 5e9, 91
BAND = (1e9, 3e9)
FMARK = (1e9, 1.5e9, 2e9, 2.4e9, 3e9)


def run(cmd, cwd, log=None):
    print("+", " ".join(cmd), flush=True)
    r = subprocess.run(cmd, cwd=cwd, capture_output=True, text=True, env={**os.environ, "PWD": cwd})  # xschem: $::env(PWD)
    if log:
        with open(log, "w") as f:
            f.write(r.stdout + r.stderr)
    if r.returncode:
        sys.exit(f"failed ({r.returncode}): {' '.join(cmd)}\n{(r.stdout + r.stderr)[-3000:]}")
    return r.stdout


def joined(lines):
    """spice lines with the '+' continuations merged"""
    out = []
    for ln in lines:
        if ln.startswith("+") and out:
            out[-1] += " " + ln[1:].strip()
        else:
            out.append(ln.rstrip("\n"))
    return out


def tb_parts(model):
    """netlist lna-core_tb.sch: model includes (coil model section replaced), .params, DUT subcircuits"""
    run(["xschem", "-n", "-s", "-q", "-x", "-o", SIM, TB], XSCHEM)
    lines = joined(open(os.path.join(SIM, "lna-core_tb.spice")).readlines())
    inc, par, sub, cur, ctl = [], [], {}, None, False
    for ln in lines:
        low = ln.lower()
        if low.startswith(".control"):
            ctl = True
        elif low.startswith(".endc"):
            ctl = False
        elif ctl:
            continue
        elif low.startswith(".subckt"):
            cur = ln.split()[1]
            sub[cur] = [ln]
        elif cur:
            sub[cur].append(ln)
            if low.startswith(".ends"):
                cur = None
        elif low.startswith((".include", ".lib")):
            inc.append(re.sub(r"(_model\.lib)\s+\w+$", rf"\1 {model}", ln))
        elif low.startswith(".param"):
            par.append(ln)
    missing = [b for b in BLOCKS if b not in sub]
    assert not missing, f"{TB}: subcircuits {missing} not in the netlist"
    pins = sub["lna_core_parts"][0].split()[2:]
    return inc, par, "\n".join("\n".join(sub[b]) for b in BLOCKS), pins


def extract(kind):
    out = os.path.join(PEX, f"lna_core_parts_pex_{kind}.spice")
    if kind == "c":
        run([sys.executable, MAGIC_PEX, GDS, "--pdk", "gf180mcuD", "--mode", "pex", "--flatten", "--cthresh", "0.1",
             "--merge", "none", "--no-wrapper", "--output", out], PEX, os.path.join(PEX, "run_c.out"))
        return out
    work = os.path.join(PEX, "magic_rc")
    os.makedirs(os.path.join(work, "ext"), exist_ok=True)
    with open(os.path.join(work, "rc.tcl"), "w") as f:
        f.write(RC_TCL.format(gds=GDS, ext="ext", out=out))
    run(["magic", "-dnull", "-noconsole", "-rcfile", MAGICRC, "rc.tcl"], work, os.path.join(PEX, "run_rc.out"))
    assert os.path.exists(out), f"magic wrote no {out}, see pex/run_rc.out"
    return out


def wrapper(kind, pins):
    """subckt lna_core_parts (schematic pin order) = extracted flat netlist + the EM coil models"""
    src = os.path.join(PEX, f"lna_core_parts_pex_{kind}.spice")
    lines = joined(open(src).readlines())
    head = next(ln for ln in lines if ln.lower().startswith(".subckt"))
    name, fpins = head.split()[1], head.split()[2:]
    assert set(pins) <= set(fpins), f"{src}: pins {set(pins) - set(fpins)} missing"
    extra = set(fpins) - set(pins) - {n for c in COILS for n in c[1:3]}
    assert not extra, f"{src}: unexpected pins {extra}"
    dst = os.path.join(PEX, f"lna_core_parts_pex_{kind}_wrap.spice")
    with open(dst, "w") as f:
        f.write(f"* lna_core_parts post-layout ({kind}): {os.path.basename(src)} + EM coil models (make_lna_core_pex.py)\n")
        f.write(f".include {src}\n")
        f.write(f".subckt lna_core_parts {' '.join(pins)}\n")
        f.write(f"Xpex {' '.join(fpins)} {name}\n")
        for inst, a, b, m in COILS:
            f.write(f"{inst} {a} {b} {m}\n")
        f.write(".ends\n")
    return dst


def testbench(var, inc, par, dut, pins):
    """op + sp + noise on lna_core_parts (DUT) in the lna-core_tb environment"""
    data = os.path.join(SIM, f"{var}")
    x4 = "x4 " + " ".join(pins) + " lna_core_parts"
    deck = f"""* lna_core_parts PEX comparison, variant {var} (make_lna_core_pex.py)
{chr(10).join(inc)}
{chr(10).join(par)}
{dut}
VDD vdd 0 {{VDD}}
VSS vss 0 0
VDDIO vddio 0 {{VDDIO_SUP}}
VBCG vbias_cg 0 {{VBIAS_CG}}
VBCS vbias_cs 0 {{VBIAS_CS}}
VBCAS vbias_cas 0 {{VBIAS_CAS}}
V3 g_cg 0 1
LBW_IN rf_in_pad net1 {{L_BW}}
RBW_IN net1 rf_in_ext {{R_BW}}
LBW_OUT rf_out_pad net2 {{L_BW}}
RBW_OUT net2 rf_out_ext {{R_BW}}
x2 rf_in_pad vddio 0 vddio 0 gf180mcu_fd_io__asig_5p0
x3 rf_out_pad vddio 0 vddio 0 gf180mcu_fd_io__asig_5p0
{x4}
* S-parameter ports (sp) / 50 ohm source + load (noise): switched with alter in .control
V1 rf_in_ext 0 DC 0 AC 1 portnum 1 z0 50
V2 rf_out_ext 0 DC 0 AC 0 portnum 2 z0 50
.control
set wr_singlescale
set wr_vecnames
op
print -i(vdd) > {data}_op_print.txt
sp lin {NPTS} {FSTART} {FSTOP} 0
let s11db = db(s_1_1)
let s21db = db(s_2_1)
let s12db = db(s_1_2)
let s22db = db(s_2_2)
wrdata {data}_sp.txt s11db s21db s12db s22db
.endc
.end
"""
    noise = f"""* lna_core_parts PEX comparison, variant {var}, NF (make_lna_core_pex.py)
{chr(10).join(inc)}
{chr(10).join(par)}
{dut}
VDD vdd 0 {{VDD}}
VSS vss 0 0
VDDIO vddio 0 {{VDDIO_SUP}}
VBCG vbias_cg 0 {{VBIAS_CG}}
VBCS vbias_cs 0 {{VBIAS_CS}}
VBCAS vbias_cas 0 {{VBIAS_CAS}}
V3 g_cg 0 1
LBW_IN rf_in_pad net1 {{L_BW}}
RBW_IN net1 rf_in_ext {{R_BW}}
LBW_OUT rf_out_pad net2 {{L_BW}}
RBW_OUT net2 rf_out_ext {{R_BW}}
x2 rf_in_pad vddio 0 vddio 0 gf180mcu_fd_io__asig_5p0
x3 rf_out_pad vddio 0 vddio 0 gf180mcu_fd_io__asig_5p0
{x4}
VSRC src 0 DC 0 AC 1
RSRC src rf_in_ext 50
RL2 rf_out_ext 0 50
.control
set wr_singlescale
set wr_vecnames
noise v(rf_out_ext) VSRC lin {NPTS} {FSTART} {FSTOP} 1
setplot noise1
let nf = 10*log10((onoise_spectrum^2 - onoise_rl2^2) / onoise_rsrc^2)
wrdata {data}_nf.txt nf
.endc
.end
"""
    for suffix, text in (("", deck), ("_noise", noise)):
        path = os.path.join(SIM, f"tb_{var}{suffix}.spice")
        with open(path, "w") as f:
            f.write(text)
        run(["ngspice", "-b", path], SIM, os.path.join(SIM, f"tb_{var}{suffix}.log"))


def table(path):
    rows = [ln.split() for ln in open(path) if ln.strip()]
    head = rows[0]
    return {h: [float(r[i]) for r in rows[1:]] for i, h in enumerate(head)}


def at(d, key, f):
    fr = d["frequency"]
    i = min(range(len(fr)), key=lambda k: abs(fr[k] - f))
    return d[key][i]


def band(d, key, fn):
    return fn(v for fq, v in zip(d["frequency"], d[key]) if BAND[0] - 1 <= fq <= BAND[1] + 1)


def report(variants):
    res = {}
    for v in variants:
        sp, nf = table(os.path.join(SIM, f"{v}_sp.txt")), table(os.path.join(SIM, f"{v}_nf.txt"))
        idd = open(os.path.join(SIM, f"{v}_op_print.txt")).read().split("=")[-1].strip()
        res[v] = (sp, nf, float(idd))
    lab = {"sch": "schematic", "c": "PEX C", "rc": "PEX RC"}
    lines = [f"lna_core_parts: schematic vs. PEX (make_lna_core_pex.py), band {BAND[0]/1e9:g}-{BAND[1]/1e9:g} GHz",
             "", f"{'':24}" + "".join(f"{lab[v]:>12}" for v in variants)]
    lines.append(f"{'I(VDD) mA':24}" + "".join(f"{res[v][2]*1e3:12.2f}" for v in variants))
    for key, name, fn in (("s21db", "S21 min dB (band)", min), ("s21db", "S21 max dB (band)", max),
                          ("s11db", "S11 max dB (band)", max), ("s22db", "S22 max dB (band)", max),
                          ("s12db", "S12 max dB (band)", max)):
        lines.append(f"{name:24}" + "".join(f"{band(res[v][0], key, fn):12.2f}" for v in variants))
    lines.append(f"{'NF max dB (band)':24}" + "".join(f"{band(res[v][1], 'nf', max):12.2f}" for v in variants))
    for f in FMARK:
        lines.append("")
        for key, d in (("s21db", 0), ("s11db", 0), ("s22db", 0), ("nf", 1)):
            name = f"{key[:3].upper()} @ {f/1e9:g} GHz"
            lines.append(f"{name:24}" + "".join(f"{at(res[v][d], key, f):12.2f}" for v in variants))
    txt = "\n".join(lines) + "\n"
    with open(os.path.join(SIM, "pex_compare.txt"), "w") as fh:
        fh.write(txt)
    print(txt)
    try:
        import matplotlib
        matplotlib.use("Agg")
        import matplotlib.pyplot as plt
    except ImportError:
        return
    fig, ax = plt.subplots(2, 2, figsize=(11, 7.5), sharex=True)
    style = {"sch": ("k", "-"), "c": ("tab:blue", "--"), "rc": ("tab:red", "-.")}
    for (r, c), key, title in (((0, 0), "s21db", "S21 / dB"), ((0, 1), "nf", "NF / dB"),
                               ((1, 0), "s11db", "S11 / dB"), ((1, 1), "s22db", "S22 / dB")):
        a = ax[r][c]
        for v in variants:
            d = res[v][1] if key == "nf" else res[v][0]
            a.plot([f / 1e9 for f in d["frequency"]], d[key], color=style[v][0], ls=style[v][1], label=lab[v])
        a.axvspan(BAND[0] / 1e9, BAND[1] / 1e9, color="0.92", zorder=0)
        a.set_title(title)
        a.grid(alpha=0.4)
    for a in ax[1]:
        a.set_xlabel("f / GHz")
    ax[0][0].legend()
    fig.suptitle("lna_core_parts: schematic vs. post-layout")
    fig.tight_layout()
    fig.savefig(os.path.join(SIM, "pex_compare.png"), dpi=110)


def main():
    p = argparse.ArgumentParser(description=__doc__.split("\n")[1])
    p.add_argument("--extract", choices=("c", "rc", "both", "none"), default="both")
    p.add_argument("--model", choices=("rl", "snp2le", "ideal"), default="rl", help="coil model section")
    a = p.parse_args()
    os.makedirs(SIM, exist_ok=True)
    kinds = {"both": ("c", "rc"), "none": ()}.get(a.extract, (a.extract,))
    if kinds:
        run(["klayout", "-b", "-r", os.path.join(HERE, "make_lna_core_pex_gds.py")], HERE)
        for k in kinds:
            extract(k)
    inc, par, sch, pins = tb_parts(a.model)
    variants = ["sch"] + [k for k in ("c", "rc") if os.path.exists(os.path.join(PEX, f"lna_core_parts_pex_{k}.spice"))]
    for v in variants:
        dut = sch if v == "sch" else f".include {wrapper(v, pins)}"
        testbench(v, inc, par, dut, pins)
    report(variants)


if __name__ == "__main__":
    main()
