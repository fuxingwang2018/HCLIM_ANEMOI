# Project AIFS ensemble inference:

## I. Build the environment
for ATOS, build up environment:
> module load conda
1. use the environment list:
> conda env create -f environment.yml -n env_test_anemoi
=> not working because of pip and conda mixed use.
2. use conda and pip install each package.
* Need to install the package one by one; otherwise there will be error message of DiskQuota full.
> conda create -n env_test_anemoi python=3.11.6

> conda activate env_test_anemoi

> pip install torch==2.5.0
> pip install anemoi-inference[huggingface]==0.6.0
> pip install anemoi-models==0.6.0
> pip install anemoi-graphs==0.6.0
> pip install anemoi-datasets==0.5.23
> pip install earthkit-regrid==0.4.0 'ecmwf-opendata>=0.3.19'
> pip install flash_attn

> sbatch slurm_aifs_ens_1000.sh

## II. Test the environment with ecinteractive:
> ecinteractive


## III. Download model checkout.
* from https://huggingface.co/ecmwf/aifs-ens-1.0/blob/main/aifs-ens-crps-1.0.ckpt
 

## IV. Make initial condition from IFS archive.
   Use the script to create initial condition.
> vi input/download_aifs.sh

## V. set up the experiments with **reg_emi_2015_48h.yaml**
> checkpoint: <path_cktpt>/aifs-ens-crps-1.0.ckpt
> lead_time: 48
> input:
  grib: <path_IC>/aifs_input_state_20230514_n320_18z_20230515_00z.grib
> output:
   grib: <path_output>/output_ens_dana_italy.grib

 
## VI. run the script on slurm system.
> sbatch **slurm_aifs_ens_1000.sh**


---
Notes:

* description of AIFS ENS v1:
https://confluence.ecmwf.int/display/FCST/Implementation+of+AIFS+ENS+v1
* description of top-level configuration for anemoi-inference:
https://anemoi.readthedocs.io/projects/inference/en/latest/inference/configs/top-level.html

---
Acknowledgment: This github is the collaborative work of ML working group of HCLIM consortium. Most the scripts and works are done by Toni from AEMET.
