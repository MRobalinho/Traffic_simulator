%%------------------------------------------------------------
% MATLAB Traffic Simulator
% Coimbra University
% Manuel Robalinho
% Contact: manuel.robalinho@gmail.com
% Year: 2022
% References:
%  https://www.mathworks.com/help/matlab/ref/uigridlayout.html
%--------------------------------------------------------------
% - Count cars on each route
%-----------------------------------------------------------------------

function [ xr1, xr2, xr3, xr4, wr1, wr2, wr3, wr4 ] = count_cars_on_route( cars, process_cars )   

% Informations about cars - 6 informations
%   1   |     2                          |   3
% n. Car; track number (1;2;3;4;5;6;7;8 ); position; 
%    4                                   |   5       |   6
% direction (1 go ahead; 2 right; 3 left); time start; time finish  
% ---
% Road 1 - Track 1 Road horizontal top
% Road 2 - Track 2 Road horizontal down
% Road 3 - Track 3 Road vertical left
% Road 4 - Track 4 Road vertical right

% Count Number cars
xr1 = 0; 
xr2 = 0;
xr3 = 0;
xr4 = 0;

% Count wait time
wr1 = 0; 
wr2 = 0;
wr3 = 0;
wr4 = 0;

    for z_car = 1 : process_cars   % Process for all cars, count cars on route
        if cars(z_car, 2 ) == 1   % Horizontal Top
            xr1 = xr1 + 1;
            wr1 = wr1 + cars(z_car, 9 ); % Wait time for this road
        end 
        if cars(z_car, 2 ) == 2   % Horizontal down
            xr2 = xr2 + 1;
            wr2 = wr2 + cars(z_car, 9 ); % Wait time for this road
        end 
        if cars(z_car, 2 ) == 3  % Vertical left
            xr3 = xr3 + 1;
            wr3 = wr3 + cars(z_car, 9 ); % Wait time for this road
        end 
        if cars(z_car, 2 ) == 4   % Vertical right
            xr4 = xr4 + 1;
            wr4 = wr4 + cars(z_car, 9 ); % Wait time for this road
        end 
    end  % for
end % function