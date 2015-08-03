clear all; close all; clc

load('sens_meas.txt');

ss = sens_meas;


% analysis for np
[u1,s1,v1]=svd(ss(1:end/2,1:end));
[u2,s2,v2]=svd(ss(1:end/2,2:end));
[u3,s3,v3]=svd(ss(1:end/2,3:end));

% analysis for x[1]
[u4,s4,v4]=svd(ss(end/2+1:end,1:end));
[u5,s5,v5]=svd(ss(end/2+1:end,2:end));
[u6,s6,v6]=svd(ss(end/2+1:end,3:end));

np_est = diag(s1)';
x1_est = diag(s4)';

est = [np_est; x1_est]';
sv = [1 2 3 4];

figure(1)
bar(est)
xlabel('Singular Values')
ylabel('Magnitude')
legend('Cumulative Production (n_p)', 'Mole Fraction (x_1)')
text(2.0,3.5,'Principal Eigenvalue Contributions')
text(2.0,3.0,'h_f     E_{MV}     cond_f     tray_f')
line([1.9 0.85],[3.0 2.5])
line([1.9 1.15],[2.9 0.5])

line([2.4 1.85],[2.7 0])
line([2.45 2.15],[2.7 0])

line([2.85 1.85],[2.7 0])

line([3.2 2.15],[2.7 0])

figure(2)
semilogy(sv,np_est,'r-','LineWidth',3)
hold on
semilogy(sv,x1_est,'b--','LineWidth',3)
xlabel('Singular Values')
ylabel('Magnitude')

figure(3)
time = linspace(0,60,60/2.5+4);
time = time';

s1 = ss(1:end/2,1);
s2 = ss(1:end/2,2);
s3 = ss(1:end/2,3);
s4 = ss(1:end/2,4);

s5 = ss(end/2+1:end,1);
s6 = ss(end/2+1:end,2);
s7 = ss(end/2+1:end,3);
s8 = ss(end/2+1:end,4);

subplot(2,1,1)
plot(time,[0;s1],'r-','LineWidth',2)
hold on
plot(time,[0;s2],'b--','LineWidth',2)
plot(time,[0;s3],'g:','LineWidth',2)
plot(time,[0;s4],'k-.','LineWidth',2)
legend('Heater Efficiency (d(n_p)/d(h_f)','Vapor Efficiency (d(n_p)/d(E_{MV}))',...
    'Condenser Fraction (d(n_p)/d(cond_f))','Tray Fraction d(n_p)/d((tray_f))')
ylabel('Production Sens (n_p)')

subplot(2,1,2)
plot(time,[0;s5],'r-','LineWidth',2)
hold on
plot(time,[0;s6],'b--','LineWidth',2)
plot(time,[0;s7],'g:','LineWidth',2)
plot(time,[0;s8],'k-.','LineWidth',2)
legend('Heater Efficiency (d(x_1)/d(h_f)','Vapor Efficiency (d(x_1)/d(E_{MV}))',...
    'Condenser Fraction (d(x_1)/d(cond_f))','Tray Fraction d(x_1)/d((tray_f))')
ylabel('Mole Frac Sens (x_1)')

xlabel('Time (min)')


%hold on
%disp(u2)
%disp(s2)
%disp(v2)

% [u2,s2,v2]=svd(ss(2:end,2:end));
% bar(diag(s2))
% disp(u2)
% disp(s2)
% disp(v2)
% 
% [u2,s2,v2]=svd(ss(3:end,3:end));
% bar(diag(s2))
% disp(u2)
% disp(s2)
% disp(v2)
