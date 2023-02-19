%%------------------------------------------------------------
% MATLAB Traffic Simulator
% Coimbra University
% Manuel Robalinho
% Contact: manuel.robalinho@gmail.com
% Year: 2022
% References:
%  https://www.mathworks.com/help/matlab/ref/uigridlayout.html
%--------------------------------------------------------------
clc
clear all

% Define Variables -----------------------
hight_matrix  = 40;          % Define the context of street
run_time      = 200;         % run time seconds
speed_vehicle = 2;           % vehicles speed  (99 is like Weather)
process_cars  = 50;          % number cars to process
wait_meters   = 4;           % Number meters for security zone ( 2 is the limit)
create_random_cars = 10;     % count for random cars each time
do_random_cars = 1;          % to create random cars ( 0 FALSE or 1 TRUE)
traffic_Light = 0;           % With traffic light or not ( 0 FALSE or 1 TRUE)

% -------------------------------------------------
xls_filename = 'MR_Traffic.xlsx';
xls_weather_table = "weather_table.xlsx";
tic  % for save inicial time

% ---- get weather ---
iLocal = 'Fortaleza';
oWeather = 'DenseFog';
oLocal = iLocal;
oTemperature = 0;
oPressure = 0;
oHumidity = 0;
oWind  = 0;
oVisibility = 0;

%  get weather data Excel file
[oLocal, oWeather, oTemperature, oPressure, oHumidity, oWind , oVisibility] = get_weather_from_excel(iLocal);

% Get weather from API
%[oLocal, oWeather, oTemperature, oPressure, oHumidity, oWind , oVisibility] = get_weather(iLocal);

% ---- RUN -------------------------
[count_cars_vector, count_time_vector] = run_traffic_simulator(hight_matrix,...
    run_time, speed_vehicle, process_cars, wait_meters, create_random_cars,...
    do_random_cars, oWeather, oVisibility, traffic_Light);

% final time
timeElapsed = toc; % final time
xmsg = ['Finish with elapsed time :', num2str(timeElapsed)];
disp(xmsg) ;

% Plot graph
ax = uiaxes; % To plot
plot_data(ax, count_cars_vector, count_time_vector, timeElapsed);  % Plot bar graph

% --- save data into excel files
save_data_to_excel(xls_filename,xls_weather_table, traffic_Light, oWeather,...
    timeElapsed, count_cars_vector, count_time_vector);

% Plot Wait time
plot_wait_time(xls_filename);

% Plot weather Wait time
plot_weather_wait_time(xls_filename, xls_weather_table);

% Plot weather Wait time by weather
plot_wait_time_by_weather(xls_filename, xls_weather_table)

%  --- end program -------------------
