function [max_global,min_global] = FindMaxSVValue(PF_results,SV_name)

max_global = 0;

min_global = 10^6;

for i = 1:length(PF_results)
    
    if ~isempty(PF_results{i})
        
        if isnumeric(PF_results{i}.(SV_name))
            max_temp = max(PF_results{i}.(SV_name),[],'all');
        else
            max_temp = max(cell2mat(cellfun(@max,PF_results{i}.yield,'UniformOutput',false)));
        end

        if max_temp > max_global

           max_global = max_temp;
       
        end
        
        if isnumeric(PF_results{i}.(SV_name))
            min_temp = min(PF_results{i}.(SV_name),[],'all');
        else
            min_temp = min(cell2mat(cellfun(@min,PF_results{i}.yield,'UniformOutput',false)));
        end

        if min_temp < min_global

           min_global = min_temp;
       
        end
        
    end
    
end