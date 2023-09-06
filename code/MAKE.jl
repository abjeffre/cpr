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
end


#####################################
######## Initalize Functions ########

include("functions/utility.jl")

######################################
#### Initalize submodules ############

include("cpr\\code\\abm\\initalize_home.jl")

######################################
######### CHOOSE ABM VERSION #########

include("cpr\\code\\abm\\abm_cleaned.jl")

