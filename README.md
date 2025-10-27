# HCLIM_ANEMOI
Appication of ANEMOI for HCLIM

- # 🌐 AIFS Ensemble Inference

- This document describes the setup and execution steps for running **AIFS ensemble inference** on the ATOS system.

---

## I. Build the Environment

### 1. Load Conda on ATOS
```bash
module load conda
```

### 2. Create a Conda Environment
As the environment is built with a mixture of conda and pip, installation of the environment needs to be done mannually on ATOS.
We are currently investigating if there is any preinstalled package on ATOS that can be used.

```bash
# Create and activate environment
conda create -n env_test_anemoi python=3.11.6
conda activate env_test_anemoi

# Install packages individually
pip install torch==2.5.0
pip install anemoi-inference[huggingface]==0.6.0
pip install anemoi-models==0.6.0
pip install anemoi-graphs==0.6.0
pip install anemoi-datasets==0.5.23
pip install "earthkit-regrid==0.4.0" "ecmwf-opendata>=0.3.19"
pip install flash_attn==2.7.3
```

⚙️ Note 
* Some version correction may be needed:
1. The right cuda version needs to be installed during the process.
   ```
   $ ln -s /usr/local/apps/cuda/12.6/ /perm/smf/cuda_12.6
   $ export CUDA_HOME=/perm/smf/cuda_12.6
   ```
3. reverse the anemoi.utils version.
```
  conda install anemoi.utils=0.4.22
```

* Conda Channels (for ECMWF Users)
  The default Anaconda repository (https://repo.anaconda.com/) is blocked within the ECMWF network due to licensing restrictions.
  To ensure compatibility, please configure Conda to use only the conda-forge channel.

  You can verify and adjust your Conda channel configuration as follows:
  ```
  # Check current channels
  conda config --show channels

  # If "defaults" appears, remove it
  conda config --remove channels defaults

  # Verify the updated configuration
  conda config --show channels
  ```
  Expected output:
  ```
  channels:
    - conda-forge
  ```

  With this configuration, environments can be created exclusively from conda-forge.
    - Conda-forge URL: https://conda.anaconda.org  
    - (Blocked) Default Anaconda repository: https://repo.anaconda.com


---

## II. Test the Environment

You can interactively test the setup using:
```bash
ecinteractive
```

---

## III. Download Model Checkpoint

Download the pretrained model from Hugging Face:
🔗 [AIFS ENS 1.0 Checkpoint](https://huggingface.co/ecmwf/aifs-ens-1.0/blob/main/aifs-ens-crps-1.0.ckpt)

---

## IV. Generate Initial Conditions from IFS Archive

Use the provided script to generate the initial condition file:
```bash
vi input/download_aifs.sh
```

---

## V. Set Up the Experiment

Edit your configuration file (e.g., `reg_emi_2015_48h.yaml`) as follows:

```yaml
checkpoint: <path_cktpt>/aifs-ens-crps-1.0.ckpt
lead_time: 48
input:
  grib: <path_IC>/aifs_input_state_20230514_n320_18z_20230515_00z.grib
output:
  grib: <path_output>/output_ens_dana_italy.grib
```

---

## VI. Run the Experiment on SLURM

Submit the job script:
```bash
sbatch slurm_aifs_ens_1000.sh
```

---

## 🔍 References

- **AIFS ENS v1 Description:**  
  [https://confluence.ecmwf.int/display/FCST/Implementation+of+AIFS+ENS+v1](https://confluence.ecmwf.int/display/FCST/Implementation+of+AIFS+ENS+v1)

- **Anemoi Inference Configuration Guide: top-level configuration**  
  [https://anemoi.readthedocs.io/projects/inference/en/latest/inference/configs/top-level.html](https://anemoi.readthedocs.io/projects/inference/en/latest/inference/configs/top-level.html)

 - **https://huggingface.co/ecmwf/aifs-ens-1.0**
   
 - **https://anemoi.ecmwf.int/**

---

## 🤝 Acknowledgment

This GitHub repository is a collaborative effort of the **ML Working Group of the HCLIM Consortium**.  
Most scripts and workflows were developed by **Toni (AEMET)**.

---
