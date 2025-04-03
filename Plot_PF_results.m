% This function plots the results of the particle filter
clear
clc
close all
warning off

restoredefaultpath

% Add all the folders in the currrent directory to MATLAB's search path
addpath('src\Plot results')
addpath('src\Input')

% Define the name of the directory (svaed in the PF results directory)
% containing the results to plot
dir_name = 'particle_simulated_data_250330_12_HAVA1901';

% Load PF results
load(['PF results\',dir_name,'\final_results'],'comb_summ','pert_pars_summ',...
    'PF_results_summ','weights_summ','pars','dates','sim')

% % Inside this function, Define which figures to plot by assigning the value 1 to the
% corresponding flag variables
pf = DefinePlotFlags();  % pf stands for 'plot flags'

% Get observed data
[obs_data] = GetObsData();

%% Plot parameter value change and then plot particles

if pf.Plot_pars_vals  %pars_value_cahnge
    
    PlotParsValueChange(pars,dates,sim,comb_summ,weights_summ,...
        pert_pars_summ);
    
end

%% Plot LAI with subplots
if pf.Plot_LAI_seasonal
    
    PlotLAISubplots(sim,dates,weights_summ,PF_results_summ,obs_data);
    
end

%% Plot final yield
if pf.Plot_f_yield_seasonal
    
    PlotFinalYield(sim,dates,PF_results_summ,weights_summ,obs_data)
    
end

%% Plot refletance RMSE with subplots
if pf.Plot_refl_RMSE_seasonal

    PlotReflctanceRMSESubplots(sim,dates,PF_results_summ,obs_data,...
        weights_summ)
 
end


%% Plot reflectnces
if pf.Plot_refl_seasonal

    PlotReflctances(sim,dates,PF_results_summ,obs_data,weights_summ)

end

%% Plot reflectance + LAI with particles seperate figures
if pf.Plot_refl_LAI_yield

    % Assign value to the variable used here
    DOYs = sim.DOYs(dates.DOYs_for_DA);
    
    DOYs2plot = dates.DOYs_for_DA;

    planting_DOY = sim.planting_DOY;

    % Define colors (choose from 'Bone' or 'Jet')
    color_type = 'Bone';

    % Define the marker size
    MS = 3;

   % Perform all necssery initiations
   [colors,max_global_LAI,max_global_yield,n,f] = InitiateSepratePlots(color_type,MS,PF_results_summ,DOYs2plot);

    % % % % Start plotting
    
    % Start loop for ploting PF results (LAI and reflectance) for each DA
    % date
    for i = DOYs2plot
     
        % Plot particles
        f(n) = figure('Name',['DAP:',num2str(DOYs(n)-planting_DOY)],...
            'Position',[350,100,1350,850]);
                
        % % Reflectance   
        PlotReflSeparate(n,i,obs_data,weights_summ,PF_results_summ,...
            colors,f)


        % % LAI
        PlotLAISeparate(sim,dates,n,obs_data,weights_summ,PF_results_summ,...
            colors,max_global_LAI);


         % % yield
        PlotYieldSeparate(sim,dates,n,obs_data,weights_summ,PF_results_summ,...
            colors,max_global_yield);


         % sgtitle(sprintf('DOY of assimilation: %d',DOYs(i)))  % In DOY
         sgtitle(sprintf('DAP of assimilation: %d',DOYs(n)-planting_DOY))  % In DAP

         n = n + 1;

    end

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Functions

function [DOYs,DOYs2Plot] = RemoveNonDADOYs(dir_name,planting_DOY,DOYs)
    
    [non_DA_DAPs] = GetNonDADates(dir_name);
    
    % Convert to DOYs
    non_DA_DOYs = non_DA_DAPs + planting_DOY;
    
    % Get indices
    if ~isempty(non_DA_DOYs)
        inds_non_DA = logical(sum(DOYs == non_DA_DOYs',1));
    else
        inds_non_DA = false(1,length(DOYs));
    end
    
    % Update DOY vector
    DOYs(inds_non_DA) = [];

    DOYs2Plot = find(~inds_non_DA);

end


function [pf] = DefinePlotFlags()
    
    % Plot parameter weighted mean values along the season
    pf.Plot_pars_vals = 1;
    
    % Plot seasonal cahnge of LAI prediction
    pf.Plot_LAI_seasonal = 1;
    
    % Plot seasonal cahnge of final yield prediction
    pf.Plot_f_yield_seasonal = 1;
    
    % Plot seasonal cahnge of reflectance RMSE
    pf.Plot_refl_RMSE_seasonal = 1;
    
    % Plot seasonal cahnge of reflectance prediction
    pf.Plot_refl_seasonal = 1;
    
    % Plot reflectance, LAI and yield of each DA date in a sinlge figure
    pf.Plot_refl_LAI_yield = 1;

end
