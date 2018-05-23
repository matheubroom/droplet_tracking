%% Functions - poly boundary
% This basic script converts the format of a set of x,y points into the
% form needed for inserting a poly shape in an image.


function poly_boundary = points_to_poly(boundary_data,counter)
    if isnan(boundary_data{counter,1}(:,1)) == 0
        poly_boundary = [boundary_data{counter,1}(:,2),boundary_data{counter,1}(:,1)];
        poly_boundary = reshape(poly_boundary',length(poly_boundary)*2,1)';
    else
        poly_boundary = [NaN NaN];
    end
end