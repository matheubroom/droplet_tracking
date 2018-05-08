%% Functions - Basic image processing 
% This script will procces a frame of the video using a very basic image
% processing method of thresholding and filling.

function BW = basic_process(frame)
    BW = imbinarize(frame,0.4);
    BW = padarray(BW,[1 1],1,'pre');
    BW = imfill(BW,'holes');
    BW = BW(2:end,2:end);
    BW = bwareaopen(BW,1000);
end