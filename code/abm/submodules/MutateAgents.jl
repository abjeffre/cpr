function MutateAgents(x, models, mutation, types)
        x=copy(x)
        n=size(x)[1]
        k=size(x)[2]
        trans_error = rand(n,k) .< fidelity
        self = models .== agents.id
        trans_error[self,:] .=0
        for i in 1:k
                if types[i] == "binary" x[:,i]=ifelse.(trans_error[:,i], ifelse.(x[models,i].==1,0,1), x[models,i])  end
                if types[i] == "prob"
                        n_error = rand(Normal(), n)
                        x[:,i] =  ifelse.(trans_error[:,i], inv_logit.(logit.(x[models,i]) .+ n_error[i]), x[models,i])
                end
                if types[i] == "positivecont"
                        n_error = rand(Normal(1, .02), n)
                        x[:,i] =  ifelse.(trans_error[:,i], inv_logit.(logit.(x[models,i]) .* n_error[i]), x[models,i])
                end
        end
        return(x)
end
