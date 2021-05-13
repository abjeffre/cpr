####################################################################
############### Leakage paper prediction plots #####################

@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_small_lkS.jld2")


##############################################################################
################## Punish WITH Punish Cost = 0.015 ##### ##############################

a=findall(x->x==0.9, S1[:,10])
q=findall(x->x==0.015, S1[:,8])
a=a[a.∈ Ref(q)]


b=findall(x->x==0.0001, S1[:,10])
q=findall(x->x==0.015, S1[:,8])
b=b[b.∈ Ref(q)]


dat1=collate(abm_dat[a], 2)
dat2=collate(abm_dat[b])

plot(dat1["punish"])
plot!(dat2["punish"])


##############################################################################
################## Punish with PC == 0.0015 #####################################

a=findall(x->x==0.9, S1[:,10])
q=findall(x->x==0.0015, S1[:,8])
a=a[a.∈ Ref(q)]


b=findall(x->x==0.0001, S1[:,10])
q=findall(x->x==0.0015, S1[:,8])
b=b[b.∈ Ref(q)]


dat1=collate(abm_dat[a], 2)
dat2=collate(abm_dat[b])

plot(dat1["punish"])
plot!(dat2["punish"])



#######################################################################
#######################################################################
################## TWENTY GROUPS ######################################
#######################################################################
#######################################################################



@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_large_lkS.jld2")


##############################################################################
################## Punish WITH Punish Cost = 0.015 ##### ##############################

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==0.015, S2[:,8])
a=a[a.∈ Ref(q)]


b=findall(x->x==0.0001, S2[:,10])
q=findall(x->x==0.015, S2[:,8])
b=b[b.∈ Ref(q)]


dat1=collate(abm_dat[a], 6:20)
dat2=collate(abm_dat[b])

plot(dat1["punish"])
plot!(dat2["punish"])


##############################################################################
################## Punish with PC == 0.0015 #####################################

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==0.0015, S2[:,8])
a=a[a.∈ Ref(q)]


b=findall(x->x==0.0001, S2[:,10])
q=findall(x->x==0.0015, S2[:,8])
b=b[b.∈ Ref(q)]


dat1=collate(abm_dat[a], 6:20)
dat2=collate(abm_dat[b])

plot(dat1["punish"])
plot!(dat2["punish"])
