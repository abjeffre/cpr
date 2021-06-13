function GetModels(agents, ngroups, gmean, nmodels, out)
      n = size(agents)[1]
      models = zeros(n)
      model_groups = sample(1:ngroups,gmean, n)
      for i = 1:n
        temp2 = agents.id[(agents.gid .∈ Ref(agents.gid[i])) .== (agents.id .!= i)]
        if glearn_strat == false
          model_list = ifelse(out[i]==1,
            sample(agents.id[agents.gid.==model_groups[i]], nmodels, replace = false),
            sample(temp2, nmodels, replace = false))
          else
            model_list = ifelse(out[i]==1,
              sample(agents.id[1:end .!= agents.id[i]], nmodels, replace = false),
              sample(temp2, nmodels, replace = false))
          end

        if learn_type == "wealth"
          model_temp = model_list[findmax(agents.payoff[model_list])[2]]
          models[i] = ifelse(agents.payoff[model_temp] > agents.payoff[i], model_temp, i) end
        if learn_type == "income"
            model_temp = model_list[findmax(agents.payoff_round[model_list])[2]]
            models[i] = ifelse(agents.payoff_round[model_temp] > agents.payoff_round[i], model_temp, i) end
      end # End finding models
      models=convert.(Int64, models)
end
