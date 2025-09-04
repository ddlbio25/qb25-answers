#!/usr/bin/env python3
import sys
import fasta
import re

file_path = sys.argv[1]

assembly_name = re.search(r"(PRJNA\d+\..+)(?:\.).+(?:\.fa)", file_path)
print("\nID:", assembly_name.group(1))




fa = fasta.FASTAReader(open(file_path))

#print(fa)

n_contigs = 0
total_length = 0
for ident, sequence in fa:
    #if ident.startswith("Contig"):
    n_contigs = n_contigs + 1
    contig_length = len(sequence.strip())

    total_length = total_length + contig_length

mean_length = total_length / n_contigs

print(f"Number of Contigs: {n_contigs}\nTotal Length: {total_length} bases")
print(f"Average Length: {mean_length:.02f} bases")