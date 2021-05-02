try
           sqrt("ten")
       catch e
           println("You should have entered a numeric value")
       end


       a =1:1000
       b = 2.3
       w =rand(1000)
try
            wsample(a, b, w)
   catch
       return(a,b,w)
   end


   plot()                                       # empty Plot object
   plot(4)                                      # initialize with 4 empty series
   plot(rand(10))                               # 1 series... x = 1:10
   plot(rand(10,5))                             # 5 series... x = 1:10
   plot(rand(10), rand(10))                     # 1 series
   plot(rand(10,5), rand(10))                   # 5 series... y is the same for all
   plot(sin, rand(10))                          # y = sin.(x)
   plot(rand(10), sin)                          # same... y = sin.(x)
   plot([sin,cos], 0:0.1:π)                     # 2 series, sin.(x) and cos.(x)
   plot([sin,cos], 0, π)                        # sin and cos on the range [0, π]
   plot(1:10, Any[rand(10), sin])               # 2 series: rand(10) and map(sin,x)
   @df dataset("Ecdat", "Airline") plot(:Cost)  # the :Cost column from a DataFrame... must import StatsPlots


  plot!(title = "New Title", xlabel = "New xlabel", ylabel = "New ylabel")
plot!(xlims = (0, 5.5), ylims = (-2.2, 6), xticks = 0:0.5:10, yticks = [0,1,5,10])
plot!(xlims = (0, 5.5), ylims = (-2.2, 6), xticks = 0:0.5:10, yticks = [0,1,5,10])
gui()





function foo(x)
    for i in 1:100
        x*5
        if x*5 == 100 break end
    end
    finally
        return(x)
    end
end


p = rand(1:1000, 1000)
w = rand(1000).-.9
n = 100

wsample(p, w, n)


include("cpr_setup.jl")



n = 1000
ngroups = 20
id = collect(1:n)
gid = rand(1:ngroups, n)
experiment_group = [2,3]
age = rand(20:85, n)
age = ones(n)
payoff = zeros(n)
mortality_rate = .03
effort=rand(n)
harv_limit =rand(n)
punish_type = rand(0:1, n)
punish_type2 = rand(0:1, n)
leakage_type = rand(0:1, n)
pop = id[gid .∈  [experiment_group]]




function makebabies(popu, ids, ages, mort, pay)
        sample_payoff = ifelse.(payoff .!=0, payoff, 0.000001)
        if asInt.(unique(age[pop]))[1]==1
            ma = mean(age[pop])
            length(age[pop])
            age[pop] .=age[pop].+rand(0:1, length(age[pop]))
        end
        mortality_risk = softmax(standardize(age[pop].^5) .- standardize(sample_payoff[pop].^.25))
        to_die = asInt(round(mortality_rate*n *((ngroups-1)/ngroups), digits =0))
        died = wsample(id[pop], mortality_risk, to_die)
        pos_parents = id[(id .∈ Ref(pop)) .== (id .∉ Ref(died))]
        pos_payoff = convert.(Float64, vec(sample_payoff[pos_parents]))
        #return(pos_parents, pos_payoff, length(died))
        babies =wsample(pos_parents, pos_payoff, length(died), replace = true)
        return(babies)
    end


function mutatebabies(babies, mutate)
        trans_error = rand(length(babies), 5) .< mutate
        n_error = [[rand(Normal(), length(babies))] [rand(Normal(1, .02), length(babies))]]
        effort[babies] = ifelse.(trans_error[:,1], inv_logit.(logit.(effort[babies]) .+ n_error[1]), effort[babies])
        leakage_type[babies]  =ifelse.(trans_error[:,2], ifelse.(leakage_type[babies].==1,0,1), leakage_type[babies])
        punish_type[babies]  =ifelse.(trans_error[:,3], ifelse.(punish_type[babies].==1,0,1), punish_type[babies])
        harv_limit[babies] = ifelse.(trans_error[:,4], abs.(harv_limit[babies] .* n_error[2]), harv_limit[babies])
        punish_type2[babies]  =ifelse.(trans_error[:,5], ifelse.(punish_type2[babies].==1,0,1), punish_type2[babies])
end


mutatebabies(babies, mutate)



function benchmark(x)
    print(Dates.Time(Dates.now()))
    x
    print(Dates.Time(Dates.now()))

end

for i in 1:100
    cpr_abm(pollution = true, pol_C = 1000, nrounds = 100, seed = (1987+i), verbose = false, experiment_punish1 =.9, experiment_group =[2,3] )
end
num



function foo(x)
    function foo2(x) x^2 end
    a=x*10
    foo2(a)
