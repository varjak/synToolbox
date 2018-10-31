function Histogram_Distance_exci(dataStruct, distinguish_cells)

%% Insert dataStruct or partitions (distinguished by Cell) into cell array
unique_cell_numbers = unique([dataStruct.Cell]);
dataStruct_cell = Partition_dataStruct(dataStruct, unique_cell_numbers, distinguish_cells);
Nstructs = size(dataStruct_cell,2);
legend_vec = cell(1, size(unique_cell_numbers,2));

%% Calculate histogram
% Loop over cell array
for s = 1:Nstructs
    
    [Inhi_struct, Exci_struct] = Transform_dataStruct_into_Inhib_and_Spines(dataStruct_cell{s});
    Exci_matrix = [vertcat(Exci_struct.Distances), vertcat(Exci_struct.Sizes), vertcat(Exci_struct.BranchSize)];
    
    histogram(Exci_matrix(:,1))
    xlabel('Distance [\mum]')
    ylabel('Counts')
    title('Histogram of exci. distances')
    hold on
    
    legend_vec{1,s} = ['Cell ', num2str(unique_cell_numbers(s))];
end

%% Show legend for each cell if distinguished
if distinguish_cells
    legend(deal(legend_vec))
end

end