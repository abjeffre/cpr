#########################
######### DAMAGE ########

stock = []
payoff = []
effort = []

for i in 30:10:300
    a = cpr_abm(pun1_on = false, pun2_on= false, tech = 0.000001, leak = false,
    labor = 1, wages = 4, degrade = 1, nrounds = 1500, n = i)
    push!(payoff, median(a[:payoffR][500:end,:,1]))
    push!(effort, mean(a[:effort][500:end,:,1]))
    push!(stock, median(a[:stock][500:end,:,1]))
end

function normalize(x)
    (x)./ (maximum(x))
end

plot(stock, label = "stock", w = 2, xlab = "Leakage", ylim = (0, 1), c = "#125c2c",
 xaxis=nothing, yaxis = nothing, grid = false)
plot!(normalize(payoff), label = "payoff", w = 2, c = "#798b06", ls = :dot)
plot!(effort, label = "effort", w = 2, c = "#ffa600", ls = :dashdot)
vline!([14], ls = :dash, label = "OAE", c = "red")


###################################################
########### DAMAGE WITH CONGESTION ################

stock = []
payoff = []
effort = []

for i in 30:10:300
    a = cpr_abm(pun1_on = false, pun2_on= false, tech = 0.000001, leak = false,
    labor = 1, wages = 4, degrade = 1, nrounds = 1500, n = i, congestion = .1)
    push!(payoff, median(a[:payoffR][500:end,:,1]))
    push!(effort, mean(a[:effort][500:end,:,1]))
    push!(stock, median(a[:stock][500:end,:,1]))
end

function normalize(x)
    (x)./ (maximum(x))
end

plot(stock, label = "stock", w = 2, xlab = "Leakage", ylim = (0, 1), c = "#125c2c",
 xaxis=nothing, yaxis = nothing, grid = false)
plot!(normalize(payoff), label = "payoff", w = 2, c = "#798b06", ls = :dot)
plot!(effort, label = "effort", w = 2, c = "#ffa600", ls = :dashdot)
vline!([14], ls = :dash, label = "OAE", c = "red")
