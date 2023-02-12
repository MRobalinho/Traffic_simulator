%%------------------------------------------------------------
% MATLAB Traffic Simulator
% Coimbra University
% Manuel Robalinho
% Contact: manuel.robalinho@gmail.com
% Year: 2022
% References:
%  https://www.mathworks.com/help/matlab/ref/uigridlayout.html
%--------------------------------------------------------------
function [hroad, hroad_coordinates] = change_street_light(hroad, hroad_coordinates, color_street_light)
%UNTITLED4 Summary of this function goes here
disp('> Change street light');
%   Detailed explanation goes here
if hroad_coordinates(1,10) == 0
    hroad_coordinates(1,10) = 1; % Street light on
    hroad_coordinates(2,10) = 1; % Street light on
    hroad_coordinates(3,10) = 0; % Street light off
    hroad_coordinates(4,10) = 0; % Street light off
else
    hroad_coordinates(1,10) = 0; % Street light off
    hroad_coordinates(2,10) = 0; % Street light off
    hroad_coordinates(3,10) = 1; % Street light on
    hroad_coordinates(4,10) = 1; % Street light on
end    

% ON / OFF for street lights
% hroad_coordinates(road,8) = line coordinate for street light
% hroad_coordinates(road,9) = col coordinate for street light

for i = 1 : 4  % for each road
    line = hroad_coordinates(i,8);
    col = hroad_coordinates(i,9);
    on_off = hroad_coordinates(i,10);
    if on_off == 1
        hroad(line, col) = color_street_light;
    else
        hroad(line, col) = 0;
    end
end
end