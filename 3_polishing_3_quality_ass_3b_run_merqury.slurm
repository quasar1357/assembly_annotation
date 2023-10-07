#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=10:00:00

#SBATCH --job-name=merqury
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/output_merqury_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/error_merqury_%j.e

# Define input and output directories
course_dir=/data/users/rschwob/01_assembly_annotation_course
meryl_dir=${course_dir}/results/3_polishing_3_quality_assessment_3_merqury/illumina.meryl
output_dir=${course_dir}/results/3_polishing_3_quality_assessment_3_merqury
mkdir ${output_dir}
cd ${output_dir}

# Define input file and options
# NOTE: CHOOSE THE ONE TO USE (OUT-COMMENT THE OTHERS)

assembly=${course_dir}/results/3_polishing_2_pilon/pilon_bt2_flye.fasta
output_tag=flye_polished

# assembly=${course_dir}/results/3_polishing_2_pilon/pilon_bt2_canu.fasta
# output_tag=canu_polished

# assembly=${course_dir}/results/2_assembly_1_flye/pacbio/assembly.fasta
# output_tag=flye_original

# assembly=${course_dir}/results/2_assembly_2_canu/pacbio/canu.contigs.fasta
# output_tag=canu_original

# Change permisson of assembly otherwise there is an error (I did not fully understand why) and go to folder where results should be stored.
# chmod ugo+rwx ${assembly}

# Run merqury
apptainer exec \
--bind ${course_dir} \
/software/singularity/containers/Merqury-1.3-1.ubuntu20.sif \
merqury.sh ${meryl_dir} ${assembly} ${output_tag}