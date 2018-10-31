function Intensity_vs_Distance_norm(dataStruct, distinguish_cells)

%% Insert dataStruct or partitions (distinguished by Cell) into cell array
unique_cell_numbers = unique([dataStruct.Cell]);
dataStruct_cell = Partition_dataStruct(dataStruct, unique_cell_numbers, distinguish_cells);
Nstructs = size(dataStruct_cell,2);

%% Calculate histogram
% Loop over cell array
figure
for s = 1:Nstructs
    
    %Inhib/Spines have:
    % - data fields: 'Distances', 'Sizes' 'BranchSize' (from dataStruct)
    % - analysis fields: 'interDistances','x_bin', 'x_hit', 'density'
    [Inhi_struct, Exci_struct] = Transform_dataStruct_into_Inhib_and_Spines(dataStruct_cell{s});
    
    Inhi_matrix = [vertcat(Inhi_struct.Distances), vertcat(Inhi_struct.Sizes), vertcat(Inhi_struct.BranchSize)];
    Exci_matrix = [vertcat(Exci_struct.Distances), vertcat(Exci_struct.Sizes), vertcat(Exci_struct.BranchSize)];

    % Calculate R^2 measure 
    A = Exci_matrix(:,1)./Exci_matrix(:,3);
    B = Exci_matrix(:,2);
    b = polyfit(A, B, 1);
    f = polyval(b, A);
    Bbar = mean(B);
    SStot = sum((B - Bbar).^2);
    SSreg = sum((f - Bbar).^2);
    SSres = sum((B - f).^2);
    R2 = 1 - SSres/SStot;
    
    subplot(Nstructs,2,s*2-1)
    plot(Exci_matrix(:,1)./Exci_matrix(:,3), Exci_matrix(:,2), 'b.')
    xlabel('Distances (normalized by branch length)')
    ylabel('Intensities')
    
    if distinguish_cells
        title(['Exci. synapses of Cell ', num2str(unique_cell_numbers(s))])
    else
        title('Exci. synapses')
    end
    
    ylim([0,5])
    yticks([0,1,2,3,4,5])
    yticklabels([0,1,2,3,4,5])
    
    % Get fitted values
    fittedX = linspace(min(A), max(A), 200);
    fittedY = polyval(b, fittedX);
    % Plot the fitted line
    hold on;
    plot(fittedX, fittedY, 'r-', 'LineWidth', 1);
    
    dummyh = line(nan, nan, 'Linestyle', 'none', 'Marker', 'none', 'Color', 'none');
    legend(dummyh, ['R^{2}=',num2str(round(R2,4))])
    legend boxoff
    
    % Calculate R^2 measure 
    A = Inhi_matrix(:,1)./Inhi_matrix(:,3);
    B = Inhi_matrix(:,2);
    b = polyfit(A, B, 1);
    f = polyval(b, A);
    Bbar = mean(B);
    SStot = sum((B - Bbar).^2);
    SSreg = sum((f - Bbar).^2);
    SSres = sum((B - f).^2);
    R2 = 1 - SSres/SStot;
    
    subplot(Nstructs,2,s*2)
    plot(Inhi_matrix(:,1)./Inhi_matrix(:,3), Inhi_matrix(:,2), 'b.')
    xlabel('Distances (normalized by branch length)')
    ylabel('Intensities')
    
    if distinguish_cells
        title(['Inhi. synapses of Cell ', num2str(unique_cell_numbers(s))])
    else
        title('Inhi. synapses')
    end
    ylim([0,5])
    yticks([0,1,2,3,4,5])
    yticklabels([0,1,2,3,4,5])

    % Get fitted values
    fittedX = linspace(min(A), max(A), 200);
    fittedY = polyval(b, fittedX);
    % Plot the fitted line
    hold on;
    plot(fittedX, fittedY, 'r-', 'LineWidth', 1);
    
    dummyh = line(nan, nan, 'Linestyle', 'none', 'Marker', 'none', 'Color', 'none');
    legend(dummyh, ['R^{2}=',num2str(round(R2,4))])
    legend boxoff
    
end

end