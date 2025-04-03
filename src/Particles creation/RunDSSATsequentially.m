function [D] = RunDSSATsequentially(comb,cultivar,ecotype,files)

% % Run DSSAT once to get the sizes of the matrices
set_cultivar_parameters(comb(1,1:12),cultivar,ecotype,files)
set_ecotype_parameters(comb(1,13:26),ecotype,files)

[PlantGro,SoilWat,Fresh,ET,ETPhot,PlantN] = run_DSSAT(1,files);

% Ititiate matrices
[D.LAID,D.SLAD,D.LSD,D.pod_num,D.LN_conc,D.WSGD] = deal(zeros(size(PlantGro.r1,1),size(comb,1)));
[D.SW1D,D.SW2D] = deal(zeros(size(SoilWat.r1,1),size(comb,1)));
D.ET = zeros(size(ET.r1,1),size(comb,1));
D.PH = zeros(size(ETPhot.r1,1),size(comb,1));
D.yield = cell(size(comb,1),1);

fprintf('Sequential run of DSSAT has started \n')

a1 = tic;

% % Run DSSAT with all parameter combinations
for i = 1:size(comb,1)
    
    % Set the genotype parameters
    set_cultivar_parameters(comb(i,1:12),cultivar,ecotype,files)
    set_ecotype_parameters(comb(i,13:26),ecotype,files)

    % Run DSSAT
    nb_runs = 1;
    
    [PlantGro,SoilWat,Fresh,ET,ETPhot,PlantN] = run_DSSAT(nb_runs,files);
    
    % Save only the parameters required for the coupling scheme
    D.LAID(:,i) = PlantGro.r1.LAID;   % LAI
    D.SLAD(:,i) = PlantGro.r1.SLAD;   % Specific leaf area  [cm^2/gr]
    D.LSD(:,i) = PlantGro.r1.("L#SD"); % Leaf number per stem
    D.pod_num(:,i) = PlantGro.r1.("P#AD");

    D.LN_conc(:,i) = PlantN.r1.("LN%D");     % Leaf Nitrogen concentration [%]
    WSGD_smoothed = smooth(PlantGro.r1.WSGD,0.1);
    D.WSGD(:,i) = WSGD_smoothed;

    D.GSTD(:,i) = PlantGro.r1.GSTD;
    
    % Get soil moisture 
    D.SW1D(:,i) = SoilWat.r1.SW1D;    % Soil water content (volumetric), soil layer 1 (0-5 [cm]) 
    D.SW2D(:,i) = SoilWat.r1.SW2D;    % Soil water content (volumetric), soil layer 2 (5-15 [cm])
    D.SW3D(:,i) = SoilWat.r1.SW3D;    % Soil water content (volumetric), soil layer 3 (15-30 [cm])
    D.SW4D(:,i) = SoilWat.r1.SW4D;    % Soil water content (volumetric), soil layer 4 (30-45 [cm])
    D.SW5D(:,i) = SoilWat.r1.SW5D;    % Soil water content (volumetric), soil layer 5 (45-60 [cm])
    
    D.ET(:,i) = ET.r1.ETAA;

    D.PH(:,i) = ETPhot.r1.PHAD;
    
    D.yield{i} = Fresh.r1.FPWAD;
    
    % Biomass (considered as the weight of stem+leaf)
    D.biomass(:,i) = PlantGro.r1.VWAD;  % [kg/ha]
    
    if mod(i,100) == 0
      fprintf('particles generation for paticle %.f/%.f ended \n',i,size(comb,1))
    end
    
end

a1 = toc(a1);

fprintf('DSSAT simulations have ended after %.2f minutes \n',a1/60)


