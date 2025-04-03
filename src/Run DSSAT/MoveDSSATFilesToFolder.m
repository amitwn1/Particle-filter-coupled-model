function [] = MoveDSSATFilesToFolder()

% Define the name of the folder
newFolderName = 'DSSAT_outputs';

% Check if a folder contaning matlab fiels exist, else make one
if ~exist(newFolderName, 'dir')
    mkdir(newFolderName);
end

% Get a list of all files in the current directory
files = cell(1,4);

files{1} = dir('*.OUT');
files{2} = dir('*.LST');
files{3} = dir('*.INP');
files{4} = dir('*.INH');

for j = 1:length(files)

    files1 = files{j};

    for i = 1:length(files1)

            fileName = files1(i).name;
            
            % Move the file to the new folder
            movefile(fileName, fullfile(newFolderName, fileName),'f');

    end
end