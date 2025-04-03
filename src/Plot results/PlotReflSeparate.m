function PlotReflSeparate(n,i,obs_data,weights_summ,PF_results_summ,...
    colors,f)


wl = 400:2400;

inds_a = 1:20:2001;

% Plot particles
figure(f(n)); hold on;

subplot(1,3,1)

% Sort particles according to their weights before plotting
% them
[B,I] = sort(weights_summ{n});

Particles_sorted = PF_results_summ{n}.refl{n}(I,1:2001);

% Plot particles
p1 = plot(wl,Particles_sorted','Color',[0.75,0.75,0.75]);

hold on

 % Color the cureves based on their weights
switch colors.color
    case 'Bone'
         AddColors2PlotBone(length(p1),B,p1)
         % AddColors2PlotBone_adj(length(p1),B,p1)
    case 'Jet'
        % AddColors2PlotJet(length(p1),weights_summ{i},p1)
         AddColors2PlotJet(length(p1),B,p1)
end

% Define an array for X axis tick labels
X = GetS2bands();

% Plot observation
obs = obs_data.refl_avg(i,:)';

obs_std = obs_data.refl_std(i,:)';

p2 = errorbar(X,obs,obs_std,'o','Color',colors.c2,'MarkerSize',colors.MS);

% Set observation curve properties             
set(p2,'MarkerFaceColor',colors.c2)


% % Plot weighted mean

% Calculte weighted mean
ST_w = PF_results_summ{n}.refl{n}(:,1:2001)' * weights_summ{n};  % weighted mean if the chosen state variable


% Plot weigthed mean
p3 = plot(wl(inds_a),ST_w(inds_a),colors.M,'Color',colors.c3,'MarkerSize',colors.MS);
set(p3,'MarkerFaceColor',colors.c3)

% % Define legned
leg1 = [p2,p3];
leg_str = {'Observed','Weighted mean'};


% % Calculate RMSE
% Calculate weighted mean of reflectance after applying the SRF
ST_w_refl_SRF = PF_results_summ{n}.refl_SRF{n}' * weights_summ{n};  % weighted mean if the chosen state variable

[inds_S2] = GetS2indices();

% Calculate RMSE of the reflectance at the current DAd ate
RMSE_refl = sqrt(sum((ST_w_refl_SRF(inds_S2) - obs).^2)/length(obs)); % Fix to weighted mean value of SRF reflectance

title(sprintf('reflectance RMSE: %.4f',RMSE_refl))


% Modify plot properties
xlabel('Wavelength [nm]'); ylabel('Reflectance'); ylim([0 1]);

legend(leg1,leg_str,...
    'Location','northwest')



