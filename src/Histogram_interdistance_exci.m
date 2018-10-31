function Histogram_interdistance_exci(dataStruct, distinguish_cells)

%% Insert dataStruct or partitions (distinguished by Cell) into cell array
unique_cell_numbers = unique([dataStruct.Cell]);
dataStruct_cell = Partition_dataStruct(dataStruct, unique_cell_numbers, distinguish_cells);
Nstructs = size(dataStruct_cell,2);
legend_vec = cell(1, size(unique_cell_numbers,2));

%% Calculate histogram
% Loop over cell array
pool_cell = cell(1,Nstructs);
for s = 1:Nstructs

    %Inhib/Spines have:
    % - data fields: 'Distances', 'Sizes' 'BranchSize' (from dataStruct)
    % - analysis fields: 'interDistances','x_bin', 'x_hit', 'density'
    [Inhib, Spines] = Transform_dataStruct_into_Inhib_and_Spines(dataStruct_cell{s});
    
    pool = [];
    NB = size(Inhib,1);
    bin_width2 = 0.3;
    
    for b = 1:NB
        % This is being done per branch; could be done per cell
        diff_dists = diff( sort(Spines(b).Distances) );
        pool = [pool; diff_dists];
    end
    
    pool_cell{s} = pool;
    
    histogram( pool, 0:bin_width2:5, 'Normalization','pdf')
    axis tight
    title('Histogram of exci. interdistances')
    xlabel( 'Inter-distance [\mum]' );
    ylabel( 'Counts' );
    hold on
    
    % hold off
    legend_vec{1,s} = ['Cell ', num2str(unique_cell_numbers(s))];
end

%% Show legend for each cell if distinguished
if distinguish_cells
    legend(deal(legend_vec) ,'AutoUpdate','off')
end

for s = 1:Nstructs
    x = 0:0.01:5;
    plot(x, exppdf(x, mean( pool_cell{s} )), 'r' )
    hold on
    phat = gamfit(pool_cell{s});
    plot(x, gampdf(x, phat(1), phat(2)), 'b' )
    hold on
end

end