function [colors,max_global_LAI,max_global_yield,n,f] = InitiateSepratePlots(color_type,MS,PF_results_summ,DOYs2plot)

% Define colors (choose from 'Bone' or 'Jet')


colors = [];

switch color_type
    case 'Bone'
        colors.c2 = 'b'; colors.c3 = 'r'; colors.c4 = 'm'; colors.c5 = 'g'; colors.M = '^';  % This is the condifugration for the actual paper

        % colors.c2 = 'c'; colors.c3 = 'm'; colors.c4 = 'm'; colors.c5 = 'y'; colors.M = 's';  % This is the condifugration for the actual paper
        % disp('Plot colors were modified to fit the conference paper') 

        colors.color = 'Bone';

    case 'Jet'
        colors.c2 = 'k'; colors.c3 = '#D9DDDC'; colors.c4 = '#808588'; colors.c5 = 'g'; colors.M = '^';

        colors.color = 'Jet';

        colormap jet
end

% Define marker size
colors.MS = MS;

[max_global_LAI] = FindMaxSVValue(PF_results_summ,'LAI');

[max_global_yield] = FindMaxSVValue(PF_results_summ,'yield');

% % % % Start plotting

% Initiate index for figure number
n = 1;

% Preallocate figure array
f = gobjects(1, length(DOYs2plot));