function [SA_mean_refl] = GetSIs()

% Define file name for the sesitivity indices data file
filename_coupled = 'Data\Sensitivity indices\SA_LH_OAT_coupled_results_26-Jan-2023 18-39-09_n_bins - 100';

% Get the SA data (average the raw SA reaults)
if isempty(filename_coupled)
    error('No such SI data file exists for coupled model')
else
    SA_mean_refl = GetSAMeanRefl(filename_coupled);
end



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
function SA_mean = GetSAMeanRefl(filename_coupled)

% Load sensitivty indices data
load([filename_coupled,'.mat'],'bins_cell');

% Get raw data array dimensions
temp1 = bins_cell{1};

plen = size(temp1,3);
bins = size(bins_cell,2);
DOYs_S2 = size(temp1,1);

% Preallocation
SA_mean = zeros(DOYs_S2,2001,plen);

% Average SA data
for i = 1:plen
    temp = zeros(DOYs_S2,2001,bins);
    for j = 1:length(bins_cell)
        temp(:,:,j) = bins_cell{j}(:,:,i);
    end
    temp_mean = mean(temp,3);
    
    SA_mean(:,:,i) = temp_mean;   
end