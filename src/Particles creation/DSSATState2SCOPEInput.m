function [pars,vals] = DSSATState2SCOPEInput(D,DOY_rel,DOY_current,flags,comb,...
    cultivar,ecotype,wth_filename,time,files,hc)
% Save variables in an adequate way for this script (For the specified (single DOY))

% % Run DSSAT once to get the DOY vectors
set_cultivar_parameters(comb(1,1:12),cultivar,ecotype,files)
set_ecotype_parameters(comb(1,13:26),ecotype,files)

[PlantGro,SoilWat,Fresh,ET,ETPhot,PlantN] = run_DSSAT(1,files);

% Ensure that DOY_rel is a row vector
DOY_rel = reshape(DOY_rel,1,[]); % rel stands for relevant, meaning that this is the DOY that is currently simulated

indx_DOY_PG = logical(sum(PlantGro.r1.DOY == DOY_rel,2));   % PG is for plant grow
indx_DOY_SW = logical(sum(SoilWat.r1.DOY == DOY_rel,2));   % SW is for soil water

% Save only the parameters required for the coupling scheme
LAID = D.LAID(indx_DOY_PG,:); % LAI
SLAD = D.SLAD(indx_DOY_PG,:);   % Specific leaf area  [cm^2/gr]
LSD = D.LSD(indx_DOY_PG,:); % Leaf number per stem
pod_num = D.pod_num(indx_DOY_PG,:); % Number of pods

LN_conc = D.LN_conc(indx_DOY_PG,:);     % Leaf Nitrogen concentration [%]

WSGD = D.WSGD(indx_DOY_PG,:); % Water strees index

GSTD = D.GSTD(indx_DOY_PG,:);

% Get soil moisture 
SW1D = D.SW1D(indx_DOY_SW,:);    % Soil water content (volumetric), soil layer 1 (0-5 [cm]) 
SW2D = D.SW2D(indx_DOY_SW,:);    % Soil water content (volumetric), soil layer 2 (5-15 [cm])

SMC_DSSAT = SW1D; %mean([SW1D;SW2D],1);

%% Creating vectors with weather data required for SCOPE

[wth_data] = wth_processing_DSSAT_SCOPE_RS(wth_filename,DOY_rel,time);

%
z = wth_data.z;
Rin = wth_data.Rin;
Ta = wth_data.Ta;
ea = wth_data.ea;
u = wth_data.u;


%% Solar zenith throughout the day
% Load angles data
load('Data\Angles\Angles2019.mat','Angles');

% Sun zenith angle
tts = Angles.tts(DOY_current);

% Observer Zenith angle
tto = Angles.tto(DOY_current);

% Difference between observer and sun azimuth
psi = Angles.psi(DOY_current);
    
%%  %% SCOPE parameters obtained from DSSAT output variables %% %%

%% Leaf parameters %%

%% Cab - Chlorophyll AB content
% Orrigianl equation [Guler and Buyuk (2007)] gives Cab in SPAD units,
% conversion to [mg/g] is from Jiang et al. (2017), distinguishing between
% vegetative and reproductive stages. Cab units used by SCOPE [ug/cm^2] is obtained
% with the SLA variable

Cab = zeros(1,length(LN_conc));

for i = 1:length(LN_conc)
    if pod_num(i) == 0
        Cab(i) = 0.0647*((LN_conc(i) - 1.42)/0.048) - 1.4543;   % [mg/g]
    else
        Cab(i) = 0.0306*((LN_conc(i) - 1.42)/0.048) + 0.1443;   % [mg/g]
    end
end

FW = SLAD/6;   % I assume that leaf fresh wight is 6 times higher the leaf dry weight (see our data or Grunzweig et al. 1999)

% Ensure both vectors of Cab and FW are of the same shape
Cab = reshape(Cab,[],1);
FW = reshape(FW,[],1);

Cab = ((Cab./FW)*10^3);   %[ug/cm^2]

if flags.Cab
    SCOPE_in.Cab = Cab;
else
    SCOPE_in.Cab = 80; % Default value
end

%% Cca - Carotenoid content
if flags.Cca
    SCOPE_in.Cca = 0.25*Cab;  % [ug/cm^2]
else
    SCOPE_in.Cca = 20; % Default value
end

%% Cdm - dry matter content 
if flags.Cdm
    SCOPE_in.Cdm = 1./SLAD;    %[g/cm^2] 
else
    SCOPE_in.Cdm = 0.012;    % Default values
end

