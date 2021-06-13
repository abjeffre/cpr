function SplitGroups(gid, groups, nmodels, id, traits, split_method)    
    if any(tab(gid, ngroups).<(nmodels+1))
      failed = findall((tab(gid, ngroups) .< (nmodels+1)))
      successful = findall((tab(gid, ngroups) .>= (nmodels+1)))
      temp = ones(ngroups)
      temp[failed].=0
      temp2 = copy(groups.group_status)
      temp3 = temp .!=temp2
      new_failed =findall(x->x .==1, temp3)
      if any(temp .!=temp2)
        gid[gid .∈ Ref(new_failed)] = sample(gid[gid .∉ Ref(new_failed)], sum(gid .∈ Ref(new_failed)), replace = false)
        if split_method == :random
            for i in 1:length(new_failed)
                tosplit=findmax(tab(gid, ngroups))[2]
                groupsize=asInt(findmax(tab(gid, ngroups))[1])
                newmembers=sample(id[gid .∈ Ref(tosplit)], groupsize)
                gid[newmembers].=new_failed[i]
            end
        end
        if split_method == :political
            for i in 1:length(new_failed)
                tosplit=findmax(tab(gid, ngroups))[2]
                groupsize=asInt(findmax(tab(gid, ngroups))[1])
                splitpoint=median(traits.harv_limit[gid.== new_failed[i]])
                temp=findall(x->x .> splitpoint, traits.harv_limit[gid.== tosplit])
                temp2=id[gid.==tosplit]
                newmembers=temp2[temp]
                gid[newmembers].=new_failed[i]
            end
        end
      end
    end
    return(gid)
  end