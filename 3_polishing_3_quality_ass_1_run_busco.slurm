#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=1-00:00:00

#SBATCH --job-name=busco
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/output_busco_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/error_busco_%j.e

# Load busco
module add UHTS/Analysis/busco/4.1.4

# Define input and output directories
course_dir=/data/users/rschwob/01_assembly_annotation_course
output_dir=${course_dir}/results/3_polishing_3_quality_assessment_1_busco
mkdir ${output_dir}
cd ${output_dir}

# Make Augustus config file writable (temporarily copy to working directory)
cp -r /software/SequenceAnalysis/GenePrediction/augustus/3.3.3.1/config augustus_config
export AUGUSTUS_CONFIG_PATH=./augustus_config

# # Define input file and options
# assembly=${course_dir}/results/3_polishing_2_pilon/pilon_bt2_flye.fasta
# output_tag=flye_polished
# assembly_type=genome

# assembly=${course_dir}/results/3_polishing_2_pilon/pilon_bt2_canu.fasta
# output_tag=canu_polished
# assembly_type=genome

# assembly=${course_dir}/results/2_assembly_1_flye/pacbio/assembly.fasta
# output_tag=flye_original
# assembly_type=genome

assembly=${course_dir}/results/2_assembly_2_canu/pacbio/canu.contigs.fasta
output_tag=canu_original
assembly_type=genome

# assembly=${course_dir}/results/2_assembly_3_trinity/Trinity.fasta
# output_tag=trinity_RNA
# assembly_type=transcriptome # IMPORTANT TO HAVE TRANSCRIPTOME HERE !

# Run busco
busco --lineage_dataset brassicales_odb10 --cpu 4 \
-i ${assembly} -o ${output_tag} --mode ${assembly_type} 
# Options:
    # --lineage_dataset: can be a dataset name, e.g. bacteria_odb10, (recommended usage) -> BUSCO will automatically download and version the corresponding dataset
    # --mode: genome, transcriptome or proteins, depending on the assembly
    # --cpu: number (N=integer) of threads/cores to use
    # -i (input): Input sequence file in FASTA format -> assembled genome or transcriptome (DNA), or protein sequences from an annotation
    # -o (outuput): Output folders and files will be labelled with this name. WARNING: do not provide a path


# Remove the copied config
rm -r ./augustus_config