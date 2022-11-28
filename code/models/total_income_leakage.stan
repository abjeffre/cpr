data{
    int N;
    int K;
    real mu_1;    
    vector[N] Y; // Outcome
    int X1[N];   // Seen forest theft 
    int X2[N];   // Blames non-locals
    int C[N];   // Seen forest theft 
    int INT[N];  // Interviewer Effect
    int S[N];     // Shehia
    matrix[N, K] Z; // Controls
    vector[4] alpha;
}


parameters{
    simplex[4] delta ;
    simplex[4] delta2 ;
    real<lower =0> sigma_X1;
    real<lower =0> sigma_X1X2;
    real<lower =0> sigma_INT;
    real<lower =0> sigma_S;
    real<lower =0> sigma_C;
    vector[24] bS;
    vector[6]  bINT;
    vector[2]  bC;
    vector[2]  bX;
    vector[2]  bX1X2;
    real a;
    real bX2;
    real<lower=0> sigma;
    vector[K] beta;
}

model{
     vector[N] mu;

     vector[5] delta_j;
     vector[5] delta_j2;
     sigma ~ exponential( 1 );
     bINT ~ normal(0, 1);
     bS ~ normal(0, 1);
     bC ~ normal(0, 1);
     bX2 ~ normal(0, 1);
     bX ~ normal(0, 1);
     bX1X2 ~ normal(0, 1);
     sigma_X1 ~ exponential( 1 );
     sigma_X1X2 ~ exponential( 1 );
     sigma_S ~ exponential (2);
     sigma_INT ~ exponential (2);
     sigma_C ~ exponential (2);
     beta ~ normal(0, .5);
     delta ~ dirichlet( alpha );
     delta_j = append_row(0, delta);
     delta2 ~ dirichlet( alpha );
     delta_j2 = append_row(0, delta2);
     a ~ normal(mu_1, 1);
   
     for(i in 1:N){
        mu[i] = a + bX[X1[i]]*sigma_X1  + bX2*sum(delta_j[1:X2[i]]) + (bX1X2[X1[i]]*sigma_X1X2) * sum(delta_j2[1:X2[i]])  + bS[S[i]]*sigma_S + bINT[INT[i]]*sigma_INT +  bC[C[i]]*sigma_C  + Z[i]*beta;
     }
     for (i in 1:N){
      Y[i] ~ normal(mu[i], sigma);
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
