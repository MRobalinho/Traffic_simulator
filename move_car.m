%% --Move car
% ---------------------------------------------------------------
function [ status_wait, hroad, cars ] = move_car(hight_matrix, hroad, hroad_coordinates, i_car, cars, color_road, color_vehicle, color_vehicle_turn )

% ---
% Informations about cars - 6 informations
%   1   |     2                          |   3
% n. Car; track number (1;2;3;4;5;6;7;8 ); position; 
%    4                                   |   5       |   6
% direction (1 go ahead; 2 right; 3 left); time start; time finish  
% ---
% Road 1 - Track 1  Road horizontal top (with 2 lanes)
% Road 2 - Track 2  Road horizontal down (with 2 lanes)
% Road 3 - Track 3  Road vertical left (with 2 lanes)
% Road 4 - Track 4  Road vertical right (with 2 lanes)

% Vehicle Position street
this_pos  = cars(i_car, 3 );  % actual car position
this_road = cars(i_car, 2 );  % atual road
this_car  = cars(i_car, 1 );  % atual car number
save_direction = cars(i_car, 5 );  % initial car direction saved
old_pos = this_pos;           % save older position

old_x   = 0;
old_y   = 0;
new_x   = 0;
new_y   = 0;

%-----
if save_direction == 1
    x_car_color = color_vehicle;   % Go ahead
else
    x_car_color = color_vehicle_turn;  % turn direction
end

% update new position of vehicle in horizontal street top
if this_road == 1  % Horizontal Top
    road_position = hroad_coordinates(this_road, 2);       % Y Fixed
    
    old_x = this_pos;         % old position X
    new_x = this_pos -1;     % next position X

    old_y = road_position;    % old position Y
    new_y = road_position;    % new position Y

    old_coordinate = new_x + 1;   % X Matrix old position
    if old_coordinate < 1
       old_coordinate = 0;
    end

    msg = ['> Move road:', num2str(this_road), ' Car: ' num2str(this_car), ' position Y= ', num2str(new_y), ' X:', num2str(new_x )] ;
    disp(msg);

    pos_next = new_x - 1;                % next, next position
    if pos_next < 1
       pos_next =  1; 
    end   
end % Road 1

% update new position of vehicle in horizontal street down
if this_road == 2  % Horizontal Top
    road_position = hroad_coordinates(this_road, 2);  % Y Fixed

    old_x = this_pos;           % old position X
    new_x = this_pos + 1;       % next position X

    old_y = road_position;      % old position Y
    new_y = road_position;      % new position Y

    old_coordinate = old_x;     % X Matrix old position
    if old_coordinate > hight_matrix
       old_coordinate = hight_matrix;
    end

    msg = ['> Move road:', num2str(this_road), ' Car: ' num2str(this_car), ' position Y= ', num2str(new_y), ' X:', num2str(new_x )] ;
    disp(msg);

    pos_next = new_x + 1;  % next, next position
    if pos_next > hight_matrix
       pos_next = hight_matrix;
    end   
end % Road 2

% update new position of vehicle in vertical street left
if this_road == 3  % Vertical Left
    road_position = hroad_coordinates(this_road, 2); % X Fixed  

    old_x = road_position;      % old position X
    new_x = road_position;      % next position X

    new_y = this_pos + 1;       % next position Y    
    old_y = this_pos;           % old position Y
    old_coordinate = old_y;     % X Matrix old position

    msg = ['> Move road:', num2str(this_road), ' Car: ' num2str(this_car), ' position Y= ', num2str(new_y), ' X:', num2str(new_x )] ;
    disp(msg);

    pos_next = new_y + 1;  % next, next position
    if pos_next > hight_matrix
       pos_next = hight_matrix;
    end   
end % Road 3

% update new position of vehicle in vertical street right
if this_road == 4  % Vertical Left
    road_position = hroad_coordinates(this_road, 2);     % X Fixed

    old_x = road_position;                       % old position X
    new_x = road_position;                       % next position X

    old_y = this_pos;                            % old position Y   
    new_y = this_pos - 1 ;     % next position Y

    old_coordinate = new_y + 1;   % Y Matrix old position
    if old_coordinate <= 1
       old_coordinate = 0;
    end
    msg = ['> Move road:', num2str(this_road), ' Car: ' num2str(this_car), ' position Y= ', num2str(new_y), ' X:', num2str(new_x )] ;
    disp(msg);

    pos_next = new_y - 1;  % next, next position
    if pos_next < 1
       pos_next =  1; 
    end 
end  % Road 4

% Avaiable next position horizontal street - MOVE
if ( this_road == 1 || this_road == 2 ) && new_x > 0
    if  hroad(new_y,  new_x) == color_road  && hroad(new_y, pos_next) == color_road && new_x <= hight_matrix       
        hroad(new_y, new_x)            = x_car_color;           % new vehicle position
        hroad(old_y, old_coordinate)   = color_road;            % reset old vehicle position
        cars( i_car, 3 )               = new_x;          % save car position
        status_wait                    = 0;    % not wait
    else
        status_wait = 1;    % wait
    end
    if pos_next <= 1 || pos_next   >= hight_matrix
        hroad(old_y,  1)            = color_road;
        hroad(old_y,  hight_matrix) = color_road;
    end
end 

% Avaiable next position vertical street - MOVE
if ( this_road == 3 || this_road == 4 ) && new_y > 0    
    if  hroad(new_y, new_x) == color_road  && hroad(pos_next, new_x ) == color_road && new_x <= hight_matrix       
        hroad(new_y, new_x)            = x_car_color;           % new vehicle position
        hroad(old_coordinate, old_x)   = color_road;            % reset old vehicle position
        cars( i_car, 3 )               = new_y;                 % save car position
        status_wait                    = 0;    % not wait
    else
        status_wait = 1;    % wait
    end
    if pos_next <= 1 || pos_next   >= hight_matrix
        hroad(1, old_x)            = color_road;
        hroad(hight_matrix, old_x) = color_road;
    end
end 

end  % function
% ---------------------------
 