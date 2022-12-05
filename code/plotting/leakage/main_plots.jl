##########################################
########## MAIN PLOTS ###################
inclue("C:\Users\jeffr\Documents\Work\cpr\code\analyitic\analyitic.jl")
inclue("C:\Users\jeffr\Documents\Work\cpr\code\plotting\leakage\base_leakage.jl")
inclue("C:\Users\jeffr\Documents\Work\cpr\code\plotting\leakage\secondary_leakage.jl")
run = false
inclue("C:\Users\jeffr\Documents\Work\cpr\code\plotting\leakage\new_abm_plots.jl")

plot(fixed_leakage, production_constraint, diffrent_costs, secondary_leakage, 
borders2, borders_cyclical, self_regulation2,  layout = grid(2,4), size = (900, 400), labelfontsize = 8, title = ["a." "b." "c." "d." "e." "f." "g."], 
titlefontsize = 8, titlelocation =:left, bottom_margin = 5mm)
savefig("C:/Users/jeffr/Documents/Work/cpr/plots/main_leakage.pdf")
