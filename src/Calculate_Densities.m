function [densityStruct_shaft, densityStruct_spine] = Calculate_Densities(dataStruct, resolution, kernel_sigma_spines, kernel_sigma_inhib, USE_INTENSITY_INFO)
%% Prepare kernel for density calculation
kernel_spines = fspecial( 'gaussian', [1, resolution * kernel_sigma_spines * 7], resolution * kernel_sigma_spines );
kernel_inhib  = fspecial( 'gaussian', [1, resolution * kernel_sigma_inhib * 7 ], resolution * kernel_sigma_inhib  );

%% Prepare struct for results
densityStruct_shaft = struct('x_bin', {}, 'x_hit', {}, 'density', {});
densityStruct_spine = struct('x_bin', {}, 'x_hit', {}, 'density', {});

%% Select rows of 'spine' and 'shaft' synapses
dataStruct_spine = dataStruct(strcmp({dataStruct.Synapse}, 'spines'));
dataStruct_shaft = dataStruct(strcmp({dataStruct.Synapse}, 'shaft'));

%% Calculate densities
Nbranches = size(dataStruct_shaft,1);
% figure
% hold on
for b = 1:Nbranches
    % Get distances
    inhib_distances = dataStruct_shaft(b).Data(:,1);
    spine_distances = dataStruct_spine(b).Data(:,1);
    
    % Get intensities
    inhib_sizes = dataStruct_shaft(b).Data(:,2);
    spine_sizes = dataStruct_spine(b).Data(:,2);
    
    % Count synapses in bins
    lower_bound = min( [ inhib_distances; spine_distances ] );
    upper_bound = max( [ inhib_distances; spine_distances ] ) + 1/resolution;
    
    x_bin = lower_bound : 1/resolution : upper_bound;
    shaft_x_hit = zeros( size( x_bin ) );
    spine_x_hit = zeros( size( x_bin ) );
    
    shaft_hits_ids = 1 + round( ( inhib_distances - lower_bound ) * resolution );
    spine_hits_ids = 1 + round( ( spine_distances - lower_bound ) * resolution );
    
    % Initialize trimmed hits vecs
    trimmed_shaft_hits_ids = shaft_hits_ids;
    trimmed_spine_hits_ids = spine_hits_ids;
    
    % Trim hits beyond branch limits
    trimmed_shaft_hits_ids(shaft_hits_ids > size(shaft_x_hit,2))=[];
    trimmed_shaft_hits_ids(shaft_hits_ids < 0)=[];
    trimmed_spine_hits_ids(spine_hits_ids > size(spine_x_hit,2))=[];
    trimmed_spine_hits_ids(spine_hits_ids < 0)=[];
    
    shaft_x_hit( trimmed_shaft_hits_ids ) = 1;
    spine_x_hit( trimmed_spine_hits_ids ) = 1;
    
    % Calculate standart density or intensity density
    if USE_INTENSITY_INFO == 0
        shaft_x_hit( trimmed_shaft_hits_ids ) = 1;
        spine_x_hit( trimmed_spine_hits_ids ) = 1;
    else
        shaft_x_hit( trimmed_shaft_hits_ids ) = inhib_sizes(logical( (shaft_hits_ids >= 0).*(shaft_hits_ids <= size(shaft_x_hit,2)) ));
        spine_x_hit( trimmed_spine_hits_ids ) = spine_sizes( logical( (spine_hits_ids >= 0).*(spine_hits_ids <= size(spine_x_hit,2)) ));
    end
    
    shaft_density = conv( shaft_x_hit, kernel_inhib, 'same' );
    spine_density = conv( spine_x_hit, kernel_spines, 'same' );
    
    % Save processing results
    densityStruct_shaft(end +1) = struct('x_bin', x_bin, 'x_hit', shaft_x_hit, 'density', shaft_density);
    densityStruct_spine(end+ 1) = struct('x_bin', x_bin, 'x_hit', spine_x_hit, 'density', spine_density);
end

end
