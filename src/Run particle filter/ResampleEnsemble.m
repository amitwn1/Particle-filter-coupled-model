function [comb_resampled] = ResampleEnsemble(weights,comb)

% % create a 'line' with the weights sorted on it

% Get the length of the weights vector
L = 1000000;

% Get the nuber of particles
N = length(weights);

% Initiate line
line = zeros(L,1);

n = 1;

% Divide line into section which sizes are based on the weights
for i = 1:N
    section_size = round(weights(i)*L);
    
    line(n:n+section_size-1) = ones(section_size,1)*i;
    
    n = n + section_size;
end

% % Create an inidices vector for bounderis on the particle line (see Van Leewuen et al. 2009)

% Choose a random number form the interval [0,1/N] (N is the number of particles)
random1 = (1/N)*rand(1,1);

% Create the indices vector
ind_vec = zeros(L,1);

first_spot = round(random1*L);

% Ensure that first_spot variable is not equal to 0
while first_spot == 0
    % Choose a random number form the interval [0,1/N] (N is the number of particles)
    random1 = (1/N)*rand(1,1);

    % Create the indices vector
    ind_vec = zeros(L,1);

    first_spot = round(random1*L);
end

ind_vec(first_spot) = 1;

step = floor((1/N)*L);

m = first_spot + step;

for i = 1:N-1
    
    ind_vec(m) = 1;
    
    m = m + step;
end

ind_vec = logical(ind_vec);

% % Resmaple

% Apply the indices vector on the weights line
line1 = line(ind_vec);

% Initiate the new combination matrix
comb_resampled = zeros(size(comb));

% Ensure that there are no zeros on the vectotr line1
if nnz(line1 == 0)
    line1(line1 == 0) = find(line1 == 0);
end

% Apply indices vector on the weights line
for j = 1:N
    comb_resampled(j,:) = comb((line1(j)),:);
end

    
    
    

    