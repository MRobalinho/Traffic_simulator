% Simple traffic simulator
% https://www.youtube.com/watch?v=Rq_wwIvp5LQ
% MRobalinho at 27-11-2022

clc
clear all

% Define Variables -----------------------
hight_matrix  = 40;          % Define the context of street
run_time      = 50;          % run time seconds
speed_vehicle = 2;           % vehicles speed 
process_cars  = 50;           % number cars to process
wait_meters   = 4;           % Number meters for security zone ( 2 is the limit)
create_random_cars = 10;     % count for random cars each tim
do_random_cars = 1;         % to create random cars ( 0 FALSE or 1 TRUE)

% -------------------------------------------------
xls_filename = 'MR_Traffic.xlsx';
tic  % for save inicial time

count_cars_vector = run_traffic_simulator(hight_matrix, run_time, speed_vehicle, process_cars, wait_meters, create_random_cars, do_random_cars);

% final time
timeElapsed = toc; % final time
xmsg = ['Finish with elapsed time :', num2str(timeElapsed)];
disp(xmsg) ;

% Plot graph
ax = uiaxes; % To plot
plot_data(ax, count_cars_vector, timeElapsed);  % Plot bar graph

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
excel_new_data(1,1) = count_cars_vector(1,1);
excel_new_data(1,2) = count_cars_vector(1,2);
excel_new_data(1,3) = count_cars_vector(1,3);
excel_new_data(1,4) = count_cars_vector(1,4);
excel_new_data(1,5) = timeElapsed;
excel_new_data(1,6) = datenumber;

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
