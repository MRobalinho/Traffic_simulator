%%------------------------------------------------------------
% MATLAB Traffic Simulator
% Coimbra University
% Manuel Robalinho
% Contact: manuel.robalinho@gmail.com
% Year: 2022
% References:
%  https://www.mathworks.com/help/matlab/ref/uigridlayout.html
%--------------------------------------------------------------
function [var_hour, var_min, var_sec, time_in_seconds] = current_clock()

%UNTITLED5 Summary of this function goes here
% makes the current time in minutes and seconds
% as integer variables

    x_clock = clock;   % Current time
    x1_clock_s = x_clock(6);   % seconds
    x1_clock_m = x_clock(5);   % minute
    x1_clock_h = x_clock(4);   % hour
    %
    data1 = [num2str(x_clock(1)),'-',num2str(x_clock(2)),'-',num2str(x_clock(3)),' ',num2str(x1_clock_h),':',num2str(x1_clock_m),':', num2str(x1_clock_s)];
    d2s = 24*3600;    % convert to seconds
    time_in_seconds  = d2s*datenum(data1);
    %
    var_min  = round(x1_clock_m,0);
    var_sec  = round(x1_clock_s,0);
    var_hour = round(x1_clock_h,0);

end