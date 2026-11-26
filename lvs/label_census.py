"""Every net label in a layout: layer, text and position.

Magic names nets from labels, and merges the substrate node into a named net when a
substrate tap reaches metal carrying that label. If vss is not labelled on tap-connected
metal, the substrate stays VSUBS.

usage: python3 lvs/label_census.py layout.gds [layout2.gds ...]
"""
import sys

import klayout.db as kdb

for path in sys.argv[1:]:
    ly = kdb.Layout(); ly.read(path)
    dbu = ly.dbu
    top = ly.cell("lna_core_parts")
    print(f"=== {path.split('/')[-1]}")
    total = 0
    for li in ly.layer_indexes():
        info = ly.get_info(li)
        texts = []
        it = top.begin_shapes_rec(li)
        while not it.at_end():
            s = it.shape()
            if s.is_text():
                t = s.text.transformed(it.trans())
                texts.append((s.text.string, t.x * dbu, t.y * dbu))
            it.next()
        if texts:
            total += len(texts)
            print(f"   layer {info.layer}/{info.datatype}: {len(texts)} labels")
            for s, x, y in sorted(texts):
                print(f"        {s:18s} ({x:9.2f},{y:9.2f})")
    print(f"   total labels: {total}\n")
