data{
  int N;
  vector[N] eff;
  int S[N];
  int E[N];
  int C[N];
  int BL[N];
  int BN[N];
  int BP[N];
  int BO[N];
  int TH[N];
  int IN[N];
  vector[N] W;
  vector[N] TW;
  vector[N] TO;
  vector<lower=0>[2] alpha1;
  vector<lower=0>[4] alpha2;
    
}

transformed data{
  int Y[N];
  
  for(i in 1:N){
    if(eff[i]== 0) Y[i] = 0;
    if(eff[i] > 0) Y[i] = 1;
  }
  
  
}


parameters{
  
  // Shared Parameters Model 
  vector[2] a; 
  
  vector[6] bE [2];
  real<lower=0> sigma_e [2];
  
  vector[24] bS [2];
  real<lower=0> sigma_S [2];
  
  // Varying effects on Index Vars
  matrix[2,4] zTC [2];
  vector<lower=0>[2] Sigma_TC[2];
  cholesky_factor_corr[2] L_RhoTC[2];

  matrix[2,4] zTCI [2,4];
  vector<lower=0>[2] Sigma_TCI[2,4];
  cholesky_factor_corr[2] L_RhoTCI[2,4];

  
  
  // Normal Model 
  real<lower=0> sigma;
  
  
  // Interactions
  
    vector[4] bB[2];
    real bB_mu[2,4];
    real<lower=0> sigma_B[2,4];
    simplex[2] deltajb[3,4] ;

    simplex[2] deltajbi[3, 4] ;
  
  // controls

    vector[2] bIN;
    real bIN_mu[2];
    real<lower=0> sigma_IN[2];
    simplex[4] deltajin [2];
    
    real bTO_mu[2];
    vector[2] bTO;
    real<lower = 0> sigma_TO[2];
    
    real bTW_mu[2];
    vector[2] bTW;
    real<lower = 0> sigma_TW[2];

    real bW_mu[2];
    vector[2] bW;
    real<lower = 0> sigma_W[2];
    
    

}




transformed parameters{
matrix[4,2] bTC[2];
matrix[4,2] bTCI[2,4];

  for(i in 1:2){
  bTC[i] = (diag_pre_multiply(Sigma_TC[i], L_RhoTC[i]) * zTC[i])';
  }
  
  for(j in 1:2){
    for(i in 1:4){
      bTCI[j,i] = (diag_pre_multiply(Sigma_TCI[j,i], L_RhoTCI[j,i]) * zTCI[j,i])';
    }
   }
}





