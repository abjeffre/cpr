par(mfrow = c(1, 2), oma =c(0,0,0, 0))


curve(-log(x+.1)+3.2, 0, 10, ylim = c(0, 5.5), yaxt="n", xaxt ="n", xlim = c(0.3, 10) , lty = 2, ylab = "", xlab = "", lwd =2)
curve(-log(x+.1)+2.2, 0, 10,  add = TRUE, lty = 2)
curve(-log(x+.1)+4, 0, 10,  add = TRUE, lty = 1, lwd = 1)
curve(-log(x+.1)+5, 0, 10,  add = TRUE, lty = 1, lwd = 2)



x =3.5
lines(c( x, x), c(-log(x+.1)+2.2, -log(x+.1)+3.2), col = "red", lty =2)
x =7.5
lines(c( x, x), c(-log(x+.1)+2.2, -log(x+.1)+3.2), col = "red", lty =2)
mtext("Time", side = 1)
mtext("Stock/Harvest", side = 2)
text(9,3, "A", cex = .6)
text(9,2, "B", cex = .6)
text(9,1.1, "C", cex = .6)
text(9,0.1, "D", cex = .6)



curve(-log(x+.1)+3.2, 0, 10, lty = 2, lwd = 2, ylim = c(0, 5.5), xlim = c(0.3, 10), xlab = "", ylab = "",yaxt="n", xaxt ="n")
curve(-log(x+.1)+3.2-(x*.1), 0, 10, lty = 2, add = TRUE)
mtext("Time", side = 1)
mtext("Stock/Harvest", side = 2)
curve(-log(x+.1)+5, 0, 10,  add = TRUE, lty = 1, lwd = 2)
curve(-log(x+.1)+4, 0, 10,  add = TRUE)

x = 4

x =3.5
lines(c( x, x), c(-log(x+.1)+3.2-(x*.1), -log(x+.1)+3.2), col = "red", lty =2)
x =7.5
lines(c( x, x), c(-log(x+.1)+3.2-(x*.1), -log(x+.1)+3.2), col = "red", lty =2)

legend(6,6, legend=c("C-Stock", "D-Stock", "C-Harvest", "D-Harvest"),
       col=c("black", "black"), lty=c(1,2), lwd = c(2,1) , cex=0.6, bty = "n")

text(9,3, "E", cex = .6)
text(9,2, "F", cex = .6)
text(9,1.1, "G", cex = .6)
text(9,0.2, "H", cex = .6)
