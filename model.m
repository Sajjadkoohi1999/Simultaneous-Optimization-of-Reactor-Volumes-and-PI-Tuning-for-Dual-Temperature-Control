function dx=model(t,x,p,initialize)
global TSP1 TSP2 QCBAR TFBAR 
%% Constant variables
DH=-35; VC=100; TCF=25; A=900; Q=2.5; QC=2; TF=29; CF=0.6; E=10.1; K0=2*(1e+3); R=1.98*(1e-3); U=4*(1e-5); 
RHO=850; RHOC=1000; CP=1.35*(1e-4); CPC=1e-3;   B=DH/(RHO*CP);   ac=(U*A)/(RHOC*VC*CPC);

%% Optimization parameters @ initialization (steady state mode)
if initialize==1
    V1=p(5);
    V2=p(6);
    yc=p(7);
    CFd=0;
    Qd=0;
end
%% Optimization parameters @ Dynamic mode
if initialize==0
KC1=p(1); Ti1=p(2); KC2=p(3); Ti2=p(4); V1=p(5); V2=p(6); yc=p(7); yi=p(8);
% Disturbances
CFd=-0.1*CF; Qd=0.1*Q;
end
a1=(U*A)/(RHO*V1*CP);
a2=(U*A)/(RHO*V2*CP);
C1=x(1); T1=x(2); C2=x(3); T2=x(4); TC1=x(5); TC2=x(6);
if initialize==0
I1=x(7);
I2=x(8);
J=x(9);
end

%% Cooling direction
TCIN1 = TCF*yc+(1-yc)*TC2;
TCIN2 = TC1*yc+(1-yc)*TCF;

%% Control system (PI)
if initialize==0
e1=TSP1-T1;
e2=TSP2-T2;
dI1=e1; %integral mode of PI for temperature of first reactor
dI2=e2; %integral mode of PI for temperature of second reactor
dJ=(e1)^2+(e2)^2; %objective function
% PI as well as Pairing
TF=TFBAR+yi*(KC1*(e1 + (1/Ti1)*I1))+(1-yi)*(KC1*(e2 + (1/Ti1)*I2));
QC=min(max(0,QCBAR-yi*(KC2*(e2 + (1/Ti2)*I2))-(1-yi)*(KC2*(e1 + (1/Ti2)*I1))),min(6,abs(QCBAR-yi*(KC2*(e2 + (1/Ti2)*I2))-(1-yi)*(KC2*(e1 + (1/Ti2)*I1)))));
end

%% ODE Equations
dC1=(CF+CFd-C1)/(V1/(Q+Qd)) - K0*(exp(-E/(R*(T1+273))))*C1;
dT1=(TF-T1)/(V1/(Q+Qd)) + B*(-K0*(exp(-E/(R*(T1+273))))*C1)-a1*(T1-TC1);
dC2=(C1-C2)/(V2/(Q+Qd)) + -K0*(exp(-E/(R*(T2+273))))*C2;
dT2=(T1-T2)/(V2/(Q+Qd)) + B*(-K0*(exp(-E/(R*(T2+273))))*C2)-a2*(T2-TC2);
dTC1=(QC/VC)*(TCIN1-TC1)+ac*(T1-TC1);
dTC2=(QC/VC)*(TCIN2-TC2)+ac*(T2-TC2);

%% Obtain variables values per time varying (Dynamic mode)
if initialize==0
dx=[dC1;dT1;dC2;dT2;dTC1;dTC2;dI1;dI2;dJ];
end

%% Obtain initial point (steady state mode)
if initialize==1
dx=[dC1;dT1;dC2;dT2;dTC1;dTC2];
end
end