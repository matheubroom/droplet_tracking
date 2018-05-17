%% Quick dirty script to make a montage of frames from a video
% user selects a video from a folder which must contain a .cih file as
% well. The user is then asked for the start frame, step in frames per
% image and the total number of images. 

[file,path] = uigetfile('*.avi');
video = VideoReader(strcat(path,file));

prompt = 'What is the start frame?';
start_frame = input(prompt);

prompt = 'What is step in frames?';
frame_step = input(prompt);

prompt = 'How many frames?';
num_frames = input(prompt);

name_file = erase(file,'.avi');
frame_rate = find_frame_rate(strcat(path,name_file,'.cih'), 16, 16);


for i = 1:num_frames
    frame_number = start_frame + (i*frame_step);
    video.CurrentTime = frame_number  /video.FrameRate;
    temp = readFrame(video);
    time = (((i-1)*frame_step)/frame_rate)*1000;
    temp = insertText(temp,[10 10],strcat('t =',num2str(time),'ms'),'FontSize',18,'BoxColor','yellow','BoxOpacity',0.4,'TextColor','white');
    frame(:,:,:,i) = temp;
end

num_rows = 2;
num_cols = num_frames/num_rows;

montage_img =montage(frame, 'Size', [num_rows num_cols]);

imwrite(montage_img, strcat(path,'montage_img.jpg'));
