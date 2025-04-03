function [w1_norm,w1,g] = weights_refl(refl_avg,refl_std,refl_SRF)
% This function calculates the weights of a particle set based on the
% corresponding obsecrved reflectance
% Parameters description:
%  * refl_avg - average reflectance values for each band
%  * refl_std - standard deviations of the averaged reflecatnace values for
%  each band
%  * refl_SRF - simulated reflectance values for each band - after
%  applying the Sentinel-2 spectral response function


mu = refl_avg;
sigma = refl_std;
nu = refl_SRF;


% If any row contains NaN values, make it equal to the previous row
for i = 2:size(nu,1)
    if any(isnan(nu(i,:)))
        nu(i,:) = nu(i-1,:);
    end
end
% For the case where the first row is nan
if any(isnan(nu(1,:)))
    nu(1,:) = nu(2,:);
end

% If the standard deviation is not known make it very close to zero
if sigma == 0
    sigma = mu*0.25;  % It was found that 0.25 is the mean standard error for observed LAI (according to treatment 1)
end

% Preallocate g (raw weights array)
g = nu*0;


% Define the Gaussian as an anonymous function
GaussFunc = @(nu,sigma,mu) exp(-((nu-mu).^2)./(2*sigma^2));

% calculate weights
for i = 1:size(nu,2)

    g(:,i) = (1/(sigma(i)*sqrt(2*pi)))*GaussFunc(nu(:,i),sigma(i),mu(i));

end


% normalizing and summing weights

% Create a global weight vector (sum the effect of differnet bands so that
% each partile will have a single weight)
w1 = sum(g,2);

% Noramalize global weight vector
w1_norm = w1/sum(w1);