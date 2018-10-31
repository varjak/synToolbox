function Total_Intensity_halves_inhi(dataStruct)

%Inhib/Spines have:
% - data fields: 'Distances', 'Sizes' 'BranchSize' (from dataStruct)
% - analysis fields: 'interDistances','x_bin', 'x_hit', 'density'
[Inhib, Spines] = Transform_dataStruct_into_Inhib_and_Spines(dataStruct);
USE_INTENSITY_INFO = 1;
NB = size(Inhib,1);

%% Calculate total inh and total exci weights in 1st and 2nd half of dendrite
if USE_INTENSITY_INFO == 1
    Total_Inh_halves = zeros( NB, 2 );
    for b = 1:NB
        branch_L = Inhib(b).BranchSize(1);
        L_half = 0.5 * branch_L;
        indx = find( Inhib(b).Distances <= L_half );
        Total_Inh_halves(b,1) = sum( Inhib(b).Sizes( indx ) );
        indx = find( Inhib(b).Distances >  L_half );
        Total_Inh_halves(b,2) = sum( Inhib(b).Sizes( indx ) );
    end
%     Total_Inh_halves_ratio = Total_Inh_halves(:,1) ./ Total_Inh_halves(:,2);
    bar(Total_Inh_halves); 
    title('Inhibitory synapses');
    xlabel('Branch id')
    ylabel('Total intensity')
    legend('First half','Second half')
end

end