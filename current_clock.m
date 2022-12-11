function [var_min, var_sec] = current_clock()
%UNTITLED5 Summary of this function goes here
% makes the current time in minutes and seconds
% as integer variables

x_clock = clock;   % Current time
x1_clock_s = x_clock(6);   % seconds
x1_clock_m = x_clock(5);   % minute
%
var_min = round(x1_clock_m,0);
var_sec = round(x1_clock_s,0);

end