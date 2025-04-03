function [PlantGro,SoilWat,Fresh,ET,ETPhot,PlantN] = run_DSSAT(nb_runs,files)

% Note: the variable nb_runs is relevant if in DSSAT's there is more than
% one simulation batch files according to DSSAT's batch file

global loc_batch loc_DSSAT %crop_code Year Meas_LAI18 Meas_ET18 fresh_yield18 Meas_LAI19 fresh_yield19 Meas_ET19 
loc_batch = files.DSSAT_loc;
loc_DSSAT = files.DSSAT_loc;

% This function runs DSSAT through the command line saves its outputs in
% MATLAB tables
[PlantGro,SoilWat,Fresh,ET,ETPhot,PlantN]=run_and_extract(nb_runs,files);

% Move the DSSAT ouput files saved in the current directory during 
% simulation to a separate directory
MoveDSSATFilesToFolder()

end