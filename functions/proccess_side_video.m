%% Functions - Proccess side video
% This script will procces a video as recorded from the side. It uses many
% functions but should stand as its own function and can be run
% independently on a signle video if needed. 


function proccess_side_video(videofolder)

cd(videofolder);
videoName = dir('*.avi');
videoName = videoName.name;

videoFReader = vision.VideoFileReader(videoName,'PlayCount',1);
videoPlayer = vision.DeployableVideoPlayer;
% videoFWriter = vision.VideoFileWriter('test.avi');
background = step(videoFReader); 

if size(background,3) == 3
     background  = rgb2gray(background);
end   

videoFReader = vision.VideoFileReader(videoName,'PlayCount',1);

prop_data(1:1000) = struct('Area',NaN,'BoundingBox',[NaN NaN NaN NaN],'Centroid',[NaN NaN],'EquivDiameter',NaN,'Perimeter',NaN,'OtherDrops', NaN);
boundary_data = cell(1000,1);

rect = [0, 0,size(background,2),size(background,1)];
test(1,1) = 0;
state = 0;
counter = 1;
centre = [0 0];

while ~isDone(videoFReader)
    
    frame_original = step(videoFReader); % read the next video frame
    
    if size(frame_original,3) == 3
        temp = rgb2hsv(frame_original);
        temp(:,:,2) = 0;
        frame_original = hsv2rgb(temp);
        frame_original = rgb2gray(frame_original);
    end   
    
    frame = imcrop(frame_original,rect);
    frame = imabsdiff(frame,imcrop(background,rect));
    
    BW = basic_process(frame);
    

    test(counter+1,1) = mean2(frame(1:5,:));
    
    if diff(test(counter:counter+1,1)) < -0.03 && state == 0 
       state = 1;
       key_frames.start_frame = counter;
%        first = frame_original;
       temp = regionprops(BW,'Centroid');
       centre = temp.Centroid;
    end
    
    if state == 1       
        
        [img_with_corners, corners] = find_corners(BW, centre);
        
        [prop_data, boundary_data] = process_BW(img_with_corners, counter,rect, prop_data, boundary_data,centre,3);
        
        prop_data(counter).corner_left = corners(1,:);
        prop_data(counter).corner_right = corners(2,:);

        poly_boundary = points_to_poly(boundary_data,counter);

        if isnan(poly_boundary) == 0
        traced_img = insertShape(frame_original, 'Polygon',poly_boundary, 'LineWidth', 2);
        traced_img = insertMarker( traced_img,corners);
        else
        traced_img = frame_original;
        end

        traced_img = insertText(traced_img,[10 10], num2str(counter), 'BoxOpacity', 1, ...
        'FontSize', 14);
        step(videoPlayer,traced_img);
        centre = prop_data(counter).Centroid;
    else 
         traced_img = insertText(frame_original,[10 10], num2str(counter), 'BoxOpacity', 1, ...
        'FontSize', 14);
         step(videoPlayer,traced_img);
         centre = prop_data(counter).Centroid;

    end

    counter = counter +1;
end

temp = vertcat(prop_data.BoundingBox);
[~, key_frames.max_frame] = max(temp(:,3));

temp = vertcat(prop_data.Centroid);
[~, temp_2] = max(diff(temp(key_frames.start_frame:key_frames.max_frame,2)));
key_frames.impact_frame = temp_2 + key_frames.start_frame;


save(strcat(videofolder,'\prop_data'),'prop_data');
save(strcat(videofolder,'\boundary_data'),'boundary_data');
save(strcat(videofolder,'\key_frames'),'key_frames');

end