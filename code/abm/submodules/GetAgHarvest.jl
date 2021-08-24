  # Harvest
  #Note that this harvest function does not pool labor before applying the elastisicty
  function GetAgHarvest(effort, gid, K, kmax, tech, labor, ag_degrade, necessity, ngroups)
    b = zeros(ngroups)
    effort = effort.*100
    for i in 1:ngroups
      b[i]=cdf.(Beta(ag_degrade[1], ag_degrade[2]), K[i]/maximum(kmax))
    end
    tech.*((1 .+ effort.^labor) .- 1).*(1 .-b[gid]) .- necessity
   end


  # Harvest
  #Note that this harvest function does not pool labor before applying the elastisicty
  function GetHarvestStone(effort, gid, K, kmax, tech, labor, ag_degrade, necessity, ngroups)
    b = zeros(ngroups)
    effort = effort.* 100
    for i in 1:ngroups
      b[i]=cdf.(Beta(ag_degrade[1], ag_degrade[2]), K[i]/maximum(kmax))
    end
    out=tech.*((1 .+ effort.^labor) .- 1).*(1 .-b[gid]) .- necessity
    ifelse.(out .< 0, out, out*2)
   end


   
     # Harvest
  #Note that this harvest function does not pool labor before applying the elastisicty
  function GetAgHarvest2(effort, gid, K, kmax, tech, labor, ag_degrade, necessity, ngroups)
    b = zeros(ngroups)
    effort = effort.*100
    for i in 1:ngroups
      b[i]=cdf.(Beta(ag_degrade[1], ag_degrade[2]), K[i]/maximum(kmax))
    end
    tech.*effort.^labor.*(kmax[gid].-K[gid]).^(1 .-b[gid]) .- necessity
   end
