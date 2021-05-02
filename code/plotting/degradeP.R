par(mfrow=c(1,1))


curve(1-qbeta(x,10, 1),0,1, xaxt = "n", yaxt = "n", ylab = "", xlab = "", lwd =2, lty =3)
curve(1-qbeta(x,.1, 1),0,1, add = TRUE, lwd =2, lty =3)
curve(1-qbeta(x,1, 1),0,1, add = TRUE, lwd =2, lty =3)
mtext("ROI", side =2)
mtext("Stock", side =1)
text(.5, .55, "B", cex = .7)
text(.1, .3, "A", cex = .7)
text(.9, .8, "C", cex = .7)

xtick<-c(0, 1)
axis(side=1, at=xtick, labels = FALSE)
mtext("min", line = .1, side = 1, adj = .002, cex = .8)
mtext("max", line = .1, side = 1, adj = .997, cex = .8)

f = function(x, E){
  -log(x+.1)+E+1
}

f2 =  function(x, Y, E, EB, max = 12){
  (-log(x+.1)+E)-
    (-log(x+.1)+E)*
    qbeta(x/(max+EB),Y, 1)
}





max = 12
DE = 4
CE = 6
CEB = CE - DE



par(mfrow = c(1,3))

# LINEAR


curve(f(x, 4), 0, max, lty = 1, lwd = 2, ylim = c(0, 7), xlim = c(0.3, max), xlab = "", ylab = "",yaxt="n", xaxt ="n")

curve(f(x, 3), 0, max, add = TRUE, lty = 3, lwd =2)

curve(f(x, 5), 0, max, lty = 1, lwd = 2, add = TRUE, col = "grey")

curve(f(x, 3.5), 0, max, add = TRUE, lty = 3, col = "grey", lwd =2)

x = 1.2
lines(c(x, x), c(f(x,3), f(x,3.5)) , lty = 2, col = "red")

lines(c(0, x), c(f(x,3), f(x,3)) , lty = 4, col = "red")
lines(c(0, x),   c(f(x,3.5), f(x,3.5)) , lty = 4, col = "red")

x=11.8
lines(c(x, x), c(f(x,3), f(x,3.5)) , lty = 2, col = "red")

lines(c(0, x), c(f(x,3), f(x,3)) , lty = 4, col = "red")
lines(c(0, x),   c(f(x,3.5), f(x,3.5)) , lty = 4, col = "red")
text(1, 6.8, "A.")
mtext("Time", side = 1)
mtext("Stock/Harvest*", side = 2)


#Convex
y = 1.5
EB = 2
curve(f(x, 4), 0, max, lty = 1, lwd = 2, ylim = c(0, 7), xlim = c(0.3, max), xlab = "", ylab = "",yaxt="n", xaxt ="n")

curve(f2(x, y, 4, 0), 0, max, add = TRUE, lty = 3, lwd =2)

curve(f(x, 5), 0, max, lty = 1, lwd = 2, add = TRUE, col = "grey")

curve(f2(x, y, 5-.3, EB), 0, max, add = TRUE, lty = 3, col = "grey", lwd =2)

x = 1.2
lines(c(x, x), c(f2(x=x,y, 4, 0 ), f2(x=x,y, 5-.3, EB)) , lty = 2, col = "red")

lines(c(0, x), c(f2(x=x,y, 4, 0 ), f2(x=x,y, 4, 0 )) , lty = 4, col = "red")
lines(c(0, x),   c(f2(x=x,y, 5-.3, EB), f2(x=x,y, 5-.3, EB)) , lty = 4, col = "red")

x=11.8
lines(c(x, x), c(f2(x=x,y, 4, 0 ), f2(x=x,y, 5-.3, EB)) , lty = 2, col = "red")

lines(c(0, x), c(f2(x=x,y, 4, 0 ), f2(x=x,y, 4, 0 )) , lty = 4, col = "red")
lines(c(0, x),   c(f2(x=x,y, 5-.3, EB), f2(x=x,y, 5-.3, EB)) , lty = 4, col = "red")
text(1, 6.8, "B.")

mtext("Time", side = 1)
mtext("Stock/Harvest*", side = 2)



#ConCave
y = .05
EB = 2
curve(f(x, 4), 0, max, lty = 1, lwd = 2, ylim = c(0, 7), xlim = c(0.3, max), xlab = "", ylab = "",yaxt="n", xaxt ="n")

curve(f2(x, y, 4, 0), 0, max, add = TRUE, lty = 3, lwd =2)

curve(f(x, 5), 0, max, lty = 1, lwd = 2, add = TRUE, col = "grey")

curve(f2(x, y, 5-.3, EB), 0, max, add = TRUE, lty = 3, col = "grey", lwd =2)

x = 1.2
lines(c(x, x), c(f2(x=x,y, 4, 0 ), f2(x=x,y, 5-.3, EB)) , lty = 2, col = "red")

lines(c(0, x), c(f2(x=x,y, 4, 0 ), f2(x=x,y, 4, 0 )) , lty = 4, col = "red")
lines(c(0, x),   c(f2(x=x,y, 5-.3, EB), f2(x=x,y, 5-.3, EB)) , lty = 4, col = "red")

x=11.8
lines(c(x, x), c(f2(x=x,y, 4, 0 ), f2(x=x,y, 5-.3, EB)) , lty = 2, col = "red")

lines(c(0, x), c(f2(x=x,y, 4, 0 ), f2(x=x,y, 4, 0 )) , lty = 4, col = "red")
lines(c(0, x),   c(f2(x=x,y, 5-.3, EB), f2(x=x,y, 5-.3, EB)) , lty = 4, col = "red")

text(1, 6.8, "C.")

mtext("Time", side = 1)
mtext("Stock/Harvest*", side = 2)

legend("topright", legend=c("CE Stock", "CE Harvest", "DE Stock", "DE Harvest"), col=c("grey", "black"), lty = c(1, 3), cex = .85)
