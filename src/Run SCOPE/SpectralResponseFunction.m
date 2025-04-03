function [M_SRF] = SpectralResponseFunction(M,name)

% This function recieves a spectrum from SCOPE output and adjust it
% according to Sentinel-2 spectral response function

% input variables:
% M - A matrix with spactral signatures simulated by SCOPE
% name - whether the data is from Sentinel-2A (name = 'A') or Sentinel-2B
% (name = 'B')

SRF_path = 'Data\Spectral response function\';
SRF_file = 'S2-SRF_COPE-GSEG-EOPG-TN-15-0007_3.0.xlsx';

%% Import spectral response function

if strcmp(name,'A')
    SRF = readmatrix([SRF_path,SRF_file],'Sheet','Spectral Responses (S2A)');
elseif strcmp(name,'B')
    SRF = readmatrix([SRF_path,SRF_file],'Sheet','Spectral Responses (S2B)');
end

M_SRF = zeros(size(M,1),(size(SRF,2)-1));
SRF_400ind = find(SRF(:,1) == 400); 
SRF_2561ind = find(SRF(:,1) == (400 + size(M,2) - 1));

for i = 1:size(M,1)
    for j = 1:(size(SRF,2) - 1)
        M_SRF(i,j) = sum(M(i,:).*SRF(SRF_400ind:SRF_2561ind,j+1)')/...
            sum(SRF(SRF_400ind:SRF_2561ind,j+1));
    end
end


