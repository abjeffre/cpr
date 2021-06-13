####################################################################
############### Leakage paper prediction plots #####################
using(JLD2)
using(Distributions)
@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\abm_dat_small_lkS.jld2")

##############################################################################
################## leak with Tech == 1 #####################################

a=findall(x->x==0.9, S1[:,10])



b=findall(x->x==0.001, S1[:,10])



dat1=collate(abm_dat[a], 2)
dat2=collate(abm_dat[b],2)

plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Proportion Investment in Exclude")

png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\predleakmean2.png")

#######################################################################
#######################################################################
################## TWENTY GROUPS ######################################
#######################################################################
#######################################################################



@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\abm_dat_large_lkS.jld2")


gs=[2,4,5,6,8]


a=findall(x->x==0.9, S2[:,10])
b=findall(x->x==0.001, S2[:,10])


dat1=collate(abm_dat[a], gs)
dat2=collate(abm_dat[b], gs)

plot(dat1["punish"], ylim=[0,1])
plot!(dat2["punish"])


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude")

png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\predleakmean20.png")


##############################################################################
################## Travel Costs ###########################################

#PC  = 0.0015
a=findall(x->x==0.9, S2[:,10])
b=findall(x->x==0.9, S2[:,10])


q=findall(x->x==0, S2[:,4])
a=a[a.∈ Ref(q)]
b=b[b.∈ Ref(q)]

dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b], gs)

plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC  = 0.0015")

png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\predleakmean20tc0.png")



#TC = .01
a=findall(x->x==0.9, S2[:,10])
b=findall(x->x==0.9, S2[:,10])
q=findall(x->x==.01, S2[:,4])
b=b[b.∈ Ref(q)]
a=a[a.∈ Ref(q)]

dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b], gs)

plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC = 0.015")

png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\predleakmean20pc015.png")




############################################################
############## TRAVEL COSTS LARGE INTERACTIONS #############
############################################################

# TC =0.01 and tech== 1.5 ##

a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==1.5, S2[:,5])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==1.5, S2[:,5])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC = 0.015, Tech = 1.5")

png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc015tech1.png")


# TC =0.01 and tech== 0.15 ##


a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==.15, S2[:,5])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==0.15, S2[:,5])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC = 0.015, Tech = 1.5")

png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc015tech2.png")



# TC =0.01 and labor==.7 ##

a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==0.7, S2[:,6])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==0.7, S2[:,6])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)

plot(dat1["punish"], ylim=[0,1])
plot!(dat2["punish"])


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC = 0.015, Labor = 0.7")

png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc015l07.png")





# TC =0.01 and labor==.35 ##

a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==0.35, S2[:,6])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==0.35, S2[:,6])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC = 0.015, Labor = 0..5")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc015l035.png")


plot(dat1["punish"], ylim=[0,1])
plot!(dat2["punish"])



# TC =0.01 and Wages==0.015 ##


a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==0.015, S2[:,19])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==0.015, S2[:,19])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC = 0.015, W = .015")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc015w015.png")



# TC =0.01 and Wages==0.15 ##


a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==0.15, S2[:,19])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==0.15, S2[:,19])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC = 0.015, W = .15")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc015w15.png")





# TC =0.01 and TC==.01 ##

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==0.01, S2[:,4])
c=findall(x->x==0.015, S2[:,8])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==0.01, S2[:,4])
c=findall(x->x==0.015, S2[:,8])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC = 0.015, PC = 0.015")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc015tc015.png")



# TC =0.01 and TC==.0 ##

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==0.0, S2[:,4])
c=findall(x->x==0.015, S2[:,8])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==0.0, S2[:,4])
c=findall(x->x==0.015, S2[:,8])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC = 0.015, PC = 0.015")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc015tc0.png")




# TC =0.01 and MF==11250 ##

a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==11250.0, S2[:,9])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==11250.0, S2[:,9])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC = 0.015, MF = 11250")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc015mf11250.png")


# TC =0.01 and MF==22500 ##

a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==22500.0, S2[:,9])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==22500.0, S2[:,9])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC = 0.015, MF = 11250")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc015mf22250.png")




# TC =0.01 and DF==1 ##

a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==1, S2[:,14])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==1, S2[:,14])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC = 0.015, DF = 1")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc015df1.png")




# TC =0.01 and DF==4 ##

a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==4, S2[:,14])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==4, S2[:,14])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC = 0.015, DF = 4")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc015df4.png")




# TC =0.01 and v==60 ##

a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==60, S2[:,15])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==60, S2[:,15])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC = 0.015, V = 60")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc015v60.png")



# TC =0.01 and V==600 ##


a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==600, S2[:,15])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==600, S2[:,15])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC = 0.015, V = 600")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc015v600.png")


# TC =0.01 and P==1 ##


a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==1, S2[:,16])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==1, S2[:,16])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC = 0.015, P = 10")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc015p1.png")



# TC =0.01 and P==10 ##


