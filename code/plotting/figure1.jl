###################################################################
############### Figure 1 ##########################################
using Plots.PlotMeasures
using Statistics
using JLD2
using Plots
using ColorSchemes
using Distributed
using DataFrames
using Serialization
using Distributed
include("functions/utility.jl")
dir = "Y:\\eco_andrews\\Projects\\CPR\\code\\plotting\\ostrom"
files=readdir(dir)
RUN = false
for i in files
    println(i)
    include(string(dir, "\\", i))
end

a=plot(heterogenity, stringent,  plotsl[2], plotsl[1], noseizures, seizures, maintain, collapse,  borders_on_selfreg, Selection, Covariance,
 layout = grid(3,4), size = (1300, 850), left_margin = 25px, bottom_margin = 25px, top_margin = 10px, right_margin = 20px);

 savefig(a, "figure1.pdf")


 ############
 # Revision #

 a=plot(heterogenity, stringent, noseizures, seizures, maintain, collapse, bandits_on_self_regulation_new, borders_on_self_regulation_new,  
 Outgroup, Selection, Covariance, plotsl[2], plotsl[1], layout = grid(4,4), legendfontsize = 5,
 size = (1000, 1000), left_margin = 25px, bottom_margin = 25px, top_margin = 10px, right_margin = 20px);
 savefig(a, "figure_revised.pdf"); 
 