%%------------------------------------------------------------
% MATLAB Traffic Simulator
% Coimbra University
% Manuel Robalinho
% Contact: manuel.robalinho@gmail.com
% Year: 2022
% References:
%  https://www.mathworks.com/help/matlab/ref/uigridlayout.html
%--------------------------------------------------------------
%  define if is in security zone
function [ wait_zone, car_in_sec_zone, turn_right_pos, turn_left_pos] = secur_zone_define(hroad, this_road, this_car_position, hroad_coordinates)

%UNTITLED6 Summary of this function goes here
%   Define de zone of cross road dependinf road
% Track 1  Road horizontal top
% Track 2  Road horizontal down
% Track 3  Road vertical left
% Track 4  Road vertical right

% hroad_coordinate (road, 5) first position control in the street
% hroad_coordinate (road, 6) position control in the street turn right 
% hroad_coordinate (road, 7) position control in the street turn left

wait_zone = 0;
car_in_sec_zone = 0;

turn_right_pos = hroad_coordinates(this_road,6);  % if go right is the position to do
turn_left_pos  = hroad_coordinates(this_road,7);  % if go left is the position to do

% security zone - determine the road to intersection
% 
first_intersection = hroad_coordinates(this_road,5);   % coordinates to control zone
%
if this_road == 1 || this_road == 4
xs1 = hroad_coordinates(this_road,5) ; % control zone
xs2 = hroad_coordinates(this_road,5) - 5; % control zone
end
if this_road == 2 || this_road == 3
xs1 = hroad_coordinates(this_road,5) ; % control zone
xs2 = hroad_coordinates(this_road,5) + 5; % control zone
end
% context for security zone
if xs1 > xs2
   security_zone_hight = xs1;
   security_zone_less  = xs2;
else
   security_zone_hight = xs2;
   security_zone_less  = xs1;
end    
    
if this_car_position >= security_zone_less && this_car_position <= security_zone_hight
   car_in_sec_zone = 1; 
else
   car_in_sec_zone = 0;
end
if this_car_position == first_intersection
    wait_zone = 1;
end  

end  % function