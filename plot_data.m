% ------------------------------------------
function plot_data(ax, count_cars_vector, timeElapsed)

% Plot data
%------------
% Plot  - Screen area

zTitle = ['Number cars for each road'];
sti    = [' Elapsed time:', num2str(timeElapsed) ]; % sub title
zLabel = ['Roads'];
ylabel(ax,'Number Cars');

bar(ax, count_cars_vector,'r');
title(ax, zTitle); % title
subtitle(ax, sti); % sub title
xlabel(ax, zLabel);

grid on;
grid minor;

end
