%%------------------------------------------------------------
% GUI for Traffic Simulator
% Coimbra University
% Manuel Robalinho
% Contact: manuel.robalinho@gmail.com
% Year: 2022
% References:
%  https://www.mathworks.com/help/matlab/ref/uigridlayout.html
%--------------------------------------------------------------

clc  % Clear screen
clear all  % Clear memory


% Define Variables -----------------------
hight_matrix  = 50;          % Define the context of street
run_time      = 100;         % run time seconds
speed_vehicle = 1;           % vehicles speed 
process_cars  = 50;          % number cars to process
wait_meters   = 4;           % Number meters for security zone ( 2 is the limit)
create_random_cars = 10;     % count for random cars
do_random_cars = 1;          % to create random cars ( 0 FALSE or 1 TRUE)

% ----
xls_filename = 'MR_Traffic.xlsx';
xls_weather_table = 'weather_table.xlsx';

% ---- get weather ---
iLocal = 'Coimbra';
oLocal = iLocal;
oWeather = 'Clear sky';
oTemperature = 30;  % Celsius
oPressure = 0;
oHumidity = 0;
oWind  = 10;  % m/s
oVisibility = 1000;  % meters

%  get IP and local ip
xIp = get_my_ip_api();
%  get local using ip
[country, region, city] = get_local_ip(xIp);
iLocal = city;

%  get weather data Excel file
[oLocal, oWeather, oTemperature, oPressure, oHumidity, oWind , oVisibility] = get_weather_from_excel(iLocal);

%  get weather data from API
%[oLocal, oWeather, oTemperature, oPressure, oHumidity, oWind , oVisibility] = get_weather(iLocal);
% -------------------------------------------------
%  Create GUI
% Figure and Panel That Each Have a Grid - Grid 1
fig = uifigure('Position',[100 100 900 500]); % top lef(x/y) / box length / box height
grid1 = uigridlayout(fig,[1 2]);   % 1 Fig with 2 columns
grid1.ColumnWidth = {250,'1x'};  % Define Column with to grid 1
% Add title for Simulator
fig.Name = "My App Traffic Simulator";
%----------------
% Add Grid 2

grid2 = uigridlayout(grid1,[19 2]);  % 18 rows and 2 columns 
grid2.RowHeight = {18, 18, 18, 18, 18, 18, 18, 18, 20, 20, 14, 14, 14, 14, 14, 14, 14, 14};  % Dimention for each row
grid2.ColumnWidth = {140,'1x'};  % Define Column with to grid 2

ax = uiaxes(grid1);
ax.XGrid = 'on';
ax.YGrid = 'on';

%---------------------------------------------
%Add three drop-downs to the first three rows of grid2.
% Grid in the panel

%----------------------------------
% Define the context of street
%hight_matrix  = 50;          % Define the context of street
dlHight_matrix = uilabel(grid2);
dlHight_matrix.HorizontalAlignment = 'right';
dlHight_matrix.Text = 'Dimensions of street';
% Hight_matrix drop-down
ddHight_matrix = uidropdown(grid2);
ddHight_matrix.Items = {' 40', ' 20', ' 60', ' 80', '100','120','140','160'};


%-------------------------------------------
% run time seconds
%run_time      = 100;          % run time seconds
dlRun_time = uilabel(grid2);
dlRun_time.HorizontalAlignment = 'right';
dlRun_time.Text = 'Run time seconds';
% Run_time drop-down
ddRun_time = uidropdown(grid2);
ddRun_time.Items = {' 200','  80', ' 100', ' 150',  ' 300', ' 400', ' 500', '1000', '2000' '3000'};

%-------------------------------------------
% speed_vehicle = 2;           % vehicles speed 
dlSpeed = uilabel(grid2);
dlSpeed.HorizontalAlignment = 'right';
dlSpeed.Text = 'Speed vehicles';
ddSpeed = uidropdown(grid2);
ddSpeed.Items = {'Like weather', '0            ', '1           ','2            ',...
    '3            ', '4             ', '5            '};

%-------------------------------------------
% process_cars  = 50;           % number cars to process
dlProcess_cars = uilabel(grid2);
dlProcess_cars.HorizontalAlignment = 'right';
dlProcess_cars.Text = 'Number process cars';
ddProcess_cars = uidropdown(grid2);
ddProcess_cars.Items = { ' 50','  1', '  4',' 10', ' 20', ' 80', '100', '200', '999'};

%-------------------------------------------
% create_random_cars = 50;     % count for random cars
dlCreate_random_cars = uilabel(grid2);
dlCreate_random_cars.HorizontalAlignment = 'right';
dlCreate_random_cars.Text = 'Random cars each time';
ddCreate_random_cars = uidropdown(grid2);
ddCreate_random_cars.Items = {' 5',' 1', ' 2', ' 3', ' 4', ' 6', ' 7', ' 8', ' 9', '10', '15', '20'};

