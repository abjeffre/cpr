using Plots.PlotMeasures
####################################
############ WEALTH ################

test=cpr_abm(rec_history = true)

using(Plots)

histogram(test[:wealth][:,1:1])

anim = @animate for i = 1:500

       h= histogram(test[:wealth][:,i,1],
            nbins =300,
            ylim = (0, 50),
            xlim =(0, 20),
            label = "Wealth",
            xlabel = "Wealth",
            xticks = ([n], ""),
            #title = "year: $i",
             top_margin = 20px)

            age=histogram(test[:age][:,i,1],
             xlim = (0,100),
             ylim = (0,100),
             nbins = 10,
             #orientation = :horizontal,
             label = "age", 
             xlabel = "age",
             xguidefontsize=9,
             bottom_margin = 20px, 
             xticks = collect(0:10:100),
             yticks = collect(0:10:100),
              size = (400, 400))

            timer=bar([i], xlim = (0,500)
            , orientation = :horizontal,
             label = false, 
             xlabel = "Time",
            xguidefontsize=9,
             bottom_margin = 20px, 
             xticks = collect(0:50:500),
              yticks = ([10], ("")),
              size = (1000, 100))
              
            # stock=plot(test[:stock][:,:,i],
            #  xlim = (0,500),
            #  label = false, 
            #  xlabel = "Time",
            #  ylabel = "Stock",
            # xguidefontsize=9,
            #  bottom_margin = 20px,
            #  left_margin = 20px, 
            #  xticks = collect(0:50:500),
            #   yticks = ([10], ("")),
            #   size = (1000, 200))



              set1 = plot(h, age, layout = (1,2), size = (1000, 400))

            l = @layout[a;b{.05h}]
            Plots.GridLayout(2, 1)
            plot(set1, timer, 
                size = (1000, 700), 
                left_margin = 20px,
                bottom_margin = 20px, 
                right_margin = 10px,
                layout = l)   
    
 

end

fps = 50
gif(anim, string("test.gif")
, fps = fps)






histogram(test[:wealth][:,1:1])

test=cpr_abm(rec_history = true, learn_strat = "wealth")

using(Plots)

histogram(test[:wealth][:,1:1])

anim = @animate for i = 1:500

       h= histogram(test[:wealth][:,i,1],
            nbins =300,
            ylim = (0, 50),
            xlim =(0, 20),
            label = "Wealth",
            xlabel = "Wealth",
            xticks = ([1000], ""),
            #title = "year: $i",
             top_margin = 20px)

            age=histogram(test[:age][:,i,1],
             xlim = (0,100),
             ylim = (0,100),
             nbins = 10,
             #orientation = :horizontal,
             label = "age", 
             xlabel = "age",
             xguidefontsize=9,
             bottom_margin = 20px, 
             xticks = collect(0:10:100),
             yticks = collect(0:10:100),
              size = (400, 400))

              age=histogram(test[:age][:,i,1],
              xlim = (0,100),
              ylim = (0,100),
              nbins = 10,
              #orientation = :horizontal,
              label = "age", 
              xlabel = "age",
              xguidefontsize=9,
              bottom_margin = 20px, 
              xticks = collect(0:10:100),
              yticks = collect(0:10:100),
               size = (400, 400))
 

            timer=bar([i], xlim = (0,500)
            , orientation = :horizontal,
             label = false, 
             xlabel = "Time",
            xguidefontsize=9,
             bottom_margin = 20px, 
             xticks = collect(0:50:500),
              yticks = ([10], ("")),
              size = (1000, 100))
              
             stock=plot(test[:stock][1:i,:,1],
             xlim = (0,500),
             ylim = (0,1),
             label = false, 
             xlabel = "Time",
             ylabel = "Stock",
            xguidefontsize=9,
             bottom_margin = 20px,
             left_margin = 20px, 
             xticks = collect(0:50:500),
              yticks = ([10], ("")),
              size = (1000, 200))
              set1 = plot(h, age, layout = (1,2), size = (1000, 400))

            l = @layout[a;b{.2h};c{.05h}]
            Plots.GridLayout(3, 1)
            plot(set1, stock, timer,
                size = (1000, 700), 
                left_margin = 20px,
                bottom_margin = 20px, 
                right_margin = 10px,
                layout = l)   
    
 

end

fps = 50
gif(anim, string("test.gif")
, fps = fps)

##########################################
#########################################

test=cpr_abm(inher = true, wages = .05, rec_history = true, )

using(Plots)

histogram(test[:wealth][:,100,1])

anim = @animate for i = 1:500

       h= histogram(test[:wealth][:,i,1],
            nbins =300,
            ylim = (0, 60),
            xlim =(0, 150),
            label = "Wealth",
            xlabel = "Wealth",
            xticks = ([1000], ""),
            #title = "year: $i",
             top_margin = 20px)

            age=histogram(test[:age][:,i,1],
             xlim = (0,100),
             ylim = (0,100),
             nbins = 10,
             #orientation = :horizontal,
             label = "age", 
             xlabel = "age",
             xguidefontsize=9,
             bottom_margin = 20px, 
             xticks = collect(0:10:100),
             yticks = collect(0:10:100),
              size = (400, 400))

            timer=bar([i], xlim = (0,500)
            , orientation = :horizontal,
             label = false, 
             xlabel = "Time",
            xguidefontsize=9,
             bottom_margin = 20px, 
             xticks = collect(0:50:500),
              yticks = ([10], ("")),
              size = (1000, 100))
              
             stock=plot(test[:stock][1:i,:,1],
             xlim = (0,500),
             ylim = (0,1),
             label = false, 
             xlabel = "Time",
             ylabel = "Stock",
            xguidefontsize=9,
             bottom_margin = 20px,
             left_margin = 20px, 
             xticks = collect(0:50:500),
              yticks = ([10], ("")),
              size = (1000, 200))



              set1 = plot(h, age, layout = (1,2), size = (1000, 400))

            l = @layout[a;b{.2h};c{.05h}]
            Plots.GridLayout(3, 1)
            plot(set1, stock, timer,
                size = (1000, 700), 
                left_margin = 20px,
                bottom_margin = 20px, 
                right_margin = 10px,
                layout = l)   
    
 

