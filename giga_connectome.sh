#!/bin/bash
#SBATCH --account=rrg-pbellec
#SBATCH --output=/lustre04/scratch/hwang1/wonkyconn/logs/%x_%A.%a.out
#SBATCH --error=/lustre04/scratch/hwang1/wonkyconn/logs/%x_%A.%a.err
#SBATCH --time=6:00:00
#SBATCH --mem=4G
#SBATCH --cpus-per-task=1
#SBATCH --array=1-7

STRATEGIES=("simple" "simple+gsr" "scrubbing.5" "scrubbing.5+gsr" "scrubbing.2" "scrubbing.2+gsr" "acompcor50")
STRATEGY=${STRATEGIES[${SLURM_ARRAY_TASK_ID} - 1 ]}

FMRIPREP_DIR=${SCRATCH}/wonkyconn/ds000228_fmriprep/fmriprep-20.2.5lts
CONNECTOME_DIR=${SCRATCH}/wonkyconn/ds000228_giga-connectome
GIGA_CONNECTOME=${HOME}/projects/rrg-pbellec/${USER}/fmriprep-denoise-benchmark-reproducible/giga_connectome.simg

module load apptainer/1.2.4

mkdir -p ${WORKINGDIR}
apptainer run \
	--bind ${FMRIPREP_DIR}:/inputs \
	--bind ${CONNECTOME_DIR}:/outputs \
	${GIGA_CONNECTOME} \
	-a /outputs/atlases \
	--atlas MIST \
	--denoise-strategy ${STRATEGY} \
	/inputs \
	/outputs \
	participant       
