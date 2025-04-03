function [PF_results] = ParticlesGenerationSIRSeasonalRefl(sim,...
    dates,files)
% % This function generate particles for particle filter

% Assign variables to firtheir names in the function
DOYs = sim.DOYs;
time = sim.time;
cultivar = sim.cultivar;
ecotype = sim.ecotype;
comb = sim.comb;
flags = sim.flags;
hc = sim.hc;

DOYs_for_DA = dates.DOYs_for_DA;
number_of_DOYs4DA = dates.number_of_DOYs4DA;

wth_filename = files.wth_filename;

% Preallocate matrices
[PF_results] = MatricesPreallocations(number_of_DOYs4DA);

% Start measuring time of total DSSAT runs
b1 = tic;

% % Particles generation % %
fprintf('Particle generation has started \n') 

% Run DSSAT with all particles
[DSSAT_results] = RunDSSATsequentially(comb,cultivar,ecotype,files);

% Index for saving the SCOPE output in the cell arrays
nn = 1;

for ii = DOYs_for_DA

    % Convert DSSAT state variable value to SCOPE input
    [pars,vals] = DSSATState2SCOPEInput(DSSAT_results,DOYs(ii),ii,flags,comb,...
        cultivar,ecotype,wth_filename,time,files,hc);

    % Run SCOPE only one time (in time series mode) with all the values from the DSSAT simulations 
    [PF_results.refl{nn},PF_results.refl_SRF{nn}] = RunSCOPESequentially(pars,vals,files);
    
    nn = nn + 1;
    
end

fprintf('SCOPE runs have ended \n')

% Assign results to a single output variable
[PF_results] = AssignResultsToOutput(PF_results,DSSAT_results);

b1 = toc(b1);

fprintf('\nrunning of particle generation (DSSAT+SCOPE) has ended \n')
fprintf('running took %.1f minutes \n', b1/60)

end



% % % % % % % % % % % % 5 % % % % % % %
function [PF_results] = MatricesPreallocations(number_of_DOYs4DA)

    [PF_results.refl,PF_results.refl_SRF] = deal(cell(number_of_DOYs4DA,1));

end

function [PF_results] = AssignResultsToOutput(PF_results,DSSAT_results)

    PF_results.LAI = DSSAT_results.LAID';
    
    PF_results.SLAD = DSSAT_results.SLAD';
    
    PF_results.lE_DSSAT = DSSAT_results.ET'*2.45*11.57; %[W/m^2] % DSSAT lE
    
    PF_results.PHAD = DSSAT_results.PH';
    
    PF_results.leaf_N = DSSAT_results.LN_conc';
    
    PF_results.yield = DSSAT_results.yield; %[kg/ha] % yield
    
    PF_results.biomass = DSSAT_results.biomass;
    
    PF_results.growing_stage = DSSAT_results.GSTD;
    
    PF_results.pod_number = DSSAT_results.pod_num;
    
    PF_results.leaf_on_stem = DSSAT_results.LSD;
    
    
    PF_results.SWC1 = DSSAT_results.SW1D;  % Soil water content
    PF_results.SWC2 = DSSAT_results.SW2D;  % Soil water content
    PF_results.SWC3 = DSSAT_results.SW3D;  % Soil water content
    PF_results.SWC4 = DSSAT_results.SW4D;  % Soil water content
    PF_results.SWC5 = DSSAT_results.SW5D;  % Soil water content

end
