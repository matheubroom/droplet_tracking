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

temp_frame = readFrame(video);
imshow(temp_frame);
rect = getrect;
close all


for i = 1:num_frames
    frame_number = start_frame + (i*frame_step);
    video.CurrentTime = frame_number  /video.FrameRate;
    temp = readFrame(video);
    temp = imcrop(temp,rect);
    time = (((i-1)*frame_step)/frame_rate)*1000;
    temp = insertText(temp,[10 10],strcat('t =',num2str(time),'ms'),'FontSize',18,'BoxColor','yellow','BoxOpacity',0.4,'TextColor','white');
    frame(:,:,:,i) = temp;
end

num_rows = 2;
num_cols = num_frames/num_rows;

montage_img =montage(frame, 'Size', [num_rows num_cols]);

MyMontage = get(montage_img, 'CData');

imwrite(MyMontage , strcat(path,'montage_img.jpg'));


function frame_rate = find_frame_rate(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as a matrix.
%   T1C1S0001 = IMPORTFILE(FILENAME) Reads data from text file FILENAME for
%   the default selection.
%
%   T1C1S0001 = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from rows
%   STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   t1C1S0001 = importfile('t1_C1S0001.cih', 16, 16);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2018/05/18 09:58:14

%% Initialize variables.
delimiter = ' ';
if nargin<=2
    startRow = 16;
    endRow = 16;
end

%% Format for each line of text:
%   column4: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%*s%*s%*s%f%*s%*s%*s%*s%*s%*s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
textscan(fileID, '%[^\n\r]', startRow(1)-1, 'WhiteSpace', '', 'ReturnOnError', false);
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    textscan(fileID, '%[^\n\r]', startRow(block)-1, 'WhiteSpace', '', 'ReturnOnError', false);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'ReturnOnError', false, 'EndOfLine', '\r\n');
    dataArray{1} = [dataArray{1};dataArrayBlock{1}];
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
frame_rate = [dataArray{1:end-1}];
end
