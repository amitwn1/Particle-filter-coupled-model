function [] = set_ecotype_parameters(pars_in,ecotype_name,files)
% Read TMGRO047 ecotype file and modify certain parameter values

% Full path of file with DSSAT's ecotype parameters
ECO_file = files.ecotype_full_path;

% Read the whole file and assign it as a character vector
ECO_char = fileread(ECO_file); 

% split to rows (create a cell array by deviding the each row of the
% character vector into a separate cell)
ECO_cell = regexp(ECO_char, '\r\n', 'split')';

% find the row to be changed
istarget = startsWith(ECO_cell, ecotype_name);

% find the location of the line to be changed
loc=find(istarget==1);

% assign the cultivar parameters supplied as function input
h = sprintf(...
     '%s SEMI-DETERMINATE  01 01   %1.1f   0.0  %04.1f   %1.1f  %04.1f   .55  %1.2f  %2.1f   %1.1f %2.2f  %1.2f   %1.1f   %1.1f  %1.2f  0%2.1f  %1.2f',...
     ecotype_name,pars_in);
   
% writing the required parameters to the appropriate cell
ECO_cell{loc,1}=sprintf(h); 

% Adjusting the input text file
fid = fopen(files.ecotype_full_path, 'wt');

fprintf(fid, '%s\n', ECO_cell{:}); %writing the required parameters

fclose(fid);
