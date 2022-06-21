
function plotWealth(; data = x, sim = 1)
    anim = @animate for i = 1:500
        h= histogram(data[:wealth][:,i,sim],
            nbins =300,
            ylim = (0, 50),
            xlim =(0, maximum(data[:wealth])),
            label = "Wealth",
            xlabel = "Wealth",
            xticks = ([1000], ""),
            #title = "year: $i",
            top_margin = 20px)

            age=histogram(data[:age][:,i,sim],
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
            
            stock=plot(x[:stock][1:i,:,sim],
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
    display(gif(anim, string("test.gif")
    , fps = fps))

end


# x = cpr_abm(rec_history = true, inher = true, learn_type = "wealth", wages = .2, ngroups = 9, n = 150*9, max_forest = 210000*150, lattice = [3,3])

#  plotWealth(data = x)