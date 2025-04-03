function [startRow,endRow] = fname2ET(X,MAX_X,filename)
%UNTITLED28 Summary of this function goes here
% 
%% Format for each line of text:
%   column1: text (%s)
%	column2: text (%s)
%   column3: text (%s)
%	column4: text (%s)
%   column5: text (%s)
%	column6: text (%s)
%   column7: text (%s)
%	column8: text (%s)
%   column9: text (%s)
%	column10: text (%s)
%   column11: text (%s)
%	column12: text (%s)
%   column13: text (%s)
%	column14: text (%s)
%   column15: text (%s)
%	column16: text (%s)
%   column17: text (%s)
%	column18: text (%s)
%   column19: text (%s)
%	column20: text (%s)
%   column21: text (%s)
%	column22: text (%s)
%   column23: text (%s)
% For more information, see the TEXTSCAN documentation.
% filename = 'SoilWat.OUT.txt';
formatSpec = '%5s%4s%6s%6s%6s%7s%7s%7s%6s%6s%6s%8s%6s%6s%7s%8s%8s%8s%8s%8s%8s%8s%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string',  'ReturnOnError', false);

%% Remove white space around all cell columns.
dataArray{1} = strtrim(dataArray{1});
dataArray{2} = strtrim(dataArray{2});
dataArray{3} = strtrim(dataArray{3});
dataArray{4} = strtrim(dataArray{4});
dataArray{5} = strtrim(dataArray{5});
dataArray{6} = strtrim(dataArray{6});
dataArray{7} = strtrim(dataArray{7});
dataArray{8} = strtrim(dataArray{8});
dataArray{9} = strtrim(dataArray{9});
dataArray{10} = strtrim(dataArray{10});
dataArray{11} = strtrim(dataArray{11});
dataArray{12} = strtrim(dataArray{12});
dataArray{13} = strtrim(dataArray{13});
dataArray{14} = strtrim(dataArray{14});
dataArray{15} = strtrim(dataArray{15});
dataArray{16} = strtrim(dataArray{16});
dataArray{17} = strtrim(dataArray{17});
dataArray{18} = strtrim(dataArray{18});
dataArray{19} = strtrim(dataArray{19});
dataArray{20} = strtrim(dataArray{20});
dataArray{21} = strtrim(dataArray{21});
dataArray{22} = strtrim(dataArray{22});
dataArray{23} = strtrim(dataArray{23});
dataArray{24} = strtrim(dataArray{24});

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
SoilWat = [dataArray{1:end-1}];
run=~cellfun('isempty',strfind(cellstr(SoilWat),'*RUN'));
run_loc=find(run);
integerTest=~mod(X,1);
% if(X>MAX_X||X<0||integerTest~=1)
%     startRow=NaN;
%     endRow=NaN;
% else if(X==MAX_X)
%     run_loc_X=run_loc(X);
%     startRow = run_loc_X+9;
%     endRow=size(SoilWat,1);
% else
% run_loc_X=run_loc(X);
% run_loc_X_plus_one=run_loc(X+1);
% startRow = run_loc_X+9;
% endRow = run_loc_X_plus_one-3;
% end
    if(X>MAX_X||X<0||integerTest~=1)
    startRow=NaN;
    endRow=NaN;
% else if(X==MAX_X)
%     run_loc_X=run_loc(X);
%     startRow = run_loc_X+9;
%     endRow=size(PlantGro,1);
else
run_loc_X=run_loc(X);
startRow = run_loc_X+9;
if X<length(run_loc)
    run_loc_X_plus_one=run_loc(X+1);
endRow = run_loc_X_plus_one-3;
else % last run
    endRow=Inf;
end
end
end

