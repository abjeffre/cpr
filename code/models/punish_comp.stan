data{
    int round_p[75];
    vector[75] after;
    vector[75] before;
    int p1[75];
    int id[75];
    int rounds[75];
    int comply_after[75];
    vector[75] harvest_np;
    int cofma[75];
    int game_id[75];
    int ward[75];
    vector[75] age;
    vector[75] twealth;
    int gender[75];
    int edu [75];
    vector[75] pop;
    vector[75] fcover;
    vector[75] lcover;
    int local[75];
    int out[75];
    int buis[75];
    int gov[75];
    int pemba[75];
    int neigh[75];
    matrix[10, 10] dist;
    vector[75] forest_before;
    vector[75] final_forest_np;
    vector[75] comply_before;
    vector<lower=0>[4] alpha;
}
parameters{
    real a;
    vector[23] bw;
    real<lower=0> sigma_ward;
    vector[20] bg;
    real<lower=0> sigma_game_id;
    vector[2] bgn;
    real<lower=0> sigma_gender;
    vector[2] bc;
    real<lower=0> sigma_cofma;
    real bnp;
    real ba;
    real bb;
    real bpr;
    real bf;
    real bff;
    simplex[4] deltan;
    simplex[4] deltal;
    simplex[4] deltao;
    simplex[4] deltap;
    simplex[4] deltab;
    simplex[4] deltag;
    simplex[5] deltaedu;
    real bnei;
    real bpem;
    real bbuis;
    real bgov;
    real bout;
    real btw;
    real bpop;
    real blc;
    real bloc;
    real bfc;
    real bedu;
    real<lower=0> sigma;
}
model{
    vector[75] p;
    vector[5] delta_n;
    vector[5] delta_o;
    vector[5] delta_l;
    vector[5] delta_p;
    vector[5] delta_b;
    vector[5] delta_g;
    vector[7] delta_edu;
    sigma ~ exponential( 1 );
    bfc ~ normal( 0 , 0.5 );
    bloc ~ normal( 0 , 0.5 );
    blc ~ normal( 0 , 0.5 );
    bpop ~ normal( 0 , 0.5 );
    btw ~ normal( 0 , 0.5 );
    bout ~ normal( 0 , 1 );
    bgov ~ normal( 0 , 1 );
    bbuis ~ normal( 0 , 1 );
    bpem ~ normal( 0 , 1 );
    bnei ~ normal( 0 , 1 );
    deltag ~ dirichlet( alpha );
    deltab ~ dirichlet( alpha );
    deltap ~ dirichlet( alpha );
    deltao ~ dirichlet( alpha );
    deltal ~ dirichlet( alpha );
    deltan ~ dirichlet( alpha );
    deltaedu ~ dirichlet( alpha );
    delta_g = append_row(0, deltag);
    delta_b = append_row(0, deltab);
    delta_p = append_row(0, deltap);
    delta_l = append_row(0, deltal);
    delta_o = append_row(0, deltao);
    delta_n = append_row(0, deltan);
    delta_edu = append_row(0, deltaedu);
    bff ~ normal( 0 , 0.5 );
    bf ~ normal( 0 , 0.5 );
    bpr ~ normal( 0 , 0.5 );
    bb ~ normal( 0 , 0.5 );
    ba ~ normal( 0 , 0.5 );
    bnp ~ normal( 0 , 0.5 );
    sigma_cofma ~ exponential( 2 );
    bc ~ normal( 0 , 0.5 );
    sigma_gender ~ exponential( 2 );
    bgn ~ normal( 0 , 0.5 );
    sigma_game_id ~ exponential( 2 );
    bg ~ normal( 0 , 0.5 );
    sigma_ward ~ exponential( 2 );
    bw ~ normal( 0.43 , 0.1 );
    a ~ normal( 0 , 1 );
    for ( i in 1:75 ) {
        p[i] = a + bb * comply_before[i] + bff * final_forest_np[i] + bf * forest_before[i] + bedu * sum(delta_edu[1:edu[i]]) + bnei * sum(delta_n[1:neigh[i]]) + bpem * sum(delta_p[1:pemba[i]]) + bgov * sum(delta_g[1:gov[i]]) + bbuis * sum(delta_b[1:buis[i]]) + bout * sum(delta_o[1:out[i]]) + bloc * sum(delta_l[1:local[i]]) + blc * lcover[i] + bfc * fcover[i] + bpop * pop[i] + bgn[gender[i]] * sigma_gender + btw * twealth[i] + ba * age[i] + bw[ward[i]] * sigma_ward + bg[game_id[i]] * sigma_game_id + bc[cofma[i]] * sigma_cofma + bnp * harvest_np[i] + bpr*round_p[i];
        p[i] = inv_logit(p[i]);
    }
    comply_after ~ binomial( rounds , p );