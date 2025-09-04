#!/usr/bin/env python3

file = open("ce11_genes.bed")

new_scores = []
for line in file:
    line = line.rstrip("\n").split("\t")

    #line[4] = orig score
    # line[2] - line[1] = feature size = chrom_end - chrom_start
    new_score = float(line[4]) * (int(line[2]) - int(line[1]))
    if line[5] == "-":
        new_score = new_score * -1
    line[4] = str(new_score)
    # create new tab delimited line and append to list
    new_line = "\t".join(line)
    new_scores.append(new_line)
file.close()

#write new bed file

output = open("ce11_new_scores.bed", mode = "w")
for i in range(len(new_scores)):
    # conditional so the last line doesn't have a newline
    if i == len(new_scores):
        output.write(f"{new_scores[i]}") 
    else:
        output.write(f"{new_scores[i]}\n")
output.close()

 