%%------------------------------------------------------------
% MATLAB Traffic Simulator
% Coimbra University
% Manuel Robalinho
% Contact: manuel.robalinho@gmail.com
% Year: 2022
% References:
%  https://www.mathworks.com/help/matlab/ref/uigridlayout.html
%--------------------------------------------------------------
% Create new car
function cars = new_car(i_road, rng_direction, cars, car_number, rng_track, process_cars, hight_matrix)

% 10 cars
% n. Car; track number (1;2;3;4;5;6;7;8 ); position; direction (1 go ahead; 2 right; 3 left)
% Road 1 - Track 1  Road horizontal top
% Road 2 - Track 2  Road horizontal down
% Road 3 - Track 3  Road vertical left
% Road 4 - Track 4  Road vertical right

% Structure MATRIX CARS
% 1 - Car number
% 2 - Number Road it is
% 3 - Actual position
% 4 - Direction (1-Go ahead; 2 turn right; 3 turn left)
% 5 - Save Initial Direction
% 6 - Save Inital Road
% 7 - Start at time
% 8 - End Time
% 9 - Count wait time

msg = ['New car:',num2str(car_number)];
disp(msg);
do_one_time = 0;

for i = 1 : process_cars
    if do_one_time == 0 
      if cars( i, 1) == 0
           cars(i, 1) = car_number;                % car number
           if i_road == 0
             cars(i, 2) = rng_track(car_number);   % random track
           else
             cars(i, 2) = i_road;                  % informed track 
           end  

           % cars(i, 2) = 4; % Track     ## Fixed for test
           x_road = cars(i, 2);
           if x_road == 2 || x_road == 3
                cars(i, 3)  = 1;              % Initial position
           end
           if x_road == 1 || x_road == 4
                cars(i, 3)  = hight_matrix;   % Initial position
           end
           cars(i, 4)  = rng_direction(car_number);    % Direction (1-Go ahead;2-right;3-left)
           %cars(i, 4)  = 2;  % forced direction for test
           cars(i, 5) = cars(i, 4);           % Save initial direction
           cars(i, 6) = 0;                    % Initial Time
           cars(i, 7) = 0;                    % End Time           
           cars(i, 8) = cars(i, 3);           % Save inital Road
           cars(i, 9) = 0;                    % Count for wait time
   
           do_one_time = 1;  % Exit
      end 
    end   
end

end