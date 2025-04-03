function [] = AddColors2PlotBone(nLevels,weight,h)

%In this function the colormap style is 'bone'.

% % choose the colormap (eg, jet) and number of levels (eg, 100)
% nLevels = aa; 
cmat =bone(nLevels); 


% % Assign each weight to a row of color. 
if range(weight) ~=0
    weightNorm = 1 - (weight-min(weight))./range(weight); %normalized 0:1

    [~,~,crow] = histcounts(weightNorm,linspace(0,1,nLevels));


    crow1 = crow + 256;
else
    crow = ones(nLevels,1);
end

% % assign color
if 0  % Shade represent absolute weight values
    set(h,{'Color'},mat2cell(cmat(crow,:),ones(size(h)),3))
else  % All partciels are getting a certain grey sahde so that the extenet of the ensebmle is visible
    temp = cmat(crow,:) - 0.085;

    temp(temp < 0) = 0;

    set(h,{'Color'},mat2cell(temp,ones(size(h)),3))
end

