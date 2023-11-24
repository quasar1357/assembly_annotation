#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=50
#SBATCH --mem=10G
#SBATCH --time=05:00:00

#SBATCH --job-name=TEsorter
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/5_2_3_TEsorter_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/5_2_3_TEsorter_%j.e

# Define output and input directories
course_dir=/data/users/rschwob/01_assembly_annotation_course
tag="Brass_db"
    output_dir=${course_dir}/results/5_annotate_TEs_2_sort_TEs/${tag}
    mkdir ${output_dir}
    cd ${output_dir}
COURSEDIR=/data/courses/assembly-annotation-course
    input_dir=${COURSEDIR}/CDS_annotation/
        input_file=${input_dir}/Brassicaceae_repbase_all_march2019.fasta

# Run TEsorter (singularity container)
singularity exec \
--bind ${output_dir} \
--bind ${COURSEDIR} \
${COURSEDIR}/containers2/TEsorter_1.3.0.sif \
TEsorter ${input_file} -db rexdb-plant -pre ${tag}