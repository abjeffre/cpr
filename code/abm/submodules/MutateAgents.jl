function MutateAgents(traits, mutation, types)
        x=copy(traits)
        n=size(x)[1]
        k=size(x)[2]
        trans_error = rand(n,k) .< mutation
        for i in 1:k
                if types[i] == "binary" x[:,i]=ifelse.(trans_error[:,i], ifelse.(x[:,i].==1,0,1), x[:,i])  end
                if types[i] == "prob"
                        n_error = rand(Normal(), n)
                        x[:,i] =  ifelse.(trans_error[:,i], inv_logit.(logit.(x[:,i]) .+ n_error[i]), x[:,i])
                end
                if types[i] == "positivecont"
                        n_error = rand(Normal(1, .02), n)
                        x[:,i] =  ifelse.(trans_error[:,i], (x[:,i]) .* n_error[i], x[:,i])
                end
        end
        return(x)
end