end


    foo(10)


    function killagents(pop, id, age, mortality_rate, payoff)
        if  length(unique(age[pop])) == 1
            length(age[pop])
            age[pop] .=age[pop].+rand(0:1, length(age[pop]))
        end
        mortality_risk = softmax(standardize(age[pop].^5) .- standardize(payoff[pop].^.25))
        to_die = asInt(round(mortality_rate*length(pop), digits =0))
        dead=wsample(pop, sample_payoff[pop], length(died), replace = true)
    end

    function makebabies(pop, id, sample_payoff, died)
        sample_payoff[died] .=0
        sample_payoff[(id) .∉ (pop)] .=0
        babies=wsample(id, sample_payoff, length(died), replace = true)
        return(babies)
    end


    #
sample_payoff[(id) ∉ (pop)]


test5 = g(9000, 60, [6,10], S2[i,4], S2[i,5], S2[i,6], S2[i,7], S2[i,8],
 S2[i,9], S2[i,10], S2[i,11], S2[i,12], S2[i,13], S2[i,14], 100000)



 ## DO NOT CHANGE
##################################################################################################################################
############# We plot the equilibrium with one set of resource dynamics with A CE and DE and then change one resource dynamic #####

using(Random)
using(Distributions)
using(Plots)
using(Dates)

cd("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm")
include("cpr_setup.jl")
include("abm_red.jl")

r1i1 = cpr_abm(nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
    max_forest = 20000, ecosys = true, eco_C=.01, harvest_limit = .1,
    pollution = true, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false)



r1i0 = cpr_abm(nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
       max_forest = 20000, ecosys = true, eco_C=.01, harvest_limit = .1,
       pollution = true, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false, inst = false)



########################################################################################
################# INCREASE ECOSYSTEM SERVICES ##########################################
r2i1 = cpr_abm(nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
   max_forest = 20000, ecosys = true, eco_C=.05, harvest_limit = .1,
   pollution = true, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false)

r2i0 = cpr_abm(nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
      max_forest = 20000, ecosys = true, eco_C=.05, harvest_limit = .1,
      pollution = true, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false, inst = false)




########################################################################################
################# DECREASE REGROW  ##########################################
r3i1 = cpr_abm(nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
               max_forest = 20000, ecosys = true, eco_C=.01, harvest_limit = .1,
               pollution = true, pol_C = 0.1,  punish_cost = .001, regrow = 0.03, verbose = false)

r3i0 = cpr_abm(nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
      max_forest = 20000, ecosys = true, eco_C=.01, harvest_limit = .1,
      pollution = true, pol_C = 0.1,  punish_cost = .001, regrow = 0.03, verbose = false, inst = false)




########################################################################################
################# Increase degradeability  ##########################################
r4i1 = cpr_abm(nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
             max_forest = 20000, ecosys = true, eco_C=.01, harvest_limit = .1,
             pollution = true, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false,  degradability = .5)

r4i0 = cpr_abm(nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
    max_forest = 20000, ecosys = true, eco_C=.01, harvest_limit = .1,
    pollution = true, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false, inst = false, degradability = .5)




########################################################################################
################# Increase Volatility ##########################################
r5i1 = cpr_abm(nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
             max_forest = 20000, ecosys = true, eco_C=.01, harvest_limit = .1,
             pollution = true, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false,  volatility = .1)

r5i0 = cpr_abm(nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
    max_forest = 20000, ecosys = true, eco_C=.01, harvest_limit = .1,
    pollution = true, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false, inst = false, volatility = .1)


########################################################################################
################# Increase Patchiness ##########################################
r6i1 = cpr_abm(nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
             max_forest = 20000, ecosys = true, eco_C=.01, harvest_limit = .1,
             pollution = true, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false,  var_forest = 3000)

r6i0 = cpr_abm(nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
    max_forest = 20000, ecosys = true, eco_C=.01, harvest_limit = .1,
    pollution = true, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false, inst = false,  var_forest = 3000)



########################################################################################
################# Increase Pollution ##########################################
r7i1 = cpr_abm(nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
             max_forest = 20000, ecosys = true, eco_C=.01, harvest_limit = .1,
             pollution = true, pol_C = 0.5,  punish_cost = .001, regrow = 0.05, verbose = false,  var_forest = 1)

r7i0 = cpr_abm(nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
    max_forest = 20000, ecosys = true, eco_C=.01, harvest_limit = .1,
    pollution = true, pol_C = 0.5,  punish_cost = .001, regrow = 0.05, verbose = false, inst = false,  var_forest = 1)




########################################################################################
################# Increase Defensibility ##########################################
r8i1 = cpr_abm(nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
             max_forest = 20000, ecosys = true, eco_C=.01, harvest_limit = .1,
             pollution = true, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false,  defensibility = .51)

r8i0 = cpr_abm(nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
    max_forest = 20000, ecosys = true, eco_C=.01, harvest_limit = .1,
    pollution = true, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = false, inst = false,  defensibility = .51)





