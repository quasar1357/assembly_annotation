#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --time=2-20:00:00
#SBATCH --mem-per-cpu=12G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16

#SBATCH --job-name=maker
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/7_maker_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/7_maker_%j.e

module load SequenceAnalysis/GenePrediction/maker/2.31.9;

# Define output and input directories
course_dir=/data/users/rschwob/01_assembly_annotation_course
output_dir=${course_dir}/results/7_annot_prots_run_2
    mkdir ${output_dir}
    cd ${output_dir}
ctl=${course_dir}/scripts/7_annot_prots_maker_opts.ctl


# 1) CREATE CONTROL FILES
# maker -CTL


# 2) Copy the prepared maker opts from script folder to output folder (overwriting the freshly created template)
# cp ${ctl} ${output_dir}/maker_opts.ctl


# 3) RUN MAKER

COURSEDIR=/data/courses/assembly-annotation-course
SOFTWAREDIR=/software

ln -s /data/courses/assembly-annotation-course/CDS_annotation

mpiexec -n 16 singularity exec \
--bind ${SCRATCH} \
--bind ${COURSEDIR} \
--bind ${SOFTWAREDIR} \
--bind ${course_dir} \
${COURSEDIR}/containers2/MAKER_3.01.03.sif \
maker -mpi -base run_mpi maker_opts.ctl maker_bopts.ctl maker_exe.ctl


# DELETED CODE/COMMENTS:

# IMPORTANT: NOW GO EDIT maker_opts.ctl in the output folder, comment out step 1) and run step 3)

# export SLURM_EXPORT_ENV=ALL
# export LIBDIR=/software/SequenceAnalysis/Repeat/RepeatMasker/4.0.7/Libraries
# export REPEATMASKER_DIR=/software/SequenceAnalysis/Repeat/RepeatMasker/4.0.7/RepeatMasker

# --bind $SCRATCH:/TMP \
# --bind ${COURSEDIR}:/${COURSEDIR} \
# --bind ${SOFTWAREDIR}:/${SOFTWAREDIR} \
# --bind ${course_dir}:${course_dir} \
# ${COURSEDIR}/containers2/MAKER_3.01.03.sif \
# maker -mpi --ignore_nfs_tmp -TMP /TMP maker_opts.ctl maker_bopts.ctl maker_exe.ctl