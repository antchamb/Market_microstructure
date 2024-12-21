clc, clearvars, close all;


% I use Statistics and Machine Learning Toolbox for exponential law

P0 = 10;
T = 4 * 3600;

function[Sn] = S_sim(n)
    % first we estimate the lambda
    lambda = 1/300;
    % exprnd simulate exponential law with the mean as an input
    Sn = exprnd(1/lambda, n, 1);
end


function[Nt] = compute_Nt(t, Tn)
    N_t = Tn(Tn <= t);
    Nt = length(N_t);
end

function Jn = get_Jn_m3(Tn)
    p = [1/4, 1/6, 1/12];
    increments = [1, 2, 3]; % Valeurs possibles des incréments
    Jn_values = randsample(increments, length(Tn), true, p);

    binary_v = 2 * randi([0, 1], length(Tn), 1) - 1;
    Jn = Jn_values .* binary_v; % Multiplier par la direction
end



Sn = S_sim(1000);

Tn = cumsum(Sn);
Tn = Tn(Tn < T); 


Jn_m1 = 2 * randi([0, 1], length(Tn), 1) - 1;
Jn_m3 = get_Jn_m3(Tn);

t_values = 0:T;
Pt_m1 = zeros(size(t_values));
Pt_m3 = Pt_m1;

for i = 1:length(t_values)
    t = t_values(i);
    Nt = compute_Nt(t, Tn);
    Pt_m1(i) = P0 + sum(Jn_m1(1:Nt));
    Pt_m3(i) = P0 + sum(Jn_m3(1:Nt));
end


figure;
plot(t_values, Pt_m1, 'LineWidth', 1.5);
title('Simulation of P_t , m = 1');
xlabel('time');
ylabel('Pt');

figure;
plot(t_values, Pt_m3, 'LineWidth', 1.5);
title('Simulation of P_t , m = 3');
xlabel('time');
ylabel('Pt');

figure;
stairs(Tn, 1:length(Tn), 'LineWidth', 1.5);
title('Simulation de la séquence Tn')
xlabel('time');
ylabel('Tn');
