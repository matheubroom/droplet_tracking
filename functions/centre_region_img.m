%% Functions - Centre Region Image
% This script will find the shape of the impacted region of a droplet 

function [centre_img, centre_shape] = centre_region_img(max_img, method)

    if size(max_img,3) > 1
        max_img = rgb2gray(max_img);
    end

    img_length = 250;
    centre = [size(max_img,2)/2, size(max_img,1)/2];

    rect = [centre(1,1)-img_length/2 centre(1,2)-img_length/2 img_length img_length];
    centre_img = imcrop(max_img,rect);

    centre_img = imsharpen(centre_img);
    
    if nargin > 1
    switch method
        case 1
        BW = edge(centre_img,'canny',[0.1 0.2],3);
        BW = bwareaopen(BW,100,8);
        BW =  bwmorph(BW,'close');
        BW =  bwmorph(BW,'bridge');   
        BW = imfill( BW , 'holes');
        temp_data = regionprops(BW,'Area','Perimeter');
        temp = vertcat(temp_data.Area);
        [~, idx] = max(temp);
        centre_shape = temp_data(idx);
        boundary = bwboundaries(BW,'noholes');
        centre_shape.boundary = boundary{idx,1};
        poly_boundary = points_to_poly(boundary,1);
        centre_img = insertShape(centre_img,'Polygon',poly_boundary,'Color',[179/255,0,0], 'LineWidth',2);
    end
    end
end

    