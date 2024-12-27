clc, clearvars, close all;

euribor_data = readtable('euribor.csv', 'VariableNamingRule', 'preserve');

disp(euribor_data.Properties.VariableNames)

prices = euribor_data.('<CLOSE>');
returns =  diff(prices);

J_hat = sign(returns);

[h, pVal, ~] = adftest(J_hat);

if h == 1
    disp('Data is Stationary')
else
    disp('data i not Stationary')
end

alpha = corr(J_hat(2:end), J_hat(1:end-1));

disp(['Alpha approximation: ', num2str(alpha)]);

figure;
histogram(J_hat, 'Normalization', 'pdf');
title('Distribution of Increments (J_n)');
xlabel('Increments');
ylabel('Density');
grid on;

figure;
autocorr(J_hat, 'NumLags', 20); % Visualize autocorrelation
title('Autocorrelation of J_n');


figure;
plot(abs(returns), 'LineWidth', 1.5);
title('Volatility Clustering in EURIBOR Returns');
xlabel('Time');
ylabel('Absolute Returns');
grid on;

% Absolute returns autocorrelation
abs_returns = abs(returns);
[h, pValue] = lbqtest(abs_returns, 'Lags', 10);
disp(['Ljung-Box Test p-value: ', num2str(pValue)]);
if h == 1
    disp('Volatility clustering detected.');
else
    disp('No volatility clustering detected.');
end
