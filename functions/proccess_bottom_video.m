%% Functions - Proccess bottom video
% This script will procces a video as recorded from the bottom. It uses many
% functions but should stand as its own function and can be run
% independently on a signle video if needed. 


function proccess_bottom_video(videofolder,option)

cd(videofolder);
videoName = dir('*.avi');
videoName = videoName.name;

videoFReader = vision.VideoFileReader(videoName,'PlayCount',1);
videoPlayer = vision.DeployableVideoPlayer;

background = step(videoFReader); 

videoFReader = vision.VideoFileReader(videoName,'PlayCount',1);

prop_data(1:1000) = struct('Area',zeros(1,1),'BoundingBox',zeros(1,4),'Centroid',zeros(1,2),'EquivDiameter',zeros(1,1),'Perimeter',zeros(1,1));
boundary_data = cell(1000,1);
% 
% imshow(background)
% rect = getrect;
% close all

rect = [0, 0,size(background,2),size(background,1)];

sigma = 1.5;
counter = 1;

centre = [size(background,2)/2,size(background,1)/2];

while ~isDone(videoFReader)
    
    frame_original = step(videoFReader); % read the next video frame
    frame = imcrop(frame_original,rect);
%     frame = imabsdiff(frame,imcrop(background,rect));
    BW = advanced_process(frame, sigma);


    [prop_data, boundary_data] = process_BW(BW, counter,rect, prop_data, boundary_data, centre,3);
    
    poly_boundary = points_to_poly(boundary_data,counter);
    
    if isnan(poly_boundary) == 0
    traced_img = insertShape(frame_original, 'Polygon',poly_boundary, 'LineWidth', 2);
    centre = prop_data(counter).Centroid;  
    else
    traced_img = frame_original;
    end
        
    traced_img = insertText(traced_img,[10 10], num2str(counter), 'BoxOpacity', 1, ...
    'FontSize', 14);

    switch option
        case 'on'
            step(videoPlayer,traced_img);
        case 'off'
    end
    counter = counter +1;
    
end

temp = vertcat(prop_data.Area);
[~, key_frames.max_frame] = max(temp);

max_img = max_spread_img(videoName,prop_data, key_frames);
imwrite(max_img,strcat(videofolder,'\max_spread.jpg'));

centre_img = centre_region_img(max_img);

imwrite(centre_img,strcat(videofolder,'\impact_region.jpg'));

bubble_image = highten_bubbles(max_img);
imwrite(bubble_image,strcat(videofolder,'\bubbles.jpg'));


save(strcat(videofolder,'\prop_data'),'prop_data');
save(strcat(videofolder,'\boundary_data'),'boundary_data');
save(strcat(videofolder,'\key_frames'),'key_frames');
%  save(strcat(videofolder,'\centre_shape'),'centre_shape');
end
