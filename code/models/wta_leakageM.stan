data{
    int N;
    vector[N] W;
    int X[N];
    int C[N];
    int E[N];
    vector[N] U;
}

transformed data{
  int Y[N];
  
  for(i in 1:N){
    if(W[i]== 0) Y[i] = 1;
    if(W[i] > 0) Y[i] = 0;
  }
  
  
}


parameters{
    
    matrix[3,4] z [2];
    vector<lower=0>[3] Sigma_X[2];
    cholesky_factor_corr[3] L_RhoX[2];
    
    real<lower =0> sigma_e[2];
    vector[6] bE [2];
    real a[2];

    vector[N] wta_tru;
    real<lower=0> sigma;
}

transformed parameters{
matrix[4,3] bX[2];
for( i in 1:2) bX[i] = (diag_pre_multiply(Sigma_X[i], L_RhoX[i]) * z[i])';

}


model{
     vector[N] mu;
     vector[N] p;
     sigma ~ exponential( 1 );
   
   for (i in 1:2){
     L_RhoX[i] ~ lkj_corr_cholesky( 2 );
     Sigma_X[i] ~ exponential( 1 );
     to_vector( z[i] ) ~ normal( 0 , 1 );
     sigma_e[i] ~ exponential (1);
     bE[i] ~ normal(0, 1);
      }
      
     a[1] ~ normal(10, 4);
     a[2] ~ normal(-2, 2);
     
     for(i in 1:N){
        mu[i] = a[1] + bX[1][X[i], C[i]]+ bE[1][E[i]]*sigma_e[1];
        p[i] =  a[2] + bX[2][X[i], C[i]]+ bE[2][E[i]]*sigma_e[2];
      }

    Y ~ bernoulli_logit(p);
  

  // Normal Hurdle Stage 2
  for (i in 1:N){
    if(Y[i]==0){  
    wta_tru[i] ~ normal(mu[i], sigma);
    W[i] ~ normal( wta_tru[i] , U[i] );
    }
  }
  
}




generated quantities{
  vector[N] log_lik;
  vector[N] p;
  
for(i in 1:N){
     p[i] = a[2] + bX[2][X[i], C[i]]+ bE[2][E[i]]*sigma_e[2];
          }
      

 for ( i in 1:N ) {
   if(Y[i]==0){
  log_lik[i] = normal_lpdf( W[i] | wta_tru[i] , U[i] ) + bernoulli_logit_lpmf( Y[i] | p[i] );
   }else{
  log_lik[i]= bernoulli_logit_lpmf( Y[i] | p[i] );
   }
}
}
