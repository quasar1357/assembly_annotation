#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=4
#SBATCH --mem=40G
#SBATCH --time=02:00:00

#SBATCH --job-name=jellyfish
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/output_jellyfish_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/error_jellyfish_%j.e

# Add the modules
module add UHTS/Analysis/jellyfish/2.3.0

# Define input and output directories
course_dir=/data/users/rschwob/01_assembly_annotation_course
fastq_parent_dir=${course_dir}/raw_data
output_parent_dir=${course_dir}/results/1_QC_2_jellyfish
mkdir ${output_parent_dir}

# For each sequencing method, get input folder, create output folder and run the analysis
for fastq_dir in ${fastq_parent_dir}/*
do
    seq_method=$(basename "$fastq_dir")
    output_dir=${output_parent_dir}/${seq_method}
    mkdir ${output_dir}

    # Run jellyfish
    jellyfish count -C -m 14 -s 1000000000 -t 4 -o ${output_dir}/reads.jf <(zcat ${fastq_dir}/*)
    jellyfish histo -t 10 ${output_dir}/reads.jf > ${output_dir}/reads.histo
done