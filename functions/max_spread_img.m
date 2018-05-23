%% Functions - Max Spread Image
% This script will find the max spread img of a video 


function max_img = max_spread_img(videoName,prop_data, key_frames)

videoFReader = vision.VideoFileReader(videoName,'PlayCount',1);

for i = 1:key_frames.max_frame
    max_img = step(videoFReader);
end

img_length = 600;
centre = prop_data(key_frames.max_frame).Centroid;
rect = [centre(1,1)-img_length/2 centre(1,2)-img_length/2 img_length img_length];
max_img = imcrop(max_img,rect);
end
