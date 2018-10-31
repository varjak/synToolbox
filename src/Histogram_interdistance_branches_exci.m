function Histogram_interdistance_branches_exci(dataStruct)

%Inhib/Spines have:
% - data fields: 'Distances', 'Sizes' 'BranchSize' (from dataStruct)
% - analysis fields: 'interDistances','x_bin', 'x_hit', 'density'
[Inhib, Spines] = Transform_dataStruct_into_Inhib_and_Spines(dataStruct);

%% Assess distribution of inhibitory interdistances
% Calculate the distribution of SORTED(!!) distances between neighbours
figure
pool = [];
NB = size(Inhib,1);
bin_width1 = 1;
for b = 1:NB
    % This is being done per branch; could be done per cell
    subplot( 1, NB, b )
    diff_dists = diff( sort(Spines(b).Distances) );
    histogram( diff_dists, 0:bin_width1:5 )
    pool = [pool; diff_dists];
    xlabel( 'Inter-dists [\mum]' );
    ylabel( 'Counts' );
    title(['Branch ', num2str(b)])
    axis tight
end

suptitle('Histograms of exci. interdistances')

end