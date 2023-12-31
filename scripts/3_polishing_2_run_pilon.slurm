#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=12
#SBATCH --mem=48G
#SBATCH --time=12:00:00

#SBATCH --job-name=run_pilon
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/output_run_pilon_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/error_run_pilon_%j.e

# Define input and output directories
course_dir=/data/users/rschwob/01_assembly_annotation_course
output_dir=${course_dir}/results/3_polishing_2_pilon
mkdir ${output_dir}
bam_dir=${course_dir}/results/3_polishing_1_align_illumina

# Define input files and run pilon with 45GB RAM

# FOR FLYE
assembly=${course_dir}/results/2_assembly_1_flye/pacbio/assembly.fasta
align_tag=bt2_flye
bam_file=${bam_dir}/${align_tag}.bam
java -Xmx45g -jar /mnt/software/UHTS/Analysis/pilon/1.22/bin/pilon-1.22.jar \
--genome ${assembly} --frags ${bam_file} --output pilon_${align_tag} --outdir ${output_dir}

# FOR CANU
assembly=${course_dir}/results/2_assembly_2_canu/pacbio/canu.contigs.fasta
align_tag=bt2_canu
bam_file=${bam_dir}/${align_tag}.bam
java -Xmx45g -jar /mnt/software/UHTS/Analysis/pilon/1.22/bin/pilon-1.22.jar \
--genome ${assembly} --frags ${bam_file} --output pilon_${align_tag} --outdir ${output_dir}