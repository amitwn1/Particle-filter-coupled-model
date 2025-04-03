function [] =  PlotReflctanceRMSESubplots(sim,dates,PF_results_summ,...
    obs_data,weights_summ)

% flag_pars - define if the simulated data will be from the weighted mean
% of the presented state variables (0) or from the DSSAT simualtion ran with
% the parameter values obtained by weighted mean (1).

% Assign values to the variables used in this script
DOYs2Plot = dates.DOYs_for_DA;

DOYs = sim.DOYs(DOYs2Plot);
planting_date = sim.planting_DOY;

% Get observed reflectance
obs = obs_data.refl_avg(DOYs2Plot,:);

inds_S2 = logical([0,1,1,1,1,1,1,0,1,0,0,1,1]);

RMSE_SV = zeros(length(DOYs2Plot),length(weights_summ));

n = 1;

figure('Name','Relectance RMSE');

for i = 1:length(DOYs2Plot) 
    
    % For each DA DOY calcaulte the RMSE value along the season (weighted mean of particles)
    for j =  1:length(DOYs2Plot) 

        temp_refl_w_SV = PF_results_summ{i}.refl_SRF{j}' * weights_summ{i};
    
        RMSE_SV(j,i) = sqrt(sum((temp_refl_w_SV(inds_S2) - obs(j,:)').^2)/length(obs(j,:)));

    end
        
    % % Plot
    
    sb_size = ceil(sqrt(length(DOYs2Plot)));
    
    subplot(sb_size,sb_size,n);

    p1 = plot(DOYs - planting_date,RMSE_SV(:,i),'-or');  % In DAP
    set(p1,'MarkerFaceColor','r'); set(p1,'MarkerSize',3)
    
    hold on
    
 
    % Modify plot properties
    ylim([0,max(RMSE_SV(:,i))+0.1]); xlabel('DAP'); ylabel('RMSE');


    % title(sprintf('DOY: %d',DOYs(i))); % In DOY
    title(sprintf('DAP: %d',DOYs(i) - planting_date)); % In DOY

    % Mark the day of DA
    % plot([DOYs(i),DOYs(i)],[0,max(PF_results_summ{i}.LAI,[],'all')+0.1],'--r'); % In DOY
    plot([DOYs(i),DOYs(i)] - planting_date,[0,max(PF_results_summ{i}.LAI,[],'all')+0.1],'--r'); % In DAP
    
    xlim([DOYs(1)-5,DOYs(end)+5] - planting_date) % In DAP

    n = n + 1; 
    
end



