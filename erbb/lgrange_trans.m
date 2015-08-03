function y = lgrange_trans(x)
%lgrange function takes the initial value of the parameter and randomly finds 
%plus or minus 1 log of the inital value and outputs a new value
%Find a random number between -.5 and .5
a = rand;
b = 0.05 * a - 0.0025;
if x == 0
    y = b;
else
	y = x + b;
end


end

