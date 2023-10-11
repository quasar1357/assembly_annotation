#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=02:00:00

#SBATCH --job-name=nucmer
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/output_nucmer_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/error_nucmer_%j.e

# Load the module
module add UHTS/Analysis/mummer/4.0.0beta1

# Define input (assemblies), reference and output paths
course_dir=/data/users/rschwob/01_assembly_annotation_course
pilon_dir=${course_dir}/results/3_polishing_2_pilon
flye=${pilon_dir}/*flye.fasta
canu=${pilon_dir}/*canu.fasta
ref=${course_dir}/references/*.fa
output_dir=${course_dir}/results/4_compare_genomes
mkdir ${output_dir}
cd ${output_dir}

# For all 3 combinations, run nucmer to map the assemblies against the ref. and against each other
# syntax: nucmer [options] <reference file> <query file>
# Options:
    # reference and query files should both be in multi-FastA format and have no limit on the number of sequences they man contain
    # --prefix: tag to use for outputs (i.e. identifier for comparisen, e.g. assembly_ref)
    # --breaklen (-b) <int>: Distance an alignment extension will attempt to extend poor scoring regions before giving up (default 200)
    # --mincluster (-c) <int>: Minimum cluster length (default 65)

# REFERENCE vs. FLYE
nucmer --prefix=ref_flye --breaklen 1000 --mincluster 1000 $ref $flye
# REFERENCE vs. CANU
nucmer --prefix=ref_canu --breaklen 1000 --mincluster 1000 $ref $canu
# FLYE vs. CANU
nucmer --prefix=flye_canu --breaklen 1000 --mincluster 1000 $flye $canu