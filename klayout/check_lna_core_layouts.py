#!/usr/bin/env python3
"""
DRC + LVS of the lna_core sub-cell layouts (klayout/lna_core_*.gds) with the gf180mcuD KLayout decks.

Usage:  python3 check_lna_core_layouts.py [cg cs input_match output_match parts]
                [--drc=klayout|magic|both] [--no-drc] [--no-lvs] [--run_dir DIR]

DRC runs with two independent decks, selected by --drc (default: both). They are NOT redundant -- the decks do
  not code the same rules, so each catches things the other misses:
    --drc=klayout  PDK KLayout deck (run_drc_klayout): FEOL + BEOL + antenna.
    --drc=magic    Magic, PDK gf180mcuD tech, style drc(full) (run_drc_magic): catches e.g. PRES/LRES/HRES.7
                   (poly contact to SAB) and MIMTM.2 (via4 enclosure on the MIM bottom plate), which the
                   KLayout deck checks differently or not at all. No antenna rules in this style.
    --drc=both     both of the above (use this for signoff).

DRC (KLayout): --variant=D (5LM, 11 kA top metal, MIM option B), deep mode, density
  and dummy-fill decks excluded (block level: a density/dummy-fill check needs full-chip context to mean
  anything -- a sub-block cut out of it will almost always "fail" a global-density-style rule in isolation).
  HISTORICAL NOTE (no longer applies): "parts" used to report a standing set of ANT.16_i/ii antenna
  violations on the vdd/vss plane, treated as an artifact of checking the macro without its padframe.
  Those are GONE: removing four metal1 rectangles in lna_core_parts (the redundant second path from the
  dummy-transistor guard rings to the vss grid) cleared all of them. Antenna rules are evaluated per metal
  level on the conductor attached to the gate at that step, so metal that is redundant for DC still counts
  its full area. Both lna_core_parts.gds and lna_core_parts_filled.gds now report ZERO antenna violations;
  any that reappear are new and worth chasing.
LVS: reference = xschem netlist of xschem/<cell>.sch (netlisted here, then PDK spice converter) with
  - inductors and their ideal loss resistors removed (no inductor device in the PDK LVS deck); the spiral / coil
    cells (<cell>__L*, coils with their sub cells) are removed from the layout copy as well, so both inductor
    terminals stay separate nets
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

"parts" LVS mismatch root cause (confirmed via the real cross-reference, NetlistCrossReference.each_net_pair /
  each_device_pair / Device.net_for_terminal on a fresh run's .lvsdb -- see /tmp session notes, 2026-11-23):
  device mismatches are NOT a wrong-PCell problem -- every mismatched device pair has an identical class name on
  both sides (nfet_03v3==NFET_03V3, cap_mim_2f0fF==CAP_MIM_2F0FF, etc); it is purely a net-connectivity cascade.
  Four coils each have one terminal that is a genuine physical dead end in the current layout (confirmed via a
  properly-converged, same-layer-then-via multi-hop flood fill through m1..m5 -- NOT a quick bbox/label-distance
  proxy, which gives false negatives/positives here):
    - LEQ's vss-side terminal (schematic pin "B"): isolated, nearest real vss-connected m1/m2/m4 metal is ~10um
      west of its marker (70000-80000,542370-543370), same Y range.
    - LSHUNT_OUT's and L1's vss-side terminals: also isolated, real distance not yet pinned down as precisely.
    - LD4's 4 parallel legs (rm2/rm3/rm4/tm11k) already correctly converge on ONE local vdd-side island (confirmed
      via the net's own terminal list) -- that island itself doesn't reach the real labelled VDD net.
    - LD2's rm4 OUTPUT_CS-side terminal (NOT its vdd side, which is already fine) is isolated.
  PR#38/#39's rule-deck patch (connect(top_metal_con, metal5_con) in a vendored gf180mcu.lvs copy) is NOT needed
  here: this layout has zero MIM-cap FuseTop overlap near any of these markers, so top_metal_con and metal5_con
  are already geometrically identical in this area (confirmed empirically: applying the same one-line patch to a
  scratch copy of the OFFICIAL deck against this unmodified layout changes nothing).
  IMPORTANT, hard-won finding on how to actually bridge one of these dead ends: resistor devices here are
  extracted by klayout's generic two-terminal DeviceExtractorResistor (kdb.DeviceExtractorResistor.__doc__ has
  the full spec) -- the metal*_res marker is the wire, and it needs a contact region "attached to the ends of
  the wire" on each side, with L/W computed from a simple-rectangle assumption. Extending the metal5 (or metal4)
  polygon so it touches the marker along its LENGTH axis (i.e. growing the resistor's own end, directly beyond
  x=<marker's own east/west edge> for a horizontal marker) reliably makes the device DISAPPEAR FROM EXTRACTION
  ENTIRELY, at ANY size tried (500nm to 4000nm), on EITHER end, with or without vias, with or without explicit
  region merging before writing -- confirmed via repeated isolated tests, not a one-off. A perpendicular side tap
  (a stub growing from the marker's TOP or BOTTOM edge, i.e. along its WIDTH axis, not touching either end) does
  NOT break extraction -- but the exact X position of that tap is NOT a safe "anywhere along the top edge" choice:
  one test placed a tap only 2um in from one end and it silently merged into the WRONG terminal's own contact
  region, creating a real cross-net short (observed: rf_in_pad, vdd and vss all merged into one net). This was
  caught before committing by checking Device.net_for_terminal after every single edit, never by DRC (DRC passed
  the shorted version clean) -- always re-check net_for_terminal per terminal after adding bridge geometry near
  a resistor marker, do not rely on the overall mismatch count alone.
  SECOND and THIRD near-misses, same session, both DRC-clean: a 500nm tap at the marker's west edge linked
  correctly to A alone; extending that same anchor ~12um further west to reach a labelled vss region merged B
  into RF_IN_PAD+VDD+VSS instead. A later, geometrically-precise attempt (see below) also ended up on a net
  reported as "VDD,VSS" by the real gf180mcu.lvs run. In BOTH cases the short was caught by re-checking
  Device.net_for_terminal after the edit, never by DRC -- always re-check net_for_terminal per terminal after
  any bridge edit near a resistor marker, do not trust the overall mismatch count or DRC cleanliness alone.

  RESOLVED this session: how to get an exact terminal contact shape instead of probing blind. Needs a live L2N
  session (shapes_of_net raises "circuit != 0" against any reloaded .lvsdb, which is all this script normally
  produces). Working recipe:
    l2n = kdb.LayoutToNetlist(top.begin_shapes_rec(ly.layer(81,0)))
    metal5 = l2n.make_layer(ly.layer(81,0), 'metal5')   # make_layer, NOT make_polygon_layer -- takes the
    metal5_res = l2n.make_layer(ly.layer(110,15), 'metal5_res')   # ORIGINAL layout's layer index directly
    fusetop = l2n.make_layer(ly.layer(75,0), 'fusetop')
    via4 = l2n.make_layer(ly.layer(41,0), 'via4')
    metal5_con = metal5 - metal5_res; top_metal_con = metal5_con - fusetop; via4_n_cap = via4 - fusetop
    l2n.extract_devices(kdb.DeviceExtractorResistor.new('tm11k', 0.04), {'R': metal5_res, 'C': top_metal_con})
    l2n.connect(via4_n_cap, metal5_con); l2n.connect(via4_n_cap, top_metal_con)
    l2n.connect(top_metal_con)   # <- the missing piece: a layer needs to be connected to ITSELF too, or
                                  #    Device.net_for_terminal() silently returns None for almost every
                                  #    terminal even though extract_devices finds the devices fine (confirmed:
                                  #    without this, only 1 of 8 terminals across 4 devices linked to a net)
    l2n.extract_netlist()
  After this, dev.net_for_terminal('A') / 'B' and l2n.shapes_of_net(net, top_metal_con, True) both work.
  For LEQ specifically this revealed the terminal split is NOT the simple east/west guess used earlier -- it is
  NORTH/SOUTH of the marker: terminal A's entire contact region has bbox (70000,459500;93000,542370) (strictly
  below the marker's south edge, y<=542370), terminal B's is (1000,543370;255400,742870) (strictly above the
  north edge, y>=543370). A tap placed north of the marker (as both near-misses above were) is in B's territory
  regardless of how far east or west it sits -- that is WHY they kept merging into B's own net (RF_IN_PAD etc),
  not because of anything specific to the x position tried. Do this shapes_of_net check for the actual coil
  before placing any bridge; do not assume the split is east/west again.
  CAUTION, also discovered this session: a bridge routed precisely inside terminal A's own confirmed shapes_of_net
  region (y=500000-501000, well inside the A bbox above, reaching toward a labelled vss area at x=20000-60000)
  STILL came back from the real gf180mcu.lvs run with A on a net named "VDD,VSS" -- so matching the resistor's
  own terminal geometry correctly is necessary but not sufficient; the real deck's full device-aware extraction
  can still find a path from a given point to both supplies that a metal-only analysis won't show. A pure
  interconnect-only re-check (connect() across m1-m5 and their vias, no devices at all) also reported combined
  "VDD,VSS" and "DEEMB_S,VBIAS_CAS,VSS" nets spanning the entire 1.11mm x 1.11mm die with thousands of shapes
  each -- that is NOT evidence of a real short, it is the expected result of connectivity analysis with no
  device boundaries at all (metal1-5 are shared by every net in the design; without transistors/resistors to
  break continuity, a same-layer-plus-via walk will eventually touch everything). This is the same trap the
  very first flood-fill attempt in this session fell into (vss and vdd network areas came out byte-identical
  then, for the same reason) -- do not use a device-less interconnect walk to judge whether two labelled nets
  are really merged; only the full official check_lna_core_layouts.py / gf180mcu.lvs result (or a from-scratch
  L2N session with the actual device extractors for the surrounding transistors too, not attempted this
  session) can be trusted for that question. Net effect: finding a target point that is simultaneously (a)
  inside the resistor terminal's own confirmed contact region and (b) does not land on a path the real deck
  considers vdd+vss-connected has not been achieved yet for any of the 4 coils.
  Lower-effort alternative still untried: KLayout's GUI marker browser on klayout/lvs/lna_core_parts_lvs.gds
  + .spice -- visually net-probing candidate target points before routing would catch issue (b) above directly,
  without needing to reason about device-level paths in the abstract.
"""
import json
import glob, os
import re
import shutil
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
XSCHEM = os.path.join(HERE, "..", "xschem")
PDK_KL = "/foss/pdks/gf180mcuD/libs.tech/klayout/tech"
PDK_MAGICRC = "/foss/pdks/gf180mcuD/libs.tech/magic/gf180mcuD.magicrc"
CELLS = ["input_match", "cg", "cs", "output_match", "parts"]
# The "parts" cell lives in its own GDS. lna_top2.gds was renamed to lna_core_parts.gds (unfilled,
# DRC clean except density + LVS clean) and lna_core_parts_filled.gds (COMP/poly2 dummy fill, clean
# on both DRC decks incl. density + LVS clean). The filled one is what lvs_config.json points at.
PARTS_GDS = "lna_core_parts_filled.gds"
DRC_ENGINES = ("klayout", "magic", "both")
SHORTS = {"lna_core_cs": {"net1": "vss"}}  # RS_EQ1

