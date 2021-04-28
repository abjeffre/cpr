try
           sqrt("ten")
       catch e
           println("You should have entered a numeric value")
       end


       a =1:1000
       b = 2.3
       w =rand(1000)
try
            wsample(a, b, w)
   catch
       return(a,b,w)
   end


   plot()                                       # empty Plot object
   plot(4)                                      # initialize with 4 empty series
   plot(rand(10))                               # 1 series... x = 1:10
   plot(rand(10,5))                             # 5 series... x = 1:10
   plot(rand(10), rand(10))                     # 1 series
   plot(rand(10,5), rand(10))                   # 5 series... y is the same for all
   plot(sin, rand(10))                          # y = sin.(x)
   plot(rand(10), sin)                          # same... y = sin.(x)
   plot([sin,cos], 0:0.1:π)                     # 2 series, sin.(x) and cos.(x)
   plot([sin,cos], 0, π)                        # sin and cos on the range [0, π]
   plot(1:10, Any[rand(10), sin])               # 2 series: rand(10) and map(sin,x)
   @df dataset("Ecdat", "Airline") plot(:Cost)  # the :Cost column from a DataFrame... must import StatsPlots


  plot!(title = "New Title", xlabel = "New xlabel", ylabel = "New ylabel")
plot!(xlims = (0, 5.5), ylims = (-2.2, 6), xticks = 0:0.5:10, yticks = [0,1,5,10])
plot!(xlims = (0, 5.5), ylims = (-2.2, 6), xticks = 0:0.5:10, yticks = [0,1,5,10])
gui()
