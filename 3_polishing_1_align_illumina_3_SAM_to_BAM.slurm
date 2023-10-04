#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=12
#SBATCH --mem=48G
#SBATCH --time=05:00:00

#SBATCH --job-name=SAM_to_BAM
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/output_SAM_to_BAM_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/error_SAM_to_BAM_%j.e

# Add the modules
module add UHTS/Analysis/samtools/1.10

# Define working directory
course_dir=/data/users/rschwob/01_assembly_annotation_course
working_dir=${course_dir}/results/3_polishing_1_align_illumina

# Define input and output files and run conversion to BAM including sorting and indexing (for both assemblies)
assembly_tag=bt2_flye
sam_file=${working_dir}/${assembly_tag}.sam
bam_unsorted=${working_dir}/${assembly_tag}_unsorted.bam
bam_file=${working_dir}/${assembly_tag}.bam
samtools view -b ${sam_file} > ${bam_unsorted}
# "-b": output as BAM
samtools sort ${bam_unsorted} -o ${bam_file}
# "sort": Sort alignments by leftmost coordinates, or by read name when -n is used. 
# "-o": Write final output to FILE rather than standard output
samtools index ${bam_file}
rm ${bam_unsorted}
rm ${sam_file}

assembly_tag=bt2_canu
sam_file=${working_dir}/${assembly_tag}.sam
bam_unsorted=${working_dir}/${assembly_tag}_unsorted.bam
bam_file=${working_dir}/${assembly_tag}.bam
samtools view -b ${sam_file} > ${bam_unsorted}
# "-b": output as BAM
samtools sort ${bam_unsorted} -o ${bam_file}
# "sort": Sort alignments by leftmost coordinates, or by read name when -n is used. 
# "-o": Write final output to FILE rather than standard output
samtools index ${bam_file}
rm ${bam_unsorted}
rm ${sam_file}