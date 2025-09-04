#!/usr/bin/env python3
import sys
import fasta
import re

file_path = sys.argv[1]

assembly_name = re.search(r"(PRJNA\d+\..+)(?:\.).+(?:\.fa)", file_path)
print("\nID:", assembly_name.group(1))




fa = fasta.FASTAReader(open(file_path))

#print(fa)

contig_lengths = []
n_contigs = 0
total_length = 0
for ident, sequence in fa:
    #if ident.startswith("Contig"):
    n_contigs = n_contigs + 1
    contig_length = len(sequence.strip())
    
    contig_lengths.append(contig_length)
    total_length = total_length + contig_length


mean_length = total_length / n_contigs

contig_lengths.sort(reverse = True)

cumulative_length = 0
for length in contig_lengths:
    cumulative_length = cumulative_length + length
    if cumulative_length > 0.5 * total_length:
        break


print(f"sequence length of shortest contig at 50% of the total assembly length is: {length} bases")
print(f"Number of Contigs: {n_contigs}\nTotal Length: {total_length} bases")
print(f"Average Length: {mean_length:.02f} bases")