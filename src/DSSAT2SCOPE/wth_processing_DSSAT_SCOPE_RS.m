function [wth_data_out] = wth_processing_DSSAT_SCOPE_RS(filename,DOYs,time)
%%
% weather data analysis
% The input to this function is the name of the relevant weather file.
% The output is a table with the weather data relevant to DSSAT weather
% files.
% It is assumed that all weather original data files are in the same
% folder.
%
% % inputs: % %
% * filename - name of wether file (it is assumed that all weather file
%              are stored at the same directory).
% * DOYs - vector of days on which Senitnel-2 observation are available (in DOY) 
%          simulations will be preformed only on these days to reduce
%          computing time.
% * time - hour of image acquisition by Sentinel-2 - a string in the format
%          of 'hh:mm'.

path = 'Data\Weather data\';

T = readtable([path,filename],'Range','A2');
T = flip(T,2);

T.Properties.VariableNames = {'date','hour','avg_temp','relative_humidity',...
'temp_10m','temp_4m','contorl_temp','temp_0.5m','grass_temp',...
'soil-temp 5cm','soil_temp_20cm','dew_hour','radiation_intensity',...
'avg_wind_speed','rain','radiation','daily_upper_wind','upper_wind_10m',...
'wind_speed_10m','wind_direction','saturated_vapor_pressure',...
'vapor_deficit','aerodynamic_evaporation','radiative_evaporation',...
'evaporation'};

%% Processing data

% Remove second line from the table
T(2,:) = [];

% Calculate number of days in the cirrent year (In 202 there were 366 days)
days_num = ceil(length(T.date(2:end - 8))/24);

% Add DOY column to the weather data
DOY_table = zeros(days_num,1);

for i = 1:days_num
DOY_table((24*(i-1) + 1):(24*(i-1) + 24)) = ones(24,1)*i;
end

DOY_table(end) = nan;

DOY_table = [nan;DOY_table;nan*ones(7,1)];

T.DOY = DOY_table;

% Convert hour from string to a fraction from 24 (double). Since weather
% data is for round hours, if a non-rounded hour is provided, it will be
% rounded
hour = str2double(time(1:2)) + str2double(time(4:5))/60;
hour = round(hour);
hour_fraction = hour/24;

% initiating matrices
SRAD = zeros(1,length(DOYs));
T_air = zeros(1,length(DOYs));
vapor_pressure = zeros(1,length(DOYs));
WIND = zeros(1,length(DOYs));

% the index of the proper table entry is obtained according to each relevant
% date and hour, and gathered in vectors that will be SCOPE input
for i = 1:length(DOYs)

    % find the index of the current date and hour
    index = ((T.DOY == DOYs(i)) - (T.hour ~= hour_fraction)) == 1;

    SRAD(i) = T.radiation_intensity(index); % Daily solar radiation [W*m^-2]
    T_air(i) = T.avg_temp(index);  % Average temperature at chosen time of the day [C]
    vapor_pressure(i) = ((T.relative_humidity(index)/100) .* T.saturated_vapor_pressure(index))*10;  % Atmospheric vapor pressure [hPa]

    WIND(i) = T.wind_speed_10m(index);% [m/sec]

end

WNDHT = 10;   % [m]

%% Date - year,Julian days
DOY = (1:365)';

%% Creating a single structure object with all the data

wth_data_out.z = WNDHT; wth_data_out.Rin = SRAD;
wth_data_out.Ta = T_air; wth_data_out.ea = vapor_pressure;
wth_data_out.u = WIND; wth_data_out.DOY = DOY;


end
        
