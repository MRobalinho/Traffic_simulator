%%------------------------------------------------------------
% MATLAB Traffic Simulator
% Coimbra University
% Manuel Robalinho
% Contact: manuel.robalinho@gmail.com
% Year: 2022
% References:
%  https://www.mathworks.com/help/matlab/ref/uigridlayout.html
%--------------------------------------------------------------
% This function create the scenery with a instersection with 2 roads
function [ hroad , hroad_coordinates ] = design_road( central_pos, hroad, hroad_coordinates,...
    hight_matrix, color_road, color_road_center,...
    color_control, color_central, color_around_control, color_street_light )

msg = ['Contruct stree = ', num2str(central_pos), ' Hight_Matrix:', num2str(hight_matrix )] ;
disp(msg);

% ---
% Road 1 - Track 1 and 2 - Road horizontal top
% Road 2 - Track 3 and 4 - Road horizontal down
% Road 3 - Track 5 and 6 - Road vertical left
% Road 4 - Track 7 and 8 - Road vertical right

hroad_coordinates(1, 1) = central_pos - 1; % road 1 right lane
hroad_coordinates(1, 2) = central_pos - 2; % road 1 left lane
hroad_coordinates(1, 3) = 0;               % count cars road 1
hroad_coordinates(1, 4) = 0;               % Wait status
hroad_coordinates(1, 5) = 0;               % Control zone 1
hroad_coordinates(1, 6) = 0;               % Turn zone
hroad_coordinates(1, 6) = 0;               % Turn zone right
hroad_coordinates(1, 7) = 0;               % Turn zone left
hroad_coordinates(1, 8) = 0;               % position traffic light line
hroad_coordinates(1, 9) = 0;               % position traffic light col

hroad_coordinates(2, 1) = central_pos + 1; % road 2 right lane
hroad_coordinates(2, 2) = central_pos + 2; % road 2 left lane
hroad_coordinates(2, 3) = 0;               % count cars road 2
hroad_coordinates(2, 4) = 0;               % Wait status
hroad_coordinates(2, 5) = 0;               % Control zone 1
hroad_coordinates(2, 6) = 0;               % Turn zone right
hroad_coordinates(2, 7) = 0;               % Turn zone left
hroad_coordinates(2, 8) = 0;               % position traffic light line
hroad_coordinates(2, 9) = 0;               % position traffic light col

hroad_coordinates(3, 1) = central_pos - 1; % road 3 right lane
hroad_coordinates(3, 2) = central_pos - 2; % road 3 left lane
hroad_coordinates(3, 3) = 0;               % count cars road 3
hroad_coordinates(3, 4) = 0;               % Wait status
hroad_coordinates(3, 5) = 0;               % Control zone 1
hroad_coordinates(3, 6) = 0;               % Turn zone right
hroad_coordinates(3, 7) = 0;               % Turn zone left
hroad_coordinates(3, 8) = 0;               % position traffic light line
hroad_coordinates(3, 9) = 0;               % position traffic light col

hroad_coordinates(4, 1) = central_pos + 1; % road 4 right lane
hroad_coordinates(4, 2) = central_pos + 2; % road 4 left lane
hroad_coordinates(4, 3) = 0;               % count cars road 4
hroad_coordinates(4, 4) = 0;               % Wait status
hroad_coordinates(4, 5) = 0;               % Control zone 1
hroad_coordinates(4, 6) = 0;               % Turn zone right
hroad_coordinates(4, 7) = 0;               % Turn zone left
hroad_coordinates(4, 8) = 0;               % position traffic light line
hroad_coordinates(4, 9) = 0;               % position traffic light col


% ----------------------------------
% define horizontal street
ypos = central_pos;
xpos_road = 1;
ypos1 = ypos - 2;
for t = 0 : hight_matrix 
   hroad(ypos1+0,   xpos_road) = color_road;
   hroad(ypos1+1,   xpos_road) = color_road;
   hroad(ypos1+2,   xpos_road) = color_road_center;
   hroad(ypos1+3,   xpos_road) = color_road;
   hroad(ypos1+4,   xpos_road) = color_road;
   xpos_road = xpos_road + 1;
end  

