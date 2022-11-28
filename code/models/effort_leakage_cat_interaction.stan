data{
    int N;
    int K;
    real mu_1;    
    vector[N] Y; // Outcome
    vector[N] Y0; // Outcome non standardized
    int X1[N];   // Seen forest theft 
    int X2[N];   // Blames non-locals
    int C[N];   // Seen forest theft 
    int INT[N];  // Interviewer Effect
    int S[N];     // Shehia
    matrix[N, K] Z; // Controls
    vector[4] alpha;
}

transformed data{
  int YB[N];
  for(i in 1:N){
    if(Y0[i]== 0) YB[i] = 0;
    if(Y0[i] > 0) YB[i] = 1;
  }
}

parameters{
    simplex[4] delta [2];
    simplex[4] delta2 [2];
    real<lower =0> sigma_X1[2];
    real<lower =0> sigma_X1X2[2];
    real<lower =0> sigma_INT[2];
    real<lower =0> sigma_S[2];
    real<lower =0> sigma_C[2];
    vector[24] bS [2];
    vector[6]  bINT [2];
    vector[2]  bC [2];
    vector[2]  bX [2];
    vector[2]  bX1X2 [2];
    real a[2];
    real bX2[2];
    real<lower=0> sigma;
    vector[K] beta [2];
}

model{
     vector[N] mu;
     vector[N] p;
     vector[5] delta_j [2];
     vector[5] delta_j2 [2];
     sigma ~ exponential( 1 );
     for (i in 1:2){
       bINT[i] ~ normal(0, 1);
       bS[i] ~ normal(0, 1);
       bC[i] ~ normal(0, 1);
       bX2[i] ~ normal(0, 1);
       bX[i] ~ normal(0, 1);
       bX1X2[i] ~ normal(0, 1);
       sigma_X1[i] ~ exponential( 1 );
       sigma_X1X2[i] ~ exponential( 1 );
       sigma_S[i] ~ exponential (2);
       sigma_INT[i] ~ exponential (2);
       sigma_C[i] ~ exponential (2);
       beta[i] ~ normal(0, .5);
       delta[i] ~ dirichlet( alpha );
       delta_j[i] = append_row(0, delta[i]);
       delta2[i] ~ dirichlet( alpha );
       delta_j2[i] = append_row(0, delta2[i]);
      }
     a[1] ~ normal(mu_1, 1);
     a[2] ~ normal(4, 1);
     for(i in 1:N){
        mu[i] = a[1] + bX[1][X1[i]]*sigma_X1[1]  + bX2[1]*sum(delta_j[1][1:X2[i]]) + (bX1X2[1][X1[i]]*sigma_X1X2[1]) * sum(delta_j2[1][1:X2[i]])  + bS[1][S[i]]*sigma_S[1] + bINT[1][INT[i]]*sigma_INT[1] +  bC[1][C[i]]*sigma_C[1]  + Z[i]*beta[1];
        p[i] =  a[2] + bX[2][X1[i]]*sigma_X1[2]  + bX2[2]*sum(delta_j[2][1:X2[i]]) + (bX1X2[2][X1[i]]*sigma_X1X2[2]) * sum(delta_j2[2][1:X2[i]])  + bS[2][S[i]]*sigma_S[2] + bINT[2][INT[i]]*sigma_INT[2] +  bC[2][C[i]]*sigma_C[2] +  Z[i]*beta[2];
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
