%%------------------------------------------------------------
% MATLAB Traffic Simulator
% Coimbra University
% Manuel Robalinho
% Contact: manuel.robalinho@gmail.com
% Year: 2022
% References:
%  https://www.mathworks.com/help/matlab/ref/uigridlayout.html
%--------------------------------------------------------------
function plot_wait_time(xls_filename)

disp('Plot wait time');
sheet = 1;
% Read old data in excel file
excel_old_data = xlsread(xls_filename ,sheet,'A1:L99'); % define number columns

count_rows = height(excel_old_data);  % number lines in excel
% Create matrix  
with_light = zeros(count_rows, 2); % create empty 

% wait time
for i=1 : count_rows
    if excel_old_data(i,1) == 1 % with traffic light
    with_light(i,1) = excel_old_data(i,7) + excel_old_data(i,8) + excel_old_data(i,9) + excel_old_data(i,10); % traffic light
    else
    with_light(i,2) = excel_old_data(i,7) + excel_old_data(i,8) + excel_old_data(i,9) + excel_old_data(i,10); % No traffic light
    end
end 
%

%with_light1 = with_light(with_light(:,1)>0,:); % filter by column 1

% Plot
zTitle = ['Cars wait time with traffic and non traffic lights'];
zLabel = ['Tests'];

col1 = 'Wait time with traffic lights ';
col2 = 'Wait time without traffic lights';

bar(with_light);

title(zTitle); % title
xlabel('Test Number');
ylabel('Time');
legend(col1,col2) ;

saveas(gcf,'wait_time.png');
end