function [] = AddColors2PlotBone_LAI(nLevels,weight,h)

%In this function the colormap style is 'bone'.

% % choose the colormap (eg, jet) and number of levels (eg, 100)
% nLevels = aa; 
cmat =bone(nLevels); 


% % Assign each weight to a row of color. 
weightNorm = 1 - (weight-min(weight))./range(weight); %normalized 0:1

[~,~,crow] = histcounts(weightNorm,linspace(0,1,nLevels));

if ~nnz(crow)
    crow(:) = 1;
end

crow1 = crow;

% crow1(crow1 > 480) = 480;


% % assign color
set(h,{'Color'},mat2cell(cmat(crow1,:),ones(size(h)),3))

% colormap bone
% 
% colorbar