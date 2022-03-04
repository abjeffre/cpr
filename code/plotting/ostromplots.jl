using Plots.PlotMeasures
using Statistics
using JLD2
using Plots
using ColorSchemes
maintit = ["low" "low" "low" "med" "med" "high" "high" "high" "high" "high"]

# cd("Y:\\eco_andrews\\projects\\")
# cd("C:\\Users\\jeffr\\Documents\\Work\\")

@JLD2.load("cpr\\data\\abmDatFull.jld2")

travelcost = unique(S[:,4])
punishcost = unique(S[:,5])
defense = unique(S[:,6])
tech = unique(S[:,9])
degrade = unique(S[:,14])

sort!(punishcost)
cols = [:RdBu_9, :PiYG_9]


pars = [:stock, :leakage, :punish, :punish2, :limit]
p_arr = Plots.Plot{Plots.GRBackend}[]
resize!(p_arr, length(travelcost)*length(punishcost) *length(defense)*length(tech)*length(degrade)*length(pars))
p_arr=reshape(p_arr, length(travelcost),length(punishcost),length(defense),length(tech),length(degrade),length(pars))


for r in 1:length(pars)
    for k in 1:length(travelcost)
        for f in 1:length(punishcost)
            for g in 1:length(defense)
                for j in 1:length(tech)
                    for z in 1:length(degrade)
                        #l=findall(x->x==0.0001, S[:,10])
                        #h=findall(x->x==0.9, S[:,10])
                        c=findall(x->x==travelcost[k], S[:,4])
                        w=findall(x->x==punishcost[f], S[:,5])
                        e=findall(x->x==defense[g], S[:,6])
                        y=findall(x->x==tech[j], S[:,9])
                        u=findall(x->x==degrade[z], S[:,14])
                        c=c[c.∈ Ref(w)]
                        c=c[c.∈ Ref(e)]
                        c=c[c.∈ Ref(y)]
                        c=c[c.∈ Ref(u)]
                        dat =abm_dat[c]
                        m = zeros(10,10)
                        for i = 1:length(dat)
                            m[i]  = mean(mean(dat[i][pars[r]][100:end,2:9,:], dims =2))#-mean(low[i][pars[r]][100:end,2,:], dims =2))# - mean(low[i]["effort"][:,2,:], dims = 2))
                        end
                        using Plots
                        gr()
                            p_arr[k,f,g,j,z,r]=p1=heatmap(m,
                                c=cols[1],
                                clim= ifelse(r==5, (0, 3), (-1,1)),
                                xlab = "Wages",
                                ylab = ifelse(k == 3, "Price", " "),
                                yguidefontsize=9,
                                xguidefontsize=9,
                                legend = false,
                                xticks = ([2,9], ("Low", "High")),
                                yticks = ([2,9], ("Low", "High")),
                                title = (string(pars[r])),
                                #legendtitle = "Δ E",
                                titlefontsize = 9,
                                top_margin = 30px,
                                right_margin = 20px,
                                bottom_margin = 30px)
                                #annotate!([23.5], [22.5], text("Δ E", :black, :right, 9))
                    end #degrade
                end#tech
            end#defense
        end#punsih
    end#travel
end#pars


for f in 1:length(punishcost)
    for g in 1:length(defense)
        for j in 1:length(tech)
            for z in 1:length(degrade)
                ps1 = [p_arr[1,f,g,j,z,2] p_arr[2,f,g,j,z,2] p_arr[3,f,g,j,z,2]]
                ps2 = [p_arr[1,f,g,j,z,3] p_arr[2,f,g,j,z,3] p_arr[3,f,g,j,z,3]]
                ps3 = [p_arr[1,f,g,j,z,4] p_arr[2,f,g,j,z,4] p_arr[3,f,g,j,z,4]]
                ps4 = [p_arr[1,f,g,j,z,5] p_arr[2,f,g,j,z,5] p_arr[3,f,g,j,z,5]]
                ps5 = [p_arr[1,f,g,j,z,1] p_arr[2,f,g,j,z,1] p_arr[3,f,g,j,z,1]]


                l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
                Plots.GridLayout(1, 3)
                set1 = plot(ps1..., heatmap((0:0.01:1).*ones(101,1),
                legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
                string.(-1:0.2:1)), title ="\\Delta E", titlefont = 8), layout=l, left_margin = 20px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px) # Plot them set y values of color bar accordingly


                l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
                Plots.GridLayout(1, 3)
                set2 = plot(ps2..., heatmap((0:0.01:1).*ones(101,1),
                legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
                string.(-1:0.2:1)), title ="\\Delta T", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly

                l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
                Plots.GridLayout(1, 3)
                set3 = plot(ps3..., heatmap((0:0.01:1).*ones(101,1),
                legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
                string.(-1:0.2:1)), title ="\\Delta X", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly

                l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
                Plots.GridLayout(1, 3)
                set4 = plot(ps4..., heatmap((0:0.01:1).*ones(101,1),
                legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
                string.(-1:0.2:1)), title ="\\Delta R", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly
                
                l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
                Plots.GridLayout(1, 3)
                set5 = plot(ps5..., heatmap((0:0.01:1).*ones(101,1),
                legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
                string.(-1:0.2:1)), title ="\\Delta X", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly

                plot(set1, set2, set3, set4, set5, size = (1000, 1400), left_margin = 25px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px,
                layout = (5,1))
                png("cpr\\output\\full pcost=$f defense=$g tech=$j degrade=$z.png")
            end
        end
    end
end

i=65
a=plot(mean(mean(dat[i][:leakage][:,:,:], dims =3),dims =2)[:,:,1], title = "leakage");
b=plot(mean(mean(dat[i][:punish][:,:,:], dims =3),dims =2)[:,:,1], title = "punish");
c=plot(mean(mean(dat[i][:punish2][:,:,:], dims =3),dims =2)[:,:,1], title = "punish2");
plot(a,b,c)


######################################################


using Plots.PlotMeasures
using Statistics
using JLD2
using Plots
using ColorSchemes
maintit = ["low" "low" "low" "med" "med" "high" "high" "high" "high" "high"]

cd("Y:\\eco_andrews\\projects\\")
@JLD2.load("cpr\\data\\abmDatOstromVar.jld2")

vari = unique(S[:,15])
pun = unique(S[:,16])

cols = [:RdBu_9, :PiYG_9]


pars = [:stock, :leakage, :punish, :punish2, :limit]
p_arr = Plots.Plot{Plots.GRBackend}[]
resize!(p_arr, length(vari)*length(pun)*length(pars))
p_arr=reshape(p_arr, length(vari),length(pun),length(pars))


for r in 1:length(pars)
    for k in 1:length(vari)
        for f in 1:length(pun)
                    #l=findall(x->x==0.0001, S[:,10])
                    #h=findall(x->x==0.9, S[:,10])
                    c=findall(x->x==vari[k], S[:,15])
                    w=findall(x->x==pun[f], S[:,16])               
                    c=c[c.∈ Ref(w)]
                    dat =abm_dat[c]
                    m = zeros(10,10)
                    for i = 1:length(dat)
                        m[i]  = mean(mean(dat[i][pars[r]][100:end,2:9,:], dims =2))#-mean(low[i][pars[r]][100:end,2,:], dims =2))# - mean(low[i]["effort"][:,2,:], dims = 2))
                    end
                    using Plots
                    gr()
                        p_arr[k,f,r]=p1=heatmap(m,
                            c=cols[1],
                            clim= ifelse(r==5, (0, 3), (-1,1)),
                            xlab = "Wages",
                            ylab = ifelse(k == 3, "Price", " "),
                            yguidefontsize=9,
                            xguidefontsize=9,
                            legend = false,
                            xticks = ([2,9], ("Low", "High")),
                            yticks = ([2,9], ("Low", "High")),
                            title = (string(pars[r])),
                            #legendtitle = "Δ E",
                            titlefontsize = 9,
                            top_margin = 30px,
                            right_margin = 20px,
                            bottom_margin = 30px)
                            #annotate!([23.5], [22.5], text("Δ E", :black, :right, 9))
                    end #degrade
                end#tech
            end#defense



for f in 1:length(pun)
        
                ps1 = [p_arr[1,f,2] p_arr[1,f,2] p_arr[1,f,2]]
                ps2 = [p_arr[1,f,3] p_arr[1,f,3] p_arr[1,f,3]]
                ps3 = [p_arr[1,f,4] p_arr[1,f,4] p_arr[1,f,4]]
                ps4 = [p_arr[1,f,5] p_arr[1,f,5] p_arr[1,f,5]]
                ps5 = [p_arr[1,f,1] p_arr[1,f,1] p_arr[1,f,1]]


                l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
                Plots.GridLayout(1, 3)
                set1 = plot(ps1..., heatmap((0:0.01:1).*ones(101,1),
                legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
                string.(-1:0.2:1)), title ="\\Delta E", titlefont = 8), layout=l, left_margin = 20px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px) # Plot them set y values of color bar accordingly


                l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
                Plots.GridLayout(1, 3)
                set2 = plot(ps2..., heatmap((0:0.01:1).*ones(101,1),
                legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
                string.(-1:0.2:1)), title ="\\Delta T", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly

                l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
                Plots.GridLayout(1, 3)
                set3 = plot(ps3..., heatmap((0:0.01:1).*ones(101,1),
                legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
                string.(-1:0.2:1)), title ="\\Delta X", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly

                l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
                Plots.GridLayout(1, 3)
                set4 = plot(ps4..., heatmap((0:0.01:1).*ones(101,1),
                legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
                string.(-1:0.2:1)), title ="\\Delta R", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly
                
                l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
                Plots.GridLayout(1, 3)
                set5 = plot(ps5..., heatmap((0:0.01:1).*ones(101,1),
                legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
                string.(-1:0.2:1)), title ="\\Delta X", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly

                plot(set1, set2, set3, set4, set5, size = (1000, 1400), left_margin = 25px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px,
                layout = (5,1))
                png("cpr\\output\\fullvar punish=$f.png")
            end

#######################################################################
#################### LEAKAGE ##########################################



using Plots.PlotMeasures
using Statistics
using JLD2
using Plots
using ColorSchemes
maintit = ["low" "low" "low" "med" "med" "high" "high" "high" "high" "high"]

cd("Y:\\eco_andrews\\projects\\")
@JLD2.load("cpr\\data\\ostromleak.jld2")

vari = unique(S[:,15])
pun = unique(S[:,1])

cols = [:RdBu_9, :PiYG_9]


pars = [:stock, :leakage, :punish, :punish2, :limit]
p_arr = Plots.Plot{Plots.GRBackend}[]
resize!(p_arr, length(vari)*length(pun)*length(pars))
p_arr=reshape(p_arr, length(vari),length(pun),length(pars))


for r in 1:length(pars)
    for k in 1:length(vari)
        for f in 1:length(pun)
                    #l=findall(x->x==0.0001, S[:,10])
                    #h=findall(x->x==0.9, S[:,10])
                    c=findall(x->x==vari[k], S[:,15])
                    w=findall(x->x==pun[f], S[:,1])               
                    c=c[c.∈ Ref(w)]
                    dat =abm_dat[c]
                    m = zeros(10,10)
                    for i = 1:length(dat)
                        m[i]  = mean(mean(dat[i][pars[r]][100:end,2:9,:], dims =2))#-mean(low[i][pars[r]][100:end,2,:], dims =2))# - mean(low[i]["effort"][:,2,:], dims = 2))
                    end
                    using Plots
                    gr()
                        p_arr[k,f,r]=p1=heatmap(m,
                            c=cols[1],
                            clim= ifelse(r==5, (0, 3), (-1,1)),
                            xlab = "Wages",
                            ylab = ifelse(k == 3, "Price", " "),
                            yguidefontsize=9,
                            xguidefontsize=9,
                            legend = false,
                            xticks = ([2,9], ("Low", "High")),
                            yticks = ([2,9], ("Low", "High")),
                            title = (string(pars[r])),
                            #legendtitle = "Δ E",
                            titlefontsize = 9,
                            top_margin = 30px,
                            right_margin = 20px,
                            bottom_margin = 30px)
                            #annotate!([23.5], [22.5], text("Δ E", :black, :right, 9))
                    end #degrade
                end#tech
            end#defense

[for i in 1:10 mean(abm_dat[i][:leakage]) end]


for f in 1:length(pun)
        
                ps1 = [p_arr[1,f,2] p_arr[1,f,2] p_arr[1,f,2]]
                ps2 = [p_arr[1,f,3] p_arr[1,f,3] p_arr[1,f,3]]
                ps3 = [p_arr[1,f,4] p_arr[1,f,4] p_arr[1,f,4]]
                ps4 = [p_arr[1,f,5] p_arr[1,f,5] p_arr[1,f,5]]
                ps5 = [p_arr[1,f,1] p_arr[1,f,1] p_arr[1,f,1]]


                l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
                Plots.GridLayout(1, 3)
                set1 = plot(ps1..., heatmap((0:0.01:1).*ones(101,1),
                legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
                string.(-1:0.2:1)), title ="\\Delta E", titlefont = 8), layout=l, left_margin = 20px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px) # Plot them set y values of color bar accordingly


                l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
                Plots.GridLayout(1, 3)
                set2 = plot(ps2..., heatmap((0:0.01:1).*ones(101,1),
                legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
                string.(-1:0.2:1)), title ="\\Delta T", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly

                l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
                Plots.GridLayout(1, 3)
                set3 = plot(ps3..., heatmap((0:0.01:1).*ones(101,1),
                legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
                string.(-1:0.2:1)), title ="\\Delta X", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly

                l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
                Plots.GridLayout(1, 3)
                set4 = plot(ps4..., heatmap((0:0.01:1).*ones(101,1),
                legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
                string.(-1:0.2:1)), title ="\\Delta R", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly
                
                l = @layout[grid(1,3) a{0.05w}] # Stack a layout that rightmost one is for color bar
                Plots.GridLayout(1, 3)
                set5 = plot(ps5..., heatmap((0:0.01:1).*ones(101,1),
                legend=:none, xticks=:none, c=cols[1], yticks=(1:10:101,
                string.(-1:0.2:1)), title ="\\Delta X", titlefont = 8), layout=l) # Plot them set y values of color bar accordingly

                plot(set1, set2, set3, set4, set5, size = (1000, 1400), left_margin = 25px, bottom_margin = 10px, top_margin = 10px, right_margin = 10px,
                layout = (5,1))
                png("cpr\\output\\fullvar punish=$f.png")
            end





            temp1 =cpr_abm(n = 9*150, max_forest = 9*210000, ngroups =9, nsim = 5,
            lattice = [3,3], harvest_limit = 1.5, regrow = .025,
            wages = 1.3, price = .06)
        
        temp2 =cpr_abm(n = 9*150, max_forest = 9*210000, ngroups =9, nsim = 5,
            lattice = [3,3], harvest_limit = 1.5, regrow = .025, pun1_on = false,
            wages = 1.3, price = .06)
        
            
        x=mean(mean(temp1[:leakage][:,:,1], dims = 3), dims =2)[:,:,1]
        y=mean(mean(temp1[:punish][:,:,1], dims = 3), dims =2)[:,:,1]
        z=mean(mean(temp1[:punish2][:,:,1], dims = 3), dims =2)[:,:,1]
        
        a=plot(x)
        plot!(y)
        plot!(z)
        
        
        x=mean(mean(temp2[:leakage][:,:,1], dims = 3), dims =2)[:,:,1]
        y=mean(mean(temp2[:punish][:,:,1], dims = 3), dims =2)[:,:,1]
        z=mean(mean(temp2[:punish2][:,:,1], dims = 3), dims =2)[:,:,1]
        
        a=plot(x)
        plot!(y)
        plot!(z)
        
        
        
        temp =cpr_abm(n = 9*150, max_forest = 9*210000, ngroups =9, nsim = 5,
            lattice = [3,3], harvest_limit = 1.5, regrow = .025,
            wages = 1.3, price = .06, defensibility = i)
        x=mean(mean(temp3[:leakage][:,:,1], dims = 3), dims =2)[:,:,1]
        y=mean(mean(temp3[:punish][:,:,1], dims = 3), dims =2)[:,:,1]
        z=mean(mean(temp3[:punish2][:,:,1], dims = 3), dims =2)[:,:,1]
        
        a=plot(x)
        plot!(y)
        plot!(z)
        
        
        d = []
        
        for i in collect(0:.02:1)
            temp=cpr_abm(n = 2*150, max_forest = 2*210000, ngroups =2, nsim = 10,
            lattice = [1,2], harvest_limit = 1.5, regrow = .025, pun2_on = false,
            wages = 1.3, price = .06, defensibility = 1, experiment_leak = i, experiment_effort =1)
            push!(d, temp)
        end
                