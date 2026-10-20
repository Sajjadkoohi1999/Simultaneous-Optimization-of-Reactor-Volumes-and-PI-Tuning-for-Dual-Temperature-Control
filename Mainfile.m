clear all
close all
clc
global Tspan tol 
Tspan=10000;
%% Optimization solver (Ga mthod is used which can handle both binary and continuous variables
LB=[0.1,7,0.1,0.1,720,720,0,0];
UB=[2,15,10,10,1080,1080,1,1];
options = optimoptions('ga','Display','iter');
tic;
 [p, OBJ,exitflag] = ga (@obj,8,[],[],[],[],LB,UB,[],[7 8],options);
toc;
exitflag
%% Results
KC1=p(1); Ti1=p(2); KC2=p(3); Ti2=p(4); V1=p(5); V2=p(6); yc=p(7); yi=p(8);
fprintf('J=%d\n',OBJ)
fprintf('KC1=%d\n',KC1)
fprintf('Ti1=%d\n',Ti1)
fprintf('KC2=%d\n',KC2)
fprintf('Ti2=%d\n',Ti2)
fprintf('V1=%d\n',V1)
fprintf('V2=%d\n',V2)
fprintf('yc=%d\n',yc)
fprintf('yi=%d\n',yi)
%Plot results to verify performance & stability
[t,x]=solvemodel(p,1);
