%% Functions - Find corners
% This script will procces a frame of the video to find the corners that
% are the contact points of the droplet. All corners in the image are found
% using the harris feastures function. Then the closest finger to the
% bottom corners of the bounding box are found. 


function [img_with_corners, corners] = find_corners(frame, centre)

    temp_data = regionprops(frame,'BoundingBox','Centroid');

    if isempty(temp_data) == 0
        temp = vertcat(temp_data.Centroid);
        idx = knnsearch(temp,centre);
        
        x_left = temp_data(idx).BoundingBox(1,1);
        y_left = temp_data(idx).BoundingBox(1,2)+temp_data(idx).BoundingBox(1,4);
        
        x_right = temp_data(idx).BoundingBox(1,1)+temp_data(idx).BoundingBox(1,3);
        y_right = temp_data(idx).BoundingBox(1,2)+temp_data(idx).BoundingBox(1,4);

        points = detectHarrisFeatures(frame);
        points_found = points.Location;
        
        points_shift  = points_found  - [x_left y_left]; 
        idx = knnsearch(points_shift,[0 0], 'K',1);
        corners(1,:) = [points_shift(idx,1)+x_left points_shift(idx,2)+y_left];
        
        points_shift  = points_found  - [x_right y_right]; 
        idx = knnsearch(points_shift,[0 0], 'K',1);
        corners(2,:) = [points_shift(idx,1)+x_right points_shift(idx,2)+y_right];
        frame = im2uint8(frame);
        img_with_corners = insertShape(frame,'line',[corners(1,:) corners(2,:)], 'Color', 'white','LineWidth',2);
    else
        
        img_with_corners  = frame;
        corners = [NaN NaN; NaN NaN];
    end
  
end