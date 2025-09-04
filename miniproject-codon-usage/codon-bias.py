#!/usr/bin/env python3
import fasta
import codons
import sys

file_path = sys.argv[1]

aa = sys.argv[2]
if aa not in codons.reverse.keys():
    sys.exit("Not an aa!")

file = open(file_path)
fa = fasta.FASTAReader(file)


aa_codons = codons.reverse.get(aa)
aa_codons = list(aa_codons)
aa_codons.sort()

def codon_tallying(fa, aa):
    counts = {} # key = codon, value = abundance (n)
    aa
    #protein_seq = {}
    for ident, sequence in fa:
        #print(ident)
        for i in range(0, len(sequence), 3):
            codon = sequence[i:(i+3)]
            for codon_2 in aa_codons:
                if codon_2 == codon:
                    if codon in counts.keys():
                        counts[codon] = counts[codon] + 1
                    else:
                        counts.update({codon:1})
                else:
                    continue
            #print(codon)
    return counts#, protein_seq



counts = codon_tallying(fa, aa)

print("codon\tcount")
for codon in counts.keys():
    print(f"{codon}\t{counts.get(codon)}")
