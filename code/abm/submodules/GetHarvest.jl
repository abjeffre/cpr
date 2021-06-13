  # Harvest
  #Note that this harvest function does not pool labor before applying the elastisicty
  function GetGroupHarvest(effort, K, kmax, tech, labor, degrade)
    b = zeros(ngroups)
    X =zeros(ngroups)
    for i in 1:ngroups
      b[i]=cdf.(Beta(degrade[1], degrade[2]), K[i]/maximum(kmax))
    end
    tech.*((1 .+ effort.^labor) .- 1).*b[loc]
   end
