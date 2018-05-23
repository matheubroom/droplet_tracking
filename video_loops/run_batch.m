%% Video Loops - Run batch parallel
% This script will run the parallel process of videos given a video folder
% using only 3 of the 4 cores of the pc. This allows Matlab to be
% useable for other work during processing. 

number_cores = 3;
j = batch('parallel_process_video_folder','Profile','local','Pool',number_cores);

wait(j,'finished');
load(j,'time');

message = strcat('Batch process has finished with a time of',num2str(round(time)),' seconds');
disp(message)