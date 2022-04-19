clc; clear; close all

%% Control Panel
robot_xy = [1 4];
goal_xy = [4 1];


%% Defining Obstacles

load('field.mat')


%% Artificial Potential Field
eta = 10;
kp = .02;

d = bwdist(obstacle_field);
d = d/500;
rho = d+1;  % to avoid possible division by zero
rho0 = 1.5;

repulsive = eta * (1./rho - 1/rho0).^2;
repulsive(rho > rho0) = 0;

[x_mesh, y_mesh] = meshgrid(field_x, field_y);
attractive = kp * ( (x_mesh - goal_xy(1)).^2 + (y_mesh - goal_xy(2)).^2);

field =  repulsive + attractive;


%% Plotting Arena
figure
mesh(field_x, field_y, field)
colorbar
xlim(bounds_x)
ylim(bounds_y)
zlim([0, 1.2*max(max(field))])
xlabel('x [m]')
ylabel('y [m]')

hold on
draw_cylinder(robot_xy, 0.1, 'b')
draw_cylinder(goal_xy, 0.1, 'r')

legend('APF', 'Robot', 'Goal')


%% Gradient

figure
[FX, FY] = gradient(-field);
quiver(field_x, field_y, FX, FY)
xlabel('x [m]')
ylabel('y [m]')


%% Functions

function [] = draw_cylinder(xy, r, color)
   [xc,yc,z] = cylinder(r);
   
   xc = xc + xy(1);
   yc = yc + xy(2);
   z_height = max(z, [], 'all');
   z = z/z_height * 0.5;
   
   surf(xc,yc,z, 'FaceColor', color, 'EdgeColor', 'none')
end