%% Cw  - leaf water content
% Assuming that the ratio between fresh and dry leaf weight is 6
%(this is a rough estimation based on our measurements) Cw is obtained
% bsed on the substruction of fresh leaf weight/leaf area - dry keaf
% weight/leaf area
if flags.Cw
    % Cw = (-0.017*WSGD + 0.02)./(LAID.^0.01);
    SCOPE_in.Cw = 6./SLAD - 1./SLAD;  % [cm]
else
    SCOPE_in.Cw = 0.009;  % Default value
end

%% Cs - Sensescent material fraction [-]
% According to DSSAT documentation (DSSATV4.5, Vol.4, Page 69, Fig. 17), Cs fraction is a
% fucntion of number of leaves on the main stem
if flags.Cs
    Cs = zeros(length(LSD),1);
    for i = 1:length(LSD)
        if LSD(i) <= 5
            Cs(i) = 0;

        elseif LSD(i) > 5 && LSD(i) <= 14
            Cs(i)  = 0.0133*LSD(i) - 0.0655;

        elseif LSD(i) > 14
            Cs(i) = 0.12;

        end
    end

    SCOPE_in.Cs = Cs;
else
    SCOPE_in.Cs = 0;  % Default value
end

%% N - Leaf thickness parameter
if flags.N
    % Convert units from cm^2/g to cm^2/mg
    SLAD_N = SLAD/1000;
    % Calculate N
    SCOPE_in.N = (0.025 + 0.9*SLAD_N)./(SLAD_N - 0.1);
else
    SCOPE_in.N = 1.4;  % Default value
end

%% Canopy parameters %%

%% LAI [m^2*m^-2]
if flags.LAI
    SCOPE_in.LAI = LAID;
else
    SCOPE_in.LAI = 3;  % Default value
end

%% LIDF a,b - average leaf inclination angle  
if flags.LIDF
    [LIDFa,LIDFb] = deal(zeros(1,length(LAID)));
    for i = 1:length(LAID)
    switch GSTD(i)
        case 0
            LIDFa(i) = -0.2; 
            LIDFb(i) = -0.15;
        case 1
            LIDFa(i) = -0.2;
            LIDFb(i) = -0.15;
        case 2
            LIDFa(i) = 0.0;
            LIDFb(i) = -0.4;
        case 3
            LIDFa(i) = 0.0;
            LIDFb(i) = -0.4;       
        case 5
            LIDFa(i) = 0.25;
            LIDFb(i) = -0.35;
        case 8
            LIDFa(i) = -0.5;
            LIDFb(i) = 0;
    end
    end
else
    LIDFa = -0.35;  % Default values
    LIDFb = -0.15;
end

SCOPE_in.LIDFa = LIDFa;
SCOPE_in.LIDFb = LIDFb;
 
%%  canopy height
SCOPE_in.hc = hc;

%% Soil parameters %%

%% BSM model parameters
if flags.BSM
    load('Data\soil spectrum parameters (BSM)\BSM_GDSH19.mat','BSM_GDSH19')
    BSMBrightness = BSM_GDSH19.BSMBrightness; BSMlat = BSM_GDSH19.BSMlat; BSMlon = BSM_GDSH19.BSMlon;
else
    BSMBrightness = 0.5; BSMlat = 25; BSMlon = 45;  % Default values
end

SCOPE_in.BSMBrightness  = BSMBrightness;
SCOPE_in.BSMlat = BSMlat;
SCOPE_in.BSMlon = BSMlon;

%% Soil moisture content
if flags.SMC
    SCOPE_in.SMC = SMC_DSSAT;
else
    SCOPE_in.SMC = 0.25;   % Default value
end


%% Writing the SCOPE parameters into an excel file readable by SCOPE
pars = {'Cab','Cca','Cw','Cs','N','Cdm',...
    'SMC','BSMBrightness','BSMlat','BSMlon',...
    'LAI','hc','LIDFa','LIDFb',...
    'z','Rin','Ta','ea','u',...
    'tts','tto','psi'};

vals = {SCOPE_in.Cab,SCOPE_in.Cca,SCOPE_in.Cw,SCOPE_in.Cs,SCOPE_in.N,SCOPE_in.Cdm,...
    SCOPE_in.SMC,SCOPE_in.BSMBrightness,SCOPE_in.BSMlat,SCOPE_in.BSMlon,...
    SCOPE_in.LAI,SCOPE_in.hc,SCOPE_in.LIDFa,SCOPE_in.LIDFb,...
    z,Rin,Ta,ea,u,...
    tts,tto,psi};