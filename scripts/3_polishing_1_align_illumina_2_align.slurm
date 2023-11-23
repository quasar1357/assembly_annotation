#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=12
#SBATCH --mem=48G
#SBATCH --time=10:00:00

#SBATCH --job-name=bt2_align
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/output_bt2_align_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/error_bt2_align_%j.e

# Add the modules
module add UHTS/Aligner/bowtie2/2.3.4.1

# Define input and output directories
course_dir=/data/users/rschwob/01_assembly_annotation_course
illumina_dir=${course_dir}/raw_data/Illumina
assembly_dir=${course_dir}/results/3_polishing_1_align_illumina
cd ${assembly_dir}

# Define input assembly and run alignment, with paired-end illumina reads and sensitive local mode
# Options:
    # --threads (-p): Launch NTHREADS parallel search threads (default: 1)
    # -x <bt2-idx>: basename of the index for the reference genome (= name of any of the index files up to but not including the final .1.bt2 / .rev.1.bt2 / etc.)
    # -1 <m1> -2 <m2>: Comma-separated lists of files containing mate 1s and 2s (filename usually includes _1 and _2). Must correspond file-for-file and read-for-read with each other.
    # -S <sam>: File to write SAM alignments to. NOTE: It would be better to pipe straight into SAM-tools SAM_to_BAM conversion!
    # --sensitive-local: Same as: -D 15 -R 2 -N 0 -L 20 -i S,1,0.75; automatically sets --local...
        # --local: Bowtie 2 does not require that the entire read align from one end to the other. Rather, some characters may be omitted ("soft clipped") from the ends in order to achieve the greatest possible alignment score.

# FOR FLYE
assembly_tag=bt2_flye
bowtie2 -p 4 -x ${assembly_tag} -1 ${illumina_dir}/*_1* -2 ${illumina_dir}/*_2* -S ${assembly_tag}.sam --sensitive-local

# FOR CANU
assembly_tag=bt2_canu
bowtie2 -p 4 -x ${assembly_tag} -1 ${illumina_dir}/*_1* -2 ${illumina_dir}/*_2* -S ${assembly_tag}.sam --sensitive-local

