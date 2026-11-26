"""Are the p-substrate taps tied to the vss metal grid?

Magic merges VSUBS with vss only if a tap -- pplus-implanted COMP, contacted, with metal
on it -- reaches the vss net. main_pex_layout_refloor resolves VSUBS; main_Chipalooza does
not, so compare the taps in the two layouts.

usage: python3 lvs/check_substrate_tie.py
"""
import klayout.db as kdb

LAYOUTS = [("main_pex_layout_refloor",
            "/foss/designs/The-Silent-Owl-GF180MCU-WB-LNA/klayout/lna_core_parts_filled.gds"),
           ("main_Chipalooza",
            "/foss/designs/The-Silent-Owl-GF180MCU-WB-LNA/chipalooza_sim/lvs/work/lna_core_parts.gds")]
LAY = {"comp": (22, 0), "pplus": (31, 0), "nplus": (32, 0), "contact": (33, 0),
       "M1": (34, 0), "nwell": (21, 0)}


def reg(ly, top, key):
    i = ly.find_layer(*LAY[key])
    r = kdb.Region() if i is None else kdb.Region(top.begin_shapes_rec(i))
    r.merge()
    return r


for tag, path in LAYOUTS:
    ly = kdb.Layout(); ly.read(path)
    dbu = ly.dbu
    top = ly.cell("lna_core_parts")
    comp = reg(ly, top, "comp")
    pplus = reg(ly, top, "pplus")
    nwell = reg(ly, top, "nwell")
    cont = reg(ly, top, "contact")
    m1 = reg(ly, top, "M1")

    pcomp = comp & pplus                      # p-type diffusion
    tap = pcomp.outside(nwell) if not nwell.is_empty() else pcomp   # in the substrate
    tapc = tap.interacting(cont)              # actually contacted
    tapm = tapc.interacting(m1)               # and reaching M1
    print(f"\n{tag}  ({path.split('/')[-1]})")
    print(f"   COMP            {comp.count():6d} shapes  {comp.area()*dbu*dbu:10.1f} um2")
    print(f"   pplus           {pplus.count():6d} shapes  {pplus.area()*dbu*dbu:10.1f} um2")
    print(f"   p-COMP          {pcomp.count():6d} shapes  {pcomp.area()*dbu*dbu:10.1f} um2")
    print(f"   outside nwell   {tap.count():6d} shapes  {tap.area()*dbu*dbu:10.1f} um2  <- substrate taps")
    print(f"   with contact    {tapc.count():6d} shapes  {tapc.area()*dbu*dbu:10.1f} um2")
    print(f"   reaching M1     {tapm.count():6d} shapes  {tapm.area()*dbu*dbu:10.1f} um2  <- can tie VSUBS")
    nocont = tap - tapc.sized(0)
    if tap.count() and not tapc.count():
        print("   -> NO contacted substrate tap at all: Magic cannot merge VSUBS with vss")
    comp_noimp = comp - pplus - reg(ly, top, "nplus")
    print(f"   COMP with no implant at all: {comp_noimp.count():6d} shapes "
          f"{comp_noimp.area()*dbu*dbu:10.1f} um2")
