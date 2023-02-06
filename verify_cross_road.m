%%------------------------------------------------------------
% MATLAB Traffic Simulator
% Coimbra University
% Manuel Robalinho
% Contact: manuel.robalinho@gmail.com
% Year: 2022
% References:
%  https://www.mathworks.com/help/matlab/ref/uigridlayout.html
%--------------------------------------------------------------
% Verify security zone for cars with priority
function [cars_in_intersection, hroad_coordinates] = verify_cross_road(i_car, cars, process_cars, hroad_coordinates)
% ---
% Track 1  Road horizontal top
% Track 2  Road horizontal down
% Track 3  Road vertical left
% Track 4  Road vertical right

cars_in_intersection = 0;
my_car            = cars( i_car, 1);  % my car
my_road           = cars( i_car, 2);  % my road
my_position       = cars( i_car, 3);  % my position
x_car             = i_car;

look_road1 = 0;  % Road 1 to cross
look_road2 = 0;  % Road 2 to cross

x1 = hroad_coordinates(my_road,5) + 1;  % control
x2 = x1 + 5;

if my_road == 2 || my_road == 4
   central_intersection_less  = x1;
   central_intersection_hight = x1 + 5;
end

if my_road == 1 || my_road == 3
   central_intersection_less  = x1;
   central_intersection_hight = x1 + 5;
end    
  
xmsg = [' >> Road:', num2str(my_road),' Security zone for Car:', num2str(i_car), '  Position Car:', num2str(my_position), ' Wait:', num2str(cars_in_intersection)];
disp(xmsg) ;

% Verify cars on road (center of the road) with legal priority
control_this_road = hroad_coordinates(my_road , 5);

% not verivy actual car ( x_car ~= i_car)
if  my_position == control_this_road
     % set priority rules - cars on the right have priority
     if my_road == 1     % Road horizontal top
         look_road1 = 4;  % Road vertical left
         look_road2 = 3;  % Road vertical right
     end
     if my_road == 2     % Road horizontal down
         look_road1 = 3;  % Road vertical left
         look_road2 = 4;  % Road vertical right
     end
     if my_road == 3     % Road vertical left
         look_road1 = 1;  % Road horizontal down
         look_road2 = 2;  % Road horizontal top
     end
     if my_road == 4     % Road vertical right
         look_road1 = 2;  % Road horizontal top
         look_road2 = 1;  % Road horizontal down
     end
end  

cars_in_intersection = 0;
%----------------------  For ROAD = 1 and 3
if ( my_road == 1 || my_road == 3)  && look_road1 ~= 0 
   % all cars for look road     
   for x1 = 1 : process_cars       
     xcar_here = cars(x1,3);
     % look road 1
     x_for_here = hroad_coordinates(look_road1, 5) - 1; % down verify less
     x_to_there = hroad_coordinates(look_road1, 5) - 5; % top verify zone 

     xmsg = [' >> Cross my road:', num2str(my_road), '  look Road:', num2str(look_road1) , ' from:', num2str(x_for_here), ' to:', num2str(x_to_there)];
     disp(xmsg) 
     temp_car = cars(x1, 1);
     if temp_car ~= my_car && cars(x1, 2) == look_road1 && xcar_here >= x_for_here && xcar_here <= x_to_there
        cars_in_intersection = 1;
        xmsg = [' >>> car:', num2str(cars(x1, 1)), ' on road:', num2str(cars(x1, 2)),' in Security zone position:', num2str(cars(x1, 3))];
        disp(xmsg) ;
     end   

     %  look road 2
     x_for_here = hroad_coordinates(look_road2, 5) + 1; % down verify less
     x_to_there = hroad_coordinates(look_road2, 5) + 5; % top verify zone  

     xmsg = [' >> Cross my road:', num2str(my_road), '  look Road:', num2str(look_road2) , ' from:', num2str(x_for_here), ' to:', num2str(x_to_there)];
     disp(xmsg) 
     
     if temp_car ~= my_car && cars(x1, 2) == look_road2 && xcar_here >= x_for_here && xcar_here <= x_to_there
        cars_in_intersection = 1;
        xmsg = [' >>> car:', num2str(cars(x1, 1)), ' on road:', num2str(cars(x1, 2)),' in Security zone position:', num2str(cars(x1, 3))];
        disp(xmsg) ;
     end  
   end   % end for 
end  % ----  For ROAD = 1 and 3

%----------------------  For ROAD = 2 and 4
if ( my_road == 2 || my_road == 4 ) && look_road1 ~= 0
   % all cars for look road    
   for x1 = 1 : process_cars       
     xcar_here = cars(x1,3);
     % look road 1
     x_for_here = hroad_coordinates(look_road1, 5) +1; % down verify less
     x_to_there = hroad_coordinates(look_road1, 5) +5;  % top verify zone 

     xmsg = [' >> Cross my road:', num2str(my_road), '  look Road:', num2str(look_road1) , ' from:', num2str(x_for_here), ' to:', num2str(x_to_there)];
     disp(xmsg) 
     temp_car = cars(x1, 1);
     if temp_car ~= my_car && cars(x1, 2) == look_road1 && xcar_here >= x_for_here && xcar_here <= x_to_there
        cars_in_intersection = 1;
     end   

     %  look road 2
     x_for_here = hroad_coordinates(look_road2, 5) + 1; % down verify less
     x_to_there = hroad_coordinates(look_road2, 5) + 5; % top verify zone  

     xmsg = [' >> Cross my road:', num2str(my_road), '  look Road:', num2str(look_road2) , ' from:', num2str(x_for_here), ' to:', num2str(x_to_there)];
     disp(xmsg) 

     if temp_car ~= my_car && cars(x1, 2) == look_road2 && xcar_here >= x_for_here && xcar_here <= x_to_there
        cars_in_intersection = 1;
     end  
   end   % end for  
end  % end road 2 and 4

% -------------------------
if cars_in_intersection == 1
    hroad_coordinates(my_road , 4) = 1;  % Wait
else
    hroad_coordinates(my_road , 4) = 0;  % Not Wait
end
  
% -----------------------------------
% verify if all road are locked
bl_road = 0;

for xi = 1 : 4
   bl_road = bl_road + hroad_coordinates(xi, 4);
end  % end for

if bl_road == 4   % all roads locked. Select one to unlock
    hroad_coordinates(my_road , 4) = 0;  % Not Wait
    cars_in_intersection = 0;
end

if cars_in_intersection == 1
    xmsg = [' >> Security zone for Car:', num2str(x_car), '  >> WAIT Road:', num2str(look_road1) , ' Or Road:', num2str(look_road2)];
    disp(xmsg) ;
end    

end  % function
