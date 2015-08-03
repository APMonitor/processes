clc; clear all; close all

nzd = 56100; % non-zeros along diagonal
nb = 110; % number of blocks
nbmax = 1018; % max block size
nbmin = 2; % min block size

% original sparsity pattern
load apm_jac.txt
fs = apm_jac;
logicvec = ones(size(fs(:,1)));
ss = sparse(fs(:,1),fs(:,2),logicvec,nzd,nzd);
ss = sparse(fs(:,1),fs(:,2),fs(:,3),nzd,nzd);
% sf = full(ss);

% modified sparsity pattern
load lbt_v_data.txt % load text file containing "new variable order" data (from apm_lbt.txt)
load lbt_e_data.txt % load text file containing "new equation order" data (from apm_lbt.txt)
load lbt_sb_data.txt % load text file containing "start of blocks" data (from apm_lbt.txt)
v = lbt_v_data;
e = lbt_e_data;
sb = lbt_sb_data;

%%
% % modified matrix
% sm1 = sf;
% sm2 = zeros(size(sm1));
% sm3 = sm2;
% for i = 1:nzd,
%     sm2(i,:) = sm1(v(i),:);
% end
% for i = 1:nzd,
%     sm3(:,i) = sm2(:,e(i));
% end
% 
% [x1,y1] = find(sm1);
% [x3,y3] = find(sm3);

%% 
% modified matrix (keeping in sparse format)
sm1 = ss;
[row,col] = size(sm1);
sm2 = sparse([],[],[],row,col,0); % Create a sparse matrix of zeros
sm3 = sm2;

for i = 1:nzd,
    sm2(i,:) = sm1(v(i),:);
end

for i = 1:nzd,
    sm3(:,i) = sm2(:,e(i));
end

[x1,y1] = find(sm1);
[x3,y3] = find(sm3);

%% Plot the matrices
figure(1)
subplot(1,2,1)
spy(ss)
subplot(1,2,2)
spy(sm3)

figure(2)
subplot(1,2,1)
scatter(x1,y1,3,'bd')
set(gca,'YDir','rev')
ylabel('Variable')
xlabel('Equation')
axis([0 nzd 0 nzd])
text(10000,5000,'Original')
text(17000,8000,'Sparsity')


subplot(1,2,2)
hold on
text(10000,3000,'Lower Block')
text(13000,6000,'Triangular')
text(16000,9000,'Form')
for i = 1:size(sb,2),
    if i<=10,
        plot([sb(i) sb(i)],[0 sb(i)],'k-','LineWidth',1)
        plot([0 sb(i)],[sb(i) sb(i)],'k-','LineWidth',1)
    end
end
scatter(x3,y3,2,'rd')
xlabel('Equation')
set(gca,'YDir','rev')
axis([0 nzd 0 nzd])

% Add another set of axes
h1 = axes('Position', [0.62 0.30 0.15 0.3]);
hold on
for i = 1:size(sb,2),
    plot([sb(i) sb(i)],[0 sb(i)],'k-','LineWidth',1)
    plot([0 sb(i)],[sb(i) sb(i)],'k-','LineWidth',1)
end
scatter(x3,y3,3,'rd')
set(gca,'YDir','rev')
set(gca,'XMinorTick','on','YMinorTick','on')
axis([0 4000 0 4000]) %[0 38 0 38]

% Add another set of axes
h2 = axes('Position', [0.24 0.43 0.1 0.2]);
hold on
scatter(x1,y1,3,'bd')
set(gca,'YDir','rev')
set(gca,'XMinorTick','on','YMinorTick','on')
axis([27000 30000 27000 30000]) %[300 320 300 320]

% Add another set of axes 
h3 = axes('Position', [0.33 0.67 0.1 0.2]);
hold on
scatter(x1,y1,3,'bd')
set(gca,'YDir','rev')
set(gca,'XMinorTick','on','YMinorTick','on')
axis([35500 36500 7600 8400]) %[340 380 50 90]

% Add another set of axes 
h4 = axes('Position', [0.18 0.16 0.1 0.2]);
hold on
scatter(x1,y1,3,'bd')
set(gca,'YDir','rev')
set(gca,'XMinorTick','on','YMinorTick','on')
axis([0 800 28600 29400]) %[200 250 450 480]
