oad('F:\Archive\Matheu\samples_database.mat');

folders = samples_database.folder_location;
for i = 1:33
    path_location = erase(folders{i,1},'\folders.mat');
    cd(path_location)
    if exist('impact_region_montage.jpg','file') ==2
        impact_images{i,1} = strcat(path_location, '\impact_region_montage.jpg');
    else
        impact_images{i,1} =  NaN;
    end
    if exist('max_spread_montage.jpg','file') ==2
        max_spread_images{i,1} = strcat(path_location, '\max_spread_montage.jpg');
    else
        max_spread_images{i,1} =  NaN;
    end
end






for i = 14:21
path_location = erase(folders{i,1},'\folders.mat');
impact_region_montage('max',videofolders,path_location)
impact_region_montage('impact',videofolders,path_location)
end

for i =10:25
 test(:,:,:,i-9)= imread(max_spread_images{i,1});
end

montage(test,'Size',[2 8])
