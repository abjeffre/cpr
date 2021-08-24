function SocialTransmission(trait, models, fidelity, types)
        x=copy(trait)
        n=size(x)[1]
        k=size(x)[2]
        trans_error = rand(n,k) .< fidelity
        self = models .== collect(1:n)
        #trans_error[self,:] .=0
        if types == "Dirichlet"
                temp=(Matrix(x).*5).+.01
                n_error  = zeros(n,k)
                for i in 1:n
                        n_error[i,:] = rand(Dirichlet(temp[i,:]), 1)'
                end
                x =  ifelse.(trans_error[:,1], n_error[models,:], x[models,:])
        else
                for i in 1:k
                        if types[i] == "binary" x[:,i]=ifelse.(trans_error[:,i], ifelse.(x[models,i].==1,0,1), x[models,i])  end
                        if types[i] == "prob"
                                n_error = rand(Normal(), n)
                                x[:,i] =  ifelse.(trans_error[:,i], inv_logit.(logit.(x[models,i]) .+ n_error), x[models,i])
                        end
                        if types[i] == "positivecont"
                                n_error = rand(Normal(1, .02), n)
                                x[:,i] =  ifelse.(trans_error[:,i], x[models,i] .* n_error, x[models,i])
                        end
                end
        end
        return(x)
end
