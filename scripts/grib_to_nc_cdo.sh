#!/bin/bash

# --- 1. Define Variables ---

module load wgrib
module load wgrib2
module load cdo

# NOTE: NO SPACES around '=' for variable assignment.
OUTDIR=/ec/res4/scratch/swe0632/Proj_anemoi/output/
OUTDIR_NC=/ec/res4/scratch/swe0632/Proj_anemoi/output_nc/
BASE_NAME=output_ens_reg_emi_2015-48h_ens-member_2 
INPUT_MIXED_GRIB=${OUTDIR}${BASE_NAME}.grib # Your original mixed input file

# Output names for the separated GRIB files (in current directory)
GRIB1_OUT_GRIB_SEP=${OUTDIR}${BASE_NAME}_grb1.grb
GRIB2_OUT_GRIB_SEP=${OUTDIR}${BASE_NAME}_grb2.grb

# Output names for the intermediate CDO-processed GRIB files (in $OUTDIR)
GRIB1_OUT_GRIB_REG=${OUTDIR}${BASE_NAME}_grb1_reg.grib
GRIB2_OUT_GRIB_REG=${OUTDIR}${BASE_NAME}_grb2_reg.grib

# Output names for the final NetCDF files (in $OUTDIR)
GRIB1_OUT_NC=${OUTDIR_NC}${BASE_NAME}_grb1.nc
GRIB2_OUT_NC=${OUTDIR_NC}${BASE_NAME}_grb2.nc
FINAL_MERGED_NC=${OUTDIR_NC}${BASE_NAME}_merged.nc

TARGET_GRID=r1440x720 

## ----------------------------------------------------------------------

# --- 2. Separate the Mixed GRIB File ---

echo "Splitting mixed GRIB file (${INPUT_MIXED_GRIB}) into GRIB1 and GRIB2..."

# Get GRIB1 messages:
# wgrib reads the file and outputs only GRIB1 messages to the specified file.
wgrib "${INPUT_MIXED_GRIB}" -grib -d all -o "${GRIB1_OUT_GRIB_SEP}"

# Get GRIB2 messages:
# wgrib2 reads the file and outputs only GRIB2 messages to the specified file.
wgrib2 "${INPUT_MIXED_GRIB}" -grib "${GRIB2_OUT_GRIB_SEP}"

echo "Separation complete. GRIB1: ${GRIB1_OUT_GRIB_SEP}, GRIB2: ${GRIB2_OUT_GRIB_SEP}"

## ----------------------------------------------------------------------

# --- 3. Process GRIB1 File (Regrid and Convert to NetCDF) ---

echo "Processing GRIB1 data..."

# a) Transform GRIB1 from reduced gaussian to regular grid (0.25x0.25 degree)
cdo remapcon,${TARGET_GRID} -setgridtype,regular "${GRIB1_OUT_GRIB_SEP}" "${GRIB1_OUT_GRIB_REG}"

# b) Convert the re-gridded GRIB1 file to NetCDF
cdo -f nc copy "${GRIB1_OUT_GRIB_REG}" "${GRIB1_OUT_NC}"

echo "GRIB1 NetCDF output: ${GRIB1_OUT_NC}"
rm "${GRIB1_OUT_GRIB_REG}"
## ----------------------------------------------------------------------

# --- 4. Process GRIB2 File (Regrid and Convert to NetCDF) ---

echo "Processing GRIB2 data..."

# a) Transform GRIB2 from reduced gaussian to regular grid (0.25x0.25 degree)
cdo remapcon,${TARGET_GRID} -setgridtype,regular "${GRIB2_OUT_GRIB_SEP}" "${GRIB2_OUT_GRIB_REG}"

# b) Convert the re-gridded GRIB2 file to NetCDF
cdo -f nc copy "${GRIB2_OUT_GRIB_REG}" "${GRIB2_OUT_NC}"

echo "GRIB2 NetCDF output: ${GRIB2_OUT_NC}"
rm "${GRIB2_OUT_GRIB_REG}"
## ----------------------------------------------------------------------

# --- 5. Merge NetCDF Files (Optional) ---

echo "Merging GRIB1 and GRIB2 NetCDF files into a single file..."

# This step combines the variables from the two separate NetCDF files.
cdo merge "${GRIB1_OUT_NC}" "${GRIB2_OUT_NC}" "${FINAL_MERGED_NC}"

echo "All processing complete. Final merged NetCDF: ${FINAL_MERGED_NC}"
