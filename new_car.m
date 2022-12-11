%% Create new car
function cars = new_car(i_road, rng_direction, cars, car_number, rng_track, process_cars, hight_matrix)

% 10 cars
% n. Car; track number (1;2;3;4;5;6;7;8 ); position; direction (1 go ahead; 2 right; 3 left)
% Road 1 - Track 1  Road horizontal top
% Road 2 - Track 2  Road horizontal down
% Road 3 - Track 3  Road vertical left
% Road 4 - Track 4  Road vertical right

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
           cars(i, 4)  = rng_direction(car_number);    % Direction
           %cars(i, 4)  = 2;  % forced direction for test
           cars(i, 5) = cars(i, 4);                    % Save initial direction
   
           do_one_time = 1;  % Exit
      end 
    end   
end

end