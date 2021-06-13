  using Distributed
  @everywhere using(Distributions)
  @everywhere using(DataFrames)
  @everywhere using(JLD2)
  @everywhere using(Random)
  @everywhere using(Dates)

  @everywhere cd("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm")
  @everywhere include("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\setup_utilies.jl")
  @everywhere include("C:\\Users\\jeffr\\Documents\\work\\cpr\\code\\abm\\abm_fine.jl")



  S =expand_grid( [300],           #Population Size
                  [2],             #ngroups
                  [[1, 2]],        #lattice, will be replaced below
                  [0.0001],        #travel cost
                  [1],             #tech
                  [.1,.5,.9],      #labor
                  [0.1],           #limit seed values
                  [.0015],         #Punish Cost
                  [15000],         #max forest
                  [0.001,.9],      #experiment leakage
                  [0.5],           #experiment punish
                  [1],             #experiment_group
                  [1],             #groups_sampled
                  [1],          #Defensibility
                  [1],             #var forest
                  10 .^(collect(range(-2, stop = 1, length = 10))),          #price
                  [.025],        #regrowth
                  [[1, 1]], #degrade
                  10 .^(collect(range(-4, stop = 0, length = 10)))       #wages
                  )

  #set up a smaller call function that allows for only a sub-set of pars to be manipulated
  @everywhere function g(n, ng, l, tc, te, la, ls, pc, mf, el, ep, eg, gs, df, vf, pr, rg, dg, wg)
      cpr_abm(nrounds = 500,
              nsim = 1,
              fine_start = nothing,
              leak = false,
              experiment_effort = 1,
              pun1_on = false,
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

  @JLD2.save("test", abm_dat, S)

 @JLD2.load("test")

using Plots.PlotMeasures

p_arr = Plots.Plot{Plots.GRBackend}[]
resize!(p_arr, 3)

elast=[.1, .5, .9]
for j in 1:length(elast)


        yt = [["Low", "High"], ["", ""], ["", ""]]

        l=findall(x->x==0.001, S[:,10])
        h=findall(x->x==0.9, S[:,10])
        #Choose Labor Elasticity
        q=findall(x->x==elast[j], S[:,6])
        v=findall(x->x==1, S[:,14])
        l=l[l.∈ Ref(q)]
        l=l[l.∈ Ref(v)]
        h=h[h.∈ Ref(q)]
        h=h[h.∈ Ref(v)]
        low = abm_dat[l]
        high =abm_dat[h]
        m = zeros(20,20)

        for i = 1:length(high)
            m[i]  = nanmean(mean(low[i]["cel"][:,2,:], dims =2))[1]# - mean(low[i]["effort"][:,2,:], dims = 2))
            end
        using Plots
        gr()
         p_arr[j]=p1=heatmap(m,
            c=:temperaturemap, clim= (-1, 1), xlab = " ", ylab= " ",
             yguidefontsize=9,  xguidefontsize=9, legend = false,
               xticks = ([2,19],[" "," "]), yticks = ([2,19],yt[j])
            )
        title!(string("Labor = ", elast[j]), titlefontsize = 9)
        if j == 1 ylabel!("Price",  yguidefontsize=9) end
end
ps = [p_arr[1] p_arr[2] p_arr[3]]


l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)

eff = plot(ps..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=:temperaturemap, yticks=(1:10:101,
string.(-1:0.2:1)), title ="\\Delta Cor[E, L]", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly

plot(eff, size = (1000, 400), left_margin = 20px, bottom_margin = 20px)


p_arr = Plots.Plot{Plots.GRBackend}[]
resize!(p_arr, 3)
##########################

elast=[.1, .5, .9]
for j in 1:length(elast)


        yt = [["Low", "High"], ["", ""], ["", ""]]

        l=findall(x->x==0.001, S[:,10])
        h=findall(x->x==0.9, S[:,10])
        #Choose Labor Elasticity
        q=findall(x->x==elast[j], S[:,6])
        v=findall(x->x==1, S[:,14])
        l=l[l.∈ Ref(q)]
        l=l[l.∈ Ref(v)]
        h=h[h.∈ Ref(q)]
        h=h[h.∈ Ref(v)]
        low = abm_dat[l]
        high =abm_dat[h]
        m = zeros(20,20)

        for i = 1:length(high)
            m[i]  = nanmean(mean(low[i]["clp2"][:,2,:], dims =2))[1]# - mean(low[i]["effort"][:,2,:], dims = 2))
            end
        using Plots
        gr()
         p_arr[j]=p1=heatmap(m,
            c=:diverging_cwm_80_100_c22_n256, clim= (-1, 1), xlab = "Wages", ylab= " ",
             yguidefontsize=9,  xguidefontsize=9, legend = false,
               xticks = ([2,19],["Low","High"]), yticks = ([2,19],yt[j])
            )
        title!(string(" "), titlefontsize = 9)
        if j == 1 ylabel!("Price",  yguidefontsize=9) end
end
ps = [p_arr[1] p_arr[2] p_arr[3]]


l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)

eff2 = plot(ps..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=:diverging_cwm_80_100_c22_n256, yticks=(1:10:101,
string.(-1:0.2:1)), title ="\\Delta Cor[R, L]", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly

plot(eff, eff2, size = (1000, 600), left_margin = 20px, bottom_margin = 20px, right_margin = 10px, layout = (2,1))

png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\punish_cov.png")




###################################################################
############## CORRELATION BETWEEN BELIEFS AND P2 #################




elast=[.1, .5, .9]
for j in 1:length(elast)


        yt = [["Low", "High"], ["", ""], ["", ""]]

        l=findall(x->x==0.001, S[:,10])
        h=findall(x->x==0.9, S[:,10])
        #Choose Labor Elasticity
        q=findall(x->x==elast[j], S[:,6])
        v=findall(x->x==1, S[:,14])
        l=l[l.∈ Ref(q)]
        l=l[l.∈ Ref(v)]
        h=h[h.∈ Ref(q)]
        h=h[h.∈ Ref(v)]
        low = abm_dat[l]
        high =abm_dat[h]
        m = zeros(20,20)

        for i = 1:length(high)
            m[i]  = nanmean(mean(high[i]["clp2"][:,2,:], dims =2)-mean(low[i]["clp2"][:,2,:], dims =2))[1]# - mean(low[i]["effort"][:,2,:], dims = 2))
            end
        using Plots
        gr()
         p_arr[j]=p1=heatmap(m,
            c=:diverging_cwm_80_100_c22_n256, clim= (-1, 1), xlab = "Wages", ylab= " ",
             yguidefontsize=9,  xguidefontsize=9, legend = false,
               xticks = ([2,19],["Low","High"]), yticks = ([2,19],yt[j])
            )
        title!(string(" "), titlefontsize = 9)
        if j == 1 ylabel!("Price",  yguidefontsize=9) end
end
ps = [p_arr[1] p_arr[2] p_arr[3]]


l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
Plots.GridLayout(1, 3)

eff2 = plot(ps..., heatmap((0:0.01:1).*ones(101,1),
legend=:none, xticks=:none, c=:diverging_cwm_80_100_c22_n256, yticks=(1:10:101,
string.(-1:0.2:1)), title ="\\Delta Cor[R, L]", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly

plot(eff2, size = (1000, 333), left_margin = 20px, bottom_margin = 20px, right_margin = 10px)



png("C:\\Users\\jeffr\\Documents\\work\\cpr\\output\\fig_cov_SI.png")
