##############################################################################
#
#  The two fundamental diffrences between these data sets are 
#    1. Self policing is false in leak and true in no-leak
#    2. Harvest limit has two values in no-leak and one in leak 
##############################################################################


##############################################################################
################ Build proper ABM files with full Parameters #################

temp1 <- readRDS(paste0(path$dataAbm, "cpr_sweeps_leak.RDS"))
temp2 <- readRDS(paste0(path$dataAbm, "cpr_sweeps_leak2.RDS"))


wages <- rep(0.05, nrow(temp1$par))
temp1$par<- cbind(temp1$par, wages)

par_ind <- match(colnames(temp1$par), colnames(temp2$par))
temp2$par<- temp2$par[,par_ind]

leak <- temp1

leak$par <- rbind(temp1$par, temp2$par)
leak$data <- c(leak$data, temp2$data)


#################################################################
################# Build No Leak #################################

temp1 <- readRDS(paste0(path$dataAbm, "cpr_sweeps_noleak.RDS"))
temp2 <- readRDS(paste0(path$dataAbm, "cpr_sweeps_noleak2.RDS"))


wages <- rep(0.05, nrow(temp1$par))
temp1$par<- cbind(temp1$par, wages)

par_ind <- match(colnames(temp1$par), colnames(temp2$par))
temp2$par<- temp2$par[,par_ind]

noleak <- temp1

noleak$par <- rbind(temp1$par, temp2$par)
noleak$data <- c(noleak$data, temp2$data)


rm(temp1)
rm(temp2)

