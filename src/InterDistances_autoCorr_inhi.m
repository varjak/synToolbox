function InterDistances_autoCorr_inhi(dataStruct)

%Inhib/Spines have:
% - data fields: 'Distances', 'Sizes' 'BranchSize' (from dataStruct)
% - analysis fields: 'interDistances','x_bin', 'x_hit', 'density'
[Inhib, Spines] = Transform_dataStruct_into_Inhib_and_Spines(dataStruct);

% Calculate spine and shaft density profiles
% PARAMETERS
resolution = 10; %[um-1]
kernel_sigma_spines = 0.5;   %[um]
kernel_sigma_inhib = 1.5;   %[um] %0.2
USE_INTENSITY_INFO = 0;
[densityStruct_shaft, densityStruct_spine] = Calculate_Densities(dataStruct, resolution, kernel_sigma_spines, kernel_sigma_inhib, USE_INTENSITY_INFO);

% Put density profiles in Inhib/Spines
[Inhib(:).density] = deal(densityStruct_shaft(:).density);
[Spines(:).density] = deal(densityStruct_spine(:).density);


%% Assess distribution of inhibitory interdistances with autocorrelation 
% calculate the distribution of SORTED(!!) distances between neighbours
% ATTENTION! IN "CHOOSE BETWEEN USING OR NOT SIZE/INTENSITY INFORMATION"

% USE THE OPTION WITHOUT SIZE

if USE_INTENSITY_INFO == 0
    figure
    pool = [];
    NB = size(Inhib,1);
    
    Ncol = ceil( sqrt( 16/9 * NB ) );
    Nrow = ceil( NB / Ncol );
    
    for b = 1:NB
        % this is being done per branch; could be done per cell
        subplot( Nrow, Ncol, b )
        [r,lags] = xcorr( Inhib(b).density );
        plot( lags * 1/resolution, r )
        xlabel( 'Distance [\mum]' );
        title( ['Branch ', num2str(b)] )
        axis tight
    end
end

end