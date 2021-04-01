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

#################################################################
################# Build FULLL ###################################


temp1 <- readRDS(paste0(path$dataAbm, "cpr_sweeps_full.RDS"))
temp2 <- readRDS(paste0(path$dataAbm, "cpr_sweeps_full2.RDS"))
temp3 <- readRDS(paste0(path$dataAbm, "cpr_sweeps_full3.RDS"))
temp4 <- readRDS(paste0(path$dataAbm, "cpr_sweeps_full4.RDS"))
temp5 <- readRDS(paste0(path$dataAbm, "cpr_sweeps_full5.RDS"))

colnames(temp1[[1]])
colnames(temp2[[1]])
colnames(temp3[[1]])
colnames(temp4[[1]])
colnames(temp5[[1]])

temp1$par <- sweeps
temp2$par <- sweeps2
temp3$par <- sweeps3
temp4$par <- sweeps4
temp5$par <- sweeps5


degradability <- rep(1, nrow(temp1$par))
temp1$par<- cbind(temp1$par, degradability)

degradability <- rep(1, nrow(temp2$par))
temp2$par<- cbind(temp2$par, degradability)


learn_type <- rep("income", nrow(temp1$par))
temp1$par<- cbind(temp1$par, learn_type)

learn_type <- rep("income", nrow(temp2$par))
temp2$par<- cbind(temp2$par, learn_type)

learn_type <- rep("income", nrow(temp3$par))
temp3$par<- cbind(temp3$par, learn_type)




par_ind <- match(colnames(temp1$par), colnames(temp2$par))
temp2$par<- temp2$par[,par_ind]

par_ind <- match(colnames(temp1$par), colnames(temp3$par))
temp3$par<- temp3$par[,par_ind]

par_ind <- match(colnames(temp1$par), colnames(temp4$par))
temp4$par<- temp4$par[,par_ind]

par_ind <- match(colnames(temp1$par), colnames(temp5$par))
temp5$par<- temp5$par[,par_ind]


full <- temp1

nrow(temp1$par)
nrow(temp2$par)
nrow(temp3$par)
nrow(temp4$par)
nrow(temp5$par)

length(temp1$data)
length(temp2$data)
length(temp3$data)
length(temp4$data)
length(temp5$data)

full$par <- rbind(full$par, temp2$par, temp3$par, temp4$par, temp5$par)
full$data <- c(full$data, temp2$data, temp3$data, temp4$data, temp5$data)


rm(temp1)
rm(temp2)
rm(temp3)
rm(temp4)
rm(temp5)