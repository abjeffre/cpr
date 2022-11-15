  # Harvest
  #Note that this harvest function does not pool labor before applying the elastisicty
  function GetHarvest(effort, loc, K, kmax, tech, labor, degrade, necessity, ngroups)
    b = zeros(ngroups)
    effort=effort.*100
    for i in 1:ngroups
      b[i]=cdf.(Beta(degrade[1], degrade[2]), K[i]/maximum(kmax))
    end
    #tech.*((1 .+ effort.^labor) .- 1).*b[loc] .- necessity
    tech.*((effort.^labor) ).*b[loc] .- necessity

   end


  # Harvest
  #Note that this harvest function does not pool labor before applying the elastisicty
  function GetHarvestStone(effort, loc, K, kmax, tech, labor, degrade, necessity, ngroups)
    b = zeros(ngroups)
    effort=effort.*100
    for i in 1:ngroups
      b[i]=cdf.(Beta(degrade[1], degrade[2]), K[i]/maximum(kmax))
    end
    out=tech.*((1 .+ effort.^labor) .- 1).*b[loc] .- necessity
    ifelse.(out .< 0, out, out*2)
   end
