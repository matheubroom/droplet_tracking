%% Data Processing - Calculate weber
% This script will calculate the weber number, reynolds and velocity of the
% droplet given the prop data, key frames and convertion factor. The values
% of the viscosity and surface tension of the fluid can be given, if not
% provided the values for water are used. 


function [weber, reynold, velocity, diameter] = calculate_weber(prop_data, key_frames, convert_factor,viscosity,surface_tension,density)

    switch nargin
        case 3
            % this defines the values of the fluid of water if not given
            % any as an input
            density = 997.77; % units Kg/m^3 source Kaye and Laby (@22degrees)
            surface_tension = 72.75e-3; % units N/m source Kaye and Laby (@20degrees)
            viscosity = 8.9e-4;
    end

    temp = vertcat(prop_data.Centroid);

    ycentre = temp(key_frames.start_frame:key_frames.impact_frame,2)*convert_factor/1000;

    time = 1/9300.*linspace(1,length(ycentre),length(ycentre))';
    p = polyfit(time, ycentre,1);
    velocity= p(1,1);    

    x = prop_data(key_frames.impact_frame).BoundingBox(1,3);
    y = prop_data(key_frames.impact_frame).BoundingBox(1,4);
    
    diameter = 2*nthroot((x/2)^2 * y/2,3);

    diameter_mm = 2*nthroot((x/2)^2 * y/2,3)*convert_factor;

    reynold = (density* velocity * diameter_mm/1000)/viscosity;

    weber = (density * velocity^2 * diameter_mm/1000)/surface_tension;

end