# gf180mcu.lvs's own spice reader can't handle a hyphenated, unquoted .lib path ("Expected a word or quoted
# string here") -- this repo's own directory name (The-Silent-Owl-...) has hyphens, and the LVS_MODELS .lib
# includes (see each schematic's own code block) resolve $::env(PWD) straight into the netlist text, verbatim
# and unquoted, since neither xschem nor the PDK's spice converter resolve .lib themselves. A hyphen-free
# symlink to XSCHEM sidesteps the parser limitation entirely without touching gf180mcu.lvs itself.
XSCHEM_PWD_LINK = "/tmp/lna_xschem_nolink"


def xschem_pwd():
    target = os.path.realpath(XSCHEM)
    if os.path.realpath(XSCHEM_PWD_LINK) != target:
        if os.path.islink(XSCHEM_PWD_LINK) or os.path.exists(XSCHEM_PWD_LINK):
            os.remove(XSCHEM_PWD_LINK)
        os.symlink(target, XSCHEM_PWD_LINK)
    return XSCHEM_PWD_LINK


def snap(v_um):
    """MIM W/L as drawn (make_lna_core_layouts.um_grid): rounded to 10 nm"""
    return round(v_um, 2)


def _lib_section_lines(path, section):
    """lines of one named '.lib <section>' / '.endl <section>' block in an external library file"""
    active = False
    for raw in open(path):
        s = raw.strip()
        low = s.lower()
        if low.startswith(".lib "):
            active = s.split()[-1].lower() == section.lower()
            continue
        if low.startswith(".endl"):
            active = False
            continue
        if active:
            yield raw.rstrip("\n")


