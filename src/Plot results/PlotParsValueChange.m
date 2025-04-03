function [] = PlotParsValueChange(pars,dates,sim,comb_summ,weights_summ,...
    pert_pars_summ)

    % Assign values to variable as they appear in this script
    parameters = pars.parameters;
    param_ranges = pars.param_ranges;
    
    DOYs = dates.DOYs_for_DA;
    number_of_DOYs = dates.number_of_DOYs4DA;

    planting_DOY = sim.planting_DOY;

    % Calculate the weighted mean of the parmaeters on each DA date
    [pars_w,inds_vec] = GetParsWeightedValue(number_of_DOYs,comb_summ,weights_summ);
        
    % Make a logical matrix with the parameters being pertrubed in each DA
    [log_mat] = CreatePertParsInds(DOYs,parameters,pert_pars_summ);

    % Choose which parameters to plot
    pars2plot = {'CSDL','EM_FL','FL_LF','SD_PM','LFMAX','SLAVR','XFRT',...
        'EM_V1','TRIFL','FL_SD'};
   
    % Define an array for the C axis tick values
    X = sim.DOYs(dates.DOYs_for_DA) - planting_DOY;  % X axis is in DAP

    X = categorical(X);
    
    % % Plot
    % Define figure properties
    f_pars_vals = figure();
    set(f_pars_vals,'Name','Parameter values')

    n = 1;

    for i = 1:size(comb_summ{1},2)
        if any(strcmp(parameters{i},pars2plot))

            % Define subplot location
            subplot(ceil(length(pars2plot)/2),2,n)
            
            % Plot parameter value at the current DA date
            plot(X,pars_w(inds_vec,i),'o-b');

            hold on
            
            % % plot marker to mark pertrubation of the paramter in each DA
            % date
            rel_dates = X(log_mat(:,i));
            
            plot(rel_dates,ones(1,length(rel_dates))*param_ranges(i,1),...
              'k^','MarkerFaceColor','k','MarkerSize',3)
            
            if contains(parameters{i},'_')
              temp = strrep(parameters{i},'_','-'); 
              title(temp)
            else
              title(parameters{i})
            end
            
            ylim(param_ranges(i,:))
            
            yticks(linspace(param_ranges(i,1),param_ranges(i,2),3))
            
            if n == length(pars2plot) || n == length(pars2plot)-1
              xlabel('DAP')
            end
            
            n = n + 1; 
        end
    end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [log_mat] = CreatePertParsInds(DOYs_to_run,parameters,pert_pars_summ)
    
   log_mat = false(length(DOYs_to_run),length(parameters));

   nn = 1;

   for j = 1:length(DOYs_to_run)
       for ii = 1:length(parameters)

           if any(ismember(pert_pars_summ{j},ii))
               log_mat(nn,ii) = 1;
           end
       end

       nn = nn + 1;
   end

end