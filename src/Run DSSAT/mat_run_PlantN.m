function PlantN = mat_run_PlantN(run2extract,filename)
%% Import data from text file.
% Script for importing data from the following text file:
%
%    PlantN.OUT.txt
%
%% Initialize variables.
i=0;
MAX_X=100;
X= run2extract;%input('which run you want to extract:');
% filename = 'PlantN.OUT.txt';
while(i<100)
[startRow,endRow] = fname2PlantN(X,MAX_X,filename);
    if(isnan(startRow)||isnan(endRow))
        X=input('NaN!!!Please try again:\n');
    else
        break;
    end
end

%% Defining format specification in the 'PlantN.OUT.' text file
% For more information, see the TEXTSCAN documentation.
formatSpec = '%5f%4f%6f%6f%8f%8f%8f%8f%8f%9f%8f%8f%8f%8f%8f%8f%7f%7f%8f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
textscan(fileID, '%[^\n\r]', startRow-1, 'WhiteSpace', '', 'ReturnOnError', false);
dataArray = textscan(fileID, formatSpec, endRow-startRow+1, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'ReturnOnError', true, 'EndOfLine', '\r\n');
dataArray{end} = str2double(dataArray{end});
%% Close the text file.
fclose(fileID);

%% Create a table from the cell array that containins the data, 
% Table headlines must be manually specifies according to the relevant
% DSSAT output file - This is the output variable
PlantN = table(dataArray{1:end}, 'VariableNames', {'YEAR','DOY','DAS','DAP',...
    'CNAD','GNAD','VNAD','GN%D','VN%D','NFXC','NUPC','LNAD','SNAD','LN%D',...
    'SN%D','SHND','RN%D','NFXD','SNN0C','SNN1C'});

%% Clear temporary variables
clearvars filename startRow endRow formatSpec fileID dataArray ans i MAX_X;
