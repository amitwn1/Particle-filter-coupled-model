function [startRow,endRow] = fname2PlantN(X,MAX_X,filename)
%% I think that the purpose of this function is to find the number of rows in the relevant output file
% 
%% Format for each line of text:
% For more information, see the TEXTSCAN documentation.

% filename = 'PlantN.OUT.txt';
formatSpec = '%5s%4s%6s%6s%8s%8s%8s%8s%8s%9s%8s%8s%8s%8s%8s%8s%7s%7s%8s%[^\n\r]';

% Open the text file.
fileID = fopen('PlantN.OUT','r');

% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string',  'ReturnOnError', false);

%% Remove white space around all cell columns.
for i = 1:length(dataArray)
dataArray{i} = strtrim(dataArray{i});
end

%% Close the text file.
fclose(fileID);

% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Detect start and end rows of numeric data and create output variable
PlantN = [dataArray{1:end}];
run = contains(PlantN,'*RUN');
run_loc=find(run);
integerTest=~mod(X,1);

    if(X>MAX_X||X<0||integerTest~=1)
    startRow=NaN;
    endRow=NaN;

else
run_loc_X=run_loc(X);
startRow = run_loc_X+7;
if X<length(run_loc)
    run_loc_X_plus_one=run_loc(X+1);
endRow = run_loc_X_plus_one-2;
else % last run
    endRow=Inf;
end
end





