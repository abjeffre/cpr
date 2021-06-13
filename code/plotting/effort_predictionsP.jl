####################################################################
############### Leakage paper prediction plots #####################
using(JLD2)
using(Distributions)
@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\abm_dat_small_lkS.jld2")


a=findall(x->x==0.9, S[:,10])



b=findall(x->x==0.001, S[:,10])



dat1=collate(abm_dat[a], 2)
dat2=collate(abm_dat[b],2)

plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort")

png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\predleakmean2.png")

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

plot(dat1["effort"], ylim=[0,1])
plot!(dat2["effort"])


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort")

png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\predleakmean20.png")


##############################################################################
################## TECH#######################################################

#Tech  = 0.15
a=findall(x->x==0.9, S2[:,10])
b=findall(x->x==0.9, S2[:,10])


q=findall(x->x==1.5, S2[:,5])
a=a[a.∈ Ref(q)]
b=b[b.∈ Ref(q)]

dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b], gs)

plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 0.15")

png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\predeffortmean20t15.png")



#TC = .01
a=findall(x->x==0.9, S2[:,10])
b=findall(x->x==0.9, S2[:,10])
q=findall(x->x==.15, S2[:,5])
b=b[b.∈ Ref(q)]
a=a[a.∈ Ref(q)]

dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b], gs)

plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 1.5")

png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\predeffortmean20t015.png")




############################################################
############## TECH LARGE INTERACTIONS #####################
############################################################

# PC =0.015 and tech== 1.5 ##

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==0.015, S2[:,8])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==0.015, S2[:,8])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 1.5, Tech = 1.5")

png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t15pc015.png")


# TC =0.01 and tech== 0.15 ##


a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==.0015, S2[:,8])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==0.0015, S2[:,8])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 1.5, Tech = 1.5")

png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t15pc0015.png")



# TC =0.01 and labor==.7 ##

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==0.7, S2[:,6])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==0.7, S2[:,6])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)

plot(dat1["effort"], ylim=[0,1])
plot!(dat2["effort"])


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 1.5, Labor = 0.7")

png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t15l07.png")





# TC =0.01 and labor==.35 ##

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==0.35, S2[:,6])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==0.35, S2[:,6])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 1.5, Labor = 0..5")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t15l035.png")


plot(dat1["effort"], ylim=[0,1])
plot!(dat2["effort"])



# TC =0.01 and Wages==0.015 ##


a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==0.015, S2[:,19])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==0.015, S2[:,19])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 1.5, W = .015")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t15w015.png")



# TC =0.01 and Wages==0.15 ##


a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==0.15, S2[:,19])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==0.15, S2[:,19])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 1.5, W = .15")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t15w15.png")





# TC =1.5 and PC==.01 ##

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==0.01, S2[:,8])
c=findall(x->x==1.5, S2[:,5])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==0.01, S2[:,8])
c=findall(x->x==1.5, S2[:,5])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 1.5, Tech  = 1.5")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t15tc015.png")



# TC =1.5 and TC==.001 ##

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==0.0, S2[:,8])
c=findall(x->x==.15, S2[:,5])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==0.0, S2[:,8])
c=findall(x->x==.15, S2[:,5])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 1.5, Tech  = 1.5")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t15tc0.png")




# TC =0.01 and MF==11250 ##

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==11250.0, S2[:,9])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==11250.0, S2[:,9])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 1.5, MF = 11250")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t15mf11250.png")


# TC =0.01 and MF==22500 ##

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==22500.0, S2[:,9])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==22500.0, S2[:,9])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 1.5, MF = 11250")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t15mf22250.png")




# TC =0.01 and DF==1 ##

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==1, S2[:,14])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==1, S2[:,14])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 1.5, DF = 1")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t15df1.png")




# TC =0.01 and DF==4 ##

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==4, S2[:,14])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==4, S2[:,14])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 1.5, DF = 4")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t15df4.png")




# TC =0.01 and v==60 ##

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==60, S2[:,15])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==60, S2[:,15])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 1.5, V = 60")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t15v60.png")



# TC =0.01 and V==600 ##


a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==600, S2[:,15])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==600, S2[:,15])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 1.5, V = 600")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t15v600.png")


# TC =0.01 and P==1 ##


a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==1, S2[:,16])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==1, S2[:,16])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 1.5, P = 10")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t15p1.png")



# TC =0.01 and P==10 ##


a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==10, S2[:,16])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==10, S2[:,16])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 1.5, P = 10")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t15p10.png")

# TC =0.01 and RG==.01 ##


a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==.01, S2[:,17])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==.01, S2[:,17])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 1.5, RG = .01")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t15rg01.png")




# TC =0.01 and RG==.05 ##


a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==.05, S2[:,17])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==.05, S2[:,17])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 1.5, RG = .05")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t15rg05.png")




# TC =0.01 and DEG==1,1 ##


a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==[1,1], S2[:,18])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==[1,1], S2[:,18])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 1.5, DG = 1,1")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t15dg11.png")



