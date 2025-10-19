import xarray as xr
# El engine 'cfgrib' lee GRIB2 y es muy tolerante
ds = xr.open_dataset('aifs_input_state_20241028_n320_18z_20241029_00z.grib', engine='cfgrib')
ds.to_netcdf('output_final_todas_variables.nc')
