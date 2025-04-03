function [res_pert_comb,f_refl] = AddNoiseBySA(resampled_comb,...
    SA_mean_refl,DOY_current,epsilon,param_ranges,plen)

%% Find which parameters are the most influential (have highest mean SIs


% Define how many parameters (with highest SI values) will be perturbed
% during noise addition
npars4pert = 4;

%  % Create a 2-D matrix only with the SIs of the current relevant date 
% Preallocation
SA_refl_c = zeros(size(SA_mean_refl,3),size(SA_mean_refl,2)); % 'c' is for current

% Assign SIs of the current DA data
for i = 1:plen
    SA_refl_c(i,:) = SA_mean_refl(DOY_current,:,i);    % 'c' is for current
end 

% Reflectance
[~,f_refl] = maxk(max(SA_refl_c,[],2),npars4pert);


%% Perturb chosen parameters to create a new parameter combination matrix

% Go through all the resampled partcile list and change the values of the
% chosen parameters according to random values drawn from a Gaussian
% distribution with mean equal to the original parameter value and standard
% deviation chosen acording to Orlova and Linker 2023.

% Define perturbation paramter
eps_p = epsilon;   % Tuning factor - chosen as the optimal value found in Orlova and Linker 2023

% Initiate matrix for the perturbed paramter sets (particles
res_pert_comb = resampled_comb;

% Go through parameters and perturb the ones that met the criterion
for j = 2:size(resampled_comb,1)
    if isequal(resampled_comb(j,:),resampled_comb(j-1,:))  % To keep good partciels, perturb a certain particle only from the csecond time it appears and on
        for i = 1:length(f_refl)
            alpha = resampled_comb(j,f_refl(i));
            updated_value = alpha + normrnd(0,alpha*eps_p);
            
            % Ensure that the parameters doesn't reasonable value limit
            if updated_value < param_ranges(f_refl(i),1)
                updated_value = param_ranges(f_refl(i),1);
            elseif updated_value > param_ranges(f_refl(i),2)
                updated_value = param_ranges(f_refl(i),2);
            end
            
            res_pert_comb(j,f_refl(i)) = updated_value;
            
            
        end
    end
end




