clc, clearvars, close all;

% Functions Toolbox
function[Sn] = S_sim(n, Nmc)
    % n = number of draw for one simulation
    % Nmc = number of simulation
    lambda = 1/300;
    Sn = exprnd(1/lambda, n, Nmc);
end

function[Tn, Pt] = get_Pt(Sn, t_values, E, p, P0)
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



% Initialisation Parameter
P0 = 10;
T = 4 * 3600;
t_values = 0:T;
E_1 = 1;
p_1 = 1/2;
E_3 = [1, 2, 3];
p_3 = [1/4, 1/6, 1/12];
n = 400;
Nmc = 1000;

Sn = S_sim(n, Nmc);

[Tn_1, Pt_m1] = get_Pt(Sn, t_values, E_1, p_1, P0);
[Tn_2, Pt_m3] = get_Pt(Sn, t_values, E_3, p_3, P0);


figure;
stairs(Tn_1, 'LineWidth', 1.5);
title('Simulation of T_n');
xlabel('n');
ylabel('Tn');


figure;
stairs(t_values, Pt_m1, 'LineWidth', 1.5);
title('Simulation of P_t , m = 1');
xlabel('time');
ylabel('Pt');

figure;
stairs(t_values, Pt_m3, 'LineWidth', 1.5);
title('Simulation of P_t , m = 3');
xlabel('time');
ylabel('Pt');


% compute proba negative
min_m1 = min(Pt_m1);
m1_p = length(min_m1(min_m1 <0)) / Nmc;

min_m3 = min(Pt_m3);
m3_p = length(min_m3(min_m3 <0)) / Nmc;

disp(['Proba(Pt < 0 | m = 1) = ', num2str(m1_p)]);
disp(['Proba(Pt < 0 | m = 3) = ', num2str(m3_p)]);
