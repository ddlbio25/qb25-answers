#!/usr/bin/env/python3

import sys
path = sys.argv[1]

fs = open(path)
alignment_count = {}
mismatch_count = {}



for line in fs:
    mismatches = None
    if line.startswith("@"):
        continue
    cols = line.split("\t")
    for i in range(len(cols)):
        if cols[i].startswith("NM:i:"):
            mismatches = int((cols[i])[5:])
            break
    chr = cols[2]

    if chr in alignment_count.keys():
        alignment_count[chr] = alignment_count[chr] + 1
    else:
        alignment_count.update({chr:1})

    if mismatches is not None:
        if mismatches in mismatch_count.keys():
            mismatch_count[mismatches] = mismatch_count[mismatches] + 1
        else:
            mismatch_count.update({mismatches:1})



print("chr\talignments")


for key in alignment_count.keys():
        print(key, alignment_count[key], sep = "\t")
print("\n", end = "")
print("mismatches per aligned read\tcount")
for key in sorted(mismatch_count.keys()):
    print(key, mismatch_count[key])
print()