plot(mean(r1i0["harvest"][:,:,1], dims = 2) - mean(r1i1["harvest"][:,:,1], dims = 2))
plot!(mean(r2i0["harvest"][:,:,1], dims = 2) - mean(r2i1["harvest"][:,:,1], dims = 2))
plot!(mean(r3i0["harvest"][:,:,1], dims = 2) - mean(r3i1["harvest"][:,:,1], dims = 2))
plot!(mean(r4i0["harvest"][:,:,1], dims = 2) - mean(r4i1["harvest"][:,:,1], dims = 2))
plot!(mean(r5i0["harvest"][:,:,1], dims = 2) - mean(r5i1["harvest"][:,:,1], dims = 2))
plot!(mean(r6i0["harvest"][:,:,1], dims = 2) - mean(r6i1["harvest"][:,:,1], dims = 2))
plot!(mean(r7i0["harvest"][:,:,1], dims = 2) - mean(r7i1["harvest"][:,:,1], dims = 2))
plot!(mean(r8i0["harvest"][:,:,1], dims = 2) - mean(r8i1["harvest"][:,:,1], dims = 2))



plot(mean(r1i0["payoffR"][:,:,1], dims = 2) - mean(r1i1["payoffR"][:,:,1], dims = 2))
plot!(mean(r2i0["payoffR"][:,:,1], dims = 2) - mean(r2i1["payoffR"][:,:,1], dims = 2))
plot!(mean(r3i0["payoffR"][:,:,1], dims = 2) - mean(r3i1["payoffR"][:,:,1], dims = 2))
plot!(mean(r4i0["payoffR"][:,:,1], dims = 2) - mean(r4i1["payoffR"][:,:,1], dims = 2))
plot!(mean(r5i0["payoffR"][:,:,1], dims = 2) - mean(r5i1["payoffR"][:,:,1], dims = 2))
plot!(mean(r6i0["payoffR"][:,:,1], dims = 2) - mean(r6i1["payoffR"][:,:,1], dims = 2))
plot!(mean(r7i0["payoffR"][:,:,1], dims = 2) - mean(r7i1["payoffR"][:,:,1], dims = 2))
plot!(mean(r8i0["payoffR"][:,:,1], dims = 2) - mean(r8i1["payoffR"][:,:,1], dims = 2))


x = 1:10; y = rand(10, 2) # 2 columns means two lines
plotly() # Set the backend to Plotly
# This plots into the web browser via Plotly
plot(x, y, title = "This is Plotted using Plotly")

gr() # We will continue onward using the GR backend
plot(x, y, seriestype = :scatter, title = "My Scatter Plot")


# Plotting in Scripts
display(plot(x, y))



######################################
########## ANIMATE TIME SERISE #######

function animtime(x...)
    n = length(x[1])
    k = length(x)

    #Construct data
    y = zeros(n,k)
    for j in 1:k y[:,j]=x[j]end
    #make animation
    df = 10# define this mystery term
    anim = @animate for i = 2:df:n
        #Define line settings
        lwd = range(0, 5, length = i)
        lalpha = range(0, 1, length = i)
        plot(y[1:i,:], ylim = (0, 1), xlim = (0, n), linewidth = lwd, seriesalpha = lalpha, lable = false)
    end
      gif(anim, "timeseriese.gif", fps = 50)
end

#########################################
########### F

using StatsBase
x1 = mean(r1i1["stock"][:,:,1], dims = 2)

x2 = mean(r1i1["limit"][:,:,1], dims = 2)
#normalize limit
dt = fit(UnitRangeTransform, x2, dims=1)
x2 =StatsBase.transform(dt, x2)

x3 = mean(r1i1["effort"][:,:,1], dims = 2)
x4 = mean(r1i1["punish2"][:,:,1], dims = 2)

animtime(x1,x2,x3, x5)


include("abm_cont.jl")

r1i1 = cpr_abm(nrounds = 2000, n=3600, ngroups = 24, lattice = [6,4],
    max_forest = 20000, ecosys = true, eco_C=.01, harvest_limit = .1,
    pollution = true, pol_C = 0.1,  punish_cost = .001, regrow = 0.05, verbose = true)

#Generate plots for WIP



x2 = mean(r1i1["limit"][:,:,1], dims = 2)
dt = fit(UnitRangeTransform, x2, dims=1) #normalize limit
x2 =StatsBase.transform(dt, x2) #normalize limit
x3 = mean(r1i1["effort"][:,:,1], dims = 2)
x4 = mean(r1i1["punish2"][:,:,1], dims = 2)
x4 = mean(r1i1["punish2"][:,:,1], dims = 2)
animtime(x1,x2,x3, x4)



