%%------------------------------------------------------------
% MATLAB Traffic Simulator
% Coimbra University
% Manuel Robalinho
% Contact: manuel.robalinho@gmail.com
% Year: 2022
% References:
%  https://www.mathworks.com/help/matlab/ref/uigridlayout.html

function plot_wait_time_by_weather(xls_filename, xls_weather_table)

disp('Plot weather wait time global');

weather_table = readtable(xls_weather_table,'Format','auto', 'PreserveVariableNames',true); 
xn = size(weather_table,1); % number lines in excel

% read table
excel_old_data = readtable(xls_filename,'Format','auto', 'PreserveVariableNames',true); 
count_rows = height(excel_old_data);  % number lines in excel

% wait time
for i=1 : count_rows
%    x_value = excel_old_data(i,7) + excel_old_data(i,8) + excel_old_data(i,9) + excel_old_data(i,10);
x_value = excel_old_data.WaitRoad1(i) +  excel_old_data.WaitRoad2(i) + excel_old_data.WaitRoad3(i);  
if x_value > 0
        % create column with total wait time each line for plotting
        excel_old_data.TotalWait(i) = x_value;
end   
end 

table_light_off = excel_old_data;
table_light_off(table_light_off.Light == 1,:) = []; % Filter data Traffic Light = 0
off_counts = groupcounts(table_light_off,"Weather"); % count group weather
%
table_light_on = excel_old_data;
table_light_on(table_light_on.Light == 0,:) = []; % Filter data Traffic Light = 1
on_counts = groupcounts(table_light_on,"Weather"); % count group weather


% count group by a column, and calcule average
% https://www.mathworks.com/help/matlab/ref/double.groupsummary.html#d124e596427
G_off = groupsummary(table_light_off,'Weather',"mean");
G_on  = groupsummary(table_light_on,'Weather',"mean");

% another table only the columns that need to print
count_rows = height(G_off);
G_plot_off = zeros(count_rows, 1);
for i=1 : count_rows
G_plot_off(i,1) = G_off.mean_TotalWait(i);
end

% another table only the columns that need to print
count_rows = height(G_on);
G_plot_on = zeros(count_rows, 1);
for i=1 : count_rows
G_plot_on(i,1) = G_on.mean_TotalWait(i);
end
% ----- 

% Plot
tiledlayout(2,1)
% Top plot
nexttile
zTitle = ['Cars wait time by weather - Traffic Light Off'];
zLabel = ['Tests'];

col1 = 'Wait time with traffic lights ';
col2 = 'Wait time without traffic lights';

% X bottow title
my_x_label = '';
for i=1 : xn 
    t_weather = weather_table.Weather(i);
    num_weather = weather_table.ID(i);
    if i == 1 
    my_x_label = strcat(my_x_label,num2str(num_weather),'-',t_weather);
    else
    my_x_label = strcat(my_x_label,';',num2str(num_weather),'-',t_weather);
    end    
end   

bar(G_plot_off);
 
title(zTitle); % title
xlabel('Weather');
ylabel('Time');
xlabel([my_x_label]);
%legend(col1,col2) ;

% For traffic Light on
% Top plot
nexttile
zTitle = ['Cars wait time by weather - Traffic Light On'];

bar(G_plot_on);

title(zTitle); % title
xlabel('Weather');
ylabel('Time');
xlabel([my_x_label]);
%legend(col1,col2) ;

saveas(gcf,'weather_wait_time_global_traffic_light.png');
end