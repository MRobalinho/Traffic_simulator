%%------------------------------------------------------------
% MATLAB Traffic Simulator
% Coimbra University
% Manuel Robalinho
% Contact: manuel.robalinho@gmail.com
% Year: 2022
% References:
%  https://www.mathworks.com/help/matlab/ref/uigridlayout.html
%--------------------------------------------------------------
% Main Function to the simulator -----------------------------
function [count_cars_vector, count_time_vector] = run_traffic_simulator(hight_matrix,...
    run_time, speed_vehicle, process_cars, wait_meters, create_random_cars,...
    do_random_cars, oWeather, oVisibility, traffic_Light)

color_road           = 4; % color for road
color_road_center    = 9; % Color for central road line
color_vehicle        = 6; % color for vehicle
color_vehicle_turn_l = 8; % color for vehicle intend to turn left
color_vehicle_turn_r = 2; % color for vehicle intend to turn right
color_around_control = 8; % color for around control light
color_control        = 7; % color for control center road start intersection (light street)
color_central        = 10; % color for central intersection
color_street_light   = 4;  % Street light color
%-----------------------------------------
% Time for Street light
street_light_clock = 40;

% Use play traffic sounds
play_sounds = 0; %( 0 - NO ; 1 - Yes)
xfile_sound_name = 'traffic-vehicles.wav';

