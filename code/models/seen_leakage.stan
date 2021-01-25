data {
  int<lower=0> N;
  int Y[N];
  int X[N];
}

parameters {

  real<lower=0> sigma;
  real a_mu;
  vector[2] a;
  real<lower=0> sigma_a;
}

model {
  vector[N] mu;
  a ~ normal(0, 1.5);
  a_mu ~ normal(0, 1);
  sigma_a ~ exponential(1);
  sigma ~ exponential(1);
  
  for(i in 1:N){
    mu[i] = a_mu + a[X[i]]*sigma_a;
  }
  
  for(i in 1:N){
  Y[i] ~ bernoulli_logit(mu[i]);
  }
}

