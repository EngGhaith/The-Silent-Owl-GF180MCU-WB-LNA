import json, sys, numpy as np
from scipy.optimize import differential_evolution
import lna_eval as e

VARS = [("rld2_len", 6, 80), ("ld2", 0.5, 12), ("ld4", 0.2, 4), ("rld3_len", 12, 45),
        ("ribcs_len", 17.8, 90), ("ribcg_len", 20, 60), ("mnc", 15, 34), ("m1", 2, 7),
        ("m2", 2, 5.49), ("m4", 4, 24), ("rcas1_len", 8, 30), ("c11_w", 30, 110),
        ("wsf", 10, 60), ("msf", 1, 20), ("msk", 1, 20), ("lout", 0, 8)]
LO = [v[1] for v in VARS]; HI = [v[2] for v in VARS]
TARGET = 15.5
PMAX = float(sys.argv[1]) if len(sys.argv) > 1 else 250

def over_of(x):
    d = dict(zip([v[0] for v in VARS], x))
    return {"XRLD2.r_length": f"{d['rld2_len']:.2f}u", "LD2": f"{d['ld2']:.3f}n", "LD4": f"{d['ld4']:.3f}n",
            "XRLD3.r_length": f"{d['rld3_len']:.2f}u", "XRIBCS.r_length": f"{d['ribcs_len']:.2f}u",
            "XRIBCG.r_length": f"{d['ribcg_len']:.2f}u", "XMNC.m": int(round(d["mnc"])), "XM1.m": int(round(d["m1"])),
            "XM2.m": int(round(d["m2"])), "XM4.m": int(round(d["m4"])), "XRCAS1.r_length": f"{d['rcas1_len']:.2f}u",
            "XC11.c_width": f"{d['c11_w']:.1f}u", "XC11.c_length": f"{d['c11_w']:.1f}u",
            "_buf": (d["wsf"], int(round(d["msf"])), int(round(d["msk"]))),
            "_out": (d["lout"] * 1e-9, 0.0, 0.0)}

def metrics_cost(r):
    if "err" in r or len(r.get("s21", [])) != 21 or "vnb" not in r:
        return 1e3
    s21min = min(r["s21"]); p = abs(r["idd"]) * 5e3
    pen = 3 * max(0, max(r["s11"]) + 11) + 3 * max(0, max(r["s22"]) + 11)
    pen += 10 * max(0, max(r["nf"]) - 3.0) + 2 * max(0, np.mean(r["nf"]) - 2.6)
    pen += 0.2 * max(0, p - PMAX)
    for m in (r["vds4"] - r["vdsat4"], r["vds1"] - r["vdsat1"], r["vnb"] - r["vdsatk"], r["vdssf"] - r["vdsatsf"]):
        pen += 10 * max(0, 0.4 - m)
    pen += 10 * max(0, r["vnb"] - 3.0)  # sink is a 3.3 V device
    return -min(s21min, TARGET) + pen + 0.05 * (max(r["s21"]) - s21min) + 0.2 * np.mean(r["nf"]) + 0.004 * p

def cost(x):
    return metrics_cost(e.evaluate(over_of(x)))

X0 = [10, 3.35, 0.5, 19.8, 30, 30.4, 27, 3, 3, 13, 16.6, 70, 29.4, 6, 6, 0.01]
if __name__ == "__main__":
    print("X0", cost(X0), flush=True)
    res = differential_evolution(cost, list(zip(LO, HI)), popsize=12, maxiter=150, tol=1e-5,
                                 workers=6, updating="deferred", seed=2, polish=False, disp=True, x0=X0)
    o = over_of(res.x)
    print("BEST", json.dumps(o))
    print(e.summary(e.evaluate(o)))
