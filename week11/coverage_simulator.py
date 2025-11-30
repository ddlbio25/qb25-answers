#!/usr/bin/env python3

import numpy as np
from scipy import stats

import sys
import math

#import random

def calculate_number_of_reads(genomesize, readlength, coverage):
  num_reads = genomesize * coverage / readlength
  return int(num_reads)

genomesize = int(sys.argv[1]) * pow(10, int(sys.argv[2]))
coverage = float(sys.argv[3])
readlength = int(sys.argv[4])

num_reads = calculate_number_of_reads(genomesize, readlength, coverage)

## use an array to keep track of the coverage at each position in the genome
genomecoverage = np.zeros(genomesize, dtype = "int")

genomelength = genomesize

for i in range(num_reads):

  startpos = np.random.uniform(0, genomelength - readlength+1)
  startpos = int(startpos)
  endpos = startpos + readlength
  genomecoverage[startpos:endpos] += 1
  #print("start",    startpos)
  #print(endpos)

#np.set_printoptions(threshold = sys.maxsize)
#print(genomecoverage)
#print(genomecoverage[startpos:endpos])



## get the range of coverages observed
maxcoverage = max(genomecoverage)
xs = list(range(0, int(maxcoverage)+1))

#print(maxcoverage)
#print(xs)

## Get the poisson pmf at each of these
def get_poisson_estimates(range, lamb):
  poisson_estimates = {}
  for value in range:
    poisson_estimate = (pow(lamb, value) * pow(math.e, -lamb)) / math.factorial(value)
    poisson_estimates[value] = poisson_estimate
  return poisson_estimates

poisson_estimates = get_poisson_estimates(xs, lamb = coverage)

#print(poisson_estimates)


## Get normal pdf at each of these (i.e. the density between each adjacent pair of points)
normal_estimates = {}
for value in xs:
  normal_estimate = stats.norm.pdf(value, loc = coverage, scale = math.sqrt(coverage))
  normal_estimates[value] = normal_estimate
#print(normal_estimates)

## now plot the histogram and probability distributions

with open("poisson_estimates.tsv", "w") as fs:
  for key, value in poisson_estimates.items():
    fs.write(f"{key}\t{value}\n")
with open("normal_estimates.tsv", "w") as fs:
  for key, value in normal_estimates.items():
    fs.write(f"{key}\t{value}\n")
with open("simulated_sequence.tsv", "w") as fs:
  for i in range(len(genomecoverage)):
        fs.write(f"{i + 1}\t{genomecoverage[i]}\n")
