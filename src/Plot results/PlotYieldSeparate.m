function PlotYieldSeparate(sim,dates,n,obs_data,weights_summ,...
                PF_results_summ,colors,max_global_yield)

% Assign values to the variables usid in this script
planting_DOY = sim.planting_DOY;

DOYs = sim.DOYs(dates.DOYs_for_DA);

% Create a an array of the season days in DAP (days after planting)
DSSAT_DOYs = planting_DOY:(planting_DOY + (length(PF_results_summ{1}.LAI) - 1));

% Convert to DAP
season_DAPs = DSSAT_DOYs - planting_DOY;


% Assign the simulated yield of the current DA date to a varaible
sim_yield_data_temp = PF_results_summ{n}.yield;

% Get the shortest yield season, and weighted and regular mean of the yield
% averaged over the shortest set of tield dates

% Remove particles with empty values for yield
yield_vec_l = cellfun(@length,PF_results_summ{n}.yield);

% For all yield vector (for each particle), fill the days prior to first
% appearance of yield with zeros
number_of_days_in_season = size(PF_results_summ{n}.LAI,2);

yield_mat_full = zeros(size(PF_results_summ{n}.LAI));

for ii = 1:length(sim_yield_data_temp)

    yield_mat_full(ii,number_of_days_in_season - yield_vec_l(ii) + 1:number_of_days_in_season) = sim_yield_data_temp{ii};

end


% Assign observe 
yield_obs = obs_data.yield;  % [kg/ha]

% Create the subplot for yield
subplot(1,3,3)     

% % Plot particle ensemble
% Sort particles according to their weights before plotting
% them

% Update weihts vector according to the missing simulated yield indices
weights_summ_temp = weights_summ{n};

% Sort the yield vectors according to the weights of their corresponding
% particles
[B,I] = sort(weights_summ_temp);

Particles_sorted = yield_mat_full(I,:);

% Preallocate graphic object
p1 = gobjects(size(yield_mat_full,1),1);

for ii = 1:length(sim_yield_data_temp)

    p1(ii) = plot(season_DAPs,Particles_sorted(ii,:));
    
    hold on
end

% Color the cureves based on their weights
switch colors.color
    case 'Bone'
         AddColors2PlotBone(length(p1),B,p1)
    case 'Jet'
         AddColors2PlotJet(length(p1),B,p1)
end


hold on

% % Plot observation
p2 = plot(season_DAPs(end),yield_obs,'o','Color',colors.c2);
set(p2,'MarkerFaceColor',colors.c2); set(p2,'MarkerSize',7)


% % Plot weighted mean 
ST_w = yield_mat_full' * weights_summ_temp;  % weighted mean if the chosen state variable

p3 = plot(season_DAPs,ST_w,'o','Color',colors.c3); % In DAP
set(p3,'MarkerFaceColor',colors.c3); set(p3,'MarkerSize',colors.MS)

% Calculate RMSE
RMSE = sqrt(sum((ST_w(end) - reshape(yield_obs,[],1)).^2)/length(yield_obs));

% Modify plot properties
ylim([0 max_global_yield+1000]); ylabel('Yield [kg/ha]');

xlabel('DAP');  % In DAP

title(sprintf('Yield RMSE: %5.2f',RMSE))

% Mark the day of DA
plot([DOYs(n),DOYs(n)] - planting_DOY,ylim,'--r'); % In DAP

% end



