clc, clearvars, close all;


% I use Statistics and Machine Learning Toolbox for exponential law

P0 = 10;
T = 4 * 3600;

function[Sn] = S_sim(Nmc)
    % first we estimate the lambda
    lambda = 1/300;
    % exprnd simulate exponential law with the mean as an input
    Sn = exprnd(1/lambda, Nmc, 1);
end

Sn = S_sim(1000);

Tn = cumsum(Sn);
Tn = Tn(Tn < T);

figure;
stairs(Tn, 1:length(Tn), 'LineWidth', 1.5);
title('Simulation de la séquence Tn')
xlabel('time');
ylabel('Tn');

Jn = 2 * randi([0, 1], length(Tn), 1) - 1;

function[Nt] = compute_Nt(t, Tn)
    N_t = Tn(Tn <= t);
    Nt = length(N_t);
end

t_values = 0:T;
Pt = zeros(size(t_values));

for i = 1:length(t_values)
    t = t_values(i);
    Nt = compute_Nt(t, Tn);
    Pt(i) = P0 + sum(Jn(1:Nt));
end

figure;
plot(t_values, Pt, 'LineWidth', 1.5);
title('Simulation of P_t')
xlabel('time');
ylabel('Pt')


