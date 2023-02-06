%%------------------------------------------------------------
% MATLAB Traffic Simulator
% Coimbra University
% Manuel Robalinho
% Contact: manuel.robalinho@gmail.com
% Year: 2022
% References:
%  https://www.mathworks.com/help/matlab/ref/uigridlayout.html
%--------------------------------------------------------------
function [country, region, city] = get_local_ip(xip)
%UNTITLED7 Summary of this function goes here
%   https://ip-api.com/docs/api:json

key = '';  % no need key
options = weboptions('ContentType','json');

url = ['http://ip-api.com/json/', xip];
Current_IP = webread(url, options);

country =Current_IP.country;
city =Current_IP.city;
region =Current_IP.regionName;
xmsg=['IP:',xip, ', Country: ',country, ' - City: ', city, ' - Region:', region];
disp(xmsg);

end