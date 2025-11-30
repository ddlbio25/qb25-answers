# Step 1.1
1 * 10^6 x 3 / 100 = 30K

Need 30K reads for 3x coverage of 1 million


# Step 1.4
50941 bps have 0 coverage

This matches well to the poisson estimate of 49787 bases out of a million bp genome

The normal distribution does not fit the simulation particuarly well, since the normal distribution predicted more bases to be at or above 3x coverage than what was simulated.

# Step 1.5

98 bases in the genome have 0 coverage in the simulation.

This matches pretty well to the poisson estiamte of 45 bases having 0 coverage in the 1 million bp long genome.

The normal distribution is a better fit compared to the 3x coverage simulation, but the right side of the normal distribution still predicts more bases in the genome having higher than 10x coverage than the poisson or simulation.


# Step 1.6
7 bases out of a 1 million genome have 0 coverage. This matches pretty well to the poisson estimate of  (basically 0) bases in the genome having zero coverage.

THe normal distribution is an even better fit compared to the previous simulations, and virtually matches the simulated sequencing distribution. The normal distribution still predicts more bases with 30x coverage than the simulation or the poisson distribution.


# Step 2.4
./de_bruijn.py | dot -Tpng -o ex2_digraph.png

# Step 2.5
ATTCATTGATTGATTCTTATTT

# Step 2.6

In order to accurately reconstruct the sequence of the genome, we would likely need longer kmers. With k=3, we see loops in the de bruijn graph. If the k-mers from length 5 reads are still too short to resolve the loops, then we would likely need reads of longer length to resolve the loops.