def _flatten_libs(path):
    """yield every line of `path`, inlining any top-level '.lib <file> <section>' directive in place --
    neither xschem's netlister nor the PDK's spice converter resolve these themselves (both just pass the
    line through verbatim, same as any other spice directive meant for whatever reads the netlist next), so
    ref_netlist() has to do it before its own .subckt/.ends scan below can see what a .lib include resolves to"""
    for raw in open(path):
        s = raw.strip()
        if s.lower().startswith(".lib "):
            tok = s.split()
            yield from _lib_section_lines(tok[1], tok[2])
        else:
            yield raw.rstrip("\n")


def ref_netlist(cell, out_dir):
    raw = os.path.join(out_dir, cell + "_xschem.spice")
    # $::env(PWD) (used by the LVS_MODELS .lib includes, see xschem/lna_core_parts.sch) reads the inherited PWD
    # environment variable, not the actual cwd set below -- subprocess's cwd= alone doesn't update it, so it has
    # to be set explicitly here or xschem resolves those .lib paths against the caller's own cwd instead. Uses
    # the hyphen-free symlink (see xschem_pwd()) rather than XSCHEM itself, so the resulting .lib path text is
    # safe for gf180mcu.lvs's own reader too, not just this function's own _flatten_libs().
    env = dict(os.environ, PWD=xschem_pwd())
    subprocess.run(["xschem", "-q", "-x", "-n", "-s", "-o", out_dir, "--netlist_filename", os.path.basename(raw),
                    os.path.join(XSCHEM, cell + ".sch")], cwd=XSCHEM, env=env, check=True, capture_output=True)
    conv = os.path.join(out_dir, cell + "_conv.spice")
    subprocess.run(["python3", os.path.join(PDK_KL, "lvs", "gf180_xschem_klayout_spice_convert.py"), raw, "-o", conv],
                   check=True, capture_output=True)
    # sub-circuits: the netlisted schematic ("**.subckt" comment header) and, for lna_core_parts, its blocks
    subs, cur = {}, None
    for ln in (l.strip() for l in _flatten_libs(conv)):
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
    # bare ideal inductors (no PDK device to compare against): drop. These parse as exactly 4 tokens with a
    # numeric (with unit suffix) value, e.g. "L1 p1 p2 1.37n". *_model calls (LEQ_MODEL etc.) are NOT dropped
    # here even though the PDK's spice converter strips their leading "X" too (so "XLEQ ... LEQ_model" becomes
    # "LEQ ... LEQ_model", also starting with "L") -- the LVS-only "lvsrm" .lib selection (see each schematic's
    # LVS_MODELS code block) always resolves them to a real PDK metal-resistor subckt by the time this runs,
    # so they must pass through normally; the numeric-value check is what tells the two apart.
    _numeric_value = re.compile(r"^[\d.]+[a-zA-Z]*$")
    is_ind = lambda tok: tok[0][0] in "Ll" and len(tok) == 4 and bool(_numeric_value.match(tok[3]))
    ind_nets = set()
    for ln in body:
        if is_ind(ln.split()):
            ind_nets.update(ln.split()[1:3])
    out = []
    short = SHORTS.get(cell, {})
    for ln in body:
        tok = ln.split()
        if is_ind(tok):
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
        if tok[-1].lower().endswith("_model") and tok[0][0] not in "Xx":
            # the PDK's spice converter unconditionally strips the leading "X" off every instance (see
            # SpicePrefixRemovalRule in gf180_xschem_klayout_spice_convert.py) -- fine for this PDK's own
            # M../R..-style primitives, but a *_model subcircuit call whose remaining name happens to start
            # with another SPICE-reserved letter (L for an inductor, same issue hit with O/B at the lna_top
            # level for OTA/bandgap/bias) gets misread by gf180mcu.lvs's own reader as that primitive device
            # instead of a subcircuit reference. Restoring the "X" is what the line actually needs to parse.
            tok[0] = "X" + tok[0]
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
        "ind = [c.cell_index() for c in ly.each_cell() if '__' in c.name and c.name.split('__')[-1][:1] == 'L']\n"
        "for ci in ind:\n"
        "    ly.prune_cell(ci, -1)  # with the coil sub cells\n"
        "if flat == '1':\n"
        "    ly.top_cell().flatten(True)\n"
        "ly.write(dst)\n")
    dst = os.path.join(out_dir, cell + "_lvs.gds")
    flat = "1" if cell == "lna_core_parts" else "0"
    subprocess.run(["klayout", "-b", "-r", scr, "-rd", f"src={gds}", "-rd", f"dst={dst}", "-rd", f"flat={flat}"],
                   check=True, capture_output=True)
    return dst


