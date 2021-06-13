function KillAgents(pop, id, age, mortality_rate, sample_payoff)
    if  length(unique(age[pop])) == 1
        age[pop] .=age[pop].+rand(0:1, length(age[pop]))
    end
    mortality_risk = softmax(standardize(age[pop].^5.5) .- standardize(sample_payoff[pop].^.25))
    to_die = asInt(round(mortality_rate*length(pop), digits =0))
    died = rand(1:300, to_die)
    died=wsample(pop, sample_payoff[pop], to_die, replace = false)
    return(died)
end
