function Total_Number_exci_vs_inhi(dataStruct, distinguish_cells)

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
    Nbranches = size(Inhib, 1);
    
    inhI_excI_branchL = zeros( Nbranches, 7);
    
    for b = 1:Nbranches
        % Update inhI_excI_branchL
        inhI_excI_branchL(b,1) = sum( Inhib(b).Sizes  );
        inhI_excI_branchL(b,2) = sum( Spines(b).Sizes );
        inhI_excI_branchL(b,3) = Inhib(b).BranchSize(1);  % Length of Branch
        
        inhI_excI_branchL(b,4) = sum( Inhib(b).Distances  );
        inhI_excI_branchL(b,5) = sum( Spines(b).Distances );
        inhI_excI_branchL(b,6) = numel(Inhib(b).Distances);
        inhI_excI_branchL(b,7) = numel(Spines(b).Distances);
    end
    

    % A = inhI_excI_branchL(:,1);
    % B = inhI_excI_branchL(:,2);
    % corr_matrix = corrcoef(A, B);
    % corr_matrix(1,2).^2
    % b = polyfit(A, B, 1);
    % f = polyval(b, A);
    % Bbar = mean(B);
    % SStot = sum((B - Bbar).^2);
    % SSreg = sum((f - Bbar).^2);
    % SSres = sum((B - f).^2);
    % R2 = 1 - SSres/SStot
    
    scatter(inhI_excI_branchL(:,6), inhI_excI_branchL(:,7), 'filled')
    for b = 1:Nbranches
        text( inhI_excI_branchL(b,6), inhI_excI_branchL(b,7), ['B',num2str(b)] );
        % t.FontSize = 8;
    end
    hold on

legend_vec{1,s} = ['Cell ', num2str(unique_cell_numbers(s))];
end

xlabel('Number of inhib. synapses');
ylabel('Number of exci. synapses');

%% Show legend for each cell if distinguished
if distinguish_cells
    legend(deal(legend_vec))
end

end