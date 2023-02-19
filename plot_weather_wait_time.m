%%------------------------------------------------------------
% MATLAB Traffic Simulator
% Coimbra University
% Manuel Robalinho
% Contact: manuel.robalinho@gmail.com
% Year: 2022
% References:
%  https://www.mathworks.com/help/matlab/ref/uigridlayout.html
%--------------------------------------------------------------
function plot_weather_wait_time(xls_filename, xls_weather_table)

disp('Plot weather wait time');
sheet = 1;
% Read weather table
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

% Read old data in excel file
excel_old_data = xlsread(xls_filename ,sheet,'A1:L99'); % define number columns

count_rows = height(excel_old_data);  % number lines in excel
% Create matrix  
with_weather = zeros(count_rows, 2); % create empty 

% wait time
for i=1 : count_rows
    id_weather = excel_old_data(i,2);
    x_value = excel_old_data(i,7) + excel_old_data(i,8) + excel_old_data(i,9) + excel_old_data(i,10);
    
    if excel_old_data(i,1) == 1 && x_value > 0 % with traffic light
    with_weather(id_weather,1) = with_weather(id_weather,1) + x_value; % traffic light
    else
    with_weather(id_weather,2) = with_weather(id_weather,2) + x_value; % No traffic light
    end
    if x_value > 0
        % create column with total wait time each line for plotting
        excel_old_data(i,13) = x_value;
    end    
end 
%
for i = 1 : count_rows
    if with_weather(i,1) + with_weather(i,2) > 0
        with_weather1(i,1) = with_weather(i,1); % traffic light
        with_weather1(i,2) = with_weather(i,2); % non traffic light
    end
end    
% average time
count_rows2 = height(with_weather1);  % number lines  
for i=1 : count_rows2
    id_weather = i;
    count_values = 0;
    for x = 1 : count_rows
        if excel_old_data(x,2) == id_weather
           count_values = count_values + 1;
        end   
    end
    % calcule for average
    if count_values > 0
       with_weather2(i,1)  = with_weather1(i,1) / count_values; % traffic light
       with_weather2(i,2)  = with_weather1(i,2) / count_values; % non traffic light
    end   
end    

% Plot
zTitle = ['Cars wait time with traffic and non traffic lights, by weather'];
zLabel = ['Tests'];

col1 = 'Wait time with traffic lights ';
col2 = 'Wait time without traffic lights';

% X bottow title
my_x_label = '';
for i=2 : xn
    t_weather = string(txt_excel_weather(i,2));
    i_num = i-1; % for num table don't have header , so its -1

    num_weather = num_excel_weather(i_num);
    if i == 2 
    my_x_label = strcat(my_x_label,num2str(num_weather),'-',t_weather);
    else
    my_x_label = strcat(my_x_label,';',num2str(num_weather),'-',t_weather);
    end    
end   

% -----    
bar(with_weather2);

title(zTitle); % title
xlabel('Weather');
ylabel('Time');
xlabel([my_x_label]);
legend(col1,col2) ;

saveas(gcf,'weather_wait_time.png');
end