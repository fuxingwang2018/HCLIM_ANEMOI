#!/bin/bash

#SBATCH --qos=ng
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gpus-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=80G
#SBATCH --time=10:00:00
#SBATCH --job-name=inference-dana_2_step_aifs_ens
#SBATCH --output=testRunner4.out

# debugging flags (optional)
export NCCL_DEBUG=INFO
export PYTHONFAULTHANDLER=1

export HYDRA_FULL_ERROR=1
#export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True
#export ECCODES_DEFINITION_PATH=/perm/esp8096/conda/envs/anemoi-training/share/eccodes/definitions:/etc/ecmwf/nfs/dh2_10_perm_b/esp8096/inferencia/eccodes_definitions_harmonie

# generic settings
#CONDA_ENV=anemoi_ens
CONDA_ENV=env_test_anemoi

export AIFS_BASE_SEED=1

cd $WORKDIR
ml conda/new
conda activate $CONDA_ENV

export PYTHONNOUSERSITE=1


CONFIG_DIR="/perm/swe0632/PROJ_anemoi_oct2025/"
#CONFIG_DIR="/ec/res4/scratch/swe0632/Proj_anemoi"
#CONFIG_DIR="/perm/esp7856/Virtual/descargas/config"
CONFIG_FILE="${CONFIG_DIR}/reg_emi_2015_48h.yaml"
OUTDIR="/ec/res4/scratch/swe0632/Proj_anemoi/output_envtest/"

for m in $(seq -w 1 5); do
#srun anemoi-inference run "$CONFIG_FILE" output.grib=${OUTDIR}"/scratch/esp7856/GRIBS/ensemble/output_ens_reg_emi_2015-48h_ens-member_${m}.grib"
srun anemoi-inference run "$CONFIG_FILE" output.grib="${OUTDIR}/output_ens_reg_emi_2015-48h_ens-member_${m}.grib"
sleep 0.005
done

