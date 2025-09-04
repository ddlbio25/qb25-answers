#!/usr/bin/env python 3

file = open("GTEx_Analysis_2017-06-05_v8_RNASeQCv1.1.9_gene_tpm.gct")

for i in range(2):
    _ = file.readline()

header = file.readline().rstrip("\n").split("\t")
first_gene = file.readline().rstrip("\n").split("\t")

DDX11L1 = dict()

for i in range(len(header)):
    DDX11L1.update({header[i]:first_gene[i]})
file.close()

#print(DDX11L1.values())
file = open("GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt")

DDX11L1_expression = []
counter = 0
first_3_tissues = []

for line in file:
    line = line.rstrip("\n").split("\t")
    if line[0] in DDX11L1.keys():
        sampid = line[0]
        tpm = DDX11L1.get(line[0])
        smtsd = line[6]
        

        new_line = f"{sampid}\t{tpm}\t{smtsd}" #tab delim string line
        DDX11L1_expression.append(new_line)
        
        if float(tpm) > 0 and counter < 3:
            first_3_tissues.append(smtsd)
            counter = counter + 1
        
        
        
        """
        print(  
            line[0], #SAMPID
            DDX11L1.get(line[0]), #TPM based on sample id
            line[6], #SMTSD
            sep = "\t"
        )
        """
#print out the expression
for line in DDX11L1_expression:
    print(line)

# print the first three tissues that have above zero expression
print("First three tissues with above zero expression are:\n", first_3_tissues)
    

file.close()

# NOTE: first three tissues with expression > 0 
# are brain-cortex, Adrenal Gland, and Thyroid
# I used bash command:
# python3 sample-by-gene.py | cut -f 2-3 | grep "^0" -v | head -n 3 