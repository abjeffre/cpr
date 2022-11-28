data{
    int N;
    int K;
    vector[N] Y; // Outcome
    vector[N] Y0; // Outcome non standardized
    int X1[N];   // Seen forest theft 
    int X2[N];   // Blames non-locals
    int C[N];   // Seen forest theft 
    int INT[N];  // Interviewer Effect
    int S[N];     // Shehia
    matrix[N, K] Z; // Controls
}

transformed data{
  int YB[N];
  for(i in 1:N){
    if(Y0[i]== 0) YB[i] = 0;
    if(Y0[i] > 0) YB[i] = 1;
  }
}

parameters{
    matrix[2,2] z [2];
    vector<lower=0>[2] Sigma_X[2];
    cholesky_factor_corr[2] L_RhoX[2];
    real<lower =0> sigma_INT[2];
    real<lower =0> sigma_S[2];
    real<lower =0> sigma_C[2];
    vector[24] bS [2];
    vector[6]  bINT [2];
    vector[2]  bC [2];
    real a[2];
    real<lower=0> sigma;
    vector[K] beta [2];
}

transformed parameters{
    matrix[2,2] bX[2];
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
       bINT[i] ~ normal(0, .5);
       bS[i] ~ normal(0, .5);
       bC[i] ~ normal(0, .5);
       sigma_S[i] ~ exponential (2);
       sigma_INT[i] ~ exponential (2);
       sigma_C[i] ~ exponential (2);
       beta[i] ~ normal(0, .5);
      }
     a[1] ~ normal(4, 1);
     a[2] ~ normal(4, 1);
     for(i in 1:N){
        mu[i] = a[1] + bX[1][X1[i],  X2[i]]+ bS[1][S[i]]*sigma_S[1] + bINT[1][INT[i]]*sigma_INT[1] +  bC[1][C[i]]*sigma_C[1]  + Z[i]*beta[1];
        p[i] =  a[2] + bX[2][X1[i],  X2[i]]+ bS[2][S[i]]*sigma_S[2] + bINT[2][INT[i]]*sigma_INT[2] +  bC[1][C[i]]*sigma_C[2] +  Z[i]*beta[2];
      }
    // Hurdle Stage 1
    YB ~ bernoulli_logit(p);
    // Normal Hurdle Stage 2
    for (i in 1:N){
      if(YB[i]==1){  
      Y[i] ~ normal(mu[i], sigma);
      }
    }
  
}

// generated quantities{
//  vector[N] log_lik;
//  vector[N] p;
//  
// for(i in 1:N){
//     p[i] = a[2] + bX[2][X1[i], X2[i]]+ bINT[2][E[i]]*sigma_e[2];
//          }
      
//
// for ( i in 1:N ) {
//   if(Y[i]==0){
//  log_lik[i] = normal_lpdf( W[i] | wta_tru[i] , U[i] ) + bernoulli_logit_lpmf( Y[i] | p[i] );
//   }else{
//  log_lik[i]= bernoulli_logit_lpmf( Y[i] | p[i] );
//   }
// }
// }
