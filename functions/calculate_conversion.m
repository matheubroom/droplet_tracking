%% Functions - Calculate conversion
% This script will calculate the conversion factor from px to mm given an
% object with a known size in frame. The user is asked for the length in mm
% and asked to draw a horizontal line across the object. 

function convertion_factor = calculate_conversion(img, length_mm)

switch nargin
    case 1
        prompt = 'What is the length of the object in mm? ';
        length_mm = input(prompt);
    case 2
        length_mm = length_mm;
end


if size(img,3) == 3
    img = rgb2gray(img);
end

imshow(img)
[xi,yi] = getline;
close all

data = improfile(img,xi,yi);
data = (abs(diff(data)));
[~, idx] =  maxk(data,2);

dist_px = abs(idx(1,1)-idx(2,1));

convertion_factor = length_mm/dist_px;
end