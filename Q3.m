clc, clearvars, close all;

function[Sn] = S_sim(n, lambda, Nmc)
    Sn = exprnd(lambda, n, Nmc);
end

function[Nt] = compute_Nt(t_values, Tn)
    [~, Nmc] = size(Tn);
    Nt = zeros(length(t_values), Nmc);
    for t = 1:length(t_values)
        Nt(t, :) = sum(Tn <= t_values(t), 1);
    end
end

function[Jn] = get_Jn_m3(Tn)
    Jn = rand(length(Tn));
    Jn(Jn >= 0.5 + 1/3) = 3;
    Jn(Jn < 0.5 + 1/3 & Jn >= 1/2) = 2;
    Jn(Jn < 0.5) = 1;
    binary_v = 2 * randi([0,1], length(Tn), 1) - 1;
    Jn = Jn .*binary_v;
end


function [Pt] = get_Pt(t_values, Tn, Jn, P0)
    % Calcul de Nt
    Nt = compute_Nt(t_values, Tn);

    % Calcul cumulatif des Jn
    Jn_cumsum = cumsum(Jn, 1);

    % Dimensions
    [num_t, Nmc] = size(Nt);
    [max_Nt, ~] = size(Jn_cumsum);

    % Initialisation de Pt
    Pt = repmat(0.5 * P0, num_t, Nmc);

    % Calcul de Pt
    for n = 1:Nmc
        for t = 1:num_t
            if Nt(t, n) > 0 && Nt(t, n) <= max_Nt
                Pt(t, n) = 0.5 * P0 + Jn_cumsum(Nt(t, n), n);
            end
        end
    end
end


% Parameters:
P0 = 10;
T = 3600;
Nmc = 1000;
t_values = 1:T;

Sn_1 = S_sim(1000, 660, Nmc);
Tn_1 = cumsum(Sn_1, 1);
% Tn_1 = Tn_1(Tn_1 < T);
Nt_1 = compute_Nt(t_values, Tn_1);
Jn_1 = get_Jn_m3(Tn_1);
Pt_1 = get_Pt(t_values, Tn_1, Jn_1, P0);


Sn_2 = S_sim(1000, 110, Nmc);
Tn_2 = cumsum(Sn_2, 1);
% Tn_2 = Tn_2(Tn_2 < T);
Nt_2 = compute_Nt(t_values, Tn_2);
Jn_2 = (2 * randi([0, 1]) - 1) * ((-1).^((1:length(Tn_2)) + 1));
Pt_2 = get_Pt(t_values, Tn_2, Jn_2, P0);

Pt = Pt_1 + Pt_2;

figure;
plot(t_values, Pt, 'LineWidth', 1.5);
title('Simulation of P_t , m = 3');
xlabel('time');
ylabel('Pt');
ylim([0, 20]);

% mdl = fitlm(Pt(1:end-1,1), Pt(2:end,1));
% phi = mdl.Coefficients.Estimate(2);
% disp(['Phi (force du retour): ', num2str(phi)]);
% 
% [h, pValue] = adftest(Pt(:,1));
% disp(['Stationnarité: ', num2str(h), ', p-value: ', num2str(pValue)]);

min_Pt = min(Pt, [], 1);

Proba_Pt = length(min_Pt(min_Pt <= 0)) / length(min_Pt);
disp('Proba_Pt <= 0');
disp(Proba_Pt);



