clc; clear; close all;
global obstacle_field field_resolution field_len_x field_len_y field_x field_y

%% Control Panel
bounds_x = [0 5];
bounds_y = [0 5];
field_resolution = 100;     % divisions per unit

PLOT_ARENA = 1;
SAVE_MAT = 1;

%% Calculations

field_x = bounds_x(1):(1/field_resolution):bounds_x(2);
field_y = bounds_y(1):(1/field_resolution):bounds_y(2);
field_len_x = length(field_x);
field_len_y = length(field_y);
obstacle_field = zeros(field_len_x, field_len_y);

% add shapes here -----------
draw_rectangle([1 1], 2, 1)
draw_circle([4.5 4.5], 1)
% ---------------------------

if PLOT_ARENA
    surf(field_x, field_y, obstacle_field, 'EdgeColor', 'none')
    xlim(bounds_x)
    ylim(bounds_y)
    xlabel('x [m]')
    ylabel('y [m]')
    title('Arena Map')
    set(gca,'YDir','reverse')
end

if SAVE_MAT
   save('field.mat')
end


%% Functions

function [] = draw_rectangle(center, len_x, len_y)
    global obstacle_field field_resolution field_len_x field_len_y
    scale = @(x) floor(x*field_resolution) + 1;
    
    top_left_x = scale(center(1) - len_x/2);
    top_left_y = scale(center(2) + len_y/2);
    scaled_len_x = scale(len_x);
    scaled_len_y = scale(len_y);
    bot_left_y = top_left_y - scaled_len_y;
    top_right_x = top_left_x + scaled_len_x;
    
    if scaled_len_x < 0
        error("Cannot use a negative X dimension.")
    elseif scaled_len_y < 0
        error("Cannot use a negative Y dimension.")
    elseif bot_left_y > field_len_y
        error("Top Left Y-Coordinate is out of bounds (%d > %d).", bot_left_y, field_len_y)
    elseif bot_left_y < 1
        error("Top Left Y-Coordinate is out of bounds (%d < 1).", bot_left_y)
    elseif top_left_x > field_len_x
        error("Top Left X-Coordinate is out of bounds (%d > %d).", top_left_x, field_len_x)
    elseif top_left_x < 1
        error("Top Left X-Coordinate is out of bounds (%d < 1).", top_left_x)
    elseif top_right_x > field_len_x
        error("Top Right X-Coordinate is out of bounds (%d > %d)", top_right_x, field_len_x)
    elseif top_left_y > field_len_y
        error("Botton Left Y-Coordinate is out of bounds (%d > %d)", topa_left_y, field_len_y)
    end
    
    obstacle_field(bot_left_y:top_left_y, top_left_x:top_right_x) = 1;
end

function [] = draw_circle(center, radius)
    global obstacle_field field_resolution field_len_x field_len_y
    scale = @(x) floor(x*field_resolution) + 1;
    
    center_x = scale(center(1));
    center_y = scale(center(2));
    r = scale(radius);
    
    [x,y] = meshgrid(1:field_len_x, 1:field_len_y);
    circle = ((x - center_x).^2 + (y - center_y).^2) < r^2;
    obstacle_field(circle) = 1;
end