% -----------------------------------------
% define vertical street
xpos = central_pos;
ypos_road = 1;
xpos1 = xpos - 2;
for t = 0 : hight_matrix 
   hroad(ypos_road, xpos1+0) = color_road;
   hroad(ypos_road, xpos1+1) = color_road;
   hroad(ypos_road, xpos1+2) = color_road_center;
   hroad(ypos_road, xpos1+3) = color_road;
   hroad(ypos_road, xpos1+4) = color_road;
   ypos_road = ypos_road + 1;
end  

% create post control  
road_1_3 = 0;
road_2_4 = 0;
xpos_road = 1;

%  controls from horizontal road
for t = 0 : hight_matrix 
    msg = ['Create control to right position Y= ', num2str(central_pos-4), ' X:', num2str(xpos_road)] ;
  %  disp(msg);
    if xpos_road > hight_matrix
       xpos_road =  hight_matrix;
    end   
    if hroad(central_pos-3, xpos_road) ~= color_road && hroad(central_pos-4, xpos_road+1 ) == color_road      
       hroad(central_pos-3, xpos_road) = color_control;
       hroad(central_pos+3, xpos_road) = color_control;
       
       % Color around control
       if xpos_road < central_pos - 2 && road_1_3 == 0  
       %    hroad(central_pos-4, xpos_road) = color_around_control ;
       %    hroad(central_pos+4, xpos_road) = color_around_control ;
    
       %    hroad(central_pos-3, xpos_road-1) = color_around_control ;
       %    hroad(central_pos+3, xpos_road-1) = color_around_control ;
           
           hroad(central_pos-4, xpos_road-1) = color_street_light ;
           hroad(central_pos+4, xpos_road-1) = color_street_light ;

           road_1_3 = 1; % do once one
       end
       %
       % save control for road 1 and 3 (hroad_coordinates[road,5]
       hroad_coordinates(1,5) = xpos_road; % for road 1
       hroad_coordinates(3,5) = xpos_road; % for road 3

       % save turn zone for road 1 and 3
       % hroad_coordinates  (position 6 ) >> turn right
       % hroad_coordinates  (position 7 ) >> turn left

       % save turn zone for road 3 and 2
       hroad_coordinates(2,6) = xpos_road + 2; % for road 3 turn right
       hroad_coordinates(2,7) = xpos_road + 4; % for road 3 turn left

       hroad_coordinates(4,6) = xpos_road + 1; % for road 1 turn right 
       hroad_coordinates(4,7) = xpos_road + 4; % for road 1 turn left
    end   
    if  hroad(central_pos-3, xpos_road) == color_road && hroad(central_pos-4, xpos_road+1 ) ~= color_road      
       hroad(central_pos-3, xpos_road+1) = color_control;
       hroad(central_pos+3, xpos_road+1) = color_control;

       % Color around control
       if xpos_road > central_pos && road_2_4 == 0 % do once one
        %  hroad(central_pos-4, xpos_road+1) = color_around_control ;
        %   hroad(central_pos+4, xpos_road+1) = color_around_control ;
    
        %   hroad(central_pos-3, xpos_road+2) = color_around_control ;
        %   hroad(central_pos+3, xpos_road+2) = color_around_control ;  
    
           hroad(central_pos-4, xpos_road+2) = color_street_light ;
           hroad(central_pos+4, xpos_road+2) = color_street_light ;

           road_2_4 = 1; % do once one
       end

       % save control for road 2 and 4
       hroad_coordinates(2,5) = xpos_road; % for road 2
       hroad_coordinates(4,5) = xpos_road; % for road 4

       % save turn zone for road 1 and 4
       hroad_coordinates(1,6) = xpos_road - 1; % for road 3 turn right
       hroad_coordinates(1,7) = xpos_road - 3; % for road 3 turn left

       hroad_coordinates(4,6) = xpos_road - 1; % for road 1 turn right 
       hroad_coordinates(4,7) = xpos_road - 3; % for road 1 turn left
    end    
    xpos_road = xpos_road + 1;
end
for i = 1 : 4
    hroad_coordinates(i,8) = 0; % fline for street light
    hroad_coordinates(i,9) = 0; % col fro street light
end    

% Search traffic lights - Road 1 and 2 - save coordinates 
if  color_street_light ~= 0  % Don't use traffic lights
for t = 1 : hight_matrix 
    if hroad(central_pos-3, t) == color_control && t > central_pos && hroad_coordinates(1,8) == 0
       hroad_coordinates(1,8) = central_pos-4; % for road 2 line
       hroad_coordinates(1,9) = t+1; % for road 1 col
    end
    if hroad(central_pos+3, t) == color_control && t < central_pos && hroad_coordinates(2,8) == 0
       hroad_coordinates(2,8) = central_pos+4; % for road 2 line
       hroad_coordinates(2,9) = t-1; % for road 2 col
    end
end   
% Search traffic lights - Road 3 and 4 - save coordinates 
for t = 1 : hight_matrix 
    if hroad(t, central_pos-3) == color_control && t < central_pos && hroad_coordinates(3,8) == 0
       hroad_coordinates(3,8) = t-1; % for road 3 line
       hroad_coordinates(3,9) = central_pos-4; % for road 3 col
    end
    if hroad(t, central_pos+3) == color_control && t > central_pos && hroad_coordinates(4,8) == 0
       hroad_coordinates(4,8) = t+1; % for road 4 line
       hroad_coordinates(4,9) = central_pos+4; % for road 4 col
    end
end 
end

% central intersection
a_x = central_pos;
a_y = central_pos-3;
hroad(a_y, a_x) = color_road_center;

a_x = central_pos;
a_y = central_pos-2;
hroad(a_y, a_x) = color_road;

a_x = central_pos;
a_y = central_pos-1;
hroad(a_y, a_x) = color_road;

a_x = central_pos;
a_y = central_pos+1;
hroad(a_y, a_x) = color_road;

a_x = central_pos;
a_y = central_pos+2;
hroad(a_y, a_x) = color_road;

a_x = central_pos;
a_y = central_pos+3;
hroad(a_y, a_x) = color_road_center;

% middle of central intersection
hroad(central_pos, central_pos) = color_central ;

%---------------------------------------
% search for control and zones to turn right and left
% ----  ROAD 1 - - varying X
xpos = 1;
ypos = central_pos - 2;
for t = 1 : central_pos
    xpos    = hight_matrix - t +1;
    xcolor1 = hroad(ypos, xpos );  % road
    xcolor2 = hroad(ypos-1, xpos );  % control
    %hroad(ypos-2, xpos ) = 6;
   if xcolor1 == color_road && xcolor2 == color_control
        hroad_coordinates(1,5) = xpos; % control for road  
        hroad_coordinates(1,6) = xpos -1; % for road  turn right 
        hroad_coordinates(1,7) = xpos -5; % for road turn left
   end
end 

% ----  ROAD 2 - - varying X
xpos = 1;
ypos = central_pos + 2;
for t = 1 : central_pos-2 
    xpos = t;
    xcolor1 = hroad(ypos, xpos  );  % road
    xcolor2 = hroad(ypos+1, xpos );  % control
   if xcolor1 == color_road && xcolor2 == color_control
        hroad_coordinates(2,5) = xpos; % control for road  
        hroad_coordinates(2,6) = xpos +1; % for road  turn right 
        hroad_coordinates(2,7) = xpos +5; % for road turn left
   end
end 
% ----  ROAD 3 - varying Y
ypos = 1;
xpos = central_pos - 2;
for t = 1 : central_pos -2
    ypos = t;
    xcolor1 = hroad(ypos, xpos );  % road
    xcolor2 = hroad(ypos, xpos-1);  % control
   if xcolor1 == color_road && xcolor2 == color_control
        hroad_coordinates(3,5) = ypos; % control for road  
        hroad_coordinates(3,6) = ypos +1; % for road  turn right 
        hroad_coordinates(3,7) = ypos +5; % for road turn left
   end
end 
% ----  ROAD 4 - varying Y
ypos = 1;
xpos = central_pos - 2;
for t = 1 : central_pos -2 
    ypos = hight_matrix - t +1;
    xcolor1 = hroad(ypos, xpos );  % road
    xcolor2 = hroad(ypos+1, xpos);  % control
   if xcolor1 == color_road && xcolor2 == color_control
        hroad_coordinates(4,5) = ypos; % control for road  
        hroad_coordinates(4,6) = ypos -1; % for road  turn right 
        hroad_coordinates(4,7) = ypos -5; % for road turn left
   end
end 
%    ( Y ,  X)
%hroad(3,   1) = 6;  % Test

end  % function