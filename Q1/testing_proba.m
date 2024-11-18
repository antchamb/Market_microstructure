clc, clearvars, close all;



function[Sn] = S_sim(n, Nmc)
    lambda = 1/300;
    Sn = exprnd(1/lambda, n, Nmc);
end

function[Jn] = get_Jn_m3(Tn, Nmc)
    
    Jn = rand(length(Tn), Nmc);
    Jn(Jn >= 0.5 + 1/3) = 3;
    Jn(Jn < 0.5 + 1/3 & Jn >= 1/2) = 2;
    Jn(Jn < 0.5) = 1;
    binary_v = 2 * randi([0,1], length(Tn), 1) - 1;
    Jn = Jn .*binary_v;
end

function[Nt] = compute_Nt(t_values, Tn)
    [~, Nmc] = size(Tn);
    Nt = zeros(length(t_values), Nmc);
    for t = 1:length(t_values)
        Nt(t, :) = sum(Tn <= t_values(t), 1);
    end
end

function [Pt] = compute_Pt(t_values, Tn, Jn, P0)
    % Compute Nt using compute_Nt
    Nt = compute_Nt(t_values, Tn);

    % Precompute cumulative sums of Jn
    Jn_cumsum = cumsum(Jn, 1);

    % Preallocate Pt with P0
    [num_t, Nmc] = size(Nt);
    Pt = repmat(P0, num_t, Nmc);

    % Compute Pt using precomputed cumulative sums
    for n = 1:Nmc
        for t = 1:num_t
            % Ensure Nt does not exceed the bounds of Jn_cumsum
            if Nt(t, n) > 0
                Pt(t, n) = P0 + Jn_cumsum(Nt(t, n), n); % Use precomputed cumulative sum
            end
        end
    end
end

% Parameters:
Nmc = 100;
P0 = 10;
T = 4 * 3600;
t_values = 1:T;

Sn = S_sim(1000, Nmc);

Mean_Sn = mean(mean(Sn, 1));
disp('mean duration of Jump is: ');
disp(Mean_Sn);

Tn = cumsum(Sn, 1);

Jn_m1 = 2 * randi([0, 1], length(Tn), 1) - 1;
Jn_m3 = get_Jn_m3(Tn, Nmc);

Nt = compute_Nt(t_values, Tn);

% Pt_m1 = compute_Pt(t_values, Tn, Jn_m1, P0);
Pt_m3 = compute_Pt(t_values, Tn, Jn_m3, P0);

Pt_inf = min(Pt_m3, 1);
 
Proba_Pt_m3 = length(Pt_m3(Pt_m3 <= 0)) / length(Pt_m3);
disp('Proba_Pt_m3');
disp(Proba_Pt_m3);

figure;
stairs(Pt_m3, 'LineWidth', 1.5);
title('Simulation de P_t')
xlabel('time');
ylabel('Pt');