% Clear MATLAB
clear all
close all
clc

addpath('apm');

diaglevel = 0;

%server = 'http://xps.apmonitor.com';
server = 'http://localhost';

app = 'virus';

% Clear previous application
apm(server,app,'clear all');

% Simulate with MATLAB
time = 0:0.25:15;
%time = 0:0.25:4;
X = [1e6 0 1e2 2];
[t_ode15s,y] = ode15s('virus_model',time,X(1,1:3));

% add some measurement noise to the virus titers
log10_ym = log10(y(:,3));
randn('seed',-1)
log10_ym = log10_ym + randn(size(log10_ym))*0.5;
ym = 10.^log10_ym;

%y = apm_solve('hiv');

% load model variables and equations
apm_load(server,app,'hiv.apm');

% load csv file
csv_load(server,app,'hiv_with_lv.csv');

% Set up variable classifications for data flow

% State variables (for display only)
apm_info(server,app,'F','lg10_kr1');
apm_info(server,app,'F','lg10_kr2');
apm_info(server,app,'F','lg10_kr3');
apm_info(server,app,'F','lg10_kr4');
apm_info(server,app,'F','lg10_kr5');
apm_info(server,app,'F','lg10_kr6');
apm_info(server,app,'S','H');
apm_info(server,app,'S','I');
apm_info(server,app,'S','V');
apm_info(server,app,'C','LV');

% imode = 7, switch to dynamic simulation
%apm_option(server,app,'nlc.imode',7);
% nodes = 3, internal nodes in the collocation structure (2-6)
apm_option(server,app,'nlc.nodes',3);
% simulation step size for every 'solve' command
apm_option(server,app,'nlc.csv_read',1);
% history horizon
apm_option(server,app,'nlc.hist_hor',0);
% coldstart application (1=sec, 2=min, 3=hr, 4=day, 5=yr)
apm_option(server,app,'nlc.ctrl_units',4);
% select solver
apm_option(server,app,'nlc.solver',1);

apm_option(server,app,'nlc.ev_type',2);

apm_option(server,app,'nlc.diaglevel',diaglevel);
apm_option(server,app,'nlc.coldstart',2);
%apm_option(server,app,'nlc.max_iter',15);
apm_option(server,app,'nlc.time_shift',0);
%apm(server,app,'solve')

apm_option(server,app,'nlc.max_iter',100);

% retrieve solution
csv = apm_sol(server,app);

% coldstart application
% indicate that LV is not measured
apm_option(server,app,'nlc.imode',5);
%apm(server,app,'clear csv');
%csv_load(server,app,'solution.csv');
apm_option(server,app,'nlc.coldstart',2);
apm_option(server,app,'nlc.sensitivity',0);

apm(server,app,'solve')

% retrieve lbt structure
if diaglevel>=2,
    apm_get(server,app,'apm_lbt.txt');
    apm_get(server,app,'apm_jac.txt');
end

apm_option(server,app,'nlc.imode',5);

% turn on parameter estimate
apm_option(server,app,'lg10_kr1.status',1);
apm_option(server,app,'lg10_kr1.dmax',2);
apm_option(server,app,'lg10_kr1.lower',-10);
apm_option(server,app,'lg10_kr1.upper',10);

apm_option(server,app,'lg10_kr2.status',1);
apm_option(server,app,'lg10_kr2.dmax',2);
apm_option(server,app,'lg10_kr2.lower',-10);
apm_option(server,app,'lg10_kr2.upper',10);

apm_option(server,app,'lg10_kr3.status',1);
apm_option(server,app,'lg10_kr3.dmax',2);
apm_option(server,app,'lg10_kr3.lower',-10);
apm_option(server,app,'lg10_kr3.upper',10);

apm_option(server,app,'lg10_kr4.status',0);
apm_option(server,app,'lg10_kr4.dmax',2);
apm_option(server,app,'lg10_kr4.lower',-10);
apm_option(server,app,'lg10_kr4.upper',10);

apm_option(server,app,'lg10_kr5.status',0);
apm_option(server,app,'lg10_kr5.dmax',2);
apm_option(server,app,'lg10_kr5.lower',-10);
apm_option(server,app,'lg10_kr5.upper',10);

