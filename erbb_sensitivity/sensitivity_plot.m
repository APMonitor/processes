clear all; close all; clc

addpath('export')

load sensitivity_erbb.txt
sensitivity = sensitivity_erbb;

vf = sensitivity(:,1);

d = sensitivity(:,2:end);
dc36 = -sensitivity(:,end);

figure(1)
lw = 2;
plot(vf,d(:,1),'r-','LineWidth',lw)
hold on
plot(vf,d(:,2),'g-','LineWidth',lw)
plot(vf,d(:,3),'k-','LineWidth',lw)
plot(vf,d(:,4),'b-','LineWidth',lw)
plot(vf,d(:,5),'m-','LineWidth',lw)
plot(vf,d(:,6),'y-','LineWidth',lw)
plot(vf,d(:,7),'r--','LineWidth',lw)
plot(vf,d(:,8),'g--','LineWidth',lw)
plot(vf,d(:,9),'k--','LineWidth',lw)
% plot(vf,d(:,10),'b--','LineWidth',lw)
% plot(vf,d(:,11),'m--','LineWidth',lw)
% plot(vf,d(:,12),'y--','LineWidth',lw)
% plot(vf,d(:,13),'r-.','LineWidth',lw)
% plot(vf,d(:,14),'g-.','LineWidth',lw)
% plot(vf,d(:,15),'k-.','LineWidth',lw)
% plot(vf,dc36,'b-.','LineWidth',lw)
xlabel('Boil-off Fraction')
ylabel('Sensitivity d(T_C)/d(x_i)')
axis([0 .5 -100 100])
%legend('C_2H_6','C_3H_8','C_4H_{10}','C_5H_{12}','C_6H_{14}','C_8H_{18}',...
%    'C_{10}H_{22}','C_{12}H_{26}','C_{14}H_{30}','C_{16}H_{34}','C_{18}H_{38}','C_{20}H_{42}',...
%    'C_{24}H_{50}','C_{28}H_{58}','C_{32}H_{66}','C_{36}H_{74}')

legend_str = {'C_2H_6';'C_3H_8';'C_4H_{10}';'C_5H_{12}';'C_6H_{14}';'C_8H_{18}';...
    'C_{10}H_{22}';'C_{12}H_{26}';'C_{14}H_{30}';'C_{16}H_{34}';'C_{18}H_{38}';'C_{20}H_{42}';...
    'C_{24}H_{50}';'C_{28}H_{58}';'C_{32}H_{66}';'C_{36}H_{74}'};

set(gcf,'color','w');

% columnlegend(4, legend_str, 'Location', 'NorthWest', 'boxon');

ss = d;

% analysis for tc
[u1,s1,v1]=svd(ss');

s1_est = diag(s1)';

sv = linspace(1,16,16);

% export_fig sensitivity_d86 -eps 
%saveas(h,'sensitivity','eps')

figure(2)
bar(s1_est)
xlabel('Singular Values')
ylabel('Magnitude')

set(gcf,'color','w');

% export_fig singular_values_d86 -eps 
