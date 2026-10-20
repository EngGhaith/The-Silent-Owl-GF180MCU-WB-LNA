"""Evaluate lna_core variants: Idd, S-params (PDK models) and NF via .noise (ideal poly R).
Overrides: {"XM1.m": 4, "XRLD2.r_length": "14u", "LD2": "4n", ...}
LD2/LD4 get series loss R = 2*pi*1.55G*L/7 (same model as L1/LSER) when LOSS=True."""
import re, subprocess, os, math, json, sys
S = os.path.dirname(os.path.abspath(__file__))
base = open(f"{S}/lna-core_tb.spice").read()
base = re.sub(r"^\.control.*?^\.endc\s*$", "", base, flags=re.M | re.S)
base = re.sub(r"^\.end\s*$", "", base, flags=re.M)
# join continuation lines so params are easy to edit
base = re.sub(r"\n\+", " ", base)

POLY = {"ppolyf_u": (350, 25.5e-9, 60), "ppolyf_u_1k": (1000, 14.8e-9, 85.45)}
def si(v):
    v = str(v); mult = {"f": 1e-15, "p": 1e-12, "n": 1e-9, "u": 1e-6, "m": 1e-3, "k": 1e3}
    return float(v[:-1]) * mult[v[-1]] if v[-1] in mult else float(v)

def poly_r(kind, w, l, m):
    rsh, dw, rt = POLY[kind]; weff = w - 2 * dw
    return (rsh * l / weff + 2 * rt * 1e-6 / weff) / m

def apply(net, over, loss=True):
    over = dict(over)
    out = over.pop("_out", None)
    if out:  # output match: series LOUT (Q=7) after C11, shunt COUTP at pad side, COUTD at drain side
        lout, cp, cd = out
        net = re.sub(r"^(XC11 net2) rf_out_pad", r"\1 nout", net, flags=re.M)
        rl = 2 * math.pi * 1.55e9 * lout / 7
        extra = f"LOUT nout nout_x {lout:.4g}\nRLOUT_loss nout_x rf_out_pad {rl:.4g}\n" if lout > 1e-11 else "RLOUT nout rf_out_pad 1m\n"
        if cp > 1e-15: extra += f"COUTP rf_out_pad vss {cp:.4g}\n"
        if cd > 1e-15: extra += f"COUTD net2 vss {cd:.4g}\n"
        net = re.sub(r"^(\.ends)", extra + r"\1", net, count=1, flags=re.M)
    buf = over.pop("_buf", None)
    if buf:  # source follower XMSF (nfet_06v0) from net2 -> nbuf, sink XMSK (nfet_03v3) mirrored from vbias_cs
        wsf, msf, msk = buf
        net = re.sub(r"^(XC11) net2 ", r"\1 nbuf ", net, flags=re.M)
        l2 = re.search(r"^XM2 .*$", net, re.M).group(0)
        lnc = re.search(r"^XMNC .*$", net, re.M).group(0)
        sf = re.sub(r"^XM2 \S+ \S+ \S+ \S+", "XMSF vdd net2 nbuf vss", l2)
        sf = re.sub(r"\bW=\S+", f"W={wsf:.3g}u", sf); sf = re.sub(r"\bm=\d+", f"m={msf}", sf)
        sk = re.sub(r"^XMNC \S+ \S+ \S+ \S+", "XMSK nbuf vbias_cs vss vss", lnc)
        sk = re.sub(r"\bm=\d+", f"m={msk}", sk)
        net = re.sub(r"^(\.ends)", sf + "\n" + sk + "\n" + r"\1", net, count=1, flags=re.M)
    lines = net.split("\n")
    for key, val in over.items():
        inst, _, par = key.partition(".")
        for i, ln in enumerate(lines):
            if ln.split(" ")[0] == inst:
                if par:
                    if re.search(rf"\b{par}=", ln):
                        lines[i] = re.sub(rf"\b{par}=\S+", f"{par}={val}", ln)
                    else:
                        lines[i] = ln + f" {par}={val}"
                else:  # plain value of R/L/C
                    f = ln.split(" "); f[3] = str(val); lines[i] = " ".join(f)
                break
        else:
            raise KeyError(inst)
    net = "\n".join(lines)
    if loss:
        for L in ("LD2", "LD4"):
            m = re.search(rf"^{L} (\S+) (\S+) (\S+)", net, re.M)
            r = 2 * math.pi * 1.55e9 * si(m.group(3)) / 7
            net = net.replace(m.group(0), f"{L} {m.group(1)} {L}_x {m.group(3)}\nR{L}_loss {L}_x {m.group(2)} {r:.4g}")
    return net

def idealize(txt):
    out = []
    for ln in txt.split("\n"):
        m = re.match(r"^(XR\S+) (\S+) (\S+) \S+ (ppolyf_u(?:_1k)?) r_width=(\S+) r_length=(\S+)(?: m=(\S+))?", ln)
        if m:
            r = poly_r(m.group(4), si(m.group(5)), si(m.group(6)), float(m.group(7) or 1))
            out.append(f"R{m.group(1)[1:]}_id {m.group(2)} {m.group(3)} {r:.5g}")
        else:
            out.append(ln)
    return "\n".join(out)

