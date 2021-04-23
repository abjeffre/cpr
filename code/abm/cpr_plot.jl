######################################
########## Plotting ##################

test =copy(abm_dat[1])

ngroups = 6
nrounds =2000


vars = ["l0p0hl", "l0p1hl", "l1p0hl", "l1p1hl"]
vari = vars[1]
di = Dict(string(vari,"1")=> filter(!isnan, test[vari][:,1,1]))
for i = 2:ngroups
    di[string(vari, i)] = filter(!isnan, test[vari][:,i,1])
end


temp=Array{Union{Missing, Number}}(missing, nrounds, ngroups)

kdi = collect(keys(di))
for i = 1:length(kdi)
    temp[1:length(di[kdi[i]]),i] = di[kdi[i]]
end

temp2=zeros(nrounds)
for i = 1:nrounds
    temp2[i] = mean(skipmissing(temp[i,:]))
end
pdi=Dict("1" => temp2)



cnt = 2
for vari in vars[2:4]
    di = Dict(string(vari,"1")=> filter(!isnan, test[vari][:,1,1]))
    for i = 2:ngroups
        di[string(vari, i)] = filter(!isnan, test[vari][:,i,1])
    end

    temp=Array{Union{Missing, Number}}(missing, nrounds, ngroups)
    kdi = collect(keys(di))
    for i = 1:length(kdi)
        temp[1:length(di[kdi[i]]),i] = di[kdi[i]]
    end

    temp2=zeros(nrounds)
    for i = 1:nrounds
        temp2[i] = mean(skipmissing(temp[i,:]))
    end
    pdi[string(cnt)] = temp2

    cnt +=1

end

kpdi = collect(keys(pdi))

plot(pdi[kpdi[1]])
plot!(pdi[kpdi[2]])
plot!(pdi[kpdi[3]])
plot!(pdi[kpdi[4]])



############################################################################
################# Means ####################################################


comb=size(abm_dat)[1]
test = copy(abm_dat)
iter = size(test[1]["effort"])[3]
rnds = size(test[1]["effort"])[1]

limit = Plots.Plot{Plots.GRBackend}[]
punish = Plots.Plot{Plots.GRBackend}[]
leak = Plots.Plot{Plots.GRBackend}[]
differ = Plots.Plot{Plots.GRBackend}[]
harvest = Plots.Plot{Plots.GRBackend}[]
effort = Plots.Plot{Plots.GRBackend}[]
stock = Plots.Plot{Plots.GRBackend}[]


temp1 = zeros(comb,7,rnds, iter)
temp2 = zeros(comb, 7, rnds)

for j in 1:comb
    for i in 1:iter
        temp1[j,1,:,i]=median(test[j]["limit"][:,:,i], dims = 2)
        temp1[j,2,:,i]=mean(test[j]["effort"][:,:,i], dims = 2)
        temp1[j,3,:,i]=mean(test[j]["harvest"][:,:,i], dims = 2)./300
        temp1[j,4,:,i]=median(test[j]["limit"][:,:,i].-test[j]["harvest"][:,:,i]./300, dims = 2)
        temp1[j,5,:,i]=mean(test[j]["punish"][:,:,i], dims = 2)
        temp1[j,6,:,i]=mean(test[j]["stock"][:,:,i], dims = 2)
        temp1[j,7,:,i]=mean(test[j]["leakage"][:,:,i], dims = 2)
    end

    for k in 1:7
        for i in 1:size(test[1]["effort"])[1]
            temp2[j,k,i]=nanmedian(temp1[j,k,i,:])
        end
    end

    push!(limit, plot(temp2[j,1,:]))
    push!(effort, plot(temp2[j,2,:]))
    push!(harvest, plot(temp2[j,3,:]))
    push!(differ, plot(temp2[j,4,:]))
    push!(punish, plot(temp2[j,5,:]))
    push!(stock, plot(temp2[j,6,:]))
    push!(leak, plot(temp2[j,7,:]))

end
