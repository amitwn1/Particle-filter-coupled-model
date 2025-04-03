function [comb] = CreateInitialParsCombinations(parameters,param_ranges,k)

% Assign number of particles and parameter ranges to variables
number_of_particles = k;

lb = param_ranges(:,1);
ub = param_ranges(:,2);


lh=lhsdesign(number_of_particles,length(parameters));

% Preallocate combinations matrix
comb = zeros(size(lh));

for i = 1:number_of_particles
    comb(i,:) = (lb + (ub-lb).*(lh(i,:))')'; % first bin values - returning to range values
end