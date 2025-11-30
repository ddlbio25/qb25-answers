#!/usr/bin/env python3

reads = ['ATTCA', 'ATTGA', 'CATTG', 'CTTAT', 'GATTG', 'TATTT', 'TCATT', 'TCTTA', 'TGATT', 'TTATT', 'TTCAT', 'TTCTT', 'TTGAT']

graph = list()

k = 3

for read in reads:
  for i in range(len(read) - k):
    kmer1 = read[i: i+k]
    kmer2 = read[i+1: i+1+k]
    candidate_edge = f"{kmer1} -> {kmer2}"
    if candidate_edge not in graph:
        graph.append(candidate_edge)
    

print("// Nodes")

print(r'digraph gattaca {')

for edge in graph:
   print(f"\t{edge};")

print("}")