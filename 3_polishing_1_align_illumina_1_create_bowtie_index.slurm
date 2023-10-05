#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=12
#SBATCH --mem=48G
#SBATCH --time=1-00:00:00

#SBATCH --job-name=bt2_idx
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/output_bt2_index_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/error_bt2_index_%j.e

# Add the modules
module add UHTS/Aligner/bowtie2/2.3.4.1

# Define and create output directory
course_dir=/data/users/rschwob/01_assembly_annotation_course
output_dir=${course_dir}/results/3_polishing_1_align_illumina
mkdir ${output_dir}
cd ${output_dir}

# Define input assembly and create index

# FOR FLYE
assembly=${course_dir}/results/2_assembly_1_flye/pacbio/assembly.fasta
assembly_tag=bt2_flye
bowtie2-build ${assembly} ${assembly_tag}

# FOR CANU
assembly=${course_dir}/results/2_assembly_2_canu/pacbio/canu.contigs.fasta
assembly_tag=bt2_canu
bowtie2-build ${assembly} ${assembly_tag}