clc, clearvars, close all;


% I use Statistics and Machine Learning Toolbox for exponential law

P0 = 10;
% t = 4*h;
lambda = 1 / 300;

function[Sn] = S_sim(lambda, Nmc)
    Sn = exprnd(1/lambda, Nmc, 1);
end

Sn = S_sim(0.2, 1000);