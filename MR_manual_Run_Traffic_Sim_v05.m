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
run_time      = 100;         % run time seconds
speed_vehicle = 2;           % vehicles speed  (99 is like Weather)
process_cars  = 50;          % number cars to process
wait_meters   = 4;           % Number meters for security zone ( 2 is the limit)
create_random_cars = 10;     % count for random cars each tim
do_random_cars = 1;          % to create random cars ( 0 FALSE or 1 TRUE)
traffic_Light = 1;           % With traffic light or not ( 0 FALSE or 1 TRUE)

% -------------------------------------------------
xls_filename = 'MR_Traffic.xlsx';
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

% Create data to excel
sheet = 1;
% Read old data in excel file
excel_old_data = xlsread(xls_filename,sheet,'A1:F99'); % define number columns

excel_header = ["Road 1", "Road 2","Road 3","Road 4","Elapsed Time","DateTime"]; % Header
% add old data - Concatenate tables
excel_my_data = [excel_header; excel_old_data]; % concatenate  

% create new data
t = datetime('now');
datenumber = datenum(t);
excel_new_data = zeros(1, 6);
%excel_new_data = count_cars_vector;
excel_new_data(1,1) = count_cars_vector(1,1); % road 1
excel_new_data(1,2) = count_cars_vector(1,2); % road 2
excel_new_data(1,3) = count_cars_vector(1,3); % road 3
excel_new_data(1,4) = count_cars_vector(1,4); % road 4
excel_new_data(1,5) = timeElapsed;  % tome
excel_new_data(1,6) = datenumber;   % today

% add new data - Concatenate tables
excel_my_data = [excel_my_data; excel_new_data]; % concatenate 

% save to excel
number_lines_of_matrix = size(excel_my_data,1);
xmsg = ['Save to excel :', xls_filename, ' Number lines:', num2str(number_lines_of_matrix)];
disp(xmsg) ;
xlswrite(xls_filename,excel_my_data, sheet);
% to convert data matlab to excel do subtract 693960 to matlab date
% In Excel =INT(MATLAB_DATE/10000)- 693960

%  --- end program -------------------
