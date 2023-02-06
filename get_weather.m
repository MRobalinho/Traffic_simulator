%%------------------------------------------------------------
% MATLAB Traffic Simulator
% Coimbra University
% Manuel Robalinho
% Contact: manuel.robalinho@gmail.com
% Year: 2022
% References:
%  https://www.mathworks.com/help/matlab/ref/uigridlayout.html
%--------------------------------------------------------------
function [oLocal, oWeather, oTemperature, oPressure, oHumidity, oWind , oVisibility] = get_weather(iLocal)

% get weather from API https://openweathermap.org
% Need obtain the KEY on: https://openweathermap.org/current
% https://openweathermap.org/current#min

key = 'My_key';  % My personal key
options = weboptions('ContentType','json');

url = ['https://api.openweathermap.org/data/2.5/weather?q=', iLocal,'&APPID=',key, '&units=metric'];
Current_Data = webread(url, options);

oLocal = [Current_Data.name,'/',Current_Data.sys.country];
oWeather = [Current_Data.weather.main,'/',Current_Data.weather.description];
oTemperature = Current_Data.main.feels_like;
oPressure = Current_Data.main.pressure;
oHumidity = Current_Data.main.humidity;
oWind = Current_Data.wind.speed;
oVisibility = Current_Data.visibility;

% ---
% Local
xLocal = Current_Data.name;
xMsg = [ 'Local                 :', xLocal, '/', Current_Data.sys.country,' | Lat:', num2str(Current_Data.coord.lat), ' | Long:', num2str(Current_Data.coord.lon)];
disp(xMsg);

% Weather
xWeather = [Current_Data.weather.main,'/',Current_Data.weather.description] ;
xMsg = [ 'Weather               :', xWeather, ' | Wind(m/s):', num2str(Current_Data.wind.speed), ' | Visibility(m):', num2str(Current_Data.visibility)];
disp(xMsg);

% Temperature
xTemperature = Current_Data.main.feels_like;
xMsg = [ 'Temperature (Celsius) :', num2str(xTemperature), ' | Pressure (hPa):', num2str(Current_Data.main.pressure), ' | Humidity(%):', num2str(Current_Data.main.humidity)];
disp(xMsg);

end
