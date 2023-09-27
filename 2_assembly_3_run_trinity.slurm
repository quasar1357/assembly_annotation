#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=12
#SBATCH --mem=48G
#SBATCH --time=1-00:00:00

#SBATCH --job-name=trinity
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/output_trinity_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/error_trinity_%j.e

# Add the modules
module add UHTS/Analysis/jellyfish/2.3.0

# Define input and output directories
course_dir=/data/users/rschwob/01_assembly_annotation_course
fastq_parent_dir=${course_dir}/raw_data
output_parent_dir=${course_dir}/results/2_assembly_3_trinity
mkdir ${output_parent_dir}

# For the RNAseq library, get input folder and create output
seq_method=RNAseq
fastq_dir=${fastq_parent_dir}/${seq_method}
output_dir=${output_parent_dir}/${seq_method}
mkdir ${output_dir}

# Run trinity