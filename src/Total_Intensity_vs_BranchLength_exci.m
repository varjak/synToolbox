function Total_Intensity_vs_BranchLength_exci(dataStruct, distinguish_cells)

%% Insert dataStruct or partitions (distinguished by Cell) into cell array
unique_cell_numbers = unique([dataStruct.Cell]);
dataStruct_cell = Partition_dataStruct(dataStruct, unique_cell_numbers, distinguish_cells);
Nstructs = size(dataStruct_cell,2);
legend_vec = cell(1, size(unique_cell_numbers,2));

%% Calculate histogram
% Loop over cell array
for s = 1:Nstructs

% Inhib/Spines have:
% - data fields: 'Distances', 'Sizes' 'BranchSize' (from dataStruct)
% - analysis fields: 'interDistances','x_bin', 'x_hit', 'density'
[Inhib, Spines] = Transform_dataStruct_into_Inhib_and_Spines(dataStruct_cell{s});
Nbranches = size(Inhib, 1);

inhI_excI_branchL = zeros( Nbranches, 7);

for b = 1:Nbranches
    %update inhI_excI_branchL
    inhI_excI_branchL(b,1) = sum( Inhib(b).Sizes  );
    inhI_excI_branchL(b,2) = sum( Spines(b).Sizes );
    inhI_excI_branchL(b,3) = Inhib(b).BranchSize(1);  % Length of Branch
    
    inhI_excI_branchL(b,4) = sum( Inhib(b).Distances  );
    inhI_excI_branchL(b,5) = sum( Spines(b).Distances );
    inhI_excI_branchL(b,6) = numel(Inhib(b).Distances);
    inhI_excI_branchL(b,7) = numel(Spines(b).Distances); 
end

scatter( inhI_excI_branchL(:,2), inhI_excI_branchL(:,3), 'filled')
for b = 1:Nbranches
    t = text( inhI_excI_branchL(b,2), inhI_excI_branchL(b,3), ['B',num2str(b)] );
    t.FontSize = 7;
end
hold on
legend_vec{1,s} = ['Cell ', num2str(unique_cell_numbers(s))];
end

xlabel('Total exci. intensities'); 
ylabel('Branch length [\mum]');

%% Show legend for each cell if distinguished
if distinguish_cells
    legend(deal(legend_vec))
end

end