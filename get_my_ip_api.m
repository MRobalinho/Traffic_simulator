%%------------------------------------------------------------
% MATLAB Traffic Simulator
% Coimbra University
% Manuel Robalinho
% Contact: manuel.robalinho@gmail.com
% Year: 2022
% References:
%  https://www.mathworks.com/help/matlab/ref/uigridlayout.html
%--------------------------------------------------------------
function [Current_IP] = get_my_ip_api()
%UNTITLED6 Summary of this function goes here
%   https://www.ipify.org/

key = '';  % no need key
options = weboptions('ContentType','text');

url = ['https://api.ipify.org'];
Current_IP = webread(url, options);
xMsg =['My IP:',Current_IP];
disp(xMsg);

end