model{
  vector[N] mu;
  vector[N] inter1;
  vector[N] inter2;
  vector[N] p;
  vector[5] delta_jin[2];
  vector[3] delta_jb[2,4];
  vector[3] delta_jbi[2,4];

for(j in 1:2){  
 for(i in 1:4){
    deltajb[j,i] ~ dirichlet(alpha1);
    delta_jb[j,i] = append_row(0, deltajb[j,i]);
    
    deltajbi[j,i] ~ dirichlet(alpha1);
    delta_jbi[j,i] = append_row(0, deltajbi[j,i]);
    }
}


for(i in 1:2){
    deltajin[i] ~ dirichlet(alpha2);
    delta_jin[i] = append_row(0, deltajin[i]);
     
}
  
  

  // Varying Effects
  a[1] ~ normal( 5 , .1 );
  a[2] ~ normal(  3, .5 );
  
  
  
  for(i in 1:2){

  L_RhoTC[i] ~ lkj_corr_cholesky( 2 );
  Sigma_TC[i] ~ normal( 0 , 1 );
  to_vector(zTC[i] ) ~ normal( 0 , 1 );
  
  }
  
  for(j in 1:2){
    for(i in 1:4){

    L_RhoTCI[j,i] ~ lkj_corr_cholesky( 2 );
    Sigma_TCI[j,i] ~ normal( 0 , 1 );
    to_vector(zTCI[j,i] ) ~ normal( 0 , 1 );
  
    }
  }
  
  
  // Shared Priors

  for(i in 1:2){
    bE[i] ~ normal( 0 , .5 ); 
    sigma_e[i] ~ exponential(1);
    
    bS[i] ~ normal(0, .5);
    sigma_S[i] ~ exponential(1);
   
    bW[i] ~normal(0, .5);
    bW_mu[i] ~normal(0, 1);
    sigma_W[i] ~ exponential(1);
    
    bTW[i] ~normal(0, .5);
    bTW_mu[i] ~normal(0, 1);
    sigma_TW[i] ~ exponential(1);

    bTO[i] ~normal(0, .5);
    bTO_mu[i] ~normal(0, 1);
    sigma_TO[i] ~ exponential(1);
    
    bIN[i] ~normal(0, .5);
    bIN_mu[i] ~normal(0, 1);
    sigma_IN[i] ~ exponential(1);
  }
  

  for(j in 1:2){
    for (i in 1:4){
      bB[j,i] ~ normal(0, 1);
      bB_mu[j,i] ~ normal(0, 1);
      sigma_B[j,i]~exponential(1);
    }
  }

  
  //Normal Priors  
  sigma ~ exponential( 2 );
  
  
  
  // MODELS 
  
  // Expectations
  
  for ( i in 1:N ) {
    inter1[i] =
    bTCI[1,1][TH[i], C[i]]*sum(delta_jbi[1,1][1:BL[i]]) +
    bTCI[1,2][TH[i], C[i]]*sum(delta_jbi[1,2][1:BN[i]]) +
    bTCI[1,3][TH[i], C[i]]*sum(delta_jbi[1,3][1:BP[i]]) +
    bTCI[1,4][TH[i], C[i]]*sum(delta_jbi[1,4][1:BO[i]]); 
  
    
    inter2[i] =
    bTCI[2,1][TH[i], C[i]]*sum(delta_jbi[2,1][1:BL[i]]) +
    bTCI[2,2][TH[i], C[i]]*sum(delta_jbi[2,2][1:BN[i]]) +
    bTCI[2,3][TH[i], C[i]]*sum(delta_jbi[2,3][1:BP[i]]) +
    bTCI[2,4][TH[i], C[i]]*sum(delta_jbi[2,4][1:BO[i]]); 
  
  }                                                                                                                                                                                                                                                           
  for(i in 1:N){
    
      mu[i] = a[1]  + inter1[i] + bS[1][S[i]]*sigma_S[1] + 
          bTC[1][TH[i], C[i]] +
         (bB[1,1]*sigma_B[1,1] + bB_mu[1,1]) *sum(delta_jb[1,1][1:BL[i]]) +
         (bB[1,2]*sigma_B[1,2] + bB_mu[1,2]) *sum(delta_jb[1,2][1:BN[i]]) +
         (bB[1,3]*sigma_B[1,3] + bB_mu[1,3]) *sum(delta_jb[1,3][1:BP[i]]) +
         (bB[1,4]*sigma_B[1,4] + bB_mu[1,4]) *sum(delta_jb[1,4][1:BO[i]]) +
         (bIN[1]*sigma_IN[1] + bIN_mu[1])*sum(delta_jin[1][1:IN[i]]) + 
         (bTW[1]*sigma_TW[1] + bTW_mu[1])*TW[i] +
         (bTO[1]*sigma_TO[1] + bTO_mu[1])*TO[i] +
         (bW[1]*sigma_W[1] + bW_mu[1])*W[i];
  }
    
  
     p[i] =  a[2]  + inter2[i] + bS[2][S[i]]*sigma_S[1] + 
     //      bTC[2][TH[i], C[i]] +
     //     (bB[2,1]*sigma_B[2,1] + bB_mu[2,1]) *sum(delta_jb[2,1][1:BL[i]]) +
     //     (bB[2,2]*sigma_B[2,2] + bB_mu[2,2]) *sum(delta_jb[2,2][1:BN[i]]) +
     //     (bB[2,3]*sigma_B[2,3] + bB_mu[2,3]) *sum(delta_jb[2,3][1:BP[i]]) +
     //     (bB[2,4]*sigma_B[2,4] + bB_mu[2,4]) *sum(delta_jb[2,4][1:BO[i]]) +
     //     (bIN[2]*sigma_IN[2] + bIN_mu[2])*sum(delta_jin[2][1:IN[i]]) + 
     //     (bTW[2]*sigma_TW[2] + bTW_mu[2])*TW[i] +
     //     (bTO[2]*sigma_TO[2] + bTO_mu[2])*TO[i] +
     //     (bW[2]*sigma_W[2] + bW_mu[2])*W[i];
     // 
     // 
     //    }
  
  //LIKELIHOODS

  // Bernoulli Hurdle Stage 1
  //Y ~ bernoulli_logit(p);
  
  
  // Normal Hurdle Stage 2
  for (i in 1:N){
    if(Y[i]==1){
      eff[i] ~ normal( mu[i] , sigma );
    }
  }
}



