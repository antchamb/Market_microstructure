clc, clearvars, close all;




% Parameters:
P0 = 10;
T = 3600;

function[Sn] = S_sim(n, lambda)
    Sn = exprnd(lambda, n, 1);
end

function[Nt] = compute_Nt(t, Tn)
    N_t = Tn(Tn <= t);
    Nt = length(N_t);
end

Sn_1 = S_sim(1000, 660);
Tn_1 = cumsum(Sn_1);
Tn_1 = Tn_1(Tn_1 < T);
Nt_1 = compute_Nt(t, Tn_1);

Sn_2 = S_sim(1000, 110);
Tn_2 = cumsum(Sn_2);
Tn_2 = Tn_2(Tn_2 < T);
Nt_2 = compute_Nt(t, Tn_2);
