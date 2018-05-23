%% Video Loops - parallel process video folder
% This script will parallel process the given videos in the video folders
% given the number of cores to use and the folders. 

load('F:\Archive\Matheu\samples_database.mat');

folders = samples_database.folder_location;
tic
for k = 12:12
load(folders{k,1});

parfor i = 1:length(folders)
%     try
     proccess_bottom_video(videofolders(i).bottom_video,'off');
%      missed_files(i,1) = NaN;
%     catch ME
%         if exist('ME') == 1
%             if (strcmp(ME.identifier,'dspshared:system:libOutFromMmFile')) == 1
%                 missed_files(i,1) = i;
%                 clear ME
%             end       
%         end 
% 
%     end
% 
%     path_location = erase(folders{k,1},'\folders.mat');
%     cd(path_location);
%     save('missed_files.mat','missed_files');


end
path_location = erase(folders{k,1},'\folders.mat');
impact_region_montage('max',videofolders,path_location)
impact_region_montage('impact',videofolders,path_location)

disp(k)
end
time = toc;
    

    
