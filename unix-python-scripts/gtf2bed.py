#!/usr/bin/env python3

file = open("/Users/cmdb/Data/References/hg38/gencode.v46.basic.annotation.gtf")

for line in file:
    if line.startswith("#"):
        continue
    line = line.rstrip("\n").split("\t")
    if line[2] != "gene":
        continue
    line[3] = str(int(line[3]) - 1) #subtracts 1 from start position
    attribute = line[8]
    
    #split attribute by ": ", then parse gene name
    gene_name = attribute.rstrip(";").split("; ")
    gene_name = gene_name[2]
    gene_name = gene_name.split(" ")[1]

    chr = line[0]
    start = line[3]
    end = line[4]
    output = [chr, start, end, gene_name]

    print("\t".join(output)) 

file.close()