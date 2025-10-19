# Project AIFS ensemble inference:

## I. Build the environment
for ATOS, build up environment:
1. use the environment list:
2. use conda and pip install each package.
* Need to install the package one by one; otherwise there will 
> torch==2.5.0
> anemoi-inference[huggingface]==0.6.0
> anemoi-models==0.6.0
> anemoi-graphs==0.6.0
> anemoi-datasets==0.5.23
> earthkit-regrid==0.4.0 'ecmwf-opendata>=0.3.19'
> flash_attn

> sbatch slurm_aifs_ens_1000.sh

## II. Test the environment:
1. with ecinteractive
2. use shell file '' to run on AIFS 

## III. Download model checkout.
* from https://huggingface.co/ecmwf/aifs-ens-1.0/blob/main/aifs-ens-crps-1.0.ckpt
* 

## IV. Make initial condition from IFS archive.
## V. set up the experiments with **reg_emi_2015_48h.yaml** and *slurm*


---
Notes:
1. conda sometimes
to use cdo:
> module reset
> ml cdo
