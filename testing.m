clc, clearvars, close all;

function [Sn] = S_sim(n, lambda, Nmc)
    % Simulate exponential inter-arrival times
    Sn = exprnd(1/lambda, n, Nmc);
end

function [Nt] = compute_Nt(t_values, Tn)
    % Count the number of events up to each t in t_values
    Nt = zeros(length(t_values), size(Tn, 2)); % Initialize Nt
    for i = 1:length(t_values)
        Nt(i, :) = sum(Tn <= t_values(i), 1); % Count arrivals for each simulation
    end
end

function [Jn] = get_Jn_m3(Tn)
    Jn = rand(size(Tn));
    Jn(Jn >= 0.6667) = 3;  % 1/3 probability for 3
    Jn(Jn < 0.6667 & Jn >= 0.5) = 2;  % 1/6 probability for 2
    Jn(Jn < 0.5) = 1;  % 1/2 probability for 1

    % Make jumps unbiased by centering around 0
    binary_v = 2 * randi([0, 1], size(Tn)) - 1; % Random sign (-1 or 1)
    Jn = Jn .* binary_v; % Add random signs to jumps
end

function [Pt] = get_Pt(t_values, Tn, Jn, P0)
    % Calculate Nt (number of arrivals up to each time)
    Nt = compute_Nt(t_values, Tn);
    num_t = length(t_values);
    Nmc = size(Tn, 2);

    % Initialize Pt
    Pt = zeros(num_t, Nmc); 
    Pt(1, :) = P0;  % Start with P0 at time 0

    % Update Pt iteratively
    for n = 1:Nmc
        for t = 2:num_t
            current_nt = Nt(t, n); % Number of arrivals up to time t
            if current_nt > 0  % Ensure there is at least one arrival
                Pt(t, n) = P0 + sum(Jn(1:current_nt, n)); % Sum jumps up to Nt
            else
                Pt(t, n) = Pt(t-1, n); % No arrivals, price stays the same
            end
        end
    end
end

% Main Parameters
P0 = 10;
T = 3600;
Nmc = 1000;
t_values = 1:T;

% Simulations
lambda_1 = 660;
lambda_2 = 110;

Sn_1 = S_sim(1000, lambda_1, Nmc);
Tn_1 = cumsum(Sn_1, 1);
Jn_1 = get_Jn_m3(Tn_1);
Pt_1 = get_Pt(t_values, Tn_1, Jn_1, P0);

Sn_2 = S_sim(1000, lambda_2, Nmc);
Tn_2 = cumsum(Sn_2, 1);
Jn_2 = get_Jn_m3(Tn_2);
Pt_2 = get_Pt(t_values, Tn_2, Jn_2, P0);

% Combine simulations
Pt = Pt_1 + Pt_2;

% Plot
figure;
plot(t_values, Pt, 'LineWidth', 1.5);
title('Simulation of P_t , m = 3');
xlabel('time');
ylabel('Pt');
ylim([-20, 20]); % Updated to reflect normalized range

% Probability of Pt <= 0
min_Pt = min(Pt, [], 1);
Proba_Pt = mean(min_Pt <= 0);
disp('Proba_Pt <= 0');
disp(Proba_Pt);
