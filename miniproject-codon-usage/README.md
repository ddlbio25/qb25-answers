# Codon Usage Miniproject

This is a computational workflow to translate codons in frame into amino acids and tally up the proportion of different amino acids. Also it compares AA composition between different types of proteins.

## Script to get codons

The output of my script is to iterate over the FASTAReader object that fetches the identity and seuquence of a fasta file supplied via command line arguement, and prints the identity of the sequence as well as the codons of the sequences when it is suppled the subset of cytoplasm.fa. I think the output is correct because when I checked the printed codons, they seemed to be in-frame with an ATG start codon at the beginning.