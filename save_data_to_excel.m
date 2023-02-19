%%------------------------------------------------------------
% MATLAB Traffic Simulator
% Coimbra University
% Manuel Robalinho
% Contact: manuel.robalinho@gmail.com
% Year: 2022
% References:
%  https://www.mathworks.com/help/matlab/ref/uigridlayout.html
%--------------------------------------------------------------
function save_data_to_excel(xls_filename,xls_weather_table, traffic_Light,...
    oWeather, timeElapsed, count_cars_vector, count_time_vector)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Create data to excel
sheet = 1;
% Read old data in excel file
excel_old_data = xlsread(xls_filename ,sheet,'A1:M99'); % define number columns
xn = size(excel_old_data,1);
for i=1 : xn
    excel_old_data(i,13) = 0;
end

excel_header = ["Light","Weather","Road1", "Road2","Road3","Road4","WaitRoad1", "WaitRoad2","WaitRoad3","WaitRoad4","Elapsed Time","DateTime","TotalWait"]; % Header
% add old data - Concatenate tables
excel_my_data = [excel_header; excel_old_data]; % concatenate  

% Weather
%-------------------------------------------
% Scale | Description  | Limit of visibility 
% ------------------------------------------
%  1  | Dense fog      |  0 m - 50 m    
%  2  | Thick fog      |  50 m - 200 m     
%  3  | Moderate fog   |  200 m - 500 m    
%  4  | Light fog      |  500 m - 1000 m    
%  5  | Thin fog       |  1 km - 2 km  
% Read old data in excel file
[num_excel_weather, txt_excel_weather, raw_excel_weather] = xlsread(xls_weather_table,sheet,'A1:C99'); % define number columns
xn = size(txt_excel_weather,1); % number lines in excel
% Find the weather
num_weather = 0;
for i=1 : xn
    t_weather = string(txt_excel_weather(i,2));
    i_num = i-1; % for num table don't have header , so its -1
    if t_weather == oWeather
       num_weather = num_excel_weather(i_num);
    end
end    
      
% create new data
t = datetime('now');
datenumber = datenum(t);
excel_new_data = zeros(1, 13); % Excel with 13 columns

%excel_new_data = count_cars_vector;
excel_new_data(1,1) = traffic_Light; % Light (0-No/1-Yes)
excel_new_data(1,2) = num_weather; % Wheather
excel_new_data(1,3) = count_cars_vector(1,1); % road 1
excel_new_data(1,4) = count_cars_vector(1,2); % road 2
excel_new_data(1,5) = count_cars_vector(1,3); % road 3
excel_new_data(1,6) = count_cars_vector(1,4); % road 4
%
excel_new_data(1,7) = count_time_vector(1,1); % WaitRoad 1
excel_new_data(1,8) = count_time_vector(1,2); % WaitRoad 2
excel_new_data(1,9) = count_time_vector(1,3); % WaitRoad 3
excel_new_data(1,10) = count_time_vector(1,4); % WaitRoad 4
excel_new_data(1,11) = timeElapsed;  % tome
excel_new_data(1,12) = datenumber;   % today
excel_new_data(1,13) = 0;   % for calcules

% add new data - Concatenate tables
excel_my_data = [excel_my_data; excel_new_data]; % concatenate 

% save to excel
number_lines_of_matrix = size(excel_my_data,1);
xmsg = ['Save to excel :', xls_filename, ' Number lines:', num2str(number_lines_of_matrix)];
disp(xmsg) ;
xlswrite(xls_filename, excel_my_data, sheet);
% to convert data matlab to excel do subtract 693960 to matlab date
% In Excel =INT(MATLAB_DATE/10000)- 693960

end