%-------------------------------------------
% Scale | Description  | Limit of visibility 
% ------------------------------------------
%  1  | Dense fog      |  0 m - 50 m    
%  2  | Thick fog      |  50 m - 200 m     
%  3  | Moderate fog   |  200 m - 500 m    
%  4  | Light fog      |  500 m - 1000 m    
%  5  | Thin fog       |  1 km - 2 km   
%------------------------------
% url = {https://jit.ndhu.edu.tw/article/view/2704}
% Decrease speed according to atmospheric weather
if speed_vehicle == 99
    if oVisibility < 50
        speed_vehicle = 5;  % Speed 1 is hight and 2 less speed and so on
    elseif oVisibility < 200
        speed_vehicle = 4;
    elseif oVisibility < 500
        speed_vehicle = 2;   
    elseif oVisibility < 20000
        speed_vehicle = 1; 
    end    
end

% horizontal road
hrw = hight_matrix ; % road width
hrl = hight_matrix ; % road leangh

% Create matrix for CARS position
% Informations about cars - 9 informations
% 1 - n. Car;|
% 2 - track number (1;2;3;4 );                         |   
% 3 - position; 
% 4 - direction (1 go ahead; 2 right; 3 left);
% 5 - save direction ;     
% 6 - time start;
% 7 - time finish 
% 8 - Save Initial Road;  
% 9 - Count wait time         
% 
% ---
% Track 1  Road horizontal top
% Track 2  Road horizontal down
% Track 3  Road vertical left
% Track 4  Road vertical right

cars = zeros(process_cars, 9); % create empty matrix cars with informations

% generate random track for new cars (2 roads horizontal; 2 roads vertical)
% https://www.mathworks.com/help/matlab/ref/rng.html
[p1,p1 ,xsec, p1] = current_clock();
rng(xsec,'multFibonacci'); % Initializes generator based on the current time(second) 
%rng(0,'twister');
rng_track = randi([1 4], 1 , process_cars);

% generate random cars direction (1-Go ahead, 2-Go Right, 3-Go left)
rng_direction = randi([1 3], 1, process_cars);

car_number = 0;
% Start with 4 cars
%  New car ( 4 at start )
%            CarNumber, Road, Direction, total cars, road

for t = 1: 4  % 4 cars initial
    car_number = car_number + 1;
    i_road = t;  % Informed road    
    cars = new_car(i_road, rng_direction, cars, car_number, rng_track,...
        process_cars,  hight_matrix);
 %  cars = new_car(   2,     3,           cars, car_number, rng_track, process_cars, hight_matrix);
end
%---------- SCENARIO ---------------------
% Create matrix for scenario
hroad = zeros(hrw, hrl); % create the design empty road

% Create matrix for road coordinates for each track of road
% MATRIX = 
%     1   ,    2     ,    3  ,     4      ,       5      ,    6,    7, 8
%          
%[ road 1, road 2, count cars, wait_status, control zone, turn right, 
% turn left, street light coord line,street light coord col, Street light on/off ]  
hroad_coordinates = zeros(4, 10) ; % create empty road coordinates

%  Cicle for create road
hmiddle_pos = hight_matrix / 2; % Central position horizontal street
central_pos = hmiddle_pos;

% calc for security zone
security_zone_less   = hmiddle_pos - wait_meters;
security_zone_most   = hmiddle_pos + wait_meters;

if traffic_Light == 0  % Don't use traffic light
    color_street_light = 0;
end    
% call function to design roads
[ hroad, hroad_coordinates ] = design_road(central_pos, hroad,...
    hroad_coordinates , hight_matrix, color_road, color_road_center,...
    color_control, color_central, color_around_control, color_street_light );  

% plot the position to empty road
xpos = 1;
ypos = hmiddle_pos + 2;  % to vehicle from left to right 
%hroad(ypos, xpos)  = 6;   % First vehicle position

% Current time
[x1_clock_hour, x1_clock_min, x1_clock_sec, x1_time_in_seconds] = current_clock();

% for last time
x2_clock_min = 0;
x2_clock_sec = 0;

% plot
figure; 
colormap([0 0 1;1 0 0;0 1 0;0 1 1])
imagesc(hroad);
t = 0;
% Title and subtitle
ti = ['MRobalinho - Traffic simulator- time = ', num2str(x1_clock_min),':', num2str(x1_clock_sec), ' sec'] ;
title(ti)
subtitle('Road 3     Road 4');
% xLabel
my_x_label = strcat(oWeather, ', Visibility(m):', num2str(oVisibility),', Speed:', num2str(speed_vehicle));
xlabel([my_x_label]);
% Ylabel
xylabels = {'Road 1','','Road 2'};
ylabel(xylabels);
ylh = get(gca,'ylabel');
gyl = get(ylh);                                                         % Object Information
ylp = get(ylh, 'Position');
set(ylh, 'Rotation',0, 'Position',ylp, 'VerticalAlignment','middle', 'HorizontalAlignment','right')
axis equal 
%------ END SCENARIO ---------------------

%--------------------------------------------------
% ------ Run cicle --------------------------------

% Street light
if color_street_light ~= 0
    [hroad, hroad_coordinates] = change_street_light(hroad, hroad_coordinates, color_street_light);
end
%
number_vehicles = 0;  % number vehicles crossing intersection
temp_clock = 0;
temp_street_light = 0;
for t = 0: run_time
  
    % Play sounds
    if play_sounds == 1 
     if t == 0  % First play time
        nBits = 16;
        [y, Fs] = audioread(xfile_sound_name); % Red file
        info = audioinfo(xfile_sound_name);    % characteristics from sound file
        audio_duration = info.Duration; % total time span of audio signal
        d1  = x1_time_in_seconds + audio_duration;

        % Play sound
        sound(y, Fs, nBits);
     end
     % Restart sound - play again
     finish_play_time  = x1_time_in_seconds + audio_duration; % Final time to the music
     [xh, xm, xs, this_second] = current_clock();
     if t > 0 && this_second > finish_play_time  % Play again
         clear sound;
         % Play sound
        disp('Play sound again '); 
        sound(y, Fs, nBits);
        x1_time_in_seconds = this_second;
     end
    end

    %  Create random cars in some road each time
    xy = mod(t, create_random_cars); % rest of Division
    if xy == 0 && do_random_cars == 1 % do_random_cars (0=FALSE; 1 = TRUE)
        % Random new car
        car_number = car_number + 1;
        i_road = 0;   % For Random road        
        cars = new_car(i_road, rng_direction, cars, car_number, rng_track,...
            process_cars, hight_matrix);
        % --
    end

   % Last cicle, read time
  if t == ( run_time - 1 )  
      % Final Current time
      [x1_clock_hour, x2_clock_min, x2_clock_sec, x1_time_in_seconds] = current_clock();
  end
  temp_clock = temp_clock + 1;

  % Simulation vehicle speed
  if temp_clock ~= ( speed_vehicle ) 
   if temp_clock == 1   
       xmsg = ['Wait clock :', num2str(temp_clock), '/', num2str(speed_vehicle)];
       disp(xmsg) ;
   end
  end

  % Change street lights
  temp_street_light = temp_street_light + 1;
  if color_street_light ~= 0 && temp_street_light == street_light_clock % Use Street light
    [hroad, hroad_coordinates] = change_street_light(hroad, hroad_coordinates, color_street_light);
     temp_street_light = 0;
  end
% ---------------------------------------------------------
  if temp_clock == ( speed_vehicle )

    temp_clock = 0;
    x_car = 1;
    for i_car = 1 : process_cars   % Process for all cars
      this_car          = cars( x_car, 1 );  % car number
      this_car_position = cars( x_car, 3 );  % car position
      this_road         = cars( x_car, 2 );  % this road
      this_direction    = cars( x_car, 4 );  % this road
      car_finished      = 0;

      if this_road == 1 || this_road == 4
          if this_car_position == 1 % process fished (end of road)
             car_finished      = 1;
          end
      end    
      if this_road == 2 || this_road == 3
          if this_car_position == hight_matrix % process fished (end of road)
             car_finished      = 1;
          end
      end 

      if this_car > 0 && car_finished == 0
            xmsg = ['Matrix Car:', num2str(x_car), ' Process Road:',num2str(this_road),'  Position Car:', num2str(this_car_position)];
            disp(xmsg) ;

        % verify if is in cross road (security zone)
        [ status_wait, car_in_sec_zone, turn_right_pos, turn_left_pos] = secur_zone_define(hroad, this_road, this_car_position, hroad_coordinates);
    
        % Transform coordinates to MIN and MAX
        if this_road == 1 || this_road == 4
           x_min_pos = hroad_coordinates(this_road, 7) -2;
           x_max_pos = hroad_coordinates(this_road, 6) +2;
           this_coord = cars( x_car, 3 );  % car position
        end   
        if this_road == 2 || this_road == 3
           x_min_pos = hroad_coordinates(this_road, 6) -2;
           x_max_pos = hroad_coordinates(this_road, 7) +2;
           this_coord = cars( x_car, 3 );  % car position
        end 
        if this_road == 1 || this_road == 2
            this_coord_light = hroad_coordinates(this_road, 9); % col Street light coordinate
        end
        if this_road == 3 || this_road == 4
            this_coord_light = hroad_coordinates(this_road, 8); % line Street light coordinate
        end
        this_light_onoff = hroad_coordinates(this_road, 10); % Street light ON/OFF

        % Car into the security zone point to look priorities
        cars_in_intersection = 0;
        if  status_wait == 1 && this_direction ~= 2  % Not go Right
            % verify security zone for cars in the priority
            [cars_in_intersection, hroad_coordinates] = verify_cross_road(i_car,...
                cars, process_cars, hroad_coordinates);
        else
            if this_road > 0
               hroad_coordinates(this_road, 4) = 0; % Not wait
            end
        end
  
       if cars_in_intersection == 1
         % wait, have cars in the intersection
           status_wait = 1;
       end 
       if car_in_sec_zone == 1 % Is in the square . Don't stop
          status_wait = 0;
       end
       if status_wait == 1 &&  cars_in_intersection == 0
           status_wait = 0;  % no cars in tntersection, can go
       end    
      
       % Use street light
       if color_street_light ~= 0  % Use Street light
          if this_coord == this_coord_light && this_light_onoff == 1
             % wait, Street light red
           status_wait = 1;
           xmsg = ['> Street Light for Car:', num2str(x_car), ' Road:',num2str(this_road),'-  Wait'];
           disp(xmsg) ;
          end 
       end  

        %  CHANGE CAR DIRECTION IN THE ROAD
        % cars( i_car, 4 ) <> 1 (1 go ahead; 2 right; 3 left)
        on_off_turn = 0; % Flag to turn or not
        xcar_road_direction = cars( i_car, 4 );  % information to turn direction
        if this_coord >= x_min_pos && this_coord <= x_max_pos && this_road ~= 0 && xcar_road_direction ~= 1
           % change direction when in the center of the road 
           [ hroad, cars, this_road, on_off_turn ] = change_car_direction( hroad_coordinates,...
               hroad, color_road, i_car, cars, turn_right_pos, turn_left_pos,...
               hight_matrix, color_control, color_central,...
               color_vehicle, color_vehicle_turn_r, color_vehicle_turn_l);
        end

        if on_off_turn == 0 && status_wait == 1 
           cars(this_car,9) = cars(this_car,9) + 1; % count numero of wait
        end 

        %  MOVE CAR IN THE ROAD
        % Move if not turn in change_car_direction2 function
        if on_off_turn == 0 && status_wait == 0 
            if   cars( i_car, 1 ) ~= 0 && cars( i_car, 3 ) <= hight_matrix
             [status_wait, hroad, cars ] = move_car(hight_matrix, hroad,...
                 hroad_coordinates, i_car, cars, color_road, color_vehicle,...
                 color_vehicle_turn_r, color_vehicle_turn_l ); 
            end
        end  

      end  % If this car > 0
      x_car = x_car + 1;
    end % For cars matrix

	% plot ------------------------
	imagesc(hroad);

    % create title
	%ti = fprintf('time = %f sec', t ) ;
    ti = ['Traffic simulator-Start time = ', num2str(x1_clock_min),':', num2str(x1_clock_sec),' End time = ', num2str(x2_clock_min),':', num2str(x2_clock_sec),' count:', num2str(t)]; 
    
    [xr1, xr2, xr3, xr4, wr1, wr2, wr3, wr4 ] = count_cars_on_route(cars, process_cars);
    
    % Count cars on route
    number_vehicles = xr1 + xr2 + xr3 + xr4;
    count_cars_vector = zeros(1, 4); % create empty matrix with number cars by road
    count_cars_vector(1,1) = xr1;
    count_cars_vector(1,2) = xr2;
    count_cars_vector(1,3) = xr3;
    count_cars_vector(1,4) = xr4;

    % Wait time
    total_wait_time = wr1 + wr2 + wr3 + wr4;
    count_time_vector = zeros(1, 4); % create empty matrix with wait time by road
    count_time_vector(1,1) = wr1;
    count_time_vector(1,2) = wr2;
    count_time_vector(1,3) = wr3;
    count_time_vector(1,4) = wr4;

    % Title and subtitle
	sti = ['Cars R1:', num2str(xr1), ' |  Cars R2:', num2str(xr2), ' |  Cars R3:', num2str(xr3), ' | Cars R4:', num2str(xr4), ' | NºVehicles= ', num2str(number_vehicles)];
    sti3 = ['Texto MRobalinho'];
    title(ti);     % Title
    subtitle(sti); % sub title

    % xLabel
    my_x_label = strcat(oWeather, ', Visibility(m):', num2str(oVisibility),', Speed:', num2str(speed_vehicle));
    xlabel([my_x_label]);

    % yLabel
    xylabels = {'Road 1','','Road 2'};
    ylabel(xylabels);
    ylh = get(gca,'ylabel');
    gyl = get(ylh);                                                         % Object Information
    ylp = get(ylh, 'Position');
    set(ylh, 'Rotation',0, 'Position',ylp, 'VerticalAlignment','middle', 'HorizontalAlignment','right')
    %
	axis equal 
	pause(0.3) ; %plot every 0,5 seconds

  end  %% end if temp_clock


end	  % end for run_time

clear sound;

end  % function run_traffic_simulator
 