def run_drc_klayout(cell, run_dir):
    """KLayout DRC with the PDK deck, variant D (5LM, 11 kA top metal, MIM option B), deep mode, FEOL + BEOL + antenna.
    Density is excluded (needs full-chip context); run it separately.
    lna_core_parts is checked on klayout/<PARTS_GDS> (see the constant near the top).

    Two PDK layouts are supported, because they drive the deck differently:
      - builds that ship drc/run_drc.py (the wrapper this check was written against) -- used when present;
      - builds that ship only drc/gf180mcu.drc (e.g. the gf180mcuD in IIC-OSIC-TOOLS here), where the deck is
        driven by rule *tags* via -rd decks=... There is no -rd feol / -rd beol switch in that deck: "feol" and
        "beol" are tags on the rules themselves (see drc/options.rb and the tags: %w[...] lines in
        drc/rule_decks/*), so decks=all,-density,-dummy_comp runs every FEOL, BEOL and antenna rule."""
    d = os.path.join(run_dir, "drc_" + cell)
    if os.path.isdir(d):
        shutil.rmtree(d)
    os.makedirs(d)
    gds = os.path.join(HERE, PARTS_GDS if cell == "lna_core_parts" else cell + ".gds")
    runner = os.path.join(PDK_KL, "drc", "run_drc.py")
    if os.path.exists(runner):
        clean_marker = "Klayout DRC run is clean"
        cmd = ["python3", runner, f"--path={gds}", "--variant=D", f"--topcell={cell}", f"--run_dir={d}",
               "--mp=4", "--run_mode=deep", "--antenna"]
    else:
        clean_marker = "DRC RESULT: SUCCESS"
        cmd = ["klayout", "-b", "-r", os.path.join(PDK_KL, "drc", "gf180mcu.drc"),
               "-rd", f"input={gds}", "-rd", f"report={os.path.join(d, cell + '.lyrdb')}",
               "-rd", f"topcell={cell}", "-rd", "variant=D", "-rd", "run_mode=deep", "-rd", "workers=4",
               "-rd", "decks=all,-density,-dummy_comp"]
    r = subprocess.run(cmd, capture_output=True, text=True, cwd=d)
    log = r.stdout + r.stderr
    open(os.path.join(d, "run_drc.log"), "w").write(log)
    viol = {}
    import xml.etree.ElementTree as ET
    for f in glob.glob(os.path.join(d, "*.lyrdb")):
        for it in ET.parse(f).getroot().iter("item"):
            cat = it.findtext("category", "").strip("'")
            viol[cat] = viol.get(cat, 0) + 1
    if clean_marker not in log and not viol:
        viol["drc run failed (see run_drc.log)"] = 1
    return viol, d