apm_option(server,app,'lg10_kr6.status',0);
apm_option(server,app,'lg10_kr6.dmax',2);
apm_option(server,app,'lg10_kr6.lower',-10);
apm_option(server,app,'lg10_kr6.upper',10);

apm_option(server,app,'lv.fstatus',1);

apm_option(server,app,'nlc.mv_step_hor',1000);

% solve a second time with DOF ON
% increase maximum interations
%csv_load(server,app,'fstatus.csv');  % turn on FSTATUS
apm_option(server,app,'nlc.time_shift',0);
apm_option(server,app,'nlc.sensitivity',1);
apm(server,app,'solve')

apm_web(server,app);

%% --------------------------------------------------------------
if (diaglevel>=2),
    % retrieve objective function value
    obj = apm_tag(server,app,'nlc.objfcnval');
    
    % % retrieve equation residuals to get number of equations
    apm_get(server,app,'apm_eqn.txt');
    load apm_eqn.txt
    n = size(apm_eqn,1); % get number of variables
    
    % % retrieve hessian
    apm_get(server,app,'apm_hes_obj.txt');
    load apm_hes_obj.txt
    hs = apm_hes_obj;
    hessian = sparse(hs(:,1),hs(:,2),hs(:,3),n,n);
    
    % retrieve F matrix which is the derivative of the equations with respect
    % to the parameters evaluated at each point
    apm_get(server,app,'apm_jac.txt');
    apm_get(server,app,'apm_jac_fv.txt');
    load apm_jac_fv.txt
    fs = apm_jac_fv;
    m = max(fs(:,2));  % get number of parameters
    fmatrix = sparse(fs(:,1),fs(:,2),fs(:,3),n,m);
    % sensitivity=
    % alpha = confidence level (e.g. 95%)
    % np = number of parameters
    % ndata = number of data points
    % obj = objective function value at the optimal solution
    % Hessian = hessian matrix at the optimal solution
    % bounding_box = confidence interval of parameters at optimal solution
    s = 1;
    % alpha = 0.95;
    np = 6;
    ndata = 61;
    % % Fstat = finv(alpha,np,ndata-np);
    % % samplevar = obj/(ndata-np);
    % % a = diag(hessian);  % generally too large to compute pinv
    % % inva = 1./a;
    % % bounding_box = sqrt(s*np*Fstat*samplevar*inva);
    
    confidenceinterval=95;% as a percentage
    alpha=confidenceinterval/100 +(1-confidenceinterval/100)/2;
    
    degoffreedom = ndata - np;
    tstat = tinv(alpha,degoffreedom);
    covariancemat=(obj/(ndata-np))*pinv(full(fmatrix'*fmatrix));
    bounding_box=tstat*(diag(covariancemat)).^0.5;% this is plus or minus for each parameter
    % covariancemathess=(obj/(ndata-np))*pinv(full(fmatrix'*hessian*fmatrix));
    % bounding_box2=tstat*(diag(covariancemathess)).^0.5;
    % break
    %% --------------------------------------------------------------
end

csv = apm_sol(server,app);
tp = csv.x.time;
H = csv.x.h;
I = csv.x.i;
V = csv.x.v;

X = [H I V];

% plot results
figure(1);
semilogy(tp,X(:,1:3),'-')
hold on
semilogy(t_ode15s,y,'.')
semilogy(time,ym,'rx','MarkerSize',5)
xlabel('Time (days)')
ylabel('Count')
legend('H Predicted','I Predicted','V Predicted','H Actual','I Actual','V Actual','V Measured')

disp('Parameter results')
disp(['kr1: ' num2str(10^(csv.x.lg10_kr1(1)))])
disp(['kr2: ' num2str(10^(csv.x.lg10_kr2(1)))])
disp(['kr3: ' num2str(10^(csv.x.lg10_kr3(1)))])
disp(['kr4: ' num2str(10^(csv.x.lg10_kr4(1)))])
disp(['kr5: ' num2str(10^(csv.x.lg10_kr5(1)))])
disp(['kr6: ' num2str(10^(csv.x.lg10_kr6(1)))])
