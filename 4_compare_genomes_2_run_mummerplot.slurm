#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=02:00:00

#SBATCH --job-name=mummerplot
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/output_mummerplot_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/error_mummerplot_%j.e

# Load the module
module add UHTS/Analysis/mummer/4.0.0beta1
export PATH=/software/bin:$PATH

# Define input (assemblies), reference and output paths
course_dir=/data/users/rschwob/01_assembly_annotation_course
pilon_dir=${course_dir}/results/3_polishing_2_pilon
flye=${pilon_dir}/*flye.fasta
canu=${pilon_dir}/*canu.fasta
ref=${course_dir}/references/*.fa
output_dir=${course_dir}/results/4_compare_genomes
mkdir ${output_dir}
cd ${output_dir}

# For all 3 combinations, run mummerplot
# syntax: mummerplot [options] <match file>
# Options:
    # match file = output file of nucmer (generally either a three column match list from mummer or the delta file from nucmer or promer)
    #  --Rfile (-R) <string>: desired reference sequences; generate a multiplot by using the order and length information contained in this file, either a FastA file of the desired reference sequences or a tab-delimited list of sequence IDs, lengths and orientations [ +-]
    #  --Qfile (-Q) <string>: desired query sequences; generate a multiplot by using the order and length information contained in this file, either a FastA file of the desired query sequences or a tab-delimited list of sequence IDs, lengths and orientations [ +-] 
    # --filter (-f): Only display alignments which represent the "best" one-to-one mapping of reference and query subsequences (requires delta formatted input)
    #  -t <string>: Set the output terminal to x11, postscript or png (alternative: --x11 --postscript --png)
    #  -s <string>: Set the output size to small, medium or large (alternative: --small --medium --large)
    # --layout (-l): Layout a multiplot by ordering and orienting sequences such that the largest hits cluster near the main diagonal (requires delta formatted input)
    # -p: prefix for output
    # --fat: ??? (old version?)

# REFERENCE vs. FLYE
mummerplot -R $ref -Q $flye --filter -t png -s large --layout -p ref_flye ref_flye.delta
# REFERENCE vs. CANU
mummerplot -R $ref -Q $canu --filter -t png -s large --layout -p ref_canu ref_canu.delta
# FLYE vs. CANU
mummerplot -R $flye -Q $canu --filter -t png -s large --layout -p flye_canu flye_canu.delta