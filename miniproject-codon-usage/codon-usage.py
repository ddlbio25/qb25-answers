#!/usr/bin/env python3
import sys
import fasta

file_path = sys.argv[1]

file = open(file_path)

fa = fasta.FASTAReader(file)


protein_seq = {}
for ident, sequence in fa:
    #print(ident)
    for i in range(0, len(sequence), 3):
        codon = sequence[i:(i+3)]
        #print(codon)

file.close()