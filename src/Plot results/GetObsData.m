function [obs_data] = GetObsData()

% Get measured LAI
[obs_data] = get_LAI();
      
% Get measured reflectance
[refl_out] = GetObsRefl();

obs_data.refl_avg = refl_out.refl_avg;

obs_data.refl_std = refl_out.refl_std;

% % Define observed yield
obs_data.yield = 6.7*10000; % [kg/ha]

end