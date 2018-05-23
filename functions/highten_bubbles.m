%% Functions - Highten Bubble Image
% This script will sharpen the difference in the impact region of a drople
% so that the bubbles are more clear. 

function bubble_image = highten_bubbles(max_img)

    if size(max_img,3) > 1
        max_img = rgb2gray(max_img);
    end
    img_length = 250;
    centre = [size(max_img,2)/2, size(max_img,1)/2];

    rect = [centre(1,1)-img_length/2 centre(1,2)-img_length/2 img_length img_length];
    centre_img = imcrop(max_img,rect);

    centre_img = imsharpen(centre_img);
    f=double(centre_img);

    f=f-min(f(:)) ;
    f=f/max(f(:)) ;
    f=(f>0.25).*f ;
    h=fspecial('gaussian',10,2) ;
    f=imfilter(double(f),h,'symmetric') ;

    bubble_image = im2uint8(f);

    bubble_image = ind2rgb(bubble_image, hot(256));
end
