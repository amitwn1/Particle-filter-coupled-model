function [] =  PlotLAISubplots(sim,dates,weights_summ,PF_results_summ,...
        obs_data)

% Assign values to variables used in this function
planting_DOY = sim.planting_DOY;
DOYs = sim.DOYs(dates.DOYs_for_DA);

DOYs2Plot = dates.DOYs_for_DA;
n_DOYs2Plot = length(DOYs2Plot);

% % Preparations
% Get the min and max LAI values to determine y axis limits
[max_global_LAI,~] = FindMaxSVValue(PF_results_summ,'LAI');

% Convert DOY to DAP
DSSAT_DOYs = planting_DOY:(planting_DOY + (length(PF_results_summ{1}.LAI) - 1));

% Create an array for the X axis tick labels
X = obs_data.LAI_DOY - planting_DOY; % X in DAP   

% Get the indices of the dates when LAI was measured
LAI_obs_DOY_inds = logical(sum(DSSAT_DOYs == reshape(obs_data.LAI_DOY,[],1),1));

% Create a figure
figure('Name','LAI','Position',[450,100,1050,800]);

% Initiate counter
n = 1;

% Start ploting - the loop goes through the DA dates and plots the ensemble
% results obtained on each date.
for i = 1:n_DOYs2Plot
    
    % % Plot particles
    subplot(ceil(n_DOYs2Plot/4),4,n)

    % Sort particles according to their weights (to plot high weighted particles later so they would show in the plot)
    [B,I] = sort(weights_summ{i});

    Particles_sorted = PF_results_summ{i}.LAI(I,:);
    
    % Plot LAI ensemble
    p1 = plot(DSSAT_DOYs - planting_DOY,Particles_sorted');%,'Color',[0.75,0.75,0.75]); % In DAP

    % Color the cureves based on their weights
    AddColors2PlotBone_LAI(length(p1),B,p1)

    hold on

    % Plot observation
    LAI_obs = reshape(obs_data.LAI,[],1);
    p2 = plot(X,LAI_obs,'ob');
    set(p2,'MarkerFaceColor','b'); set(p2,'MarkerSize',3)
    
    % Plot weighted mean
    ST_w = PF_results_summ{i}.LAI' * weights_summ{i};  % weighted mean if the chosen state variable
    p3 = plot(DSSAT_DOYs - planting_DOY,ST_w,'or');  % in DAP
    set(p3,'MarkerFaceColor','r'); set(p3,'MarkerSize',3)
    
    RMSE(1) = sqrt(sum((ST_w(LAI_obs_DOY_inds) - LAI_obs).^2)/length(LAI_obs));
    
    
    % % Modify plot properties
    % Adjust axes limits
    ylim([0 max_global_LAI+0.1]); 
    xlim([planting_DOY - 5,DSSAT_DOYs(end) + 5] - planting_DOY(1))  % In DAP
    
    if mod(n-1,4) == 0
        ylabel('LAI');
    end
    
    if any(n == n_DOYs2Plot-3:n_DOYs2Plot)
        xlabel('DAP'); % xlabel('DOY');
    end

    % Calculate and show NRMSE
    LAI_NRMSE = RMSE/mean(LAI_obs)*100;
    
    txt_str = sprintf('NRMSE: %.2f [%%]',LAI_NRMSE);

    text(10,(max_global_LAI+0.1)*0.85,txt_str)

   
    % Mark the day of DA
    % plot([DOYs(i),DOYs(i)],ylim,'--r');  % In DOY
    plot([DOYs(i),DOYs(i)] - planting_DOY(1),ylim,'--r');  % In DAP
       
    % title(sprintf('DOY: %d, RMSE(W): %5.2f',DOYs(i),RMSE(1))) % In DOY
    title(sprintf('DAP: %d, RMSE(W): %5.2f',DOYs(i)-planting_DOY,RMSE(1))) % In DAP

    % Add legend
    if n == 1
        lg = legend([p1(1),p2,p3],...
        {'Particles','Oberved',sprintf('Weighted mean')},'Location','northwest');
    
    end

    
    n = n + 1;  
    
end






end

