  # Harvest
      function GetGroupHarvest(effort, loc, K, kmax, tech, labor, degrade, ngroups)
       b = zeros(ngroups)
       X =zeros(ngroups)
       for i in 1:ngroups
         b[i]=cdf.(Beta(degrade[1], degrade[2]), K[i]/maximum(kmax))
       end
       for i in 1:ngroups
         X[i] =tech*((sum(effort[loc .== i])^labor)*b[i])
       end
       return(X)
      end
