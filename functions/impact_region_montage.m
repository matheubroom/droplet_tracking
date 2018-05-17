function impact_region_montage(image_type,videofolders,location)

    for i =1:length(videofolders)
        cd(videofolders(i).bottom_video)
        switch image_type
            case 'impact'
                temp = imread('impact_region.jpg');
                save_name = 'impact_region_montage.jpg';
            case 'max'
                temp = imread('max_spread.jpg');
                save_name = 'max_spread_montage.jpg';
            case 'bubble'
                temp = imread('bubbles.jpg');
                save_name = 'bubbles_montage.jpg';
        end
        
        [x y z] = size(temp);
        
 
        if x < 601
             delta_p = 601 - x;
             temp = padarray(temp,[delta_p/2 0],0);
        end
        if y < 601
            delta_p = 601 - y;
            temp = padarray(temp,[0 delta_p/2],0);
        end
        
        image_stack(:,:,:,i) = temp;
    end
    
    for i =1:11
    image_row(:,:,:,i) = [image_stack(:,:,:,(i*3)-2),image_stack(:,:,:,(i*3)-1),image_stack(:,:,:,(i*3)-0)];
    end

    newimage = [image_row(:,:,:,1);image_row(:,:,:,2);image_row(:,:,:,3);image_row(:,:,:,4);image_row(:,:,:,5);image_row(:,:,:,6);image_row(:,:,:,7);image_row(:,:,:,8);image_row(:,:,:,9);image_row(:,:,:,10);image_row(:,:,:,11)];
    cd(location)
    
    imwrite(newimage,save_name);

end