a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==10, S2[:,16])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==10, S2[:,16])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC = 0.015, P = 10")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc015p10.png")

# TC =0.01 and RG==.01 ##


a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==.01, S2[:,17])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==.01, S2[:,17])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC = 0.015, RG = .01")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc015rg01.png")




# TC =0.01 and RG==.05 ##


a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==.05, S2[:,17])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==.05, S2[:,17])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC = 0.015, RG = .05")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc015rg05.png")




# TC =0.01 and DEG==1,1 ##


a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==[1,1], S2[:,18])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==[1,1], S2[:,18])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC = 0.015, DG = 1,1")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc015dg11.png")



# TC =0.01 and DEG==10,10 ##


a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==[10,10], S2[:,18])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.015, S2[:,8])
q=findall(x->x==[10,10], S2[:,18])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC = 0.015, DG = 10,10")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc015dg1010.png")



################### Travel Cost ==0 ###############




# TC =0.01 and tech== 1.5 ##

a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==1.5, S2[:,5])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==1.5, S2[:,5])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC  = 0.0015, Tech = 1.5")

png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc0015tech1.png")


# TC =0.01 and tech== 0.15 ##


a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==0.15, S2[:,5])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==0.15, S2[:,5])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC  = 0.0015, Tech = 1.5")

png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc0015tech2.png")



# TC =0.01 and labor==.7 ##

a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==0.7, S2[:,6])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==0.7, S2[:,6])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)

plot(dat1["punish"], ylim=[0,1])
plot!(dat2["punish"])


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC  = 0.0015, Labor = 0.7")

png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc0015l07.png")





# TC =0.01 and labor==.35 ##

a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==0.35, S2[:,6])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==0.35, S2[:,6])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC  = 0.0015, Labor = 0..5")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc0015l035.png")


plot(dat1["punish"], ylim=[0,1])
plot!(dat2["punish"])



# TC =0.01 and Wages==0.015 ##


a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==0.015, S2[:,19])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==0.015, S2[:,19])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC  = 0.0015, W = .015")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc0015w015.png")



# TC =0.01 and Wages==0.15 ##


a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==0.15, S2[:,19])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==0.15, S2[:,19])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC  = 0.0015, W = .15")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc0015w15.png")





# TC =0.01 and PC==.015 ##

a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
c=findall(x->x==0.015, S2[:,8])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
c=findall(x->x==0.015, S2[:,8])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC  = 0.0015, PC = 0.015")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc0015pc015.png")



# TC =0.01 and PC==.0015 ##

a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
c=findall(x->x==0.0015, S2[:,8])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
c=findall(x->x==0.0015, S2[:,8])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC  = 0.0015, PC = 0.015")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc0015pc0015.png")




# TC =0.01 and MF==11250 ##

a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==11250.0, S2[:,9])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==11250.0, S2[:,9])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC  = 0.0015, MF = 11250")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc0015mf11250.png")


# TC =0.01 and MF==22500 ##

a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==22500.0, S2[:,9])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==22500.0, S2[:,9])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC  = 0.0015, MF = 11250")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc0015mf22250.png")




# TC =0.01 and DF==1 ##

a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==1, S2[:,14])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==1, S2[:,14])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC  = 0.0015, DF = 1")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc0015df1.png")




# TC =0.01 and DF==4 ##

a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==4, S2[:,14])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==4, S2[:,14])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC  = 0.0015, DF = 4")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc0015df4.png")




# TC =0.01 and v==60 ##

a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==60, S2[:,15])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==60, S2[:,15])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC  = 0.0015, V = 60")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc0015v60.png")



# TC =0.01 and V==600 ##


a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==600, S2[:,15])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==600, S2[:,15])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC  = 0.0015, V = 600")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc0015v600.png")


# TC =0.01 and P==1 ##


a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==1, S2[:,16])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==1, S2[:,16])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC  = 0.0015, P = 10")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc0015P1.png")



# TC =0.01 and P==10 ##


a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==10, S2[:,16])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==10, S2[:,16])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC  = 0.0015, P = 10")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc0015P10.png")

# TC =0.01 and RG==.01 ##


a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==.01, S2[:,17])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==.01, S2[:,17])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC  = 0.0015, RG = .01")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc0015RG01.png")




# TC =0.01 and RG==.05 ##


a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==.05, S2[:,17])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==.05, S2[:,17])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC  = 0.0015, RG = .05")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc0015RG05.png")




# TC =0.01 and DEG==1,1 ##


a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==[1,1], S2[:,18])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==[1,1], S2[:,18])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC  = 0.0015, DG = 1,1")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc0015dg11.png")



# TC =0.01 and DEG==10,10 ##


a=findall(x->x==0.9, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==[10,10], S2[:,18])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
c=findall(x->x==0.0015, S2[:,8])
q=findall(x->x==[10,10], S2[:,18])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["punish"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["punish"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Investment in Exclude | PC  = 0.0015, DG = 10,10")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish1\\pp120pc0015dg1010.png")
