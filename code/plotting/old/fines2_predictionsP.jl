####################################################################
############### Leakage paper prediction plots #####################

@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_lkS.jld2")




##############################################################################
################## Limit WITH seed = 0.25 ##### ##############################

a=findall(x->x==0.9, S1[:,10])
q=findall(x->x==0.25, S1[:,7])
a=a[a.∈ Ref(q)]


b=findall(x->x==0.0001, S1[:,10])
q=findall(x->x==0.25, S1[:,7])
b=b[b.∈ Ref(q)]


dat1=collate(abm_dat[a], 2)
dat2=collate(abm_dat[b])

plot(dat1["fine2"])
plot!(dat2["fine2"])



##############################################################################
################## Limit WITH seed = 0.1 ##### ######################

a=findall(x->x==0.9, S1[:,10])
q=findall(x->x==0.1, S1[:,7])
a=a[a.∈ Ref(q)]


b=findall(x->x==0.0001, S1[:,10])
q=findall(x->x==0.1, S1[:,7])
b=b[b.∈ Ref(q)]


dat1=collate(abm_dat[a], 2)
dat2=collate(abm_dat[b])

plot(dat1["fine2"], ylim = [0, 1])
plot!(dat2["fine2"])


##############################################################################
################## Limit with PC == 0.0015 #####################################

a=findall(x->x==0.9, S1[:,10])
q=findall(x->x==0.0015, S1[:,8])
a=a[a.∈ Ref(q)]


b=findall(x->x==0.0001, S1[:,10])
q=findall(x->x==0.0015, S1[:,8])
b=b[b.∈ Ref(q)]


dat1=collate(abm_dat[a], 2)
dat2=collate(abm_dat[b])

plot(dat1["fine2"])
plot!(dat2["fine2"])



##############################################################################
################## Limit with PC == 0.015 #####################################

a=findall(x->x==0.9, S1[:,10])
q=findall(x->x==0.015, S1[:,8])
a=a[a.∈ Ref(q)]


b=findall(x->x==0.0001, S1[:,10])
q=findall(x->x==0.015, S1[:,8])
b=b[b.∈ Ref(q)]


dat1=collate(abm_dat[a], 2)
dat2=collate(abm_dat[b])

plot(dat1["fine2"],  ylim = [0, 1])
plot!(dat2["fine2"])


#######################################################################
#######################################################################
################## TWENTY GROUPS ######################################
#######################################################################
#######################################################################



@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_large_lkS.jld2")


##############################################################################
################## Limit WITH seed = 0.25 ##### ##############################

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==0.25, S2[:,7])
a=a[a.∈ Ref(q)]


b=findall(x->x==0.0001, S2[:,10])
q=findall(x->x==0.25, S2[:,7])
b=b[b.∈ Ref(q)]


dat1=collate(abm_dat[a], 6:20)
dat2=collate(abm_dat[b])

plot(dat1["limit"], ylim = [0, 1])
plot!(dat2["limit"])



##############################################################################
################## Limit WITH seed = 0.1 ##### ######################

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==0.1, S2[:,7])
a=a[a.∈ Ref(q)]


b=findall(x->x==0.0001, S2[:,10])
q=findall(x->x==0.1, S2[:,7])
b=b[b.∈ Ref(q)]


dat1=collate(abm_dat[a], 6:20)
dat2=collate(abm_dat[b])

plot(dat1["limit"], ylim = [0, 1])
plot!(dat2["limit"])


##############################################################################
################## Limit with PC == 0.0015 #####################################

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==0.0015, S2[:,8])
a=a[a.∈ Ref(q)]


b=findall(x->x==0.0001, S2[:,10])
q=findall(x->x==0.0015, S2[:,8])
b=b[b.∈ Ref(q)]


dat1=collate(abm_dat[a], 6:20)
dat2=collate(abm_dat[b])

plot(dat1["limit"], ylim = [0, 1])
plot!(dat2["limit"])



##############################################################################
################## Limit with PC == 0.015 #####################################

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==0.015, S2[:,8])
a=a[a.∈ Ref(q)]


b=findall(x->x==0.0001, S2[:,10])
q=findall(x->x==0.015, S2[:,8])
b=b[b.∈ Ref(q)]


dat1=collate(abm_dat[a], 6:20)
dat2=collate(abm_dat[b])

plot(dat1["limit"], ylim = [0, 1])
plot!(dat2["limit"])
