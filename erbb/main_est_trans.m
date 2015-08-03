% Clear MATLAB
clear all
close all
clc

% start time
start = datestr(now);

% Include APM libraries
addpath('apm');

% Set server and app as global so they can be accessed in functions
global server
global app
% server = 'http://apmonitor.com';
% server = 'http://byu.apmonitor.com';
% server = 'http://xps.apmonitor.com';
server = 'http://localhost'; % Note: group computer does not have localhost

% Application Name
app = 'erbb_est';

% Clear previous application
apm(server,app,'clear all');

% load model variables and equations
apm_load(server,app,'erbb_log.apm');

% Load data
csv_load(server,app,'horizon_dis.csv');

% State variables (Variables to be estimated)
% Be sure to uncomment here any values that are to be estimated later on
% Turn on status for estimation
apm_info(server,app,'FV','lg_k103');
apm_info(server,app,'FV','lg_k44');
apm_info(server,app,'FV','lg_k42');
apm_info(server,app,'FV','lg_k52');
apm_info(server,app,'FV','lg_k48');
apm_info(server,app,'FV','lg_kd103');
apm_info(server,app,'FV','lg_k109');
apm_info(server,app,'FV','lg_k69');
apm_info(server,app,'FV','lg_k60');
apm_info(server,app,'FV','lg_k106');
apm_info(server,app,'FV','lg_k8');
%Note: only evaluating 11 most sensitive (with respect to erk_pp and
%akt_pp, the same ones as in the plots shown in the paper

apm_info(server,app,'SV','erk_pp');
apm_info(server,app,'SV','akt_pp');

%%
% imode = 7, switch to dynamic simulation
apm_option(server,app,'nlc.imode',7);
% nodes = 3, internal nodes in the collocation structure (2-6)
apm_option(server,app,'nlc.nodes',2);
% coldstart application (1=sec, 2=min, 3=hr, 4=day, 5=yr)
apm_option(server,app,'nlc.ctrl_units',1);
% read data from CSV file
apm_option(server,app,'nlc.csv_read',1);
% turn off/on web viewer file generation
apm_option(server,app,'nlc.web',0);
% select solver
apm_option(server,app,'nlc.solver',1); %2: BPOPT; 3: IPOPT; 4: SNOPT; experiment with different solvers
% max number of iterations
apm_option(server,app,'nlc.max_iter',50);
% history horizon
apm_option(server,app,'nlc.hist_hor',0);
% set web plot update frequency
apm_option(server,app,'nlc.web_plot_freq',6);
% set diagnostic level
apm_option(server,app,'nlc.diaglevel',2);

% Pre-solve
disp('Starting sequential simulation')
tic
output = apm(server,app,'solve');
disp(output);
toc
disp('Completed sequential simulation')

% Retrieve the results and put them into matlab
apm_get(server,app,'results.csv')

% Clear current CSV file
apm(server,app,'clear csv');

% Load new CSV file
csv_load(server,app,'results.csv');

% step horizon
apm_option(server,app,'nlc.mv_step_hor',1000);
% turn off time shift
apm_option(server,app,'nlc.time_shift',0);
apm_option(server,app,'nlc.coldstart',1);
apm_option(server,app,'nlc.imode',5);

% Simultaneous solution with all parameters turned off
% disp('Starting primary simultaneous solution')
% output = apm(server,app,'solve');
% disp(output);

%%
disp('Perturb parameters')

% Option to debug in perturb_trans function
% dbstop in perturb_trans

% perturb_trans each parameter according to global erk_pp sensitivity
% perturb_trans('lg_k103');
% perturb_trans('lg_k44');
% perturb_trans('lg_k42');
% perturb_trans('lg_k52');
% perturb_trans('lg_k48');
% perturb_trans('lg_kd103');
% perturb_trans('lg_k109');
% perturb_trans('lg_k69');
% perturb_trans('lg_k60');
% perturb_trans('lg_k106');
% perturb_trans('lg_k8');

% Load perturbed value
% apm_meas(server,app,'lg_k103',-8.073090131);
% apm_meas(server,app,'lg_k44',-4.965687018);
% apm_meas(server,app,'lg_k42',-4.22766926);
% apm_meas(server,app,'lg_k52',-5.065002985);
% apm_meas(server,app,'lg_k48',-4.611955647);
% apm_meas(server,app,'lg_kd103',-1.768828642);
% apm_meas(server,app,'lg_k109',-5.262722762);
% apm_meas(server,app,'lg_k69',-4.522482669);
% apm_meas(server,app,'lg_k60',-2.617260192);
% apm_meas(server,app,'lg_k106',-4.901551481);
% apm_meas(server,app,'lg_k8',-6.192595887);


% apm_option(server,app,'erk_pp.fstatus',1);
% apm_option(server,app,'akt_pp.fstatus',1);
% csv_load(server,app,'fstatus.csv');  % turn on FSTATUS
apm_option(server,app,'nlc.web',1);
% apm_option(server,app,'nlc.coldstart',1);
% apm_option(server,app,'nlc.imode',5);
apm_option(server,app,'nlc.sensitivity',1);

disp('Starting coldstart estimation')
time_now = datestr(now) % Display current time
tic
output = apm(server,app,'solve');
disp(output);
toc
disp('Completed coldstart estimation')

apm_web(server,app);

% break

% Retrieve initial solution
csv0 = apm_sol(server,app);
results0 = cell2mat(csv0(2:end,:));
erk_pp0 = results0(:,454);
akt_pp0 = results0(:,455);

%%
% % Add options
% apm_option(server,app,'nlc.time_shift',0);
% apm_option(server,app,'nlc.web',1);

apm_option(server,app,'nlc.coldstart',0); % Turns off automatically with successful solution
apm_option(server,app,'nlc.imode',5); % change to 5 or 8

disp('Starting estimation')
time_now = datestr(now) % Display current time
tic
output = apm(server,app,'solve');
disp(output);
toc
disp('Completed estimation')

apm_get(server,app,'apm_lbt.txt'); % Return the lower block triangular form
apm_get(server,app,'apm_jac.txt'); % Return the Jacobian

% % Retrieve full sensitivity analysis
% apm_get(server,app,'apm_sens_fv.txt');
% 
% Open web-viewer
apm_web(server,app);

% End time
end_time = datestr(now);
disp(start)
disp(end_time)

%% Plot results
% Retrieve optimized solution
csv = apm_sol(server,app);
results = cell2mat(csv(2:end,:));
tp = results(:,1); % returns list of time points
erk_pp_meas = results(:,2);
akt_pp_meas = results(:,3);
erk_pp = results(:,454);
akt_pp = results(:,455);

% plot erk_pp results
figure(1);
subplot(1,2,2);
plot(tp,erk_pp_meas,'ok',tp,erk_pp0,'-r',tp,erk_pp,'--b');   %Plots original points, initial solution, optimal solution
% plot(tp,erk_pp_meas,'ok',tp,erk_pp,'-b');   %Plots original points, initial solution, optimal solution
xlabel('time (sec)');
ylabel('[pERK] (molecules/cell)');
legend('pERK measured','pERK_0','pERK',2);
% legend('erk-pp meas','erk-pp',1);
% title('ERK-PP values');

% Plot akt_pp results
subplot(1,2,1);
plot(tp,akt_pp_meas,'ok',tp,akt_pp0,'-r',tp,akt_pp,'--b');   %Plots original points, initial solution, optimal solution
% plot(tp,akt_pp_meas,'ok',tp,akt_pp,'-b');   %Plots original points, initial solution, optimal solution
xlabel('time (sec)');
ylabel('[pAkt] (molecules/cell)');
legend('pAkt measured','pAkt_0','pAkt',2);
% legend('akt-pp meas','akt-pp',2);
% title('AKT-PP values');

% Sound beep to notify of finish
beep

