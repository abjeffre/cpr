data{
    int N;
    int X[N];
    int C[N];
    int E[N];
}



parameters{
    
    vector[4] bX;
    real<lower =0> Sigma_X;
    real<lower =0> sigma_e;
    vector[6] bE;
    ordered[2] cutpoints;

}


model{
     vector[N] phi;
     
     Sigma_X ~ exponential( 1 );
     sigma_e ~ exponential (1);
     bX ~ normal(0, 1);
     bE ~ normal(0, 1);
     cutpoints ~ normal( 0 , 1 );    
     
     for(i in 1:N){
        phi[i] = bX[X[i]]*Sigma_X+ bE[E[i]]*sigma_e;
      }
      
  C ~ ordered_logistic( phi, cutpoints );
}


generated quantities{
  vector[N] log_lik;
  vector[N] phi;
  
for(i in 1:N){
     phi[i] = bX[X[i]]*Sigma_X+ bE[E[i]]*sigma_e;
          }
      

 for ( i in 1:N ) {
  
  log_lik[i]= ordered_logistic_lpmf( C[i] |phi[i], cutpoints );
   }
}
