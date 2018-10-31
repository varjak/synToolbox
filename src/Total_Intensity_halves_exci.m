function Total_Intensity_halves_exci(dataStruct)

%Inhib/Spines have:
% - data fields: 'Distances', 'Sizes' 'BranchSize' (from dataStruct)
% - analysis fields: 'interDistances','x_bin', 'x_hit', 'density'
[Inhib, Spines] = Transform_dataStruct_into_Inhib_and_Spines(dataStruct);
USE_INTENSITY_INFO = 1;
NB = size(Inhib,1);

%% Calculate total inh and total exci weights in 1st and 2nd half of dendrite
if USE_INTENSITY_INFO == 1
%     Total_Inh_halves = zeros( NB, 2 );
    Total_Exc_halves = zeros( NB, 2 );
    for b = 1:NB
        branch_L = Inhib(b).BranchSize(1);
        L_half = 0.5 * branch_L;
        indx = find( Spines(b).Distances <= L_half );
        Total_Exc_halves(b,1) = sum( Spines(b).Sizes( indx ) );
        indx = find( Spines(b).Distances >  L_half );
        Total_Exc_halves(b,2) = sum( Spines(b).Sizes( indx ) );
    end

%     Total_Exc_halves_ratio = Total_Exc_halves(:,1) ./ Total_Exc_halves(:,2);
    bar(Total_Exc_halves); 
    title('Excitatory synapses');
    xlabel('Branch id')
    ylabel('Total intensity')
    legend('First half','Second half')
end

end