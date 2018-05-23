%% Functions - Advanced image processing 
% This script will procces a frame of the video using a more advanced
% routine. This involves using a edge detection routine which will slow
% down the processing. This method is generally used for underneath images.

function BW = advanced_process(frame, sigma)

    BW = rgb2gray(frame);
    BW = edge(BW,'canny',[0.1 0.2],sigma);
    BW = bwareaopen(BW,50,8);
    BW =  bwmorph(BW,'close');
    BW =  bwmorph(BW,'bridge');   

    BW_temp = imfill( BW , 'holes');
    BW_temp = bwareaopen(BW_temp,1000,4);
    
    temp  = regionprops(BW, 'Area');
    N_objects = numel(temp);
    
    if mean2(BW_temp) == 0 &&  N_objects < 10
        BW = filledgegaps(BW,40);
        BW = imfill( BW , 'holes');
        BW = bwareaopen(BW,1000,4);
    elseif mean2(BW_temp) > 0
            BW = BW_temp;
    else            
        BW = zeros(size(BW,1),size(BW,2));
    end
 end

