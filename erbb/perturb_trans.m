function perturb_trans(x)
%PERTURB function takes as an input any parameter specified and puts a
%perturbed value into apm

% Call up global variables
global server
global app

% Load original parameter value
para_x = apm_tag(server,app,strcat(x,'.meas'));

% % Perturb by +/-.5
% new_x = lgrange_trans(para_x);
% % Insert the new value to apm
% apm_meas(server,app,x,new_x);
% % disp([strcat('new ',x,' value:') & new_x]);

% define upper and lower bound, then input into apm
upper_bound = para_x + 0.5;
lower_bound = para_x - 0.5;
% change some options for APM solver
apm_option(server,app,strcat(x,'.status'),1);
apm_option(server,app,strcat(x,'.dmax'),1000);
apm_option(server,app,strcat(x,'.upper'),upper_bound);
apm_option(server,app,strcat(x,'.lower'),lower_bound);
apm_option(server,app,strcat(x,'.dcost'),1e-3); % penalty from previous value


end

