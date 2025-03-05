clc, clearvars, close all;

function[Sn] = S_sim(n, Nmc, lambda)
    Sn = exprnd(1/lambda, n, Nmc);
end


function[Pt] = get_Pt_1(Sn, t_values, E, p, P0)
    % Sn = simulation of Tn+1 - Tn
    % t_values = discretization of time
    % E = set where Jn can take values
    % p = proba distribution of E
 
    [~, Nmc] = size(Sn);
    Tn = cumsum(Sn);
    Pt = zeros(length(t_values), Nmc);
    
    for i = 1:Nmc
        Jn = randsample(E, length(Tn(:,i)), true, p);
        sign_Jn = 2 * randi([0, 1], length(Tn(:,i)), 1) - 1;
        Jn = sign_Jn .* Jn;
        for t = 1:length(t_values)
            N_t = Tn(:,i);
            Nt= length(N_t(N_t < t));
            Pt(t, i) = P0 + sum(Jn(1:Nt));
        end
    end
end

function[Pt] = get_Pt_2(Sn, t_values, P0)
    % Sn = simulation of Tn+1 - Tn
    % t_values = discretization of time
    % E = set where Jn can take values
    % p = proba distribution of E
 
    [~, Nmc] = size(Sn);
    Tn = cumsum(Sn);
    Pt = zeros(length(t_values), Nmc);
    
    for i = 1:Nmc
        Jn = (-1) .^ (1:length(Tn));
        for t = 1:length(t_values)
            N_t = Tn(:,i);
            Nt= length(N_t(N_t < t));
            Pt(t, i) = P0 + sum(Jn(1:Nt));
        end
    end
end

P0 = 10;
T = 4 * 3600;
t_values = 0:T;
E_1 = 1;
p_1 = 1/2;
E_3 = [1, 2, 3];
p_3 = [1/4, 1/6, 1/12];
n = 500;
Nmc = 1000;


Sn_1 = S_sim(n, Nmc, 1/660);
Pt_1 = get_Pt_1(Sn_1, t_values, E_1, p_1, P0/2);

Sn_2 = S_sim(n, Nmc, 1/110);
Pt_2 = get_Pt_2(Sn_2, t_values, P0/2);

Pt = Pt_1 + Pt_2;

figure;
stairs(t_values, Pt, 'LineWidth', 1.5);
title('Simulation of P_t')
xlabel('time');
ylabel('Pt');

min_Pt = min(Pt);
test = min_Pt(min_Pt < 0);
p = length(min_Pt(min_Pt < 0)) / Nmc;
disp(['Proba(Pt < 0) = ', num2str(p)]);
