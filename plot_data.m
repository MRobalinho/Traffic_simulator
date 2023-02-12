%%------------------------------------------------------------
% MATLAB Traffic Simulator
% Coimbra University
% Manuel Robalinho
% Contact: manuel.robalinho@gmail.com
% Year: 2022
% References:
%  https://www.mathworks.com/help/matlab/ref/uigridlayout.html
%--------------------------------------------------------------
function plot_data(ax, count_cars_vector, count_time_vector, timeElapsed)

% Plot data
%------------
% Plot  - Screen area

x_print = zeros(4, 2);
for i=1:4
    x_print(i,1) = count_cars_vector(i);
    x_print(i,2) = count_time_vector(i);
end

zTitle = ['Number cars for each road and wait time'];
sti    = [' Elapsed time:', num2str(timeElapsed) ]; % sub title
zLabel = ['Roads'];

col1 = 'Number Cars';
col2 = 'Wait Time';

ylabel(ax,'Number Cars');

bar(ax, x_print);

title(ax, zTitle); % title
subtitle(ax, sti); % sub title
xlabel(ax, zLabel);
legend(ax, col1,col2) ;

grid on;
grid minor;

end
