import json, re, sys, numpy as np
import lna_eval as e

BEST = json.loads(open(sys.argv[1]).read()) if len(sys.argv) > 1 else None

RSH = {"res_typical": (350, 1000), "res_ss": (420, 1200), "res_ff": (280, 800)}
TC1 = {"ppolyf_u": -0.9e-4, "ppolyf_u_1k": -9.39e-4}

def set_res_corner(rc, temp):
    dt = temp - 27
    a, b = RSH[rc]
    e.POLY["ppolyf_u"] = (a * (1 + TC1["ppolyf_u"] * dt), 25.5e-9, 60)
    e.POLY["ppolyf_u_1k"] = (b * (1 + TC1["ppolyf_u_1k"] * dt), 14.8e-9, 85.45)

CORNERS = [  # mos, res, mim, temp, vdd
    ("typical", "res_typical", "mimcap_typical", 27, 5.0),
    ("ss", "res_ss", "mimcap_ss", 125, 4.5), ("ss", "res_ss", "mimcap_ss", -40, 4.5),
    ("ff", "res_ff", "mimcap_ff", -40, 5.5), ("ff", "res_ff", "mimcap_ff", 125, 5.5),
    ("ss", "res_ff", "mimcap_typical", 125, 4.5), ("ff", "res_ss", "mimcap_typical", -40, 5.5),
    ("sf", "res_typical", "mimcap_typical", 27, 5.0), ("fs", "res_typical", "mimcap_typical", 27, 5.0),
    ("typical", "res_ss", "mimcap_ss", 27, 5.0), ("typical", "res_ff", "mimcap_ff", 27, 5.0),
    ("typical", "res_typical", "mimcap_typical", -40, 5.0), ("typical", "res_typical", "mimcap_typical", 125, 5.0),
    ("typical", "res_typical", "mimcap_typical", 27, 4.5), ("typical", "res_typical", "mimcap_typical", 27, 5.5),
]

def stability(over, libs, temp, vdd):
    net = e.apply(e.base, over)
    for a, b in libs.items():
        net = re.sub(rf"(sm141064\.ngspice) {a}$", rf"\1 {b}", net, flags=re.M)
    net = re.sub(r"^\.param VDD=\S+", f".param VDD={vdd}", net, flags=re.M)
    deck = net + f".temp {temp}\n" + """
.control
sp dec 40 10meg 20G
let k=0
let n=length(frequency)
while k < n
  let f=frequency[k]
  let a=real(S_1_1[k])
  let b=imag(S_1_1[k])
  let c=real(S_1_2[k])
  let d=imag(S_1_2[k])
  let g=real(S_2_1[k])
  let h=imag(S_2_1[k])
  let p=real(S_2_2[k])
  let q=imag(S_2_2[k])
  echo ST $&f $&a $&b $&c $&d $&g $&h $&p $&q
  let k=k+1
end
.endc
.end
"""
    o = e.run(deck, "st")
    rows = np.array([[float(x) for x in l.split()] for l in re.findall(r"^ST (.*)$", o, re.M)])
    f = rows[:, 0]
    s11 = rows[:, 1] + 1j * rows[:, 2]; s12 = rows[:, 3] + 1j * rows[:, 4]
    s21 = rows[:, 5] + 1j * rows[:, 6]; s22 = rows[:, 7] + 1j * rows[:, 8]
    dl = s11 * s22 - s12 * s21
    mu = (1 - abs(s11) ** 2) / (abs(s22 - np.conj(s11) * dl) + abs(s12 * s21))
    mu2 = (1 - abs(s22) ** 2) / (abs(s11 - np.conj(s22) * dl) + abs(s12 * s21))
    sel = (f > 1e8) & (f < 1e10)
    m = np.minimum(mu, mu2)[sel]; i = np.argmin(m)
    return m[i], f[sel][i]

if __name__ == "__main__":
    configs = {"baseline": {}}
    if BEST: configs["buffer"] = BEST
    for name, over in configs.items():
        print(f"===== {name}")
        for mos, res, mim, t, v in CORNERS:
            set_res_corner(res, t)
            libs = {"typical": mos, "res_typical": res, "mimcap_typical": mim}
            r = e.evaluate(over, corner_lib=libs, temp=t, vdd=v)
            mu, fmu = stability(over, libs, t, v)
            print(f"{mos:7s} {res:11s} {mim:14s} {t:4d}C {v:.1f}V  {e.summary(r)}  mu_min={mu:.2f}@{fmu/1e9:.2f}G", flush=True)
