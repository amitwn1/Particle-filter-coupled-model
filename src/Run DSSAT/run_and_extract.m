function [PlantGro,SoilWat,Fresh,ET,ETPhot,PlantN]=run_and_extract(nb_runs,files)
global loc_batch loc_DSSAT

% Check if a folder contaning matlab fiels exist, else make one
if ~exist('DSSAT_outputs', 'dir')
    mkdir('DSSAT_outputs');
end

% Delete all DSSAT output files from previous runs
!del DSSAT_outputs\*.OUT

% Run DSSAT through the command line
% I think the 'N' indicates the model to run in seasonal mode
[stat,cmdout]=system([loc_DSSAT,files.exe,' N ', loc_batch,files.batch]);

% Report if an error occured during DSSAT run 
if stat ~= 0 
    fprintf('DSSAT run not sucessful.\n')
    cmdout
    keyboard
end

for run2extract=1:nb_runs
%%%
% Here the relevant output files from DSSAT simulation are read and
% required parameters are wrriten into tables gathered in matlab
% structurs
%%%
    eval(['PlantGro.r' num2str(run2extract) '=mat_run_plantGro(run2extract,''PlantGro.OUT'');']);
    eval(['SoilWat.r' num2str(run2extract) '=mat_run_SoilWat(run2extract,''SoilWat.OUT'');']);
    eval(['Fresh.r' num2str(run2extract) '=mat_run_Fresh(run2extract,''FreshWt.OUT'');']);
    eval(['ET.r' num2str(run2extract) '=mat_run_ET(run2extract,''ET.OUT'');']);
    eval(['ETPhot.r' num2str(run2extract) '=mat_run_ETPhot(run2extract,''ETPhot.OUT'');']);
    eval(['PlantN.r' num2str(run2extract) '=mat_run_PlantN(run2extract,''PlantN.OUT'');']);

end