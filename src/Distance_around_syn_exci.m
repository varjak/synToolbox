function Distance_around_syn_exci(dataStruct, distinguish_cells)

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

%% Assess clustering by size in spines
% calculate the distribution of distances between neighbours
% for each spine, calculate the difference in "size" (fluorescence) with its immediate neighbour

subplot(Nstructs,1,s)
diff_list_experimental = [];
diff_list_random = [];
for b = 1:size(Inhib,1)
    data = [ Spines(b).Distances, Spines(b).Sizes ];
    % CAREFUL: cannot assume sorted distances
    [~,sorted_ind] = sort( data(:,1) );
    data_sorted = data(sorted_ind,:);
    diff_list_experimental = [diff_list_experimental; diff( data_sorted(:,2) )];
    
    % test with randomized locations
    dist_only = data(:,2);
    for k = 1:100
        dist_only = dist_only( randperm( numel( dist_only ) ) );
        diff_list_random = [diff_list_random; diff( dist_only )];
    end
end
hold on
edges = linspace(-5, 5, 40);
histogram( diff_list_experimental, edges, 'Normalization', 'pdf' );
histogram( diff_list_random,       edges, 'Normalization', 'pdf' );
axis tight
hold off
xlabel('Intensity diff. between consecutive spines')
ylabel('prob. dist.')
title(['Interdistance distribution of Cell ', num2str(unique_cell_numbers(s))])
legend('Experimental locations','Permutated locations')
% there seems to be a bias towards low differences is size in neighbouring
% spines but, at least with this quantification method, it is not striking

end

end