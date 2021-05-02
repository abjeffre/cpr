######################################################
############# SETUP FUNCTIONS FOR ABM ################
  #functions
  function logit(p)
     log(p/(1-p))
   end

function nanmean(x)
  mean(filter(!isnan, x))
end


function nanmedian(x)
  median(filter(!isnan, x))
end

function benchmark(x)
  rn1 = Dates.Time(Dates.now())
  x
  rn2 = Dates.Time(Dates.now())
  return(rn2-rn1)
end

  function inv_logit(x)
     1/(1+exp(-x))
  end

  function softmax(x)
    exp.(x)/sum(exp.(x))
  end

  function rnorm(n, mu, sd)
    rand(Normal(mu, sd), n)
  end

  function asInt(x)
    convert(Int64, x)
  end


  function rbinom(n, N, p)
    asInt.(rand(Binomial(N, p), n))
  end


  function tab(x, ngroups)
    cnt = zeros(ngroups)
    for i = 1:ngroups
      cnt[i] = sum(x.==i)
    end
    return(cnt)
  end

  function report(x, gid, ngroups)
    cnt = zeros(ngroups)
    for i = 1:ngroups
      cnt[i] = mean(x[gid .== i])
    end
    return(cnt)
  end

  function isnumber(val)
    if typeof(val)<:Number
      x  =  ifelse(isnan(val), false, true)
    else
      x = false
    end
    return(x)
  end



  # note that we use \notin
  # we also use \in
  # vectorized versions include .\in .\notin

  function standardize(x)
     (x.-mean(x))/std(x)
  end

  function distance(x)
    n = length(x)
    Dist = zeros(n,n)
    for i = 1:n, j=1:n
      cordi = findall( x -> x == i, x )
      cordj =  findall( x -> x == j, x )
      Dist[i, j] =  sqrt(abs(cordi[1][1]-cordj[1][1])^2 + abs(cordi[1][2]-cordj[1][2])^2)
    end
    return(Dist)
  end


function wsample2(data, weights, size)
            w = convert.(Float64, vec(sample_payoff[weights]))
            wsample(data, w, size)
        end



  """
  Create a Data Frame from All Combinations of Factor Variables (see R's base::expand.grid)
  # Arguments
  ... Array, Dict, or Tuple containing at least one value
  # Return
  A DataFrame containing one row for each combination of the supplied argument. The first factors vary fastest.
  # Examples
  ```julia
  expand_grid([1,2],["owl","cat"])
  expand_grid((1,2),("owl","cat"))
  expand_grid((1,2)) # -> Returns a DataFrame with 2 rows of 1 and 2.
  ```
  """
  function expand_grid(args...)
      nargs= length(args)

      if nargs == 0
        error("expand_grid need at least one argument")
      end

      iArgs= 1:nargs
      nmc= "Var" .* string.(iArgs)
      nm= nmc
      d= map(length, args)
      orep= prod(d)
      rep_fac= [1]
      # cargs = []

      if orep == 0
          error("One or more argument(s) have a length of 0")
      end

      cargs= Array{Any}(undef,orep,nargs)

      for i in iArgs
          x= args[i]
          nx= length(x)
          orep= Int(orep/nx)
          mapped_nx= vcat(map((x,y) -> repeat([x],y), collect(1:nx), repeat(rep_fac,nx))...)
          cargs[:,i] .= x[repeat(mapped_nx,orep)]
          rep_fac= rep_fac * nx
      end
     return(cargs)
  end


bar(a,b,x...) = (a,b,x)

bar(1,2, [3 4], [5 6])
