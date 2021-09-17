function [gl]=myGL(y,mu,var)
gl=(1/(sqrt(2*pi*var)))*exp(-((y-mu)^2)/(2*var));
end
