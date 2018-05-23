%% Video Loops - parallel process video folder - side
% This script will parallel process the given videos in the video folders
% given the number of cores to use and the folders. 

load('F:\Archive\Matheu\samples_database.mat');

folders = samples_database.folder_location;
tic
for k = 25:25
load(folders{k,1});

parfor i = 1:length(folders)
    try
     proccess_side_video(videofolders(i).side_video);
    catch ME
        error{i,1} = ME.message;
    end
    
end

missed_videos = find(~cellfun(@isempty,error));

for i =1:length(missed_videos)
     proccess_side_video(videofolders(missed_videos(i)).side_video);
end

disp(k)
end
time = toc;
    

    
