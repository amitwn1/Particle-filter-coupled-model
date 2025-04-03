function [obs_data] = GetObsRefl()

% Load observed reflectance of Gadash 2019 season
temp_mean = load('Data\Observed data\reflectance_gadash19.mat');

temp_std = load('Data\Observed data\reflectance_std_gadash19.mat');

obs_data.refl_avg = temp_mean.refl_avg/10000;

obs_data.refl_std = temp_std.refl_std/10000;
           

end