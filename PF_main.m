% Particle filter - main

% In this version of the SIR PF script, at each DA step the refletance is
% calculated for the whole season (only for days with DA). The aim is to
% examine the improvement of reflectance presdiction along the season.
clear
clc
close all
warning off

restoredefaultpath

% Add all the folders in the currrent directory to MATLAB's search path
addpath(genpath(pwd))

% To make the first ensemble values reproducible 
rng('default');

%% Define simulation details
[sim,pars,files] = DefineSimulationDetails();

%% Perform simulation initializations
[sim,files,SA_mean_refl,obs_data,dates,summ] = SimulationInitialization(sim,pars,files);

% Assing the DOY and COY index counter to the variables used in the PF run
DOY_current_index = dates.DOY_current_index;

DOY_current = dates.DOY_current;
%% Start the particle filter procedure
c1 = tic;

% Start the particle filter
for kk = 1:length(dates.DOYs_for_DA) % first_DOY_of_DA:number_of_DOYs4DA

    %% Create particles ensemble
    [PF_results] = ParticlesGenerationSIRSeasonalRefl(sim,dates,files);

   %% Calculate weights   
   [weights,~,~] = CalcWeights(PF_results,obs_data,DOY_current,...
    DOY_current_index);

   %% Perform resampling
   [resampled_comb] = ResampleEnsemble(weights,sim.comb);

   %% Add noise 
   % Add noise to the resampled particles (based on sensitivty analysis results)
   [res_pert_comb,f_refl] = AddNoiseBySA(resampled_comb,...
    SA_mean_refl,DOY_current,sim.epsilon,pars.param_ranges,pars.plen); % resampled perturbed parameters
    
   % Update the variable containing the parameter conbinations
   sim.comb = res_pert_comb;

   %% Save data
   [summ] = AssignCurrentPFResults(summ,PF_results,weights,sim,f_refl,kk);

   %% Propogate simulation
   fprintf('\nData assimilation on DOY %d/%d has ended \n\n',DOY_current_index,dates.number_of_DOYs4DA)
   
   % Propagate the data assimilation DOY index counter
   DOY_current_index = DOY_current_index + 1;
    
   % Make sure the the current DA DOY index is not larger than the total
   % number of DA dates (due to discarding observation dates with problematic observations)
   if DOY_current_index <= length(dates.DOYs_for_DA)
     DOY_current = dates.DOYs_for_DA(DOY_current_index);
   end

end

%% Save results   --> This should go into a function

% Save simulation results to a folder called 'PF results'
[files] = SaveResults(files,summ,pars,dates,sim);

% Creata a text file with simulation details
WriteSimulationDetailsSatellite(sim,files)

c1 = toc(c1);

fprintf('\n\n\n Total particle filter procedure took %.2f hours \n',c1/3600)

