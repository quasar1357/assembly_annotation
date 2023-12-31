#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=01:00:00

#SBATCH --job-name=canu
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/output_canu_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/error_canu_%j.e

# Add the modules
module add UHTS/Assembler/canu/2.1.1

# Define input and output directories
course_dir=/data/users/rschwob/01_assembly_annotation_course
fastq_parent_dir=${course_dir}/raw_data
output_parent_dir=${course_dir}/results/2_assembly_2_canu
mkdir ${output_parent_dir}

# For the pacbio library, get input folder and create output
seq_method=pacbio
fastq_dir=${fastq_parent_dir}/${seq_method}
output_dir=${output_parent_dir}/${seq_method}
mkdir ${output_dir}

# Run canu
canu -p canu -d ${output_dir} genomeSize=131m -pacbio ${fastq_dir}/* \
        maxThreads=16 maxMemory=64 \
        gridEngineResourceOption="--cpus-per-task=THREADS --mem-per-cpu=MEMORY" \
        gridOptions="--mail-user=roman.schwob@students.unibe.ch --mail-type=end,fail --partition=pall --job-name=canu"





                # "--output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/output_canu_%j.o " + \
                # "--error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/error_canu_%j.e"

# files="ERR3415830.fastq.gz ERR3415831.fastq.gz"
# gridEngineResourceOption="--cpus-per-task=THREADS --mem-per-cpu=MEMORY"


# # what is the genome size?
# for file in $files; do
#   canu -p pacbio_canu -d $out_dir genomeSize=124m -pacbio $file_path/$file maxThreads=16 maxMemory=64
# done