function [reflectance_out,reflectance_SRF] = RunSCOPESequentially(pars,vals,files) 

% Update SCOPE input file with new parameter values (only for the relevant parameters)
change_SCOPE_input(pars,vals,files);

% change input file in SCOPE simulation 
ChangeSCOPEInputFilename(files)


%% Run SCOPE with new input data

% Run SCOPE
run_SCOPE(files);


%% Import SCOPE output reflectance data  % I need to figure out how to read the latest file each time
reflectance_out = readmatrix(fullfile([files.SCOPE_dir_loc,'\','output\',files.SCOPE_output_file,'\reflectance.csv']),'Range',3);

%% Spectral response function
% adjust values from simulated spectra to Sentinel-2 bands considering
% spectral response functions using the SpectralResponseFunction function      

% Define which spectral response function to use (Sentinel-2 A or B)
name = 'A';

reflectance_SRF = SpectralResponseFunction(reflectance_out,name);

