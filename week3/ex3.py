#!/usr/bin/env python3
# sample IDs (in order, corresponding to the VCF sample columns)
sample_ids = ["A01_62", "A01_39", "A01_63", "A01_35", "A01_31",
              "A01_27", "A01_24", "A01_23", "A01_11", "A01_09"]



# open the VCF file
output = list()
with open("biallelic.vcf") as fs:
    for line in fs:
        if line.startswith("#"):
            continue

        # split the line into fields by tab, then
        fields = line.split("\t")
        chrom = fields[0]
        pos   = fields[1]

        # for each sample in sample_ids:
        for sample in range(9, len(fields)):
            sample_id = sample_ids[sample - 9]
            # get the sample's data from fields[9], fields[10], ...
            # genotypes are represented by the first value before ":" in that sample's data
            values = fields[sample].split(":")
            genotype = values[0]
            
            # if genotype is "0" then print "0"
            if genotype in ["0", "1"]:
                output.append(f"{sample_id}\t{chrom}\t{pos}\t{genotype}")
            #else:
            #    print(genotype)
            # if genotype is "1" then print "1"
            # otherwise skip

with open("gt_long.txt", mode = "w") as fs:
    for item in output:
        fs.write(f"{item}\n")

        
        