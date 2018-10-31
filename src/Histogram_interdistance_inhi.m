function Histogram_interdistance_inhi(dataStruct, distinguish_cells)

%% Insert dataStruct or partitions (distinguished by Cell) into cell array
unique_cell_numbers = unique([dataStruct.Cell]);
dataStruct_cell = Partition_dataStruct(dataStruct, unique_cell_numbers, distinguish_cells);
Nstructs = size(dataStruct_cell,2);
legend_vec = cell(1, size(unique_cell_numbers,2));

%% Calculate histogram
% Loop over cell array
for s = 1:Nstructs
    
    %Inhib/Spines have:
    % - data fields: 'Distances', 'Sizes' 'BranchSize' (from dataStruct)
    % - analysis fields: 'interDistances','x_bin', 'x_hit', 'density'
    [Inhib, Spines] = Transform_dataStruct_into_Inhib_and_Spines(dataStruct_cell{s});
    
    pool = [];
    NB = size(Inhib,1);
    bin_width2 = 4;
    
    for b = 1:NB
        % This is being done per branch; could be done per cell
        diff_dists = diff( sort(Inhib(b).Distances) );
        pool = [pool; diff_dists];
    end
    
    % figure
    histogram( pool, 0:bin_width2:40, 'Normalization','pdf')
    axis tight
    title('Histogram of inhi. interdistances')
    xlabel( 'Inter-distance [\mum]' );
    ylabel( 'Counts' );
    hold on
    legend_vec{1,s} = ['Cell ', num2str(unique_cell_numbers(s))];
end

%% Show legend for each cell if distinguished
if distinguish_cells
    legend(deal(legend_vec))
end

end