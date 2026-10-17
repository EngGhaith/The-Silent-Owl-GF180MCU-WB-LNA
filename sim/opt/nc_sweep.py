import re, subprocess, sys, os, math
S = os.path.dirname(os.path.abspath(__file__))
base = open(f"{S}/lna-core_tb.spice").read()
base = re.sub(r"^\.control.*?^\.endc\s*$", "", base, flags=re.M | re.S)
base = re.sub(r"^\.end\s*$", "", base, flags=re.M)

POLY = {"ppolyf_u": (350, 25.5e-9, 60), "ppolyf_u_1k": (1000, 14.8e-9, 85.45)}
def si(v): return float(v.replace("u", "e-6"))

def idealize(txt):
    out = []
    for ln in txt.split("\n"):
        m = re.match(r"^(XR\S+) (\S+) (\S+) \S+ (ppolyf_u(?:_1k)?) r_width=(\S+) r_length=(\S+)(?: m=(\d+))?", ln)
        if m:
            rsh, dw, rt = POLY[m.group(4)]
            w, l, mm = si(m.group(5)), si(m.group(6)), int(m.group(7) or 1)
            weff = w - 2 * dw
            r = (rsh * l / weff + 2 * rt * 1e-6 / weff) / mm
            out.append(f"R{m.group(1)[1:]}_id {m.group(2)} {m.group(3)} {r:.4g}")
        else:
            out.append(ln)
    return "\n".join(out)

def set_m(txt, inst, m):
    # m= sits on a continuation line of the instance
    lines = txt.split("\n")
    for i, ln in enumerate(lines):
        if ln.startswith(inst + " "):
            j = i
            while not re.search(r"\bm=\d+", lines[j]): j += 1
            lines[j] = re.sub(r"\bm=\d+", f"m={m}", lines[j])
            return "\n".join(lines)
    raise KeyError(inst)

def run(deck):
    fn = f"{S}/deck_{os.getpid()}.spice"
    open(fn, "w").write(deck)
    p = subprocess.run(["ngspice", "-b", fn], capture_output=True, text=True, cwd=S)
    return p.stdout + p.stderr

def sim(mnc, m1=3, lcs=17.8):
    net = set_m(set_m(base, "XMNC", mnc), "XM1", m1)
    net = re.sub(r"^(XRIBCS .*r_length=)\S+", lambda m: f"{m.group(1)}{lcs}u", net, flags=re.M)
    # S-params + Idd with original ports and PDK resistors
    sp = net + """
.control
op
echo IDD $&i(VDD)
sp lin 21 1G 3G
let s11=db(S_1_1)
let s21=db(S_2_1)
let s22=db(S_2_2)
let a=vecmax(s11)
let b=vecmax(s22)
let c=vecmin(s21)
let d=vecmax(s21)
echo S11 $&a
echo S22 $&b
echo S21MIN $&c
echo S21MAX $&d
.endc
.end
"""
    o = run(sp)
    r = {k: float(v) for k, v in re.findall(r"^(IDD|S11|S22|S21MIN|S21MAX) (\S+)", o, re.M)}
    # noise with ideal resistors, 50 ohm source/load
    nz = idealize(net)
    nz = re.sub(r"^V1 rf_in_ext GND .*$", "V1 src GND DC 0 AC 1\nRSRC src rf_in_ext 50", nz, flags=re.M)
    nz = re.sub(r"^V2 rf_out_ext GND .*$", "RL2 rf_out_ext GND 50", nz, flags=re.M)
    nz += """
.control
noise v(rf_out_ext) V1 lin 21 1G 3G 1
setplot noise1
let nf=10*log10((onoise_spectrum^2-onoise_rl2^2)/onoise_rsrc^2)
let nn=length(nf)
let i=0
while i < nn
  let ff=frequency[i]
  let vv=nf[i]
  echo NF $&ff $&vv
  let i=i+1
end
.endc
.end
"""
    o2 = run(nz)
    nf = [(float(f), float(v)) for f, v in re.findall(r"^NF (\S+) (\S+)", o2, re.M)]
    if not nf or not r:
        print(o[-1500:], o2[-1500:]); sys.exit(1)
    r["nf"] = nf
    return r

if __name__ == "__main__":
    combos = [tuple(map(float, a.split(","))) for a in sys.argv[1:]] or [(27, 3, 17.8)]
    print(f"{'mNC':>4} {'m1':>3} {'Lcs':>5} {'Idd mA':>7} {'P mW':>6} {'NF@1G':>6} {'NF@2G':>6} {'NF@3G':>6} {'NFavg':>6} {'NFmax':>6} {'S11':>6} {'S22':>6} {'S21min':>6} {'S21max':>6}")
    for mnc, m1, lcs in combos:
        mnc, m1 = int(mnc), int(m1)
        r = sim(mnc, m1, lcs)
        nf = dict(r["nf"]); vals = [v for _, v in r["nf"]]
        idd = abs(r["IDD"]) * 1e3
        g = lambda f: min(nf.items(), key=lambda kv: abs(kv[0] - f))[1]
        print(f"{mnc:>4} {m1:>3} {lcs:5.1f} {idd:7.1f} {idd*5:6.0f} {g(1e9):6.2f} {g(2e9):6.2f} {g(3e9):6.2f} {sum(vals)/len(vals):6.2f} {max(vals):6.2f} {r['S11']:6.1f} {r['S22']:6.1f} {r['S21MIN']:6.1f} {r['S21MAX']:6.1f}")
