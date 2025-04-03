function [files] = SaveResults(files,summ,pars,dates,sim)

% Create the new directory
if files.create_dir_flag
    mkdir(['PF results\',files.folderName])

    files.create_dir_flag = 0;
end

% Save results
PF_results_summ = summ.PF_results_summ;
weights_summ = summ.weights_summ;
comb_summ = summ.comb_summ;
pert_pars_summ = summ.pert_pars_summ;
std_summ = summ.std_summ;

save(['PF results\',files.folderName,'\final_results'],...
    'PF_results_summ','weights_summ','comb_summ','pert_pars_summ','std_summ',...
    'pars','dates','sim');

end