%-------------------------------------------
% do_random_cars = 1;         % to create random cars ( 0 FALSE or 1 TRUE)
dlDo_random = uilabel(grid2);
dlDo_random.HorizontalAlignment = 'right';
dlDo_random.Text = 'Do Random cars ?';
ddDo_random = uidropdown(grid2);
ddDo_random.Items = {'Yes', 'No '};

% Use Traffic Light = 1;         %  ( 0 FALSE or 1 TRUE)
dlTraffic_Light = uilabel(grid2);
dlTraffic_Light.HorizontalAlignment = 'right';
dlTraffic_Light.Text = 'Use traffic lights ?';
ddTraffic_Light = uidropdown(grid2);
ddTraffic_Light.Items = {'Yes', 'No '};

% Local_weather = 'Coimbra';     % Local weather
dlLocal_weather = uilabel(grid2);
dlLocal_weather.HorizontalAlignment = 'right';
dlLocal_weather.Text = 'Weather';
ddLocal_weather = uidropdown(grid2);
ddLocal_weather.Items = {'ClearSky','DenseFog','ThickFog','Mild Fog','LightFog','Thin Fog','Coimbra ','Porto   ','Lisboa  ', 'Computer'};

%---------------------------------

% Create a 1-by-2 grid called grid3 inside the last row of grid2. 
% Then add two buttons to grid3. Remove the padding on the left and right 
% edges of grid3 so that the buttons align with the left and right 
% edges of the drop-downs.
% Create Buttons

%grid3 = uigridlayout(grid2,[1 2]);
%grid3.Padding = [0 10 0 10];

% label 1 ------------
dlLbl2 = uilabel(grid2);
dlLbl2.HorizontalAlignment = 'left';
dlLbl2.Text = 'Execution';
dlLbl2.FontWeight = 'bold';
dlLbl2.FontColor = 'k'; 
dlLbl2.BackgroundColor = 'c';

% - Blank label 2
dlLbl3 = uilabel(grid2);
dlLbl3.HorizontalAlignment = 'left';
dlLbl3.Text = '';


% Create a push button EXECUTE - 9
b1 = uibutton(grid2,'Text','Start',...
    'ButtonPushedFcn', @(b1,event)...
    transform_values(ax, ddHight_matrix.Value,...
    ddRun_time.Value, ddSpeed.Value, ddProcess_cars.Value, wait_meters,...
    ddCreate_random_cars.Value, ddDo_random.Value,...
    xls_filename, xls_weather_table,...
    ddLocal_weather.Value, oVisibility, ddTraffic_Light.Value) );

% Set to red the current button
set(b1,'Backgroundcolor','green');
% https://www.mathworks.com/help/matlab/ref/matlab.ui.control.label-properties.html

% Create a push button CANCEL - 13
b4 = uibutton(grid2,'Text','Stop',...
               'ButtonPushedFcn',...
               @(b2,event) ExitButtonPushed(b2,ax, fig));
% Set to red the current button
set(b4,'Backgroundcolor','r');

% - Wheather
xLocal = ddLocal_weather.Value;
if xLocal == "Porto   " || xLocal == "Coimbra " || xLocal == "Lisboa  "
else
   xLocal = city; 
end 

% - label 4
dlLbl4 = uilabel(grid2);
dlLbl4.HorizontalAlignment = 'left';
dlLbl4.Text = [oLocal,' Wheather'];
dlLbl4.FontWeight = 'bold';
dlLbl4.FontColor = 'k'; 
dlLbl4.BackgroundColor = 'c';

% - label 5
dlLbl5 = uilabel(grid2);
dlLbl5.HorizontalAlignment = 'left';
dlLbl5.Text = oWeather;
dlLbl5.FontColor = 'k';

% - label 6
dlLbl6 = uilabel(grid2);
dlLbl6.HorizontalAlignment = 'right';
dlLbl6.Text = 'Temperature';
dlLbl6.FontColor = 'k';
% - label 7
dlLbl7 = uilabel(grid2);
dlLbl7.HorizontalAlignment = 'left';
dlLbl7.Text = [num2str(oTemperature),'ºC'];
dlLbl7.FontColor = 'k';

% - label 8
dlLbl8 = uilabel(grid2);
dlLbl8.HorizontalAlignment = 'right';
dlLbl8.Text = 'Visibility';
dlLbl8.FontColor = 'k';
% - label 9
dlLbl9 = uilabel(grid2);
dlLbl9.HorizontalAlignment = 'left';
dlLbl9.Text = [num2str(oVisibility),' m'];
dlLbl9.FontColor = 'k';

% - label 10
dlLbl10 = uilabel(grid2);
dlLbl10.HorizontalAlignment = 'right';
dlLbl10.Text = 'Wind';
dlLbl10.FontColor = 'k';
% - label 11
dlLbl11 = uilabel(grid2);
dlLbl11.HorizontalAlignment = 'left';
dlLbl11.Text = [num2str(oWind),' m/s'];
dlLbl11.FontColor = 'k';

% - label 12
dlLbl12 = uilabel(grid2);
dlLbl12.HorizontalAlignment = 'left';
dlLbl12.Text = 'Developed by:';
dlLbl12.FontColor = 'b';