# TC =0.01 and DEG==10,10 ##


a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==[10,10], S2[:,18])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==[10,10], S2[:,18])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 1.5, DG = 10,10")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t15dg1010.png")



################### TECH 0.15 ###############




# PC =0.01 and tech== 0.15 ##

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==.015, S2[:,8])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==0.015, S2[:,8])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 0.15, PC = 015")

png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t015pc015.png")


# TC =0.01 and tech== 0.15 ##


a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==0.0015, S2[:,8])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==0.0015, S2[:,8])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 0.15, Tech = 1.5")

png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t015pc0015.png")



# TC =0.01 and labor==.7 ##

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==0.7, S2[:,6])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==0.7, S2[:,6])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)

plot(dat1["effort"], ylim=[0,1])
plot!(dat2["effort"])


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 0.15, Labor = 0.7")

png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t015l07.png")





# TC =0.01 and labor==.35 ##

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==0.35, S2[:,6])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==0.35, S2[:,6])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 0.15, Labor = 0..5")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t015l035.png")


plot(dat1["effort"], ylim=[0,1])
plot!(dat2["effort"])



# TC =0.01 and Wages==0.015 ##


a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==0.015, S2[:,19])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==0.015, S2[:,19])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 0.15, W = .015")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t015w015.png")



# TC =0.01 and Wages==0.15 ##


a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==0.15, S2[:,19])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==0.15, S2[:,19])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 0.15, W = .15")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t015w15.png")





# TC =0.01 and PC==.015 ##

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==0.01, S2[:,5])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==0.01, S2[:,5])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 0.15, Tech  = 1.5")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t015l01.png")



# TC =0.01 and PC==.0015 ##

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==0, S2[:,5])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==0, S2[:,5])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 0.15, Tech  = 1.5")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t015l0.png")




# TC =0.01 and MF==11250 ##

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==.15, S2[:,5])
q=findall(x->x==11250.0, S2[:,9])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==.15, S2[:,5])
q=findall(x->x==11250.0, S2[:,9])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 0.15, MF = 11250")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t015mf11250.png")


# TC =0.01 and MF==22500 ##

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==22500.0, S2[:,9])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==22500.0, S2[:,9])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 0.15, MF = 11250")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t015mf22250.png")




# TC =0.01 and DF==1 ##

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==1, S2[:,14])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==1, S2[:,14])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 0.15, DF = 1")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t015df1.png")




# TC =0.01 and DF==4 ##

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==4, S2[:,14])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==.15, S2[:,5])
q=findall(x->x==4, S2[:,14])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 0.15, DF = 4")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t015df4.png")




# TC =0.01 and v==60 ##

a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==60, S2[:,15])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==60, S2[:,15])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 0.15, V = 60")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t015v60.png")



# TC =0.01 and V==600 ##


a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==600, S2[:,15])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==600, S2[:,15])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 0.15, V = 600")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t015v600.png")


# TC =0.01 and P==1 ##


a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==1, S2[:,16])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==1, S2[:,16])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 0.15, P = 10")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t015P1.png")



# TC =0.01 and P==10 ##


a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==10, S2[:,16])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==10, S2[:,16])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 0.15, P = 10")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t015P10.png")

# TC =0.01 and RG==.01 ##


a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==.01, S2[:,17])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==.01, S2[:,17])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 0.15, RG = .01")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t015RG01.png")




# TC =0.01 and RG==.05 ##


a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==.05, S2[:,17])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==.05, S2[:,17])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 0.15, RG = .05")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t015RG05.png")




# TC =0.01 and DEG==1,1 ##


a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==[1,1], S2[:,18])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==[1,1], S2[:,18])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 0.15, DG = 1,1")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t015dg11.png")



# TC =0.01 and DEG==10,10 ##


a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==[10,10], S2[:,18])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]


b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==.15, S2[:,5])
c=findall(x->x==[10,10], S2[:,18])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
plot!(dat2["effort"], label ="Low Leakage", color = "turquoise")
xlabel!("Time")
ylabel!("Effort | Tech  = 0.15, DG = 10,10")


png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\effort\\e20t015dg1010.png")


















a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==.7, S2[:,6])
d =findall(x->x==.15, S2[:,19])
e =findall(x->x==1, S2[:,16])
f =findall(x->x==600, S2[:,15])
h=findall(x->x==0.01, S2[:,4])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]
a=a[a.∈ Ref(d)]
a=a[a.∈ Ref(e)]
a=a[a.∈ Ref(f)]
a=a[a.∈ Ref(h)]



