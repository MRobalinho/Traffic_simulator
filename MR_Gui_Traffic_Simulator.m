%%------------------------------------
% GUI for Traffic Simulator
% Coimbra University
% Manuel Robalinho
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

%% -------------------------------------------------
%  Create GUI
% Figure and Panel That Each Have a Grid - Grid 1
fig = uifigure('Position',[100 100 900 450]); % top lef(x/y) / box length / box height
grid1 = uigridlayout(fig,[1 2]);   % 1 Fig with 2 columns
grid1.ColumnWidth = {250,'1x'};  % Define Column with to grid 1
% Add title for Simulator
fig.Name = "My App Traffic Simulator";
%----------------
% Add Grid 2

grid2 = uigridlayout(grid1,[10 2]);  % 10 rows and 2 columns 
grid2.RowHeight = {20, 20, 20, 20, 20, 20, 20, 20, 20, 20};  % Dimention for each row
grid2.ColumnWidth = {150,'1x'};  % Define Column with to grid 2

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
ddSpeed.Items = {'1', '0', '2',  '3', '4', '5'};

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
    'ButtonPushedFcn', @(b1,event) transform_values(ax, ddHight_matrix.Value,...
    ddRun_time.Value, ddSpeed.Value, ddProcess_cars.Value, wait_meters,...
    ddCreate_random_cars.Value, ddDo_random.Value, xls_filename) );

% https://www.mathworks.com/help/matlab/ref/matlab.ui.control.label-properties.html

% Create a push button CANCEL - 13
b4 = uibutton(grid2,'Text','Stop',...
               'ButtonPushedFcn',...
               @(b2,event) ExitButtonPushed(b2,ax, fig));

% - label 4
dlLbl4 = uilabel(grid2);
dlLbl4.HorizontalAlignment = 'left';
dlLbl4.Text = 'Developed by:';
dlLbl4.FontColor = 'b';

% -  label 5
dlLbl5 = uilabel(grid2);
dlLbl5.HorizontalAlignment = 'left';
dlLbl5.Text = '';
dlLbl5.FontColor = 'b'; 

% - Blank label 6
dlLbl6 = uilabel(grid2);
dlLbl6.HorizontalAlignment = 'left';
dlLbl6.Text = 'Manuel Robalinho';
dlLbl6.FontColor = 'b'; 

% - label 7
dlLbl7 = uilabel(grid2);
dlLbl7.HorizontalAlignment = 'left';
dlLbl7.Text = 'Year 2022';
dlLbl7.FontColor = 'b';

% - label 8
temp_label = [xls_filename];
dlLbl8 = uilabel(grid2);
dlLbl8.HorizontalAlignment = 'left';
dlLbl8.Text = temp_label;
dlLbl8.FontColor = 'b';

% label 9
temp_label = ['Log File'];
dlLbl9 = uilabel(grid2);
dlLbl9.HorizontalAlignment = 'left';
dlLbl9.Text = temp_label;
dlLbl9.FontColor = 'b';

% -- GUI FINISH DESIGN ----------------------------

%% -- Funtio to transform values and call execution
function transform_values(ax, xhight_matrix,...
    xrun_time, xspeed_vehicle, xprocess_cars, wait_meters,...
    xcreate_random_cars, xdo_random_cars, xls_filename)

tic   % save initial time

% convert string to numeric
hight_matrix       = str2double(xhight_matrix);
run_time           = str2double(xrun_time);
speed_vehicle      = str2double(xspeed_vehicle);
process_cars       = str2double(xprocess_cars);
create_random_cars = str2double(xcreate_random_cars);
if xdo_random_cars == "Yes"
    do_random_cars = 1;
else
    do_random_cars = 0;
end    

% Call execution
count_cars_vector = run_traffic_simulator(hight_matrix,...
    run_time, speed_vehicle, process_cars, wait_meters,...
    create_random_cars, do_random_cars);

timeElapsed = toc; % final time

% Plot graph
plot_data(ax, count_cars_vector, timeElapsed);

% ---  Create data to save in excel -------
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