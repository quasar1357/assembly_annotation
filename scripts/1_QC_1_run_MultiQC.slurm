#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=1
#SBATCH --mem=4000M
#SBATCH --time=01:00:00

#SBATCH --job-name=MutiQC
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/output_MutiQC_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/error_MutiQC_%j.e

module add UHTS/Analysis/MultiQC/1.8

course_dir=/data/users/rschwob/01_assembly_annotation_course
parent_dir=${course_dir}/results/1_QC_1_FastQC #Illuminapacbio, RNAseq

# For each sequencing method, get input folder, create output folder and run the analysis
for qc_dir in ${parent_dir}/*
do
    seq_method=$(basename "$qc_dir")
    seq_dir=${parent_dir}/${seq_method}
    # mkdir ${seq_dir}

    # Run the quality analysis
    multiqc --filename ${seq_method}_MultiQC -o ${seq_dir}/MultiQC ${seq_dir}
    
done