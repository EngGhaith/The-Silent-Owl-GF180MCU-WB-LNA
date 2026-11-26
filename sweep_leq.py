"""Swap the LEQ_MAIN rl model for each coil candidate and re-run the ngspice testbench.

L and R are taken straight from each coil's EM .s1p at 2.4 GHz:
    Z11 = 50*(1+S11)/(1-S11),  L = Im(Z11)/w,  R = Re(Z11)
which is the same definition the committed LEQ_MAIN_model.lib rl section uses.
"""
import os, re, math, cmath, shutil, subprocess

F0 = 2.4e9
RP = "/foss/designs/rapidpassives/try4/newflow"
XS = "/foss/designs/The-Silent-Owl-GF180MCU-WB-LNA/chipalooza_sim/xschem"
LIB = os.path.join(XS, "LEQ_MAIN_model.lib")
NET = "/tmp/simrun/tb.spice"

CANDS = [
    ("D418.0 square (in schematic)", f"{RP}/output/run_leq_main_data/run_leq_main.s1p"),
    ("RECT_FINAL X247/Y174", f"{RP}/good_tries/LEQ_MAIN_RECT_FINAL_X247.0_Y174.0_N2_W26/LEQ_MAIN_RECT_series.s1p"),
    ("RECT cand1 X244/Y174", f"{RP}/good_tries/LEQ_MAIN_RECT_cand1_X244.0_Y174.0_N2_W26/output/run_leq_main_rect_data/run_leq_main_rect.s1p"),
    ("RECT4 X130.8/Y314", f"{RP}/good_tries/LEQ_MAIN_RECT4_X130.8_Y314.0_N2_W26/output/run_leq_main_rect4_data/run_leq_main_rect4.s1p"),
    ("L1_RECT3 X314/Y118", f"{RP}/good_tries/L1_RECT3_X314.0_Y118.0_N2_W26/output/run_l1_rect3_data/run_l1_rect3.s1p"),
    ("LSHUNT_OUT_RECT_CAND3", f"{RP}/good_tries/LSHUNT_OUT_RECT_CAND3_X314.0_Y112.5_N2_W26/output/run_lshunt_rect3_data/run_lshunt_rect3.s1p"),
]


def zat(p):
    fmt, z0, unit, rows = "ri", 50.0, 1e9, []
    for ln in open(p, errors="ignore"):
        ln = ln.strip()
        if not ln or ln.startswith("!"):
            continue
        if ln.startswith("#"):
            t = ln.upper().replace("#", " ").split()
            for u, m in (("HZ", 1.0), ("KHZ", 1e3), ("MHZ", 1e6), ("GHZ", 1e9)):
                if u in t: unit = m
            for f in ("RI", "MA", "DB"):
                if f in t: fmt = f.lower()
            if "R" in t:
                try: z0 = float(t[t.index("R") + 1])
                except Exception: pass
            continue
        v = ln.split()
        if len(v) >= 3:
            rows.append((float(v[0]) * unit, float(v[1]), float(v[2])))
    f, a, b = min(rows, key=lambda r: abs(r[0] - F0))
    s = complex(a, b) if fmt == "ri" else cmath.rect(a if fmt == "ma" else 10 ** (a / 20), math.radians(b))
    z = z0 * (1 + s) / (1 - s)
    return f, z.imag / (2 * math.pi * f), z.real


orig = open(LIB).read()
shutil.copy(LIB, LIB + ".orig")
results = []
try:
    for name, s1p in CANDS:
        f, L, R = zat(s1p)
        new = re.sub(r"(\.lib rl\n\.SUBCKT LEQ_MAIN_MODEL p1 p2\nR1 p1 mid_LEQ_MAIN )[0-9.eE+-]+(\nL1 mid_LEQ_MAIN p2 )[0-9.eE+-]+n",
                     lambda m: "%s%.4f%s%.4fn" % (m.group(1), R, m.group(2), L * 1e9), orig)
        assert ("%.4f" % R) in new and ("%.4fn" % (L * 1e9)) in new, "substitution failed for " + name
        open(LIB, "w").write(new)
        d = "/tmp/simrun/" + re.sub(r"[^A-Za-z0-9]+", "_", name)
        os.makedirs(d, exist_ok=True)
        subprocess.run(["ngspice", "-b", NET], cwd=d, capture_output=True, text=True)
        rep = os.path.join(d, "lna_core_06V_cgcs_report.txt")
        vals = {}
        for ln in open(rep):
            m = re.match(r"(S11_DB|S21_DB|S22_DB|NF_DB)\s+(-?[0-9.eE+-]+)", ln)
            if m: vals[m.group(1)] = float(m.group(2))
            m2 = re.match(r"NF_DB\s+-?[0-9.eE+-]+\s+NFMIN_DB\s+(-?[0-9.eE+-]+)", ln)
            if m2: vals["NFMIN_DB"] = float(m2.group(1))
        results.append((name, L * 1e9, R, vals))
        print("%-32s L=%.4f nH  R=%.4f ohm  Q=%.3f" % (name, L * 1e9, R, 2 * math.pi * f * L / R))
finally:
    open(LIB, "w").write(orig)
    os.remove(LIB + ".orig")

print("\n%-32s %8s %8s | %8s %8s %8s %8s %8s" %
      ("candidate", "L[nH]", "R[ohm]", "Gain", "S11", "S22", "NF", "NFmin"))
for name, L, R, v in results:
    print("%-32s %8.4f %8.4f | %8.3f %8.3f %8.3f %8.3f %8.3f" %
          (name, L, R, v.get("S21_DB", float("nan")), v.get("S11_DB", float("nan")),
           v.get("S22_DB", float("nan")), v.get("NF_DB", float("nan")), v.get("NFMIN_DB", float("nan"))))
