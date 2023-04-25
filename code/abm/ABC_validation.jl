include("cpr/code/abm/ABC_processing.jl")
# Construct a prior that is generated from the ABC
n = length(best)
S2=S[best,:]

# Here you would generate a distribution that summarizes the best responses
# Sample from that distribution
# These samples would then be pushed through the ABC once again
# 
S2[:,1]=sample(S2[:,1], n)
S2[:,2]=sample(S2[:,2], n)
S2[:,3]=sample(S2[:,3], n)
S2[:,4]=sample(S2[:,4], n)

valdiation=pmap(g, S2[:,1],S2[:,2],S2[:,3],S2[:,4],S2[:,5],S2[:,6],S2[:,7],S2[:,8],S2[:,9])
jldsave("validation_check.jld2"; valdiation, S2)

check=load("cpr/data//validation_check.JLD2")
a = check["valdiation"]


i = 1
plot(scatter(a[i][:effort][:,:,1], label = false), scatter(e[:,1], label = false))
plot(plot(a[i][:stock][:,:,1], label = false), scatter(e[:,1], label = false))
