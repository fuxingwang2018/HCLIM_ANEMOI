#!/bin/bash

# --- Environment Setup and Verification ---
set -e
# Make sure that the 'date' utility with the '-d' argument is available (common in GNU/Linux and compatible systems).

# --- Key Variable Configuration ---
BASE_DATE="20230514" # Base date: We will download the 18Z cycle for this day.

# --- Calculate the next day’s date (for the 00Z cycle) ---
# Compute the date for 00Z of the following day.
NEXT_DATE=$(date -d "${BASE_DATE} + 1 day" +%Y%m%d)
TARGET_FILE="aifs_input_state_${BASE_DATE}_n320_18z_${NEXT_DATE}_00z.grib"
echo "--------------------------------------------------------------------------------"
echo "📦 Preparing consolidated MARS request for AIFS on N320 grid."
echo "   Specific download cycles: 18Z of ${BASE_DATE} and 00Z of ${NEXT_DATE}."
echo "   Target file: ${TARGET_FILE}"
echo "--------------------------------------------------------------------------------"

# --- Clean the target file if it exists to ensure a clean start ---
rm -f "${TARGET_FILE}"

cat <<EOF | mars
# Each request is split into two blocks (a and b) to ensure that only
# the exact combinations are downloaded: (BASE_DATE, 18Z) and (NEXT_DATE, 00Z).

# --- Request 1a: Dynamic surface variables - 18Z (Base Day) ---
retrieve,
  class     = ea,
  stream    = oper,
  type      = an,
  expver    = 1,
  levtype   = sfc,
  param     = 10u/10v/2t/2d/msl/skt/sp/tcw/lsm/z,
  step      = 0,
  date      = ${BASE_DATE},
  time      = 18,
  grid      = N320,
  format    = grib2,
  target    = "${TARGET_FILE}"

# --- Request 1b: Dynamic surface variables - 00Z (Next Day) ---
retrieve,
  class     = ea,
  stream    = oper,
  type      = an,
  expver    = 1,
  levtype   = sfc,
  param     = 10u/10v/2t/2d/msl/skt/sp/tcw/lsm/z,
  step      = 0,
  date      = ${NEXT_DATE},
  time      = 00,
  grid      = N320,
  format    = grib2,
  target    = "${TARGET_FILE}"

# --- Request 2a: Soil variables (swvl1/2, stl1/2) - 18Z (Base Day) ---
retrieve,
  class     = od,
  stream    = oper,
  type      = an,
  expver    = 1,
  levtype   = sfc,
  param     = 039/040/139/170,
  step      = 0,
  date      = ${BASE_DATE},
  time      = 18,
  grid      = N320,
  format    = grib2,
  target    = "${TARGET_FILE}"

# --- Request 2b: Soil variables (swvl1/2, stl1/2) - 00Z (Next Day) ---
retrieve,
  class     = od,
  stream    = oper,
  type      = an,
  expver    = 1,
  levtype   = sfc,
  param     = 039/040/139/170,
  step      = 0,
  date      = ${NEXT_DATE},
  time      = 00,
  grid      = N320,
  format    = grib2,
  target    = "${TARGET_FILE}"

# --- Request 3a: Pressure level variables (PARAM_PL) - 18Z (Base Day) ---
retrieve,
  class     = ea,
  stream    = oper,
  type      = an,
  expver    = 1,
  levtype   = pl,
  levelist  = 1000/925/850/700/600/500/400/300/250/200/150/100/50,
  param     = z/t/u/v/w/q,
  date      = ${BASE_DATE},
  time      = 18,
  grid      = N320,
  format    = grib2,
  target    = "${TARGET_FILE}"

# --- Request 3b: Pressure level variables (PARAM_PL) - 00Z (Next Day) ---
retrieve,
  class     = ea,
  stream    = oper,
  type      = an,
  expver    = 1,
  levtype   = pl,
  levelist  = 1000/925/850/700/600/500/400/300/250/200/150/100/50,
  param     = z/t/u/v/w/q,
  date      = ${NEXT_DATE},
  time      = 00,
  grid      = N320,
  format    = grib2,
  target    = "${TARGET_FILE}"

# --- Request 4a: Secondary orography parameters (slor, sdor) - 18Z (Base Day) ---
retrieve,
  class     = ea,
  stream    = oper,
  type      = an,
  expver    = 1,
  levtype   = sfc,
  param     = slor/sdor,
  date      = ${BASE_DATE},
  time      = 18,
  grid      = N320,
  format    = grib2,
  target    = "${TARGET_FILE}"

# --- Request 4b: Secondary orography parameters (slor, sdor) - 00Z (Next Day) ---
retrieve,
  class     = ea,
  stream    = oper,
  type      = an,
  expver    = 1,
  levtype   = sfc,
  param     = slor/sdor,
  date      = ${NEXT_DATE},
  time      = 00,
  grid      = N320,
  format    = grib2,
  target    = "${TARGET_FILE}"
EOF

echo "✅ All MARS data requests completed."
echo "🔄 GRIB field renaming (if required by AIFS) was not included here but should be performed after download."
echo "✅ All AIFS data have been downloaded and prepared in '${TARGET_FILE}'."
