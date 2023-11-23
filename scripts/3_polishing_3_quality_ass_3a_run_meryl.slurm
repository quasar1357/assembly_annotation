#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=02:00:00

#SBATCH --job-name=meryl
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/output_meryl_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/error_meryl_%j.e

# Load the module
module add UHTS/Assembler/canu/2.1.1

# Define input (illumina) and output directories
course_dir=/data/users/rschwob/01_assembly_annotation_course
illumina_dir=${course_dir}/raw_data/Illumina
output_dir=${course_dir}/results/3_polishing_3_quality_assessment_3_merqury
mkdir ${output_dir}

# Create meryl db (first for each read into $SCRATCH, then merge them and save in course directory)
meryl k=19 count output $SCRATCH/read_1.meryl ${illumina_dir}/*1.fastq.gz
meryl k=19 count output $SCRATCH/read_2.meryl ${illumina_dir}/*2.fastq.gz
meryl union-sum output ${output_dir}/illumina.meryl $SCRATCH/read*.meryl