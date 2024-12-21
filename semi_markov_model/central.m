clc, clearvars, close all;

data = readtable('euribor.csv', 'VariableNamingRule', 'preserve');

% Initialisation des Paramètres
P0 = 100;
Tmax = 4 * 3600;
lambda = 1/300;


