function [sim,pars,files] = DefineSimulationDetails()

% In this function, all the details required to run the data assimilation
% are defined.

%% Simulation details
% Define time of RS observation (for SCOPE's RTMo simulation)
sim.time = '11:00';

% Define coupling relations to be used in the simulation of the coupled
% model
[sim.flags,~,~] = DefineFlags();

% % Parameters related to noise addition
sim.epsilon = 0.08; % perturbution factor 

% Define number of parameters with which will have 2 values in each
% combination (this define the size of the ensemble which is 2^k)
sim.particle_n = 10;

% % Remove reflectance observations on certain dates due to
% irreasonable values of reflectance at certain bands **
sim.removed_DAPs = [48 78 83];  % For Gadash 2019 season

% % Define cultivar for perturbution **
% Define number of parameters with which will have 2 values in each
% combination (this define the size of the ensemble which is 2^k)
sim.cultivar = 'TM0011'; % This cultivar is modified during the particle generation process
sim.ecotype = 'TM0011';

%% Parameter details
% Parameter names
pars.parameters = {'CSDL','PPSEN','EM_FL','FL_SH','FL_SD',...
              'SD_PM','FL_LF','LFMAX','SLAVR','SIZLF',...
              'XFRT','PODUR','THVAR','EM_V1','V1_JU',...
              'JU_R0','PM09','LNGSH','R7_R8','FL_VS',...
              'TRIFL','RWDTH','RHGHT','R1PPO','OPTBI',...
              'SLOBI'};

% Parameter ranges
pars.param_ranges = [[10;15],[0;4],[16;28],[1;6],[9;25],...
       [35;55],[40;60],[1.1;1.65],[300;410],[250;350],...
       [0.55;0.8],[40;63],[0;5],[10;30],[0;5],...
       [1;9],[0.6;0.9],[20;65],[0;5],[18;32],...
       [0.25;0.6],[0.8;1.2],[0.8;1.2],[0;0.3],[0;3],...
       [0;0.03]]';

% Assign the number of parameters to a variable
pars.plen = length(pars.parameters);


%% Dierctory and file names and description
% % Particle filter Simulation related
% Define the name of the directory where the particle filter results will
% be stored
dateString = char(datetime('today'),'yyMMdd');

files.folderName = sprintf('particle_simulated_data_%s_%02d_%s',dateString,hour(datetime),'HAVA1901'); 

% % DSSAT run related
% Define the path of DSSAT's directory (on the nachine running this code)
% e.g.: 'C:\DSSAT47\'
files.DSSAT_loc = 'C:\DSSAT47\';

% Define the name of DSSAT's run .exe file (including the .exe extension)
%e.g.: 'DSCSM047.EXE'
files.exe = 'DSCSM047.EXE';

% Define the name of DSSAT batch file
%e.g.: 'DSCSM047.EXE'
files.batch = 'DSSBatch1.v47';

% Assign the path of DSSAT's cultivar file relevant to your machine
% Note that the path and the file extension are correct (file extension is dependent on DSSAT version)
% e.g.: 'C:\DSSAT47\Genotype\TMGRO047.CUL'
files.cultivar_full_path = 'C:\DSSAT47\Genotype\TMGRO047.CUL';  % This string should be changed according to the path and DSSAT version
files.ecotype_full_path = 'C:\DSSAT47\Genotype\TMGRO047.ECO';  % This string should be changed according to the path and DSSAT version

% % SCOPE run related
% define the name for the csv file with default SCOPE parameter values
files.SCOPE_default_input = 'input_data_default.csv';

% define the name for the csv file with SCOPE parameter values adjusted
% during particle filter run
files.SCOPE_new_input = 'input_data_AW_example.csv';

% Define the path of the location of SCOPE directory
files.SCOPE_dir_loc = 'C:\SCOPE-2.1\'; %'C:\SCOPE-master\';

% Define the name of SCOPE main code file
files.SCOPE_run_file = 'SCOPE'; % 'SCOPE_Amit';

% Define the name of the direcoty where SCOPE output will be saved
% * Note that this name should be provided inside the SCOPE
% create_output_files_binary() function (under the scetion '13. create output files')
% as the name of the output directory (variable 'outdir_name')
files.SCOPE_output_file = 'DSSAT_couplig';



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
function [flags,relations_inds,var_str] = DefineFlags()

% % Define which relations will be used in the models' coupling

% % Define a structure of binary variables, where each filed is a possible
% relation % %

% Cab - leaf chlorophyl content
flags.Cab = 1;
% Cca - lea carotenoid content
flags.Cca = 1;
% Cdm - leaf dry matter conent
flags.Cdm = 1;
% Cw - leaf equivalent water layer
flags.Cw = 1;
% Cs - leaf senescent material fraction
flags.Cs = 1;
% N - leaf structure parameter
flags.N = 1;
% LAI- leaf area index
flags.LAI = 1;
% LIDFa,LIDFb - leaf inclination angle distribution parameters
flags.LIDF = 1;
% hc - crop height
% flags.hc = 0;
% BSM - BSM parameters (soil reflectance model)
flags.BSM = 1;
% SMC - soil moisture (used in the soil reflectance model)
flags.SMC = 1;

if flags.N == 0 || flags.Cdm == 0
    warning('Coupling of N and Cdm is not activated')
end

% Define indices vector for chosen relations
relations_inds = logical([flags.Cab,flags.Cca,flags.Cdm,flags.Cw,flags.Cs,...
    flags.N,flags.LAI,flags.LIDF,flags.BSM,flags.SMC]);

var_str = {'Cab','Cca','Cdm','Cw','Cs','N','LAI','LIDF','BSM','SMC'};