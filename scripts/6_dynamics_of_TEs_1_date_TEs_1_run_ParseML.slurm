#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=4
#SBATCH --mem=5G
#SBATCH --time=05:00:00

#SBATCH --job-name=date
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/6_1_date_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/6_1_date_%j.e

# Installed into environment one of the following:
# conda install -c bioconda perl-bioperl
# consta install -c "bioconda/label/cf201901" perl-bioperl

# Define output and input directories
genome=pilon_bt2_flye.fasta
course_dir=/data/users/rschwob/01_assembly_annotation_course
in_dir=${course_dir}/results/5_annotate_TEs_1_EDTA/${genome}.mod.EDTA.anno
in_file=${in_dir}/${genome}.mod.out
output_dir=${course_dir}/results/6_dynamics_of_TEs_1_dating
    mkdir ${output_dir}
    cd ${output_dir}

# 1) split the amount of DNA by bins of % divergence (or My) for each repeat name, family or class
parse_script=/data/users/rschwob/01_assembly_annotation_course/scripts/6_dynamics_of_TEs_1_date_TEs_ParseML.pl
perl ${parse_script} -i ${in_file} -l 50,1 -v
# move output files to output folder (is by default created in input folder)
mv ${in_dir}/*landscape* ${output_dir}

# 2) removing the first and the 3rd line
sed_in=${genome}.mod.out.landscape.Div.Rname.tab
sed_out=${sed_in}.sed
sed '1d;3d' ${sed_in} > ${sed_out}


# ==> Use R-script (locally) to create plot