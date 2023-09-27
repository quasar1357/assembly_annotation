#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pcourseassembly

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

# For each sequencing method, get input folder, create output folder and run the analysis
for fastq_dir in ${fastq_parent_dir}/*
do
    seq_method=$(basename "$fastq_dir")
    output_dir=${output_parent_dir}/${seq_method}
    mkdir ${output_dir}

    # Run jellyfish
    jellyfish count -C -m 19 -s 5000000000 -t 10 -o ${output_dir}/reads.jf <(zcat ${fastq_dir}/*)
    jellyfish histo -t 10 ${output_dir}/reads.jf > ${output_dir}/reads.histo
done