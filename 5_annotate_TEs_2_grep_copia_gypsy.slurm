#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=4
#SBATCH --mem=4G
#SBATCH --time=02:00:00

#SBATCH --job-name=grep
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/output_grep_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/error_grep_%j.e

course_dir=/data/users/rschwob/01_assembly_annotation_course
# input_dir=${course_dir}/results/5_annotate_TEs
input_dir=/data/users/srasch/assembly_course/05_annotation/TE_annotator
input_file=${input_dir}/polished.fasta.mod.EDTA.TElib.fa
output_dir=${course_dir}/results/5_annotate_TEs_SABRINA
mkdir ${output_dir}

for tag in "Gypsy" "Copia"
do
    tag_dir=${output_dir}/${tag}
    mkdir ${tag_dir}
    output_file=${tag_dir}/${tag}.fa

    grep -A1 ${tag} ${input_file} | grep -v -- "^--$" > ${output_file}
done