def run_drc_magic(cell, run_dir):
    """Magic DRC with the PDK's own gf180mcuD tech, style drc(full) -- the second opinion the Chipathon
    integrator runs. It is not redundant with the KLayout deck: the two decks do not code the same rules.
    Magic catches e.g. PRES/LRES/HRES.7 (poly contact distance to SAB) and MIMTM.2 (via4 enclosure on the MIM
    bottom plate), which the KLayout deck checks differently or not at all; the KLayout deck in turn runs the
    antenna rules, which this style does not. Run both for signoff (--drc=both)."""
    d = os.path.join(run_dir, "drc_magic_" + cell)
    if os.path.isdir(d):
        shutil.rmtree(d)
    os.makedirs(d)
    gds = os.path.join(HERE, PARTS_GDS if cell == "lna_core_parts" else cell + ".gds")
    script = "\n".join([
        "crashbackups stop",
        "drc off",                      # no incremental checking while the GDS is being read
        f"gds read {gds}",
        f"load {cell}",
        "select top cell",
        "drc style drc(full)",
        "drc euclidean on",
        "drc check",
        "drc catchup",                  # block until the checker has drained its queue
        'puts "MAGIC_DRC_COUNT: [drc list count total]"',
        "drc listall why",
        "quit -noprompt",
    ])
    try:
        r = subprocess.run(["magic", "-dnull", "-noconsole", "-rcfile", PDK_MAGICRC],
                           input=script, capture_output=True, text=True, cwd=d)
    except FileNotFoundError:
        return {"magic not installed": 1}, d
    log = r.stdout + r.stderr
    open(os.path.join(d, "magic_drc.log"), "w").write(log)

    m = re.search(r"MAGIC_DRC_COUNT:\s*(\d+)", log)
    if m is None:
        return {"magic drc run failed (see magic_drc.log)": 1}, d
    total = int(m.group(1))
    if total == 0:
        return {}, d
    # "drc listall why" prints each rule's own text, then its violating boxes; count the boxes per rule so the
    # summary matches the KLayout side's {rule: count} shape instead of a single opaque number.
    viol, rule = {}, None
    for line in log.splitlines()[log.splitlines().index(m.group(0)) if m.group(0) in log.splitlines() else 0:]:
        s = line.strip()
        if not s or s.startswith("MAGIC_DRC_COUNT"):
            continue
        if re.match(r"^-?\d+\s+-?\d+\s+-?\d+\s+-?\d+$", s):   # a violation box
            if rule:
                viol[rule] = viol.get(rule, 0) + 1
        elif not s.startswith("["):
            rule = s[:90]
    return viol or {f"magic drc: {total} violations (see magic_drc.log)": total}, d


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
    drc_engine = "both"
    for a in list(args):
        if a.startswith("--drc="):
            drc_engine = a.split("=", 1)[1].strip().lower()
            args.remove(a)
    if drc_engine not in DRC_ENGINES:
        sys.exit(f"--drc must be one of {'/'.join(DRC_ENGINES)} (got {drc_engine!r})")

    cells = [a for a in args if not a.startswith("--")] or CELLS
    for c in cells:
        cell = "lna_core_" + c
        if "--no-drc" not in args:
            for eng, fn in (("klayout", run_drc_klayout), ("magic", run_drc_magic)):
                if drc_engine in (eng, "both"):
                    viol, d = fn(cell, run_dir)
                    tag = f"DRC[{eng}]"
                    print(f"{cell:24s} {tag:13s} {'clean' if not viol else 'VIOLATIONS ' + str(viol)}   ({d})",
                          flush=True)
        if "--no-lvs" not in args:
            ok, d, log = run_lvs(cell, run_dir)
            print(f"{cell:24s} LVS {'match' if ok else 'MISMATCH'}   ({d})", flush=True)
            if not ok:
                print("\n".join(log.splitlines()[-15:]))


main()
