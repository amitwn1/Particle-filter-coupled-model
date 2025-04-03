function [LAI_out] = get_LAI()
%
path = 'Data\Observed data\';
file = 'Height_LAI_Gadash_2019.xlsx';

% Data from Gadash Farm, 2019
GDSH_LAI_19 = readtable([path,file],'Sheet','Raw_LAI','Range','A1:C7');

% % Assign data to Matlab structure
% Mean meaured LAI
LAI_out.LAI = GDSH_LAI_19.LAI;

% LAI STD
LAI_out.LAI_std = GDSH_LAI_19.STD;

% Get LAI observation DOYs
d = GDSH_LAI_19.Date; d.Format = 'dd-MM-yyyy';
LAI_out.LAI_DOY = day(d,"dayofyear");


end