% This model is used for comparison with ode15s
% It isn't used by the APM code

% Virus model from Nowak and May's 2000 book

function xdot=virus_model(t,x)

    kr1 = 1e5;
    kr2 = 0.1;
    kr3 = 2e-7;
    kr4 = 0.5;
    kr5 = 5;
    kr6 = 100;

    %% states
    %% 1: H
    %% 2: I
    %% 3: V
    xdot = zeros(3,1);
    xdot(1) = kr1 - kr2*x(1) - kr3*x(1)*x(3);
    xdot(2) = kr3*x(1)*x(3) - kr4*x(2);
    xdot(3) = -kr3*x(1)*x(3) - kr5*x(3) + kr6*x(2);
