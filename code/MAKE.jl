####################
#LOAD PACKAGES #####

######################################
############ DETERMINE COMPUTER ######
using DataFrames
using Statistics
using Distributions
using Random
using Distributions
using StatsBase
using Distributed
using Plots
using Plots.PlotMeasures
using JLD2

if gethostname()  == "ECOD038"
    cd("Y:\\eco_andrews\\Projects\\")
elseif gethostname()== "DESKTOP-H4MPGAP"
    cd("C:\\Users\\jeffr\\Documents\\Work\\")
end


#####################################
######## Initalize Functions ########

include(string(pwd(), "\\functions\\utility.jl"))

######################################
#### Initalize submodules ############

include(string(pwd(), "\\cpr\\code\\abm\\initalize_home.jl"))

######################################
######### CHOOSE ABM VERSION #########

include(string(pwd(), "\\cpr\\code\\abm\\abm_cleaned.jl"))

