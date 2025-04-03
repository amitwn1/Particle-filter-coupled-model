function [] = AddColors2PlotJet(nLevels,weight,h)

%In this function the colormap style is 'bone'.

% % choose the colormap (eg, jet) and number of levels (eg, 100)
% nLevels = aa; 
cmat =jet(nLevels); 


% % Assign each weight to a row of color. 
weightNorm = (weight-min(weight))./range(weight); %normalized 0:1

[~,~,crow] = histcounts(weightNorm,linspace(0,1,nLevels));

% % assign color
set(h,{'Color'},mat2cell(cmat(crow,:),ones(size(h)),3))


% colormap bone
% 
% colorbar