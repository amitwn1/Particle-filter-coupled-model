function [] = change_SCOPE_input(pars,vals,files)

% Aim: run SCOPE faster - chagane the part of reassigning SCOPE's
% parameters

%% Read text from the original SCOPE input_data file
% file = 'C:\SCOPE-master\input\input_data_default.csv';
file = fullfile(files.SCOPE_dir_loc,'input',files.SCOPE_default_input);

fid = fopen(file);

% Knowing that the SCOPE input file contains 89 lines, I can preallocate
% the y paramter
y = cell(89,1);

k = 1;

while ~feof(fid)
    line    = fgetl(fid);
    y(k)       = textscan(line,'%s', 'Delimiter', ',', 'TreatAsEmpty',  ' ');
    
    k = k + 1;
end

fclose(fid);

%% Change required parameter values

% Change the defined parameter values
for i = 1:length(pars)
    for j = 1:length(y)
        if strcmp(y{j}{1},pars{i})
            % Assign the values to the relevant cell, assuring it is a row
            % vector
            y{j}{2} = reshape(vals{i},1,[]);
        end
        
    end
    
end


%% Write the modified data into a new SCOPE input_data file
fid = fopen(fullfile(files.SCOPE_dir_loc,'input',files.SCOPE_new_input),'w');



for i = 1:length(y)
    % Case of blank line or a headline
    if length(y{i}) == 1
        fprintf(fid,'%s,\n',y{i}{1});
    else
    % Other cases
        num_str = regexprep(num2str(y{i}{2}),'\s+',',');
        fprintf(fid,'%s,%s\n',y{i}{1},num_str);            
    end
end

fclose(fid);
