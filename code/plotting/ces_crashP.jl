

############################################################
########## LIMITS AFTER COLLAPSE ###########################




v=findall(x->x==.15, S1[:,5])
x=findall(x->x==1, S1[:,16])
a=a[a.∈ Ref(q)]
a=a[a.∈ Ref(w)]
a=a[a.∈ Ref(v)]
a=a[a.∈ Ref(x)]

b=b[b.∈ Ref(q)]
b=b[b.∈ Ref(w)]
b=b[b.∈ Ref(v)]
b=b[b.∈ Ref(x)]



b=collect(127:256)

a=collect(1:32)

w=findall(x->x==.05, S[:,4])
a=a[a.∈ Ref(w)]

q=findall(x->x==2000, S[:,5])
a=a[a.∈ Ref(q)]

v=findall(x->x==[5,2], S[:,6])
a=a[a.∈ Ref(v)]


x=findall(x->x==.5, S[:,7])
a=a[a.∈ Ref(x)]

h=findall(x->x==.00, S[:,18])
a=a[a.∈ Ref(h)]

j=findall(x->x==true, S[:,17])
a=a[a.∈ Ref(j)]

i=findall(x->x==true, S[:,16])
a=a[a.∈ Ref(i)]


dat1=collate(abm_dat)
plot(dat1["stock"])
plot(dat1["payoffR"])
plot(dat1["harvest",]./dat1["effort"], ylim = [0,1])
plot(dat1["limit"],ylim = [0,.3])
plot(dat1["effort"],ylim = [0,1])
plot!(dat1["harvest",], ylim = [0,.4])
plot!(dat1["punish2"],ylim = [0,1])
plot(dat1["punish"],ylim = [0,1])
plot!(dat1["leak"],ylim = [0,1])



temp = zeros(3000, 20)
for sim in 1:20
     temp[:,sim] = mean(cpr_abm["effort"][:,:,sim], dims =2)
 end
E=zeros(3000)
E = mean(temp, dims =2)


for sim in 1:20
     temp[:,sim] = mean(cpr_abm["harvest"][:,:,sim]./150, dims =2)
 end
H=zeros(3000)
H = mean(temp, dims =2)


for sim in 1:20
     temp[:,sim] = mean(cpr_abm["limit"][:,:,sim], dims =2)
 end
L=zeros(3000)
L = mean(temp, dims =2)



animtime(200, 20, 2, [B1 A1 C1 H1 ], [0, 1],S ,H, E, L)
