#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=4
#SBATCH --mem=4G
#SBATCH --time=02:00:00

#SBATCH --job-name=grep
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/5_2_1_grep_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/5_2_1_grep_%j.e

# Define input and output paths
course_dir=/data/users/rschwob/01_assembly_annotation_course
    input_dir=${course_dir}/results/5_annotate_TEs_1_EDTA
        input_file=${input_dir}/pilon_bt2_flye.fasta.mod.EDTA.TElib.fa
    output_dir=${course_dir}/results/5_annotate_TEs_2_sort_TEs
    mkdir ${output_dir}

for tag in "Gypsy" "Copia"
do
    tag_dir=${output_dir}/${tag}
    mkdir ${tag_dir}
        output_file=${tag_dir}/${tag}.fa

    grep -A1 ${tag} ${input_file} | grep -v -- "^--$" > ${output_file}
done


# PATHS FOR SABRINA'S DATA:
# input_dir=/data/users/srasch/assembly_course/05_annotation/TE_annotator
# input_file=${input_dir}/polished.fasta.mod.EDTA.TElib.fa