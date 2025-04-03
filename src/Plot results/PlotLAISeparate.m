function PlotLAISeparate(sim,dates,n,obs_data,weights_summ,...
                PF_results_summ,colors,max_global_LAI)


planting_DOY = sim.planting_DOY;

DOYs = sim.DOYs(dates.DOYs_for_DA);

DSSAT_DOYs = planting_DOY:(planting_DOY + (length(PF_results_summ{1}.LAI) - 1));

% Define DOYs for X axis for the observed data curve
X = obs_data.LAI_DOY - planting_DOY; % In DAP

% Get the indices of the dates when LAI was measured
LAI_obs_DOY_inds = logical(sum(DSSAT_DOYs == reshape(obs_data.LAI_DOY,[],1),1));

% Create subplot
subplot(1,3,2)     

% % Plot particle ensemble
% Sort particles according to their weights before plotting
% them
[B,I] = sort(weights_summ{n});

Particles_sorted = PF_results_summ{n}.LAI(I,:);

p1 = plot(DSSAT_DOYs - planting_DOY,Particles_sorted');%,'Color',[0.75,0.75,0.75]); % In DAP

 % Color the cureves based on their weights
switch colors.color
    case 'Bone'
         AddColors2PlotBone(length(p1),B,p1)
         % AddColors2PlotBone_adj(length(p1),B,p1)
    case 'Jet'
        % AddColors2PlotJet(length(p1),weights_summ{i},p1)
         AddColors2PlotJet(length(p1),B,p1)
end


hold on

% % Plot observation
LAI_obs = obs_data.LAI;
p2 = plot(X,LAI_obs,'o','Color',colors.c2);
set(p2,'MarkerFaceColor',colors.c2); set(p2,'MarkerSize',colors.MS)


% % Plot weighted mean 
ST_w = PF_results_summ{n}.LAI' * weights_summ{n};  % weighted mean if the chosen state variable

p3 = plot(DSSAT_DOYs - planting_DOY,ST_w,'o','Color',colors.c3); % In DAP
set(p3,'MarkerFaceColor',colors.c3); set(p3,'MarkerSize',colors.MS)


% Calculate RMSE
RMSE = sqrt(sum((ST_w(LAI_obs_DOY_inds) - reshape(LAI_obs,[],1)).^2)/length(LAI_obs));

% Modify plot properties
ylim([0 max_global_LAI+0.1]); ylabel('LAI');

xlabel('DAP');  % In DAP

title(sprintf('LAI RMSE: %5.2f',RMSE))

% Mark the day of DA

plot([DOYs(n),DOYs(n)] - planting_DOY,ylim,'--r'); % In DAP

% end



