function [startRow,endRow] = fname1(X,MAX_X,filename)
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
%	column24: text (%s)
%   column25: text (%s)
%	column26: text (%s)
%   column27: text (%s)
%	column28: text (%s)
%   column29: text (%s)
%	column30: text (%s)
%   column31: text (%s)
%	column32: text (%s)
%   column33: text (%s)
%	column34: text (%s)
%   column35: text (%s)
%	column36: text (%s)
%   column37: text (%s)
%	column38: text (%s)
%   column39: text (%s)
%	column40: text (%s)
%   column41: text (%s)
%	column42: text (%s)
%   column43: text (%s)
%	column44: text (%s)
%   column45: text (%s)
%	column46: text (%s)
%   column47: text (%s)
%	column48: text (%s)
% For more information, see the TEXTSCAN documentation.
% filename = 'PlantGro.OUT.txt';
formatSpec = '%5s%4s%6s%6s%7s%7s%7s%7s%7s%7s%7s%7s%7s%7s%7s%7s%7s%7s%7s%7s%7s%7s%7s%7s%7s%7s%7s%7s%7s%7s%9s%7s%7s%7s%8s%8s%8s%8s%8s%8s%8s%8s%7s%7s%7s%8s%8s%s%[^\n\r]';
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
dataArray{25} = strtrim(dataArray{25});
dataArray{26} = strtrim(dataArray{26});
dataArray{27} = strtrim(dataArray{27});
dataArray{28} = strtrim(dataArray{28});
dataArray{29} = strtrim(dataArray{29});
dataArray{30} = strtrim(dataArray{30});
dataArray{31} = strtrim(dataArray{31});
dataArray{32} = strtrim(dataArray{32});
dataArray{33} = strtrim(dataArray{33});
dataArray{34} = strtrim(dataArray{34});
dataArray{35} = strtrim(dataArray{35});
dataArray{36} = strtrim(dataArray{36});
dataArray{37} = strtrim(dataArray{37});
dataArray{38} = strtrim(dataArray{38});
dataArray{39} = strtrim(dataArray{39});
dataArray{40} = strtrim(dataArray{40});
dataArray{41} = strtrim(dataArray{41});
dataArray{42} = strtrim(dataArray{42});
dataArray{43} = strtrim(dataArray{43});
dataArray{44} = strtrim(dataArray{44});
dataArray{45} = strtrim(dataArray{45});
dataArray{46} = strtrim(dataArray{46});
dataArray{47} = strtrim(dataArray{47});
dataArray{48} = strtrim(dataArray{48});

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
PlantGro = [dataArray{1:end-1}];
run=~cellfun('isempty',strfind(cellstr(PlantGro),'*RUN'));
run_loc=find(run);
integerTest=~mod(X,1);
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
endRow = run_loc_X_plus_one-2;
else % last run
    endRow=Inf;
end
end
    
end

