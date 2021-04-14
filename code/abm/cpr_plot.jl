######################################
########## Plotting ##################

ngroups = 2
nrounds =2000


hl = zeros(1000, 4)


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

iter = size(deg0["effort"])[3]
rnds = size(deg1["effort"])[1]

m = zeros(rnds, iter)
c = zeros(rnds, iter)
p = zeros(rnds, iter)
s = zeros(rnds, iter)
l = zeros(rnds, iter)

for i in 1:iter
    m[:,i]=mean(deg0["limit"][:,:,i], dims = 2)
    c[:,i]=mean(deg0["limit"][:,:,i].-deg0["effort"][:,:,i], dims = 2)
    p[:,i]=mean(deg0["punish"][:,:,i], dims = 2)
    s[:,i]=mean(deg0["stock"][:,:,i], dims = 2)
    l[:,i]=mean(deg0["leakage"][:,:,i], dims = 2)
end

a=plot(mean(m, dims =2))
b=plot(mean(c, dims =2))
d=plot(mean(p, dims =2))
d1=plot(mean(s, dims =2))
d2 =plot(mean(l, dims =2))

m = zeros(rnds, iter)
c = zeros(rnds, iter)

for i in 1:iter
    m[:,i]=mean(deg1["limit"][:,:,i], dims = 2)
    c[:,i]=mean(deg1["limit"][:,:,i].-deg1["effort"][:,:,i], dims = 2)
    p[:,i]=mean(deg1["punish"][:,:,i], dims = 2)
    s[:,i]=mean(deg1["stock"][:,:,i], dims = 2)
    l[:,i]=mean(deg1["leakage"][:,:,i], dims = 2)
end

e=plot(mean(m, dims =2))
f=plot(mean(c, dims =2))
g=plot(mean(p, dims =2))
g1=plot(mean(s, dims =2))
g2=plot(mean(l, dims = 2))


plot(a,b,d,d1,d2,e,f,g,g1,g2, layout = (2,5))








b =plot(mean(m, dims =2))

plot(a, b,  layout = (2,1))
