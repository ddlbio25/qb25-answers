#!/usr/bin/env python3
allele_freqs = list()


read_depths = list()
line_count = 0



for line in open("biallelic.vcf"):
    allele_freq = None
    read_depth = None
    format_index = None

    if line.startswith('#'):
        continue
    line_count = line_count + 1
    fields = line.rstrip('\n').split('\t')
    info = fields[7]
    info = info.split(";")
    format = fields[8]
    format = format.split(":")
    
    
    for var in info:
        if var.startswith("AF="):
            allele_freq = var.split("=")[1]
            allele_freq = float(allele_freq)
    for i in range(len(format)):
        if format[i] == "DP":
            format_index = i
            
    for sample in fields[9:]:
        values = sample.split(":")
        read_depth = values[format_index]
        if read_depth is not None:
            read_depths.append(read_depth)


    if allele_freq is not None:
        allele_freqs.append(allele_freq)


fs = open("AF.txt", mode = "w")
for af in allele_freqs:
    fs.write(f"{af}\n")
fs.close()

fs1 = open("DP.txt", mode = "w")
for dp in read_depths:
    fs1.write(f"{dp}\n")
fs1.close()

print(line_count)

    # grab what you need from `fields`