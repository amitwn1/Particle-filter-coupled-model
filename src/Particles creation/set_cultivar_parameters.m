function [] = set_cultivar_parameters(pars_in,cultivar_name,ecotype_name,files)
% Read TMGRO047 cultivar file and modify certain parameter values

% Full path of file with DSSAT's cultivar parameters
CUL_file = files.cultivar_full_path;

% Read the whole file and assign it as a character vector
CUL_char = fileread(CUL_file); 

% split to rows (create a cell array by deviding the each row of the
% character vector into a separate cell)
CUL_cell = regexp(CUL_char, '\r\n', 'split')';

% find the row to be changed
istarget = startsWith(CUL_cell, cultivar_name);

% find the location of the line to be changed
loc=find(istarget==1);

% More current (less parameters)
% assign the cultivar parameters supplied as function input
h = sprintf(...
     '%s Cultivar for SA      . %s %05.2f  %1.2f  %3.1f   %1.1f  %04.1f %2.2f %2.2f  %1.2f  %.f. %3.1f  %1.2f .0040  26.0 300.0  %2.1f   8.5  .300  0.05',...
     cultivar_name,ecotype_name,pars_in);

% writing the required parameters to the appropriate cell
CUL_cell{loc,1}=sprintf(h); 

% Adjusting the input text file
fid = fopen(files.cultivar_full_path, 'wt');

fprintf(fid, '%s\n', CUL_cell{:}); %writing the required parameters

fclose(fid);
% end