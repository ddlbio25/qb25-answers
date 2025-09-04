# Codon Usage Miniproject

This is a computational workflow to translate codons in frame into amino acids and tally up the proportion of different amino acids. Also it compares AA composition between different types of proteins.

## Script to get codons

The output of my script is to iterate over the FASTAReader object that fetches the identity and seuquence of a fasta file supplied via command line arguement, and prints the identity of the sequence as well as the codons of the sequences when it is suppled the subset of cytoplasm.fa. I think the output is correct because when I checked the printed codons, they seemed to be in-frame with an ATG start codon at the beginning.

The output of script after an update is to output the number of each amino acid in a particular fasta which has the sequences of many different proteins and peptides. It is correct because I properly queried the forward dictionary in codons.py to translate the codons to its aa. I then properly iteratatively tallied the aa count by adding one to the value in the aas dict for each aa everytime it was encountered.

It appears membrane proteins have more hydrophobic aas like phenylalanine, alanine, and isoleucine than cytoplasm proteins. Membranes proteins conversly have less hydrophilic amino acids like glutamic acid. I think this difference occurs because the membrane is a mostly hydrophobic environment due to the phospholipids, whereas the cytoplasm is more hydrophilic. Therefore, the protein aa residues will shift in abudnace to become more hydrophobic or hydrophilic in the membrane or cytoplasm, respectively.