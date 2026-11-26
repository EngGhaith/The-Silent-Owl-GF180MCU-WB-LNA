"""Swap the LEQ coil geometry in klayout/lna_core_parts.gds for the Chipalooza LEQ.

Same method as db1c57a: the content of cell "lna_core_input_match__LEQ" is cleared and
replaced by a single reference to the imported coil, so the existing outer placement
instance (origin / rotation / mirror) in the parent is left untouched. The new coil is
re-centred on the old coil's bbox centre, so it lands in the same place.

No DRC / LVS is attempted -- the new coil is much larger and will overlap its neighbours;
the floorplan is corrected by hand afterwards.
"""
import sys
import klayout.db as kdb

SRC = "klayout/lna_core_parts.gds"
NEW = ("/foss/designs/rapidpassives/try4/newflow/good_tries/"
       "LEQ_MAIN_RECT4_X130.8_Y314.0_N2_W26/Ind2_LEQ_MAIN_RECT4_X130.8_Y314.0_REAL_5LAYER.gds")
CELL = "lna_core_input_match__LEQ"
dst = sys.argv[1] if len(sys.argv) > 1 else SRC

ly = kdb.Layout()
ly.read(SRC)
dbu = ly.dbu
old = ly.cell(CELL)
ob = old.bbox()
print("old LEQ cell %-26s bbox %7.1f x %7.1f um, centre (%.1f, %.1f)"
      % (CELL, ob.width() * dbu, ob.height() * dbu, ob.center().x * dbu, ob.center().y * dbu))
for pi in old.each_parent_inst():
    t = pi.inst().cplx_trans
    print("   placed in %-24s at (%.1f, %.1f) rot=%g mirror=%s"
          % (ly.cell(pi.parent_cell_index()).name, t.disp.x * dbu, t.disp.y * dbu,
             t.angle, t.is_mirror()))

# import the new coil as its own cell tree
imp = kdb.Layout()
imp.read(NEW)
itop = imp.top_cell()
nb = itop.bbox()
print("new coil  %-28s bbox %7.1f x %7.1f um, centre (%.1f, %.1f)"
      % (itop.name, nb.width() * imp.dbu, nb.height() * imp.dbu,
         nb.center().x * imp.dbu, nb.center().y * imp.dbu))

newname = "LEQ_MAIN_RECT4"
holder = ly.create_cell(newname)
holder.copy_tree(itop)

# wipe the old coil content (its own shapes and its sub-cell references)
old.clear()
# place the new coil so its bbox centre sits on the old bbox centre
hb = holder.bbox()
off = kdb.Trans(kdb.Vector(ob.center().x - hb.center().x, ob.center().y - hb.center().y))
old.insert(kdb.CellInstArray(holder.cell_index(), off))
ly.cleanup()

fb = old.bbox()
print("after swap: %s bbox %7.1f x %7.1f um, centre (%.1f, %.1f)"
      % (CELL, fb.width() * dbu, fb.height() * dbu, fb.center().x * dbu, fb.center().y * dbu))
ly.write(dst)
print("wrote", dst)
