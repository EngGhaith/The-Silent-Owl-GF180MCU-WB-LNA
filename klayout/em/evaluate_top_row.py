#!/usr/bin/env python3
"""Evaluate the Palace run of palace_top_row.py: 5-port S -> Z with the vdd (3) and LSHUNT vss (5) ports shorted
(AC ground) -> L, R, Q of LD4 (port 1, vm2), LD2 (port 2, vx), LSHUNT_OUT (port 4, rf_out) and their coupling k,
compared with the team coil models (xschem/*_model.lib, rl)."""
import csv
import os
import re

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
CSV = os.path.join(HERE, "palace_model", "palace_top_row_data", "output", "palace_top_row", "port-S.csv")
N, Z0 = 5, 50.0
rows = list(csv.reader(open(CSV)))
head = [h.strip() for h in rows[0]]
data = np.array([[float(v) for v in r] for r in rows[1:] if r])
f = data[:, 0] * 1e9
S = np.zeros((len(f), N, N), complex)
for i in range(N):
    for j in range(N):
        cm = [k for k, h in enumerate(head) if re.search(rf"\|S\[{i + 1}\]\[{j + 1}\]\|", h)]
        ca = [k for k, h in enumerate(head) if re.search(rf"arg\(S\[{i + 1}\]\[{j + 1}\]\)", h)]
        S[:, i, j] = 10 ** (data[:, cm[0]] / 20) * np.exp(1j * np.radians(data[:, ca[0]]))
keep = [0, 1, 3]  # vm2, vx, rf_out; ports 3 (vdd) and 5 (vss) shorted
I = np.eye(N)
out = []
for k in range(len(f)):
    Y = np.linalg.solve(I + S[k], I - S[k]) / Z0
    out.append(np.linalg.inv(Y[np.ix_(keep, keep)]))
Z = np.array(out)
w = 2 * np.pi * f
names = ["LD4 (vm2)", "LD2 (vx)", "LSHUNT_OUT (rf_out)"]
model = {}
for n, lib in (("LD4 (vm2)", "LD4"), ("LD2 (vx)", "LD2"), ("LSHUNT_OUT (rf_out)", "LSHUNT_OUT")):
    txt = open(os.path.join(HERE, "..", "..", "xschem", f"{lib}_model.lib")).read()
    blk = txt[txt.index(".lib rl"):]
    model[n] = (float(re.search(r"\nL1 \S+ \S+ ([\d.]+)n", blk).group(1)), float(re.search(r"\nR1 \S+ \S+ ([\d.]+)", blk).group(1)))
print("EM top row (Palace), vdd / vss ports shorted; model = team coil model (rl)")
for fk in (1e9, 2e9, 2.4e9, 3e9):
    k = int(np.argmin(abs(f - fk)))
    print(f"\n f = {f[k] / 1e9:.2f} GHz")
    for i, n in enumerate(names):
        z = Z[k, i, i]
        L, R = z.imag / w[k], z.real
        print(f"   {n:20s} L = {L * 1e9:6.2f} nH  R = {R:6.2f} ohm  Q = {z.imag / z.real:5.2f}   model L = {model[n][0]:.2f} nH R = {model[n][1]:.2f} ohm")
    for a, b in ((0, 1), (1, 2), (0, 2)):
        kk = Z[k, a, b].imag / np.sqrt(Z[k, a, a].imag * Z[k, b, b].imag)
        print(f"   k {names[a].split()[0]:>10s} - {names[b].split()[0]:<10s} = {kk:+.4f}")
np.savez(os.path.join(HERE, "top_row_Z.npz"), f=f, Z=Z, S=S)
