function [pars_w,inds_vec] = GetParsWeightedValue(number_of_DOYs,comb_summ,weights_summ)


% number_of_DOYs = length(DOYs);

inds_vec = zeros(number_of_DOYs,1);

pars_w = zeros(size(comb_summ{1},2),number_of_DOYs);

% % For t = 0, he paramter values will the average of the values in the different combinations
% pars_w(:,1) = mean(comb_summ{1},1)';

m = 0;

for i = 1:number_of_DOYs
    if isempty(weights_summ{i})
        m = m + 1;
    end

    if ~isempty(comb_summ{i})
        pars_w(:,i) = comb_summ{i}' * weights_summ{i+m};  % weighted mean if the parameters
        inds_vec(i) = 1;
    end

    if isempty(comb_summ{i})
        m = m - 1;
    end
end

inds_vec = logical(inds_vec);

pars_w = pars_w';

end