function [] = PlotReflctances(sim,dates,PF_results_summ,obs_data,...
    weights_summ)

% Assign values to the variables used in this script
DOYs2Plot = dates.DOYs_for_DA;

DOYs = sim.DOYs(DOYs2Plot);
planting_date = sim.planting_DOY;


% Get observed reflectance
obs = obs_data.refl_avg(DOYs2Plot,:);

inds_S2 = logical([0,1,1,1,1,1,1,0,1,0,0,1,1]);

DAPs = DOYs - planting_date;

% Define bands
obs_wl = [492,559,665,704,739,782,864,1610,2185];  % Sentinel-2 bands (inly the relevant ones)

% % Plot results
figure('Name','Relectances','Position',[440   80   650   550]);

RMSE_SV = zeros(length(DOYs2Plot),length(weights_summ));

n = 1;

for i = 1:length(DOYs2Plot)
    
    % For each DA DOY calcaulte the RMSE value along the season (weighted mean of particles)
    for j = 1:length(DOYs2Plot)
            
        temp_refl_w_SV = PF_results_summ{i}.refl_SRF{j}' * weights_summ{i};
    
        RMSE_SV(j,i) = sqrt(sum((temp_refl_w_SV(inds_S2) - obs(j,:)').^2)/length(obs(j,:)));
                    
        % Plot
        ll = length(DOYs2Plot);

        subplot(ll,ll,n)

        plot(obs_wl,[temp_refl_w_SV(inds_S2),obs(j,:)'])
        
        if i ~= length(DOYs2Plot)
            set(gca,'xtick',[])
        end

        if i == 1
            title(sprintf('DAP: %d',DAPs(j)))
        end

        if j == 1
            ylabel(sprintf('DAP: %d',DAPs(i)),'Rotation',0,'FontWeight','bold');
        end
             
        n = n + 1; 

         
    end
        
    
end


end