def run(deck, tag):
    fn = f"{S}/deck_{os.getpid()}_{tag}.spice"
    open(fn, "w").write(deck)
    p = subprocess.run(["ngspice", "-b", fn], capture_output=True, text=True, cwd=S)
    return p.stdout + p.stderr

def evaluate(over, loss=True, corner_lib=None, temp=None, vdd=None):
    hasbuf = "_buf" in over
    net = apply(base, over, loss)
    if corner_lib:
        for a, b in corner_lib.items():
            net = re.sub(rf"(sm141064\.ngspice) {a}$", rf"\1 {b}", net, flags=re.M)
    if vdd:
        net = re.sub(r"^\.param VDD=\S+", f".param VDD={vdd}", net, flags=re.M)
    tline = f".temp {temp}\n" if temp is not None else ""
    sp = net + tline + """
.control
op
let idd=i(VDD)
let vm1=v(x1.vm1)
let vnet2=v(x1.net2)
let vm2=v(x1.vm2)
let vdsat4=@m.x1.xm4.m0[vdsat]
let vds4=@m.x1.xm4.m0[vds]
let vds1=@m.x1.xm1.m0[vds]
let vdsat1=@m.x1.xmnc.m0[vdsat]
echo OP $&idd $&vm1 $&vnet2 $&vm2 $&vds4 $&vdsat4 $&vds1 $&vdsat1
BUFOP
sp lin 21 1G 3G
let s11=db(S_1_1)
let s21=db(S_2_1)
let s22=db(S_2_2)
let k=0
while k < 21
  let ff=frequency[k]
  let a=s11[k]
  let b=s21[k]
  let c=s22[k]
  echo SP $&ff $&a $&b $&c
  let k=k+1
end
.endc
.end
"""
    sp = sp.replace("BUFOP", "let vnb=v(x1.nbuf)\nlet vdsatk=@m.x1.xmsk.m0[vdsat]\nlet vdssf=@m.x1.xmsf.m0[vds]\nlet vdsatsf=@m.x1.xmsf.m0[vdsat]\necho BUF $&vnb $&vdsatk $&vdssf $&vdsatsf" if hasbuf else "")
    o = run(sp, "sp")
    b = re.search(r"^BUF (.*)$", o, re.M)
    r = {}
    op = re.search(r"^OP (.*)$", o, re.M)
    if not op:
        return {"err": o[-800:]}
    v = [float(x) for x in op.group(1).split()]
    r["idd"], r["vm1"], r["vnet2"], r["vm2"], r["vds4"], r["vdsat4"], r["vds1"], r["vdsat1"] = v
    if b:
        r["vnb"], r["vdsatk"], r["vdssf"], r["vdsatsf"] = [float(x) for x in b.group(1).split()]
    sp_rows = [[float(x) for x in l.split()] for l in re.findall(r"^SP (.*)$", o, re.M)]
    r["f"] = [x[0] for x in sp_rows]; r["s11"] = [x[1] for x in sp_rows]
    r["s21"] = [x[2] for x in sp_rows]; r["s22"] = [x[3] for x in sp_rows]
    nz = idealize(net)
    nz = re.sub(r"^V1 rf_in_ext GND .*$", "V1 src GND DC 0 AC 1\nRSRC src rf_in_ext 50", nz, flags=re.M)
    nz = re.sub(r"^V2 rf_out_ext GND .*$", "RL2 rf_out_ext GND 50", nz, flags=re.M)
    nz += tline + """
.control
noise v(rf_out_ext) V1 lin 21 1G 3G 1
setplot noise1
let nf=10*log10((onoise_spectrum^2-onoise_rl2^2)/onoise_rsrc^2)
let k=0
while k < 21
  let vv=nf[k]
  echo NF $&vv
  let k=k+1
end
.endc
.end
"""
    o2 = run(nz, "nz")
    r["nf"] = [float(x) for x in re.findall(r"^NF (\S+)", o2, re.M)]
    if len(r["nf"]) != 21:
        r["err"] = o2[-800:]
    return r

def summary(r):
    if "err" in r: return "ERR " + r["err"][-300:]
    nf = r["nf"]
    return (f"P={abs(r['idd'])*5e3:5.0f}mW S21={min(r['s21']):5.2f}..{max(r['s21']):5.2f} "
            f"S11<={max(r['s11']):6.1f} S22<={max(r['s22']):6.1f} NF avg={sum(nf)/len(nf):4.2f} max={max(nf):4.2f} "
            f"| vds4-vdsat={r['vds4']-r['vdsat4']:.2f} vds1-vdsat={r['vds1']-r['vdsat1']:.2f}"
            + (f" vnbuf={r['vnb']:.2f} sink_marg={r['vnb']-r['vdsatk']:.2f} sf_marg={r['vdssf']-r['vdsatsf']:.2f}" if "vnb" in r else ""))

if __name__ == "__main__":
    for a in sys.argv[1:]:
        over = json.loads(a)
        print(json.dumps(over), "\n   ", summary(evaluate(over)))
