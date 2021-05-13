####################################################################
############### Leakage paper prediction plots #####################

@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_small_lkS.jld2")


##############################################################################
################## Effort WITH Tech = 0.5 ##### ##############################

a=findall(x->x==0.9, S1[:,10])
q=findall(x->x==0.5, S1[:,5])
a=a[a.∈ Ref(q)]


b=findall(x->x==0.0001, S1[:,10])
q=findall(x->x==0.5, S1[:,5])
b=b[b.∈ Ref(q)]


dat1=collate(abm_dat[a], 2)
dat2=collate(abm_dat[b])

plot(dat1["effort"])
plot!(dat2["effort"])


##############################################################################
################## Effort with Tech == 1 #####################################

a=findall(x->x==0.9, S1[:,10])
q=findall(x->x==1, S1[:,5])
a=a[a.∈ Ref(q)]


b=findall(x->x==0.0001, S1[:,10])
q=findall(x->x==1, S1[:,5])
b=b[b.∈ Ref(q)]


dat1=collate(abm_dat[a], 2)
dat2=collate(abm_dat[b])

plot(dat1["effort"])
plot!(dat2["effort"])



##############################################################################
################## Effort WITH labor = 0.07 ##### ##############################


a=findall(x->x==0.9, S1[:,10])
q=findall(x->x==.07, S1[:,6])
a=a[a.∈ Ref(q)]


b=findall(x->x==0.0001, S1[:,10])
q=findall(x->x==.07, S1[:,6])
b=b[b.∈ Ref(q)]


dat1=collate(abm_dat[a], 2)
dat2=collate(abm_dat[b])

plot(dat1["effort"])
plot!(dat2["effort"])



##############################################################################
################## Effort with labor == .7 #####################################

a=findall(x->x==0.9, S1[:,10])
q=findall(x->x==.7, S1[:,6])
a=a[a.∈ Ref(q)]


b=findall(x->x==0.0001, S1[:,10])
q=findall(x->x==.7, S1[:,6])
b=b[b.∈ Ref(q)]


dat1=collate(abm_dat[a], 2)
dat2=collate(abm_dat[b])

plot(dat1["effort"])
plot!(dat2["effort"])


#######################################################################
#######################################################################
################## TWENTY GROUPS ######################################
#######################################################################
#######################################################################



@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_large_lkS.jld2")


##############################################################################
################## Effort WITH Tech = 0.5 ##### ##############################

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==0.5, S2[:,5])
a=a[a.∈ Ref(q)]


b=findall(x->x==0.0001, S2[:,10])
q=findall(x->x==0.5, S2[:,5])
b=b[b.∈ Ref(q)]


dat1=collate(abm_dat[a], 6:20)
dat2=collate(abm_dat[b])

plot(dat1["effort"])
plot!(dat2["effort"])


##############################################################################
################## Effort with Tech == 1 #####################################

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==1, S2[:,5])
a=a[a.∈ Ref(q)]


b=findall(x->x==0.0001, S2[:,10])
q=findall(x->x==1, S2[:,5])
b=b[b.∈ Ref(q)]


dat1=collate(abm_dat[a], 6:20)
dat2=collate(abm_dat[b])

plot(dat1["effort"])
plot!(dat2["effort"])



##############################################################################
################## Effort WITH labor = 0.07 ##### ##############################


a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==.07, S2[:,6])
a=a[a.∈ Ref(q)]


b=findall(x->x==0.0001, S2[:,10])
q=findall(x->x==.07, S2[:,6])
b=b[b.∈ Ref(q)]


dat1=collate(abm_dat[a], 6:20)
dat2=collate(abm_dat[b])

plot(dat1["effort"])
plot!(dat2["effort"])



##############################################################################
################## Effort with labor == .7 #####################################

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==.7, S2[:,6])
a=a[a.∈ Ref(q)]


b=findall(x->x==0.0001, S2[:,10])
q=findall(x->x==.7, S2[:,6])
b=b[b.∈ Ref(q)]


dat1=collate(abm_dat[a], 6:20)
dat2=collate(abm_dat[b])

plot(dat1["effort"])
plot!(dat2["effort"])
