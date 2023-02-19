clc;
clear all;
% ---- Sounds ---

xfilename = 'traffic-vehicles.wav';
nBits = 16;
[y, Fs] = audioread(xfilename);
%
info = audioinfo(xfilename);
audio_duration = info.Duration; % total time span of audio signal
[xhour0, xmin0, xsec0, x1_time_in_seconds] = current_clock();
%
sound(y, Fs, nBits);
%
data1 = x1_time_in_seconds;
disp(data1);
%
d2  = x1_time_in_seconds + audio_duration;
disp(d2);
display(d2-x1_time_in_seconds)
%
xmsg = [ 'Tempo 0:', num2str(x1_time_in_seconds),' Ate:', num2str(d2)];
disp(xmsg);
xd = x1_time_in_seconds;
while xd < d2
    [xhour1, xmin1, sec_now, xd] = current_clock();
    xmsg = [ 'Tempo now:', num2str(sec_now)];
  % disp(xd);
end    
clear sound;
xmsg = ['Play again: ', num2str(xd)];
disp(xmsg);
sound(y, Fs, nBits);

%% ----------------------------
xfilename = 'traffic-vehicles.wav';
playerObj = getplayer(xfilename);
play(playerObj);
xx = isplaying(playerObj);

%clear sound;
%%  new test
for k=1:4;
    t=[1/8000:1/8000:2];
    y=sin(2*pi*440*t)+sin(2*pi*480*t);
    sound(y,8000)
    pause(4)
end
%% ------------------------------
[xhour0, xmin0, xsec0, x1_time_in_seconds] = current_clock();
%% ------------------------------
rng(2,'multFibonacci');
s=randi([1 4], 1 , 10);
disp(s);
%% ------------------------
clc
clear all;
xls_filename = 'MR_Traffic.xlsx';
% Plot Wait time
plot_wait_time(xls_filename);
%---
%% --------------------
clc
clear all;
xls_filename = 'MR_Traffic.xlsx';
% Plot Wait time wheather
plot_weather_wait_time(xls_filename);
%% -------------------------
clc
clear all;
xls_weather_table = "weather_table.xlsx";

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
sheet = 1;
[num_excel_weather, txt_excel_weather, raw_excel_weather] = xlsread(xls_weather_table,sheet,'A1:C99'); % define number columns
xn = size(txt_excel_weather,1); % number lines in excel
disp('Save file');
save( 'weather1.mat', 'num_excel_weather', 'txt_excel_weather');

% ----- load
xx = load('weather1.mat');
a1 = xx.txt_excel_weather(1,2);
disp(a1);
%% -----------------
clc
clear all;
% Read old data in excel file
sheet = 1;
xls_filename = 'MR_Traffic.xlsx';

excel_old_data = readtable(xls_filename,'Format','auto', 'PreserveVariableNames',true); % define number columns
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

T1 = excel_old_data ;

% count group by a column, and calcule average
% https://www.mathworks.com/help/matlab/ref/double.groupsummary.html#d124e596427
G = groupsummary(T1,'Weather',"mean");

% another table only the columns that need to print
count_rows = height(G);
for i=1 : count_rows
G_PLOT.Weather(i) = G.Weather(i);
G_PLOT.mean_TotalWait(i) = G.mean_TotalWait(i);
end

%% ---- call the function to plot
clc
clear all;
xls_filename = 'MR_Traffic.xlsx';
xls_weather_table = "weather_table.xlsx";

plot_wait_time_by_weather(xls_filename, xls_weather_table);


%% ----
clc
clear all;
% Read old data in excel file
sheet = 1;
xls_filename = 'MR_Traffic.xlsx';
xls_weather_table = "weather_table.xlsx";

excel_old_data = readtable(xls_filename,'Format','auto', 'PreserveVariableNames',true); % define number columns

count_rows = height(excel_old_data);  % number lines in excel

