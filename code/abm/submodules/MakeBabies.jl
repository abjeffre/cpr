
function MakeBabies(pop, id, sample_payoff, died)
    sample_payoff[died] .=0
    sample_payoff[(id) .∉ Ref(pop)] .=0
    babies=wsample(id, sample_payoff, length(died), replace = true)
    return(babies)
end

