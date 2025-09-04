#!/usr/bin/env python3
import sys
import fasta
import codons

#print(codons.forward)

file_path = sys.argv[1]
file_path_2 = sys.argv[2]

file = open(file_path)

fa = fasta.FASTAReader(file)

file2 = open(file_path_2)

fa2 = fasta.FASTAReader(file2)




def aa_tallying(fa):
    aas = {} # key = aa, value = abundance (n)
    #protein_seq = {}
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
    return aas#, protein_seq

aas_1 = aa_tallying(fa)
aas_2 = aa_tallying(fa2)

aa_list = codons.reverse.keys()
aa_list = list(aa_list)
aa_list.sort()
#print(aa_list)

print(f"aa\t{sys.argv[1]}\t{sys.argv[2]}")
for aa in aa_list:
    count1 = aas_1.get(aa) 
    count2 = aas_2.get(aa)
    print(f"{aa}\t{count1}\t{count2}")

file.close()