l = mean(r1i1["limit"][:,:,1], dims = 2)
dt = fit(UnitRangeTransform, l, dims=1) #normalize limit
l =StatsBase.transform(dt, l) #normalize limit
e = mean(r1i1["effort"][:,:,1], dims = 2)
p2 = mean(r1i1["punish2"][:,:,1], dims = 2)
h = mean(r1i1["harvest"][:,:,1], dims = 2)
dt = fit(UnitRangeTransform, h, dims=1) #normalize harvest
h =StatsBase.transform(dt, h) #normalize harvest
s = mean(r1i1["stock"][:,:,1], dims = 2)
roi = h./e
dt = fit(UnitRangeTransform, roi, dims=1) #normalize harvest
roi =StatsBase.transform(dt, roi) #normalize harvest


animtime(1000,20, 2, h,e)
animtime(1000, 20, 5, roi,s)



using(JLD2)
@JLD2.load("C:\\Users\\jeffr\\Documents\\Work\\cpr\\data\\abm\\abm_dat_envWS2.jld2")


#Collect targets
cond=findall(x->x==1, S2[:,7])
data = abm_dat[cond]
function collate(x)
    dat=x

    #set up parameters
    comb=length(dat)
    iter = length(dat[1]["effort"][1,1,:])
    rnds = length(dat[1]["effort"][:,1,1])
    temp1 = zeros(comb,11,rnds, iter)
    temp2 = zeros(comb, 11, rnds)

    for j in 1:comb
        for i in 1:iter
            temp1[j,1,:,i]=median(dat[j]["limit"][:,:,i], dims = 2)
            temp1[j,2,:,i]=mean(dat[j]["effort"][:,:,i], dims = 2)
            temp1[j,3,:,i]=mean(dat[j]["harvest"][:,:,i], dims = 2)./150
            temp1[j,4,:,i]=median(dat[j]["limit"][:,:,i].-dat[j]["harvest"][:,:,i]./150, dims = 2)
            temp1[j,5,:,i]=mean(dat[j]["punish"][:,:,i], dims = 2)
            temp1[j,6,:,i]=mean(dat[j]["stock"][:,:,i], dims = 2)
            temp1[j,7,:,i]=mean(dat[j]["leakage"][:,:,i], dims = 2)
            temp1[j,8,:,i]=mean(dat[j]["punish2"][:,:,i], dims = 2)
            temp1[j,9,:,i]=mean(dat[j]["seized"][:,:,i], dims = 2)
            temp1[j,10,:,i]=mean(dat[j]["seized2"][:,:,i], dims = 2)
            temp1[j,11,:,i]=mean(dat[j]["payoffR"][:,:,i], dims = 2)

        end
        d = zeros(rnds,11)
        for k in 1:11
            for i in 1:length(dat[1]["effort"][:,1,1])
                temp2[j,k,i]=nanmedian(temp1[j,k,i,:])
            end
        end


        for i = 1:11
            d[:,i] =  mean(temp2[:,i,:]', dims =2)
        end
    end
        limit = normalize(d[:,1])
        effort =d[:,2]
        harvest = normalize(d[:,3])
        differ = d[:,4]
        punish = d[:,5]
        stock = d[:,6]
        leak = d[:,7]
        punish2 = d[:,8]
        seized = d[:,9]
        seized2 =d[:,10]
        payoffR = d[:,11]

        output=Dict("effort" => effort,
        "limit" => limit,
        "stock" => stock,
        "harvest" => harvest,
        "differ" => punish,
        "punish" => effort,
        "leak" => leak,
        "punish2" => punish2,
        "seized" => seized,
        "seized2" => seized2,
        "payoffR" => payoffR,)

        return (output)
end



#Degradeability
cond=findall(x->x==1, S2[:,6])
temp = abm_dat[cond]
w1=collate(temp)

cond=findall(x->x==0, S2[:,6])
data = abm_dat[cond]
w2 = collate(data)



animtime(2000,40, 10, w1["stock"], w1["harvest"])
animtime(2000,40, 10, w2["stock"], w2["harvest"])


roi1 = w1["harvest"]./w1["effort"]
roi1 = normalize(roi1)
roi2 = w2["harvest"]./w2["effort"]
roi2 = normalize(roi2)

animtime(2000, 40, 10, w1["effort"], w1["stock"])
animtime(2000, 40, 10, w2["effort"], w2["stock"])

animtime(2000, 40, 10, w1["effort"], roi1)
animtime(2000, 40, 10, w2["effort"], roi2)

animtime(2000, 40, 10, w1["harvest"], roi1)
animtime(2000, 40, 10, w2["harvest"], roi2)


roi2-roi1


animtime(2000, 40, 1)

animtime(2000,40, 10, stock, harvest)
animtime(2000, 40, 10, roi,stock)
animtime(2000, 40, 10, roi,stock)
