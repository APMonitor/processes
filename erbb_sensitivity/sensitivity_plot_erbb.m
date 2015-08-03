clear all; close all; clc

% addpath('export')

%% ERK parameter sensitivity section
load sens_erk.txt
sensitivity_akt = sens_erk;

time = sensitivity_akt(:,1);

d = sensitivity_akt(:,2:end);
dc36 = -sensitivity_akt(:,end);

figure(1)
subplot(2,2,2);
lw = 2;
semilogy(time,d(:,1),'r-','LineWidth',lw)
hold on
semilogy(time,d(:,2),'g-','LineWidth',lw)
semilogy(time,d(:,3),'k-','LineWidth',lw)
semilogy(time,d(:,4),'b-','LineWidth',lw)
semilogy(time,d(:,5),'m-','LineWidth',lw)
semilogy(time,d(:,6),'y-','LineWidth',lw)
semilogy(time,d(:,7),'r--','LineWidth',lw)
semilogy(time,d(:,8),'g--','LineWidth',lw)
semilogy(time,d(:,9),'k--','LineWidth',lw)
semilogy(time,d(:,10),'b--','LineWidth',lw)
semilogy(time,d(:,11),'m--','LineWidth',lw)
% semilogy(time,d(:,12),'y--','LineWidth',lw)
% semilogy(time,d(:,13),'r-.','LineWidth',lw)
% semilogy(time,d(:,14),'g-.','LineWidth',lw)
% semilogy(time,d(:,15),'k-.','LineWidth',lw)
% semilogy(time,dc36,'b-.','LineWidth',lw)
xlabel({'time step';'(b)'})
ylabel('Sensitivity d(k)/d(erk_{pp})')
axis([0 55 10e-5 10e3])
legend('k103', 'k44', 'k42', 'k52', 'k48', 'kd103', 'k109', 'k69', 'k60', 'k106', 'k8')

% legend_str = {'C_2H_6';'C_3H_8';'C_4H_{10}';'C_5H_{12}';'C_6H_{14}';'C_8H_{18}';...
%     'C_{10}H_{22}';'C_{12}H_{26}';'C_{14}H_{30}';'C_{16}H_{34}';'C_{18}H_{38}';'C_{20}H_{42}';...
%     'C_{24}H_{50}';'C_{28}H_{58}';'C_{32}H_{66}';'C_{36}H_{74}'};

set(gcf,'color','w');

% columnlegend(4, legend_str, 'Location', 'NorthWest', 'boxon');

ss = d;

% analysis for tc
[u1,s1,v1]=svd(ss');

s1_est = diag(s1)';

sv = linspace(1,16,16);

% export_fig sensitivity_d86 -eps 
%saveas(h,'sensitivity','eps')

subplot(2,2,4)
bar(s1_est)
xlabel({'Singular Values';'(d)'})
ylabel('Magnitude')

set(gcf,'color','w');

% export_fig singular_values_d86 -eps 

%% AKT parameter sensitivity section
load sens_akt.txt
sensitivity_akt = sens_akt;

time = sensitivity_akt(:,1);

d = sensitivity_akt(:,2:end);
dc36 = -sensitivity_akt(:,end);

subplot(2,2,1)
lw = 2;
semilogy(time,d(:,1),'r-','LineWidth',lw)
hold on
semilogy(time,d(:,2),'g-','LineWidth',lw)
semilogy(time,d(:,3),'k-','LineWidth',lw)
semilogy(time,d(:,4),'b-','LineWidth',lw)
semilogy(time,d(:,5),'m-','LineWidth',lw)
semilogy(time,d(:,6),'y-','LineWidth',lw)
semilogy(time,d(:,7),'r--','LineWidth',lw)
semilogy(time,d(:,8),'g--','LineWidth',lw)
semilogy(time,d(:,9),'k--','LineWidth',lw)
semilogy(time,d(:,10),'b--','LineWidth',lw)
semilogy(time,d(:,11),'m--','LineWidth',lw)
% semilogy(time,d(:,12),'y--','LineWidth',lw)
% semilogy(time,d(:,13),'r-.','LineWidth',lw)
% semilogy(time,d(:,14),'g-.','LineWidth',lw)
% semilogy(time,d(:,15),'k-.','LineWidth',lw)
% semilogy(time,dc36,'b-.','LineWidth',lw)
xlabel({'time step';'(a)'})
ylabel('Sensitivity d(k)/d(akt_{pp})')
axis([0 55 10e-5 350])
legend('k103', 'k44', 'k42', 'k52', 'k48', 'kd103', 'k109', 'k69', 'k60', 'k106', 'k8')

% legend_str = {'k6';'k8';'k60';'kd68';'k69';'kd75';...
%     'kd96';'kd104';'k109';'kd109';'k42';'k48';...
%     'kd49';'k52';'k44'};

set(gcf,'color','w');

% columnlegend(4, legend_str, 'Location', 'SouthEast', 'boxon');

ss = d;

% analysis for tc
[u1,s1,v1]=svd(ss'); % look at u or v value; 55x55, find transpose, look at rows

s1_est = diag(s1)';

sv = linspace(1,16,16);

% export_fig sensitivity_d86 -eps 
%saveas(h,'sensitivity','eps')

subplot(2,2,3) % put on semilog plot
bar(s1_est)
xlabel({'Singular Values';'(c)'})
ylabel('Magnitude')

set(gcf,'color','w');

% export_fig singular_values_d86 -eps 