% -  label 13
dlLbl13 = uilabel(grid2);
dlLbl13.HorizontalAlignment = 'left';
dlLbl13.Text = '';
dlLbl13.FontColor = 'b'; 

% - label 14
dlLbl14 = uilabel(grid2);
dlLbl14.HorizontalAlignment = 'left';
dlLbl14.Text = 'Manuel Robalinho / 2022';
dlLbl14.FontColor = 'b'; 

% label 15
dlLbl15 = uilabel(grid2);
dlLbl15.HorizontalAlignment = 'left';
dlLbl15.Text = '';
dlLbl15.FontColor = 'b';

% - label 16
temp_label = [xls_filename];
dlLbl16 = uilabel(grid2);
dlLbl16.HorizontalAlignment = 'left';
dlLbl16.Text = temp_label;
dlLbl16.FontColor = 'b';

% label 17
temp_label = ['Log File'];
dlLbl17 = uilabel(grid2);
dlLbl17.HorizontalAlignment = 'left';
dlLbl17.Text = temp_label;
dlLbl17.FontColor = 'b';

% - label 18 
temp_label = ['My IP:', xIp];
dlLbl18 = uilabel(grid2);
dlLbl18.HorizontalAlignment = 'left';
dlLbl18.Text = temp_label;
dlLbl18.FontColor = 'b';

dlLbl19 = uilabel(grid2);
dlLbl19.HorizontalAlignment = 'left';
dlLbl19.Text = city;
dlLbl19.FontColor = 'b';

% -- GUI FINISH DESIGN ----------------------------

% -- Funtion to transform values and call execution
function transform_values(ax, xhight_matrix,...
    xrun_time, xspeed_vehicle, xprocess_cars, wait_meters,...
    xcreate_random_cars, xdo_random_cars,...
    xls_filename, xls_weather_table,...
    xLocal_weather, oVisibility, xtraffic_Light)

tic   % save initial time

% Convert Speed looking Weather
%'ClearSky','DenseFog','ThickFog','Mild Fog','LightFog','Thin Fog',
%-------------------------------------------
% Scale | Description  | Limit of visibility 
% ------------------------------------------
%  1  | Dense fog      |  0 m - 50 m    
%  2  | Thick fog      |  50 m - 200 m     
%  3  | Moderate fog   |  200 m - 500 m    
%  4  | Light fog      |  500 m - 1000 m    
%  5  | Thin fog       |  1 km - 2 km   
%------------------------------
% url = {https://jit.ndhu.edu.tw/article/view/2704}
% Decrease speed according to atmospheric weather
if xLocal_weather == 'ClearSky'
    oVisibility =3000;
elseif xLocal_weather == 'DenseFog'
    oVisibility =49;
elseif xLocal_weather == 'ThickFog'
    oVisibility =199;
elseif xLocal_weather == 'Mild Fog'
    oVisibility =499;  
elseif xLocal_weather == 'LightFog'
    oVisibility =999;   
elseif xLocal_weather == 'Thin Fog'
    oVisibility =1999; 
end 

% - Speed like Wheather
if xspeed_vehicle == "Like weather"
   xspeed_vehicle = '99';  % Sinalize to Like Weather
end    

% convert string to numeric
if xtraffic_Light == "Yes"
   xtraffic_Light = 1;
else   
   xtraffic_Light = 0;
end    
hight_matrix       = str2double(xhight_matrix);
run_time           = str2double(xrun_time);
speed_vehicle      = str2double(xspeed_vehicle);
process_cars       = str2double(xprocess_cars);
create_random_cars = str2double(xcreate_random_cars);
traffic_Light      = xtraffic_Light;
if xdo_random_cars == "Yes"
    do_random_cars = 1;
else
    do_random_cars = 0;
end    

% Call execution
[count_cars_vector, count_time_vector] = run_traffic_simulator(hight_matrix,...
    run_time, speed_vehicle, process_cars, wait_meters,...
    create_random_cars, do_random_cars, xLocal_weather, oVisibility, traffic_Light);

timeElapsed = toc; % final time

% Plot graph
plot_data(ax, count_cars_vector, count_time_vector, timeElapsed);

% --- save data into excel files
save_data_to_excel(xls_filename,xls_weather_table, traffic_Light,xLocal_weather,...
    timeElapsed, count_cars_vector, count_time_vector);

% Plot Wait time
plot_wait_time(xls_filename);

% Plot weather Wait time
plot_weather_wait_time(xls_filename);

end % function
%% -- STOP Function
function ExitButtonPushed(btn,ax, fig)
 
  %  quit; % Shut down the entire app.
  
  anss = uiconfirm(fig, 'Do you wish to quit?', 'Confirm Exit',...
      'Options',{'Yes','No','Cancel'}, ...
      'DefaultOption',3,'CancelOption',3, 'Icon', 'question');
            
     switch anss
        case 'Yes'
            save Traffic_test.mat 
            exit; % Ends this session
         otherwise
            return;
     end     

end  % Exit Button