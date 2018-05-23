%% Folder structure
% This basic script will generate a folder structure given the main folder
% location and the steps taken between the heights of the needle height. 

folder_loc = uigetdir;

start_height = 5000;
step_height = 1000;
number_heights = 11;

for i = 1:number_heights
    number = num2str(start_height+((i-1)*step_height));
    sample = strcat('Z',number);
    videofolders((i*3)-2).bottom_video = strcat(folder_loc,'\',sample,'\t1\t1_C1S0001\');
    videofolders((i*3)-1).bottom_video = strcat(folder_loc,'\',sample,'\t2\t2_C1S0001\');
    videofolders(i*3).bottom_video = strcat(folder_loc,'\',sample,'\t3\t3_C1S0001\');
    videofolders((i*3)-2).side_video  = strcat(folder_loc,'\',sample,'\t1\t1_C2S0001\');
    videofolders((i*3)-1).side_video = strcat(folder_loc,'\',sample,'\t2\t2_C2S0001\');
    videofolders(i*3).side_video = strcat(folder_loc,'\',sample,'\t3\t3_C2S0001\');
end

cd(folder_loc);
img_cal_side = imread('side_calibration.tif');
img_cal_bottom = imread('bottom_calibration.tif');
 
conversion_factor_side = calculate_conversion(img_cal_side,4);
conversion_factor_bottom = calculate_conversion(img_cal_bottom, 4);

videofolders(1).conversion_factor_side = conversion_factor_side;
videofolders(1).conversion_factor_bottom = conversion_factor_bottom;

save('folders.mat','videofolders');