end

fps = 50
gif(anim, string("test.gif")
, fps = fps)


###########################################
########### Age in Wealth Cate ########


tech_data = collect(0.001:.002:1)
tech_data = [tech_data; ones(500)]

test=cpr_abm(inher = true, wages = .05, nrounds = 1000, zero = true, experiment_leak = .001, experiment_effort =1)
plot(test[:effort][:,:,1])
plot(test[:limit][:,:,1])
plot(test[:punish][:,:,1])
plot(test[:punish2][:,:,1])
plot(test[:stock][:,:,1])

test2=cpr_abm(inher = true, wages = .05, nrounds = 1000, zero = true, experiment_leak = .9, experiment_effort =1)

test = copy(test2)

test[:wealthgroups][:,i,1]
tempG=test[:wealthgroups][:,i,1] .==2
n = 1000

histogram(test[:wealth][tempG,i,1])

anim = @animate for i = 1:n
    h= histogram(test[:wealth][tempG,i,1],
         nbins =300,
         ylim = (0, 60),
         xlim =(0, 150),
         ylabel = "Frequency",
         xlabel = "Wealth",
         xticks = ([1000], ""),
         #title = "year: $i",
          top_margin = 20px)

         age=histogram(test[:age][tempG,i,1],
          xlim = (0,100),
          ylim = (0,100),
          nbins = 10,
          #orientation = :horizontal,
          label = "age", 
          xlabel = "age",
          xguidefontsize=9,
          bottom_margin = 20px, 
          xticks = collect(0:10:100),
          yticks = collect(0:10:100),
           size = (400, 400))

           theil_bar=bar([Theil(test[:wealth][tempG,i,1])], 
            ylim = (0,1),
            label = false, 
            xlab = "",
            ylab = "Inequality",
            xguidefontsize=9,
            left_margin = 20px, 
            yticks = collect(0:.1:1),
             xticks = ([10], ("")), 
             size =(100, 400))
  
  
            
             l = @layout[a b{.05w}]
             Plots.GridLayout(1, 2)
             ineq = plot(h, theil_bar, layout = l, size = (400, 500))
  

         timer=bar([i], xlim = (0,n)
         , orientation = :horizontal,
          label = false, 
          xlabel = "Time",
         xguidefontsize=9,
          bottom_margin = 20px, 
          xticks = collect(0:n/10:n),
           yticks = ([10], ("")),
           size = (1000, 100))
           
          stock=plot(test[:stock][1:i,2,1],
          xlim = (0,n),
          ylim = (0,1),
          label = false, 
          xlabel = "Time",
          ylabel = "Stock",
         xguidefontsize=9,
          bottom_margin = 20px,
          left_margin = 20px, 
          xticks = collect(0:n/10:n),
           yticks = ([10], ("")),
           size = (1000, 200))

         group=quantile(test[:wealth][:,i,1], collect(0.1:.1:1))
         indexes=findall(x->x.==1, tempG)
         wealth = test[:wealth][tempG,i,1]
         avAge = zeros(10)
         avAge[1] =mean(test[:age][indexes,i,1][wealth.<= group[1]])
        for j in 2:10

             avAge[j] = mean(test[:age][indexes,i,1][(wealth .>= group[j-1]) .& 
             (wealth.<= group[j])])
        end

         wealth_age=bar(avAge, xticks = collect(1:10), 
         ylab = "Mean age",
         ylim = (0, 70),
         xlab = "Wealth Quantile")

         group=quantile(test[:wealth][indexes,i,1], collect(0.1:.1:1))
         wealth = test[:wealth][:,i,1]
         dAge = []
         temp=test[:age][indexes,i,1][wealth[indexes].<= group[1]]
         push!(dAge, temp)
         for j in 2:10
             temp=test[:age][indexes,i,1][(wealth[indexes] .>= group[j-1]) .& 
             (wealth[indexes].<= group[j])]
             push!(dAge, temp)
         end
         ageDist=violin(dAge, leg = false, xticks = collect(1:10), 
         ylab = "Age",
         ylim = (0, 80),
         xlab = "Wealth Quantile", color = :steelblue3)
         

         l = @layout[a b{.45w}]
         Plots.GridLayout(1, 2)
         set1 = plot(ineq, ageDist, layout = l)

         l = @layout[a;b{.2h};c{.05h}]
         Plots.GridLayout(3, 1)
         plot(set1, stock, timer,
             size = (1000, 700), 
             left_margin = 20px,
             bottom_margin = 20px, 
             right_margin = 10px,
             layout = l)   
 


end

fps = 50
gif(anim, string("test.gif")
, fps = fps)

