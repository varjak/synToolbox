function Density_exci_around_syn_inhi(dataStruct, distinguish_cells)

%% Insert dataStruct or partitions (distinguished by Cell) into cell array
unique_cell_numbers = unique([dataStruct.Cell]);
dataStruct_cell = Partition_dataStruct(dataStruct, unique_cell_numbers, distinguish_cells);
Nstructs = size(dataStruct_cell,2);
legend_vec = cell(1, size(unique_cell_numbers,2));

%% Calculate histogram
% Loop over cell array
figure
for s = 1:Nstructs

    %Inhib/Spines have:
    % - data fields: 'Distances', 'Sizes' 'BranchSize' (from dataStruct)
    % - analysis fields: 'interDistances','x_bin', 'x_hit', 'density'
    [Inhib, Spines] = Transform_dataStruct_into_Inhib_and_Spines(dataStruct_cell{s});
    
    % Calculate spine and shaft density profiles
    % PARAMETERS
    resolution = 10; %[um-1]
    kernel_sigma_spines = 0.5;   %[um]
    kernel_sigma_inhib = 1.5;   %[um] %0.2
    USE_INTENSITY_INFO = 1;
    [densityStruct_shaft, densityStruct_spine] = Calculate_Densities(dataStruct_cell{s}, resolution, kernel_sigma_spines, kernel_sigma_inhib, USE_INTENSITY_INFO);
    
    % Put density profiles in Inhib/Spines
    [Inhib(:).density] = deal(densityStruct_shaft(:).density);
    [Spines(:).density] = deal(densityStruct_spine(:).density);
    [Inhib(:).x_bin] = deal(densityStruct_shaft(:).x_bin);
    [Spines(:).x_bin] = deal(densityStruct_spine(:).x_bin);
    [Inhib(:).x_hit] = deal(densityStruct_shaft(:).x_hit);
    [Spines(:).x_hit] = deal(densityStruct_spine(:).x_hit);
    
    %% Assess mean density of spines "above" and "below" inhibitory synapses
    npoints = 25*kernel_sigma_inhib * resolution;
    density_around = [];
    % figure
    for b = 1:size(Inhib,1)
        for inhib_id = find( Inhib(b).x_hit > 0 );
            % Only use this segment if it contains the full neighbourhood
            if inhib_id - npoints > 1 && inhib_id + npoints < numel( Spines(b).density ) + 1
                spine_density = Spines(b).density( inhib_id - npoints : inhib_id + npoints );
                density_around = [ spine_density; density_around ];
            end
        end
    end
    density_around_mean = mean( density_around, 1);
    density_around_sem  = std( density_around, 1) / sqrt( size(density_around, 1 ) );
    x_data = (-npoints:npoints)./resolution;
    
    
    % plot( x_data, density_around_mean, 'b' )
    plot( x_data, density_around_mean)
    hold on
    if ~distinguish_cells
        plot( x_data, density_around_mean - density_around_sem, 'r:' )
        plot( x_data, density_around_mean + density_around_sem, 'r:' )
    end
    xlabel( 'Position [\mum]' );
    ylabel( 'spines density [(intensity)/\mum]' );
    
    legend_vec{1,s} = ['Cell ', num2str(unique_cell_numbers(s))];
end

%% Show legend for each cell if distinguished
if distinguish_cells
    legend(deal(legend_vec))
end

end

