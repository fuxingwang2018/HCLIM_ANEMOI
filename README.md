# 🌐 Project: AIFS Ensemble Inference

This document describes the setup and execution steps for running **AIFS ensemble inference** on the ATOS system.

---

## I. Build the Environment

### 1. Load Conda on ATOS
```bash
module load conda
```

### 2. Create a Conda Environment

#### Option 1: Using the environment file (⚠️ may fail due to pip–conda conflicts)
```bash
conda env create -f environment.yml -n env_test_anemoi
```

#### Option 2: Manual installation (recommended)
If the above fails or you encounter disk quota issues, install packages manually:

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
pip install flash_attn
```

Once everything is installed, test the setup by submitting a test job:
```bash
sbatch slurm_aifs_ens_1000.sh
```

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

- **Anemoi Inference Configuration Guide:**  
  [https://anemoi.readthedocs.io/projects/inference/en/latest/inference/configs/top-level.html](https://anemoi.readthedocs.io/projects/inference/en/latest/inference/configs/top-level.html)

---

## 🤝 Acknowledgment

This GitHub repository is a collaborative effort of the **ML Working Group of the HCLIM Consortium**.  
Most scripts and workflows were developed by **Toni (AEMET)**.

---
