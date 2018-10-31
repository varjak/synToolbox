function Intensity_vs_distance_NN_inhi(dataStruct, distinguish_cells)

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
    
    NB = size(Inhib,1);
%     figure
    hold on
    for b = 1:NB
        n_inh = numel( Inhib(b).Distances );
        for k = 1:n_inh
            intensity = Inhib(b).Sizes(k);
            switch k
                case 1
                    nnd = abs( Inhib(b).Distances(2) - Inhib(b).Distances(1) );
                case n_inh
                    nnd = abs( Inhib(b).Distances(n_inh) - Inhib(b).Distances(n_inh-1) );
                otherwise
                    % check what't the nnd
                    nnd = min( abs( Inhib(b).Distances(k) - Inhib(b).Distances(k-1) ), abs( Inhib(b).Distances(k+1) - Inhib(b).Distances(k) ) );
            end
            plot( nnd, intensity, '.')
            hold on
        end
    end
    xlabel( 'Distante to nearest inh [\mum]' );
    ylabel( 'Inh size (F intensity) [a.u.]' );
    
    legend_vec{1,s} = ['Cell ', num2str(unique_cell_numbers(s))];
end

%% Show legend for each cell if distinguished
if distinguish_cells
    legend(deal(legend_vec))
end

end