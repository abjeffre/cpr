####################################################################
############### Leakage paper prediction plots #####################

@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_small_lkS.jld2")


#################################################################
######### TWO GROUPS ############################################

################## LEAKAGE WITH NO TRAVEL COSTS ##############################
a=findall(x->x==0.9, S1[:,10])
q=findall(x->x==0.0, S1[:,4])
a=a[a.∈ Ref(q)]


b=findall(x->x==0.0001, S1[:,10])
q=findall(x->x==0.0, S1[:,4])
b=b[b.∈ Ref(q)]


dat1=collate(abm_dat[a], 2)
dat2=collate(abm_dat[b])

plot(dat1["leak"])
plot!(dat2["leak"])



################## LEAKAGE WITH  TRAVEL COSTS ##############################
a=findall(x->x==0.9, S1[:,10])
q=findall(x->x==0.01, S1[:,4])
a=a[a.∈ Ref(q)]


b=findall(x->x==0.0001, S1[:,10])
q=findall(x->x==0.01, S1[:,4])
b=b[b.∈ Ref(q)]


dat1=collate(abm_dat[a], 2)
dat2=collate(abm_dat[b])

plot(dat1["leak"])
plot!(dat2["leak"])


###################################################################
############ TWENTY GROUPS #######################################

@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_large_lkS.jld2")

################## LEAKAGE WITH NO TRAVEL COSTS ##############################
a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==0.0, S2[:,4])
a=a[a.∈ Ref(q)]


b=findall(x->x==0.0001, S2[:,10])
q=findall(x->x==0.0, S2[:,4])
b=b[b.∈ Ref(q)]


dat1=collate(abm_dat[a], 6:20)
dat2=collate(abm_dat[b])

plot(dat1["leak"])
plot!(dat2["leak"])

################## LEAKAGE WITH  TRAVEL COSTS ##############################
a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==0.01, S2[:,4])
a=a[a.∈ Ref(q)]


b=findall(x->x==0.0001, S2[:,10])
q=findall(x->x==0.01, S2[:,4])
b=b[b.∈ Ref(q)]


dat1=collate(abm_dat[a], 6:20)
dat2=collate(abm_dat[b])

plot(dat1["leak"])
plot!(dat2["leak"])
