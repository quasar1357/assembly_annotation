#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=50
#SBATCH --mem=10G
#SBATCH --time=05:00:00

#SBATCH --job-name=TEsorter
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/output_TEsorter_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/error_TEsorter_%j.e

# Define working directory
working_dir=/data/users/rschwob/01_assembly_annotation_course/results/5_annotate_TEs_SABRINA

COURSEDIR=/data/courses/assembly-annotation-course

for tag in "Gypsy" "Copia"
do
    tag_dir=${working_dir}/${tag}
    input_file=${tag_dir}/${tag}.fa
    mkdir ${tag_dir}
    cd ${tag_dir}

    singularity exec \
    --bind ${COURSEDIR} \
    --bind ${tag_dir} \
    ${COURSEDIR}/containers2/TEsorter_1.3.0.sif \
    TEsorter ${input_file} -db rexdb-plant -pre ${tag}
done