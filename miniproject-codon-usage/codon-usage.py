#!/usr/bin/env python3
import sys
import fasta
import codons

#print(codons.forward)

file_path = sys.argv[1]

file = open(file_path)

fa = fasta.FASTAReader(file)

aas = {} # key = aa, value = abundance (n)

protein_seq = {}
for ident, sequence in fa:
    #print(ident)
    for i in range(0, len(sequence), 3):
        codon = sequence[i:(i+3)]
        aa = codons.forward.get(codon)
        if aa in aas.keys():
            aas[aa] = aas[aa] + 1
        else:
            aas.update({aa:1})
        #print(codon)

print("\n", aas)
file.close()