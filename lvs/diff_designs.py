"""List the differences between two designs: top-level instances, ports, devices.

usage: python3 lvs/diff_designs.py mainUnfilled.gds chipalooza.gds mainNetlist chipNetlist
"""
import collections
import re
import sys

import klayout.db as kdb

ga, gb, na, nb = sys.argv[1:5]
TAGS = ("main_pex_layout_refloor", "main_Chipalooza")


def insts(path):
    ly = kdb.Layout(); ly.read(path)
    top = ly.cell("lna_core_parts")
    c = collections.Counter(i.cell.name for i in top.each_inst())
    b = top.bbox()
    return c, (b.width() * ly.dbu, b.height() * ly.dbu)


ca, sa = insts(ga)
cb, sb = insts(gb)
print("### LAYOUT -- top-level instances")
print(f"   {TAGS[0]}: {sum(ca.values())} instances, die {sa[0]:.0f} x {sa[1]:.0f} um")
print(f"   {TAGS[1]}: {sum(cb.values())} instances, die {sb[0]:.0f} x {sb[1]:.0f} um\n")
for k in sorted(set(ca) | set(cb)):
    x, y = ca.get(k, 0), cb.get(k, 0)
    if x != y:
        mark = "only in main" if y == 0 else ("only in Chipalooza" if x == 0 else "count differs")
        print(f"   {k:28s} main x{x}   chipalooza x{y}    <- {mark}")

print("\n### SCHEMATIC -- top-level ports")
for tag, path in zip(TAGS, (na, nb)):
    line = ""
    for ln in open(path):
        if ln.startswith(".subckt lna_core_parts"):
            line = ln.strip()
            break
    pins = line.split()[2:]
    print(f"   {tag}: {len(pins)} ports")
    print(f"      {' '.join(pins)}")

print("\n### SCHEMATIC -- device instances per subcircuit")
for tag, path in zip(TAGS, (na, nb)):
    txt = open(path).read()
    cur, out = None, collections.OrderedDict()
    for ln in txt.split("\n"):
        if ln.startswith(".subckt "):
            cur = ln.split()[1]
            out[cur] = []
        elif ln.startswith(".ends"):
            cur = None
        elif cur and re.match(r"^[Xx]\S+ ", ln):
            out[cur].append(ln.split()[-1] if "=" not in ln.split()[-1] else
                            [t for t in ln.split() if "=" not in t][-1])
    print(f"   {tag}:")
    for k, v in out.items():
        if k.startswith("lna_core"):
            print(f"      {k:26s} {len(v):2d} devices: {', '.join(sorted(set(v)))}")
