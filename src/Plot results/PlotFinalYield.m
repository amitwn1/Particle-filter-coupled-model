function [] =  PlotFinalYield(sim,dates,PF_results_summ,weights_summ,...
    obs_data)

% Assign values to the varuables used in this script
DOYs2Plot = dates.DOYs_for_DA;

planting_DOY = sim.planting_DOY;
DOYs = sim.DOYs(DOYs2Plot);

yield_obs = obs_data.yield;

% Preallocations
[y_final_w_SV,y_final_w_pars,y_final_r_SV] = deal(zeros(length(PF_results_summ),1));

% % Get weighted maen of the fianl yield obtained by DA at differnet
% DOYs
for i = 1:length(DOYs2Plot)

        % Save the yield data of current data assimilation date (a cell array) in a temporary variable
        temp_DA_data = PF_results_summ{i}.yield;

        % Initiate vector to store temporary values of days number of yield
        % simulation for each particle (it varies between particles)
        y_final = zeros(size(temp_DA_data,1),1); 

        % Create a vector of only the yield at the final day of the season
        for j = 1:size(temp_DA_data,1)
            if isempty(temp_DA_data{j})
                y_final(j) = 0;
            else
                y_final(j) = temp_DA_data{j}(end);  % yields at the fianl day
            end

        end

        % Calculate weighted mean of the finel yield
        y_final_w_SV(i) = sum(y_final .* weights_summ{i});

        col1 = 'r';
        
        % Calculate regular mean of the finel yield
        y_final_r_SV(i) = mean(y_final);
        
        col3 = 'm';
        

end


% % Plot
figure('Name','Yield');

XLim = [0,DOYs(end) - planting_DOY + 5];

% Get indices of DOYs which were simulated
% inds_temp = first_DOY_of_simulation:length(weights_summ);
inds_temp = 1:length(DOYs2Plot);

% Plot time series of simulated final yield (weighted mean)
% s1 = scatter(DOYs(inds_temp),y_final_w_SV(inds_temp),[],col1,'filled'); % In DOY
s1 = scatter(DOYs(inds_temp) - planting_DOY,y_final_w_SV(inds_temp),[],col1,'filled'); % In DAP

hold on

% Plot observed final yield as a dashed horizontal line
p1 = plot(XLim,[yield_obs,yield_obs],'--b');

% Modify plot properties
% xlabel('DOY'); % In DOY
xlabel('DAP');  % In DAP
ylabel('Final yield [kg/ha]');

ylim([0,max([max(y_final_w_pars),max(y_final_w_SV),...
    yield_obs]) + 2000]);

xlim(XLim)

 
legend([s1,p1],{'Simulated (weighted mean of particles)','Observed'},'Location','southeast')

title(sprintf('Final yield - simulated and observed'))

% % Calculate and show absolute error (AE) and notmalized absolute error (NAE) obtained at the final DA data
% Calculate AE and NAE
AE = abs(yield_obs - y_final_w_SV(end));

NAE = (AE/yield_obs)*100;

% Show as text on the figure
txt_str = sprintf('AE = %.2e \nNAE = %.2f [%%]',AE,NAE);

text(5,10^4,txt_str)

end

