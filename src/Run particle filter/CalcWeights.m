function [weights,w1,g] = CalcWeights(PF_results,obs_data,DOY_current,...
    DOY_current_index)

% % Get the relvant obsevation
refl_avg = obs_data.refl_avg;
refl_std = obs_data.refl_std;

% % Filter Sentinel-2 bands to use only the relevant bands
% Indices for the relevant Sentinel-2 bands
inds_S2 = logical([0,1,1,1,1,1,1,0,1,0,0,1,1]);

% Keep only relevant bands
SRF_refl = PF_results.refl_SRF{DOY_current_index}(:,inds_S2);     %%%%% For new version of data structure


% % calculate weights
[weights,w1,g] = weights_refl(refl_avg(DOY_current,:),refl_std(DOY_current,:),...
SRF_refl);