b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]
b=b[b.∈ Ref(d)]
b=b[b.∈ Ref(e)]
b=b[b.∈ Ref(f)]
b=b[b.∈ Ref(h)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"]-dat2["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
xlabel!("Time")



###########################################################
############# TESTING #####################################


a=findall(x->x==0.9, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
c=findall(x->x==.7, S2[:,6])
d =findall(x->x==.15, S2[:,19])
e =findall(x->x==1, S2[:,16])
f =findall(x->x==600, S2[:,15])
h=findall(x->x==0.01, S2[:,4])
i =findall(x->x==1, S2[:,14])
a=a[a.∈ Ref(c)]
a=a[a.∈ Ref(q)]
a=a[a.∈ Ref(d)]
a=a[a.∈ Ref(e)]
a=a[a.∈ Ref(f)]
a=a[a.∈ Ref(h)]
a=a[a.∈ Ref(i)]



b=findall(x->x==0.001, S2[:,10])
q=findall(x->x==1.5, S2[:,5])
b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(c)]
b=b[b.∈ Ref(d)]
b=b[b.∈ Ref(e)]
b=b[b.∈ Ref(f)]
b=b[b.∈ Ref(h)]
b=b[b.∈ Ref(i)]


dat1=collate(abm_dat[a],  gs)
dat2=collate(abm_dat[b],  gs)


plot(dat1["effort"]-dat2["effort"], ylim = [0,1],
label ="High leakage", color = "goldenrod" )
xlabel!("Time")



####################################################################
################# HEATMAPS #########################################

S =expand_grid( [300],           #Population Size
                [2],             #ngroups
                [[1, 2]],        #lattice, will be replaced below
                [0],             #travel cost
                [1],             #tech
                [.1,.5,.9],     #labor
                [0.1],           #limit seed values
                [.0015],         #Punish Cost
                [5000],          #max forest
                [0.001,.9],      #experiment leakage
                [0.5],           #experiment punish
                [1],             #experiment_group
                [1],             #groups_sampled
                [1],             #Defensibility
                [100],           #var forest
                collect( range(1, stop = 100, length = 20) ),          #price
                [.025],        #regrowth
                [[1, 1]], #degrade
                collect( range(0.001, stop = 1, length = 20) )       #wages
                )


#set up a smaller call function that allows for only a sub-set of pars to be manipulated
@everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg)
    cpr_abm(nrounds = 500,
            nsim = 6,
            fine_start = nothing,
            leak = true,
            pun1_on = true,
            pun2_on = true,
            n = n,
            ngroups = ng,
            lattice = l,
            travel_cost = tc,
            tech = te,
            labor = la,
            harvest_limit = ls,
            punish_cost = pc,
            max_forest = mf,
            experiment_leak = el,
            experiment_punish1 = ep,
            experiment_punish2 = ep,
            experiment_group = eg,
            groups_sampled =gs,
            defensibility = df,
            var_forest = vf,
            price = pr,
            regrow = rg,
            degrade=dg,
            wages = wg

            )
end



abm_dat = pmap(g, S[:,1], S[:,2], S[:,3], S[:,4], S[:,5], S[:,6], S[:,7],
 S[:,8], S[:,9], S[:,10] , S[:,11], S[:,12] , S[:,13],  S[:,14], S[:,15],
 S[:,16], S[:,17], S[:,18], S[:,19])

@JLD2.save("abm_dat_effort_hm_l.jld2", abm_dat, S1)

#####################################################
###########LOW LABOR ################################



@JLD2.load("C:\\Users\\jeffr\\Documents\\work\\cpr\\data\\abm\\abm_dat_effort_hm_none.jld2")



l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.1, S[:,6])
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]



low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["effort"][:,2,:], dims =2) - mean(low[i]["effort"][:,2,:], dims = 2))
    end

#price is on the y axis and wage is on the x

using Plots
gr()
heatmap(1:size(m,1),
    1:size(m,2), m,
    c=:thermal,
    xlabel="Wages", ylabel="Price",
    title="Elasticity of Labor = 0.1")


#####################################################
###########Mid LABOR ################################

l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.5, S[:,6])
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]



low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["effort"][:,2,:], dims =2) - mean(low[i]["effort"][:,2,:], dims = 2))
    end

#price is on the y axis and wage is on the x

using Plots
gr()
heatmap(1:size(m,1),
    1:size(m,2), m,
    c=:thermal,
    xlabel="Wages", ylabel="Price",
    title="Elasticity of Labor = 0.5")




#####################################################
###########High LABOR ################################

l=findall(x->x==0.001, S[:,10])
h=findall(x->x==0.9, S[:,10])
#Choose Labor Elasticity
q=findall(x->x==.9, S[:,6])
l=l[l.∈ Ref(q)]
h=h[h.∈ Ref(q)]



low = abm_dat[l]
high =abm_dat[h]
m = zeros(20,20)
for i = 1:length(high)
    m[i]  = mean(mean(high[i]["effort"][:,2,:], dims =2) - mean(low[i]["effort"][:,2,:], dims = 2))
    end



#price is on the y axis and wage is on the x

using Plots
gr()
heatmap(1:size(m,1),
    1:size(m,2), m,
    c=:thermal,
    xlabel="Wages", ylabel="Price",
    title="Elasticity of Labor = 0.9")
