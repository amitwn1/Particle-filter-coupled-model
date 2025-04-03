function run_SCOPE(files)

% The aim of this function is to run SCOPE, so it will not clear all
% variables and pathes in the main code

run(fullfile(files.SCOPE_dir_loc,files.SCOPE_run_file));