source("/home/jeffrey_andrews/cpr/models/seen_leakage.R")



png("/home/jeffrey_andrews/cpr/output/seen_leakage.png")
par(oma = c(3,1,1,1))
a <- density(post$a[,1] - post$a[,2])

post <- extract.samples(model)
dens(post$a[,1] - post$a[,2], show.HPDI = .95, xlab = "posterior log-odds ATE estimate", main = "CoFMA status and reported leakage")
lines(x =c(0,0), y = c(0, 1), col = "red", lty = 1)
lines(x =c(median(post$a[,1] - post$a[,2]),median(post$a[,1] - post$a[,2]) ), y =c(0, .4), lty = 2  )
#mtext(c("Figure XXX - Shows the Estimate Log -odds treatment effect of CoFMAs on leakage"), outer = T, cex = .8, side = 1, line = 1)
dev.off()
