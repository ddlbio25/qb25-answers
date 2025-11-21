#!/usr/bin/env python3

import sys

import numpy as np

from fasta import readFASTA


#====================#
# Read in parameters #
#====================#


fasta_path = sys.argv[1]





scoring_matrix = sys.argv[2]
gap_penalty = float(sys.argv[3])
outfile = sys.argv[4]





# The scoring matrix is assumed to be named "sigma_file" and the 
# output filename is assumed to be named "out_file" in later code

sigma_file = scoring_matrix

# Read the scoring matrix into a dictionary
fs = open(sigma_file)
sigma = {}
alphabet = fs.readline().strip().split()
for line in fs:
	line = line.rstrip().split()
	for i in range(1, len(line)):
		sigma[(alphabet[i - 1], line[0])] = float(line[i])
fs.close()

#print(sigma)



# Read in the actual sequences using readFASTA

input_sequences = readFASTA(open(fasta_path))

seq1_id, sequence1 = input_sequences[0]
seq2_id, sequence2 = input_sequences[1]

#print(seq1_id)

#=====================#
# Initialize F matrix #
#=====================#

f_matrix = np.zeros((len(sequence1) + 1, len(sequence2) + 1), dtype = float)
# fill first row
for j in range(1, len(sequence2) + 1):
	f_matrix[0, j] = j * gap_penalty
# fill first column
for i in range(1, len(sequence1) + 1):
	f_matrix[i, 0] = i * gap_penalty






#=============================#
# Initialize Traceback Matrix #
#=============================#
tb_matrix = np.zeros((len(sequence1) + 1, len(sequence2) + 1), dtype = int)





#===================#
# Populate Matrices #
#===================#
# get alignment scores
for i in range(1, len(sequence1) + 1):
	for j in range(1, len(sequence2) + 1):
		# look at alignment score based on sigma matrix
		alignment_score = sigma[sequence1[i - 1], sequence2[j - 1]]
		cumulative_score = f_matrix[i - 1, j - 1] + alignment_score
		
		# if there is a gap
		horizontal_gap = f_matrix[i, j - 1] + gap_penalty # sequence 1 gap
		vertical_gap = f_matrix[i - 1, j] + gap_penalty # sequence 2 gap
		highest_score = max(cumulative_score, horizontal_gap, vertical_gap)

		# order of conditionals dictates tiebreaker
		if highest_score == cumulative_score:
			direction = 1 # go diagonal on traceback
		elif highest_score == horizontal_gap:
			direction = 2 # go left on traceback
		else:
			direction = 3 # go up on traceback
		
		f_matrix[i, j] = highest_score
		tb_matrix[i, j] = direction


#print(f_matrix)
#print(tb_matrix)



#========================================#
# Follow traceback to generate alignment #
#========================================#

column = len(sequence2)
row = len(sequence1)

# record alignment score
alignment_score = f_matrix[row, column]

backwards_seq1_alignment = []
backwards_seq2_alignment = []
while column != 0 and row != 0:
	"""
	if row == 0:
		backwards_seq1_alignment.append("-")
	else:
		backwards_seq1_alignment.append(sequence1[row - 1])
	if column == 0:
		backwards_seq2_alignment.append("-")
	else:
		backwards_seq2_alignment.append(sequence2[column - 1])
	"""

	# hack to account for traceback going onto row or column 0
	if row == 0:
		backwards_seq1_alignment.append("-")
		backwards_seq2_alignment.append(sequence2[column - 1])
		column -= 1
		continue
	if column == 0:
		backwards_seq1_alignment.append(sequence1[row - 1])
		backwards_seq2_alignment.append("-")
		row -= 1
		continue

	direction = tb_matrix[row, column]
	if direction == 1:
		# go northwest, assign no gap
		backwards_seq1_alignment.append(sequence1[row - 1])
		backwards_seq2_alignment.append(sequence2[column - 1])
		row -= 1
		column -= 1
	elif direction == 2:
		# go left / west, assign gap to sequence 1
		
		backwards_seq1_alignment.append("-")
		backwards_seq2_alignment.append(sequence2[column - 1])
		column -= 1
	else:
		# go up / north, assign gap to sequence 2
		
		backwards_seq1_alignment.append(sequence1[row - 1])
		backwards_seq2_alignment.append("-")
		row -= 1





# The aligned sequences are assumed to be strings named sequence1_alignment
# and sequence2_alignment in later code

sequence1_alignment = ""
sequence2_alignment = ""

seq1_gaps = 0
seq2_gaps = 0
for char in backwards_seq1_alignment:
	sequence1_alignment = char + sequence1_alignment
	if char == "-":
		seq1_gaps += 1
for char in backwards_seq2_alignment:
	sequence2_alignment = char + sequence2_alignment
	if char == "-":
		seq2_gaps += 1

#print(sequence1_alignment)
#print()
#print(sequence2_alignment)

#print(alignment_score)


#=================================#
# Generate the identity alignment #
#=================================#

# This is just the bit between the two aligned sequences that
# denotes whether the two sequences have perfect identity
# at each position (a | symbol) or not.

n_matches_seq_1 = 0
identity_alignment = ''
for i in range(len(sequence1_alignment)):
	if sequence1_alignment[i] == sequence2_alignment[i]:
		identity_alignment += '|'
		n_matches_seq_1 += 1
	else:
		identity_alignment += ' '



percent_identity_1 = (n_matches_seq_1 * 100) / len(sequence1_alignment)

n_matches_seq_2 = 0
for i in range(len(sequence2_alignment)):
	if sequence2_alignment[i] == sequence1_alignment[i]:
		n_matches_seq_2 += 1

percent_identity_2 = (n_matches_seq_2 * 100) / len(sequence2_alignment)


#===========================#
# Write alignment to output #
#===========================#

# Certainly not necessary, but this writes 100 positions at
# a time to the output, rather than all of it at once.

output = open(outfile, 'w')

for i in range(0, len(identity_alignment), 100):
	output.write(sequence1_alignment[i:i+100] + '\n')
	output.write(identity_alignment[i:i+100] + '\n')
	output.write(sequence2_alignment[i:i+100] + '\n\n\n')


#=============================#
# Calculate sequence identity #
#=============================#


#======================#
# Print alignment info #
#======================#

# seq1 gaps
print(f"Sequence 1 Gaps: {seq1_gaps}")
# seq2 gaps
print(f"Sequence 2 Gaps: {seq2_gaps}")
# percent identity
print(f"Percent identity of Sequence 1: {percent_identity_1}%")
print(f"Percent identity of Sequence 2: {percent_identity_2}%")
# score
print(f"Score: {alignment_score}")

# You need the number of gaps in each sequence, the sequence identity in
# each sequence, and the total alignment score
