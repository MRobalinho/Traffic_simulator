%%------------------------------------------------------------
% MATLAB Traffic Simulator
% Coimbra University
% Manuel Robalinho
% Contact: manuel.robalinho@gmail.com
% Year: 2022
% References:
%  https://www.mathworks.com/help/matlab/ref/uigridlayout.html
%--------------------------------------------------------------
function [oLocal, oWeather, oTemperature, oPressure, oHumidity, oWind , oVisibility] = get_weather_from_excel(my_city)
%UNTITLED9 Summary of this function goes here
%   Returns weather from excel file

oWeather = '';
oTemperature = 0;
oPressure = 0;
oHumidity = 0;
oWind  = 0;
oVisibility = 0;
oLocal = my_city;

sheet = 1;
% Read old data in excel file
[num,txt,raw] = xlsread('weather_data',sheet,'A1:G10'); % define number columns

xn = size(txt,1); % number lines in excel
% Find my city
for i=1 : xn
    t_city = string(txt(i,1));
    i_num = i-1; % for num table don't have header , so its -1
    if t_city == my_city
        oWeather = string(txt(i,2));        
        oTemperature = num(i_num,5);
        oPressure = num(i_num,2);
        oHumidity = num(i_num,3);
        oWind  = num(i_num,4);
        oVisibility = num(i_num,1);
    end
end
% ---
% Local
x1Msg = [ 'Local                 :', my_city];
% Weather
x2Msg = [ 'Weather               :', oWeather, ' | Wind(m/s):', num2str(oWind), ' | Visibility(m):', num2str(oVisibility)];
% Temperature
x3Msg = [ 'Temperature (Celsius) :', num2str(oTemperature), ' | Pressure (hPa):', num2str(oPressure), ' | Humidity(%):', num2str(oHumidity)];
disp(x1Msg);
disp(x2Msg);
disp(x3Msg);

end