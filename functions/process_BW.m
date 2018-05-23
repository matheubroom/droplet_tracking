%% Functions - Proccess BW
% This script will procces BW frame to retrieve the main measurements. 


function [prop_data, boundary_data] = process_BW(BW, counter,rect, prop_data, boundary_data,centre, method)
    if islogical(BW) == 0
        BW =  im2bw(BW);
    end
    
    temp_data = regionprops(BW,'BoundingBox','Area','Centroid','EquivDiameter','Perimeter');
       
    if isempty(temp_data) == 0
        
        switch method
            case 1
            temp = vertcat(temp_data.Centroid);
            idx = knnsearch(temp,centre);
            case 2
            temp = vertcat(temp_data.Area);
            [~, idx] = max(temp);
            case 3
            temp = vertcat(temp_data.Centroid);
            [idx,D] = knnsearch(temp,centre);
            if D > 0.2*size(BW,1)
                idx = [];
            elseif vertcat(temp_data(idx).Area) > 0.4*(size(BW,1)*size(BW,2))
                idx = [];
            else
                idx = idx;
            end
                
        end
    else
        idx = [];
 
    end

    
    if isempty(idx) == 1
        prop_data(counter).Area  = NaN;
        prop_data(counter).BoundingBox  = [NaN NaN NaN NaN];
        prop_data(counter).Centroid  = [NaN NaN];
        prop_data(counter).EquivDiameter  = NaN;
        prop_data(counter).Perimeter  = NaN;
        prop_data(counter).OtherDrops = NaN;
        boundary_data{counter,1} = [NaN NaN];
    else          
        prop_data(counter).Area  = temp_data(idx).Area;
        prop_data(counter).BoundingBox  = temp_data(idx).BoundingBox + [rect(1,1:2),0,0];
        prop_data(counter).Centroid  = temp_data(idx).Centroid + rect(1,1:2);
        prop_data(counter).EquivDiameter  = temp_data(idx).EquivDiameter;
        prop_data(counter).Perimeter  = temp_data(idx).Perimeter;
        temp_boundary = bwboundaries(BW,'noholes');
        boundary_data{counter,1}(:,:) = temp_boundary{idx,1}(:,:)+[rect(1,2),rect(1,1)];

    
    if  size(temp_data,1) > 1
        temp_data(idx) = [];
        prop_data(counter).OtherDrops = temp_data;
    else 
        prop_data(counter).OtherDrops = NaN;
    end
    end
    


end
 