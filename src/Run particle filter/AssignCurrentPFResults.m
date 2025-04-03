function [summ] = AssignCurrentPFResults(summ,PF_results,weights,sim,...
    f_refl,kk)

   summ.PF_results_summ{kk} = PF_results;
   summ.weights_summ{kk} = weights;
   summ.comb_summ{kk+1} = sim.comb;
   summ.pert_pars_summ{kk} = f_refl;

end