// generated quantities{
//  vector[N] log_lik;
//  vector[N] mu;
//  vector[N] inter1;
//  vector[N] inter2;
//  vector[N] p;
//  vector[5] delta_jin[2];
//  vector[3] delta_jb[2,4];
//  vector[3] delta_jbi[2,4];

//  for(j in 1:2){  
//    for(i in 1:4){
//      delta_jb[j,i] = append_row(0, deltajb[j,i]);
    
//      delta_jbi[j,i] = append_row(0, deltajbi[j,i]);
//      }
//    }

//  for(i in 1:2){
//     delta_jin[i] = append_row(0, deltajin[i]);
//    }
//  for(i in 1:N){
//    mu[i] = v_mu[1] + v[1][1, cat[i]] + inter1[i] + bS[1][S[i]]*sigma_S[1] + 
//         bTCCAT[1][THC[i], cat[i]] +
//         (bB[1,1][cat[i]]*sigma_B[1,1] + bB_mu[1,1]) *sum(delta_jb[1,1][1:BL[i]]) +
//         (bB[1,2][cat[i]]*sigma_B[1,2] + bB_mu[1,2]) *sum(delta_jb[1,2][1:BN[i]]) +
//         (bB[1,3][cat[i]]*sigma_B[1,3] + bB_mu[1,3]) *sum(delta_jb[1,3][1:BP[i]]) +
//         (bB[1,4][cat[i]]*sigma_B[1,4] + bB_mu[1,4]) *sum(delta_jb[1,4][1:BO[i]]) +
//         (bIN[1][cat[i]]*sigma_IN[1])*sum(delta_jin[1][1:IN[i]]) + 
//         (bTW[1][cat[i]]*sigma_TW[1] + bTW_mu[1])*TW[i] +
//         (bTO[1][cat[i]]*sigma_TO[1] + bTO_mu[1])*TO[i] +
//         (bW[1][cat[i]]*sigma_W[1] + bW_mu[1])*W[i];
    
//    
//     p[i] = v_mu[2] + v[2][1, cat[i]] + inter2[i] + bS[2][S[i]]*sigma_S[1] + 
//         bTCCAT[2][THC[i], cat[i]] +
//         (bB[2,1][cat[i]]*sigma_B[2,1] + bB_mu[2,1]) *sum(delta_jb[2,1][1:BL[i]]) +
//         (bB[2,2][cat[i]]*sigma_B[2,2] + bB_mu[2,2]) *sum(delta_jb[2,2][1:BN[i]]) +
//         (bB[2,3][cat[i]]*sigma_B[2,3] + bB_mu[2,3]) *sum(delta_jb[2,3][1:BP[i]]) +
//         (bB[2,4][cat[i]]*sigma_B[2,4] + bB_mu[2,4]) *sum(delta_jb[2,4][1:BO[i]]) +
//         (bIN[2][cat[i]]*sigma_IN[2])*sum(delta_jin[2][1:IN[i]]) + 
//         (bTW[2][cat[i]]*sigma_TW[2] + bTW_mu[2])*TW[i] +
//         (bTO[2][cat[i]]*sigma_TO[2] + bTO_mu[2])*TO[i] +
//         (bW[2][cat[i]]*sigma_W[2] + bW_mu[2])*W[i];
    
//        }
        
        
// for ( i in 1:N ) {
//  if(Y[i]==0){
// log_lik[i] = normal_lpdf( eff[i] | mu[i] , sigma ) + bernoulli_logit_lpmf( Y[i] | p[i] );
//   }else{
//  log_lik[i]= bernoulli_logit_lpmf( Y[i] | p[i] );
//   }
// }
// }
