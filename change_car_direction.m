%% Change car direction
function  [hroad, cars, new_road, x_turn ] = change_car_direction( hroad_coordinates, hroad, color_road, i_car, cars, turn_right_pos, turn_left_pos, hight_matrix, color_control, color_central, color_vehicle, color_vehicle_turn)

% cars( i_car, 4 ) <> 1 (1 go ahead; 2 right; 3 left)
old_road     = cars(i_car, 2);  % Road
new_road     = cars(i_car, 2);  % default is the present road
my_position  = cars(i_car, 3);  % Position
new_pos      = my_position; % default is the present
car_turn_to  = cars(i_car, 4);  % Turn to ( 1- right; 2 -left)
save_direction = cars(i_car, 5 );  % initial car direction saved
x_turn = 0; % turn or not turn

%
%-----
if save_direction == 1
    x_car_color = color_vehicle;   % Go ahead
else
    x_car_color = color_vehicle_turn;  % turn direction
end

if car_turn_to == 2  
   x_pos_turn =  turn_right_pos;  % Go right
else
   x_pos_turn =  turn_left_pos ;  % Go left
end 
%  hroad_coordinates(new_road , 6); to turn right
%  hroad_coordinates(new_road , 7); to turn left

%   Vertical road
if old_road == 3 || old_road == 4
   % Fix X and varying Y 
   a_x = hroad_coordinates(old_road,2);
   a_y = my_position ;

   if old_road == 3
       look_x = a_x-1 ;
       look_y = a_y ;
      if car_turn_to == 2  % turn right
           look_x = a_x-1 ;
           look_y = a_y ;
       else                    % turn left
           look_x = a_x+2 ;
           look_y = a_y ;
      end    
      old_x = a_x;  % actual positios X and Y
      old_y = a_y;  % actual positios X and Y
      x_control = hroad(look_y, look_x );
   end   

   if old_road == 4
       look_x = a_x-2 ;
       look_y = a_y ;
       x_control = hroad(look_y, look_x );
      if car_turn_to == 2  % turn right
           look_x = a_x+1 ;
           look_y = a_y ;
           a_y = my_position;
       else                    % turn left
           look_x = a_x-2 ;
           look_y = a_y ;
           a_y = my_position;
      end    
      old_x = a_x;  % actual positios X and Y
      old_y = a_y;  % actual positios X and Y
      x_control = hroad(look_y, look_x );
   end   

   if x_control == color_control && car_turn_to == 2  % turn right 
       x_turn = 1; % turn ON
   end  
   if x_control == color_central && car_turn_to == 3 % turn left
       x_turn = 1; % turn ON
   end 
end

%  Horizontal road
if old_road == 1 || old_road == 2
   % Fix Y and varying X 
   a_x = my_position;
   a_y = hroad_coordinates(old_road,2);
   if old_road == 1
         if car_turn_to == 2  % turn right
           look_x = a_x ;
           look_y = a_y-1 ;
         else                    % turn left
           look_x = a_x ;
           look_y = a_y+2 ;
         end 
       old_x = a_x;  % actual positios X and Y
       old_y = a_y;  % actual positios X and Y  
       x_control = hroad(look_y, look_x );
   end 
   if old_road == 2
         if car_turn_to == 2  % turn right
           look_x = a_x ;
           look_y = a_y+1 ;
       else                    % turn left
           look_x = a_x;
           look_y = a_y-2 ;
         end 
       old_x = a_x;  % actual positios X and Y
       old_y = a_y;  % actual positios X and Y
       x_control = hroad(look_y, look_x );
   end 


   if x_control == color_control && car_turn_to == 2  % turn right 
       x_turn = 1; % turn ON
   end  
   if x_control == color_central && car_turn_to == 3 % turn left
       x_turn = 1; % turn ON
   end 
end

% --- verify if X_TURN is ON or OFF
if x_turn == 1  &&  car_turn_to ~= 1 % Need TURN left or right
   
    % Go on horizontal top
    if old_road == 1 
        if  car_turn_to == 2 % turn right
           new_road = 4;   % Vertical right
           new_pos  = hroad_coordinates(new_road , 7); % Turn Rihgt
           new_pos = new_pos - 2;
        else  % Turn left
           new_road = 3;   % Vertical left
           new_pos  = hight_matrix/2; %hroad_coordinates(new_road , 6); % Turn left
        end  
    end

    % Go on horizontal down
    if old_road == 2 
       if car_turn_to == 2 % turn right
           new_road = 3;   % Vertical left
           new_pos  = hroad_coordinates(new_road , 7); % Turn Rihgt
       else  % Turn left
           new_road = 4;   % Vertical right
           new_pos  = hight_matrix/2; %hroad_coordinates(new_road , 7); % Turn left
       end
    end

    % Go on vertical left
    if old_road == 3  
        if car_turn_to == 2  % turn right
           new_road = 1;   % horizontal top
           new_pos  = hroad_coordinates(new_road , 7); % Turn Rihgt
        else  % Turn left
           new_road = 2;   % horizontal down
           new_pos  = hight_matrix/2; % hroad_coordinates(new_road , 6); % Turn left
        end  
    end    

    % Go on vertical right
    if old_road == 4 
        if  car_turn_to == 2 % turn right
           new_road = 2;   % horizontal down
           new_pos  = hroad_coordinates(new_road , 7); % Turn Rihgt
        else  % Turn left
           new_road = 1;   % horizontal top
           new_pos  = hight_matrix/2; % hroad_coordinates(new_road , 6); % Turn left
        end
    end    

    xmsg = ['>> Change car :', num2str(i_car), ' to road:', num2str(new_road)];
    disp(xmsg) ;
    cars(i_car, 2) = new_road;  % change road in CARS matrix
    cars(i_car, 4) = 1;         % change direction (go ahead)
    cars(i_car, 3) = new_pos;   % the position in the new road

    road_position = hroad_coordinates(new_road, 2); 
    if new_road == 1 || new_road == 2
    hroad( road_position, new_pos) =  x_car_color;  % New position in new road
    end
    if new_road == 3 || new_road == 4
    hroad( new_pos, road_position) =  x_car_color;  % New position in new road
    end
    hroad(old_y,  old_x )   =  color_road;     % reset old vehicle position on road
 
end   % end if

end  % Change car direction 