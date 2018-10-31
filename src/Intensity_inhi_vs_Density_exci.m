function Intensity_inhi_vs_Density_exci(dataStruct, distinguish_cells)

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
[Inhi_struct, Exci_struct] = Transform_dataStruct_into_Inhib_and_Spines(dataStruct_cell{s});

branch_length_vec = zeros(1, size(Exci_struct, 1));
density_vec = zeros(1, size(Exci_struct, 1));
mean_size_inhib = zeros(1, size(Exci_struct, 1));
std_size_inhib = zeros(1, size(Exci_struct, 1));

for b = 1: size(Exci_struct, 1)
    
    branch_length_vec(b) = Exci_struct(b).BranchSize(1);
    density_vec(b) = size(Exci_struct(b).Distances,1)./branch_length_vec(b);
    
    mean_size_inhib(b) = mean(Inhi_struct(b).Sizes);
    std_size_inhib(b) = std(Inhi_struct(b).Sizes);
end

errorbar(density_vec,mean_size_inhib,std_size_inhib,'x', 'MarkerSize',10)
xlabel('Density of spines per branch')
ylabel('Mean of inhib. syn. size')
hold on

legend_vec{1,s} = ['Cell ', num2str(unique_cell_numbers(s))];
end

%% Show legend for each cell if distinguished
if distinguish_cells
    legend(deal(legend_vec))
end
end