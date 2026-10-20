function [t,x]=solvemodel(p,withplot)
global Tspan TSP2 TSP1 QCBAR TFBAR
QCBAR= 2;
TFBAR=29;
%% Obtain initial point (steady state mode)
firstguess=[0.06,175,0.005,175,27,25];
options = optimoptions('fsolve','Display','none');
steadystate=fsolve(@(x0) model(0,x0,p,1),firstguess,options);
TSP1=steadystate(2);
TSP2=steadystate(4);

%% Obtain variables values per time (Dynamic mode)
[t,x]=ode15s(@(t,x)model(t,x,p,0),[0 Tspan],[steadystate,0,0,0]);
C1=x(:,1); T1=x(:,2); C2=x(:,3); T2=x(:,4); TC1=x(:,5); TC2=x(:,6); I1=x(:,7); I2=x(:,8);

  %% Post solve simulation
if withplot
   %% Reconstruct control actions
KC1=p(1);
Ti1=p(2);
KC2=p(3);
Ti2=p(4);
yi=p(8);
TF=TFBAR+yi*(KC1*(TSP1-T1 + (1/Ti1)*I1))+(1-yi)*(KC1*(TSP2-T2 + (1/Ti1)*I2));
QC=min(max(0,QCBAR-yi*(KC2*(TSP2-T2 + (1/Ti2)*I2))-(1-yi)*(KC2*(TSP1-T1 + (1/Ti2)*I1))),min(6,abs(QCBAR-yi*(KC2*(TSP2-T2 + (1/Ti2)*I2))-(1-yi)*(KC2*(TSP1-T1 + (1/Ti2)*I1))))); 
    
   subplot(2,2,1)
    
    plot(t,T1,'r','LineWidth',2)
    ylabel('T1','FontSize',16,'FontWeight','bold')
    xlabel('time','FontSize',16,'FontWeight','bold')
    grid on
    
    subplot(2,2,2)
    plot(t,T2,'r','LineWidth',2)
    ylabel('T2','FontSize',16,'FontWeight','bold')
    xlabel('time','FontSize',16,'FontWeight','bold')
    grid on
    
    subplot(2,2,3)
    plot(t,TF,'LineWidth',2)
    ylabel('TF','FontSize',16,'FontWeight','bold')
    xlabel('time','FontSize',16,'FontWeight','bold')
    grid on
    
    subplot(2,2,4)
    plot(t,QC,'LineWidth',2)
    ylabel('QC','FontSize',16,'FontWeight','bold')
    xlabel('time','FontSize',16,'FontWeight','bold')
    grid on
end