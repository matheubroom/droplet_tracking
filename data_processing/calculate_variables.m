%% Data Processing - Main values, weber, reynolds, velocity, spreadfactor
% This script will calculate the weber number, reynolds, velocity and
% spread factor for a set of given videos. This is used for side videos. 

function calculate_variables(videofolders)

conversion_factor_side = videofolders(1).conversion_factor_side;

weber = zeros(length(videofolders),1);
reynold = zeros(length(videofolders),1);
velocity = zeros(length(videofolders),1);
diameter = zeros(length(videofolders),1);
spread_factor = zeros(length(videofolders),1);


for i= 1:length(videofolders)
    cd(videofolders(i).side_video);
    load('prop_data.mat');
    load('key_frames.mat');
    
    [weber(i,1), reynold(i,1), velocity(i,1), diameter(i,1)] = calculate_weber(prop_data, key_frames,conversion_factor_side);
    spread_factor(i,1) = prop_data(key_frames.max_frame).BoundingBox(1,3)/diameter(i,1);
end

[filepath,~,~] = fileparts(videofolders(1).side_video);

out=regexp(filepath,'\','split');

folder = strcat(out{1,1},'\',out{1,2},'\',out{1,3},'\',out{1,4},'\');

save_name = strcat(out{1,4},'_',out{1,5},'_main_variables');

save(strcat(folder,save_name),'weber','reynold','velocity','spread_factor')