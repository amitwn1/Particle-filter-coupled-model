function [sim,files,SA_mean_refl,obs_data,dates,summ] = SimulationInitialization(sim,pars,files)

%% Define simlation details
% Define the season name (may be redundent in this version)
sim.season = 'HAVA1901';

% Assign additional details of this season
sim.DOYs = [116,121,131,136,141,146,151,161,176,181,186,196,201,206,211];

% Define number of days in the simulation
sim.season_days = 109;

% Define constant crop height
sim.hc = 0.35;  % [cm]

% Define planting date for Gadash Farm 2019 season
sim.planting_DOY = 103;

% Create the first combination set of parameters ***
sim.comb = CreateInitialParsCombinations(pars.parameters,...
    pars.param_ranges,sim.particle_n);

%% Define file details
% Define the name of the file containing weather data
files.wth_filename = 'wth_Gadash2019_365_filled.xlsx';

% Initilaize the flag for directory creation (so it will create a new directory only at the end of the first repetition)
files.create_dir_flag = 1;

%% Get Sensitivity indices
% % Definition of DSSAT Parameters and sensitivity analyss properties
load('Data\Sensitivity indices\SA_mean_refl.mat','SA_mean_refl');

% % Get observed data
[obs_data] = GetObsRefl();

%% Create data assimilation dates vector
% Initiate count of DOYs when observation are available (DA dates) ***
dates.DOYs_for_DA = 1:length(sim.DOYs);  % Indices

% Remove dates when observation are questionable
inds_removed = find(logical(sum(sim.DOYs - sim.planting_DOY == sim.removed_DAPs',1)));

dates.DOYs_for_DA(inds_removed) = [];

warning('DOYs %s are not included in the simulation',mat2str(sim.removed_DAPs))

% % Initializations
% Initialzie current DOY counter (both index and the actual DOY)
dates.DOY_current_index = 1;

dates.DOY_current = dates.DOYs_for_DA(dates.DOY_current_index);

% Number of DOYs for data assimialtion
dates.number_of_DOYs4DA = length(dates.DOYs_for_DA);

%% Preallocations
number_of_DOYs4DA = dates.number_of_DOYs4DA;

summ.PF_results_summ = cell(number_of_DOYs4DA,1);
[summ.weights_summ, summ.weights_raw_summ] = deal(cell(number_of_DOYs4DA,1));
summ.comb_summ = cell(number_of_DOYs4DA+1,1);
summ.pert_pars_summ = cell(number_of_DOYs4DA,1);

summ.std_summ = zeros(number_of_DOYs4DA,9);

summ.weights = ones(size(sim.comb,1),1);

summ.comb_summ{1} = sim.comb;