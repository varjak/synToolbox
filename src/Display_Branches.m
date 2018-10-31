function Display_Branches(dataStruct)
%% Select rows of 'spine' and 'shaft' synapses
dataStruct_spine = dataStruct(strcmp({dataStruct.Synapse}, 'spines'));
dataStruct_shaft = dataStruct(strcmp({dataStruct.Synapse}, 'shaft'));

%% Calculate max. and min. intensities of spine and shaft synapses
% Shaft
shaft_intensities = [];
for i = 1:size(dataStruct_shaft,1)
    shaft_intensities = [shaft_intensities ; dataStruct_shaft(i).Data(:,2)];
end
min_shaft_intensity = min(shaft_intensities(:));
max_shaft_intensity = max(shaft_intensities(:));

% Spine
spine_intensities = [];
for i = 1:size(dataStruct_spine,1)
    spine_intensities = [spine_intensities ; dataStruct_spine(i).Data(:,2)];
end
min_spine_intensity = min(spine_intensities(:));
max_spine_intensity = max(spine_intensities(:));

%% Plot 1
max_marker_size = 10;
min_marker_size = 1;

figure
% Plot spine synapses
for i = 1:size(dataStruct_spine,1)
    
    data = dataStruct_spine(i).Data;
    y = i - 0.25;
    plot([0, data(1,3)], [y, y], '-k') ;
    hold on
    
    for j = 1:size(data,1)
        % Map intensity into marker size
        m = (max_marker_size-min_marker_size)/(max_spine_intensity-min_spine_intensity);
        b = min_marker_size - min_spine_intensity*m;

        marker_size = data(j,2)*m + b;
        
        x = data(j,1);
        plot(x, y, 'ok', 'MarkerFaceColor', 'r', 'MarkerSize', marker_size, 'LineWidth',0.1) ;
        hold on
    end
end

% Plot shaft synapses
for i = 1:size(dataStruct_shaft,1)
    
    data = dataStruct_shaft(i).Data;
    y = i;
    plot([0, data(1,3)], [y, y], '-k') ;
    hold on
    
    for j = 1:size(data,1)
        % Map intensity into marker size        
        m = (max_marker_size-min_marker_size)/(max_shaft_intensity-min_shaft_intensity);
        b = min_marker_size - min_shaft_intensity*m;
        
        marker_size = data(j,2)*m + b;
        
        x = data(j,1);
        plot(x, y, 'ok', 'MarkerFaceColor', 'b', 'MarkerSize', marker_size, 'LineWidth',0.1) ;
        hold on
    end
end

LH(1) = plot(nan, nan, 'ok', 'MarkerFaceColor', 'b');
L{1} = 'Inhibitory';
LH(2) = plot(nan, nan, 'ok', 'MarkerFaceColor', 'r');
L{2} = 'Excitatory';
legend(LH, L);
title('Graphical Display w/ divided branches')
xlim( [-40, 160] );
ylim([0.01 size(dataStruct_shaft,1)+1-0.25])
xlabel('Position [\mum]') % x-axis label
ylabel('Branch id') % y-axis label
set(gca, 'YTick', 1:size(dataStruct_shaft,1))

%% Plot 2
Nbranches = size(dataStruct_spine,1);

% Visualizations factors
size_scalefactor = 10;
density_scalefactor_spines = 2;   %[1]
density_scalefactor_inhib = 6;   %[1]

% Parameters
resolution = 10; %[um-1]
kernel_sigma_spines = 1.2;   %[um]
kernel_sigma_inhib = 1.2;   %[um] %0.2
USE_INTENSITY_INFO = 1;

% Calculate densities
[densityStruct_shaft, densityStruct_spine] = Calculate_Densities(dataStruct, resolution, kernel_sigma_spines, kernel_sigma_inhib, USE_INTENSITY_INFO);

figure
% Plot densities
for b = 1:Nbranches
    plot( densityStruct_spine(b).x_bin, b + density_scalefactor_spines * densityStruct_spine(b).density, 'r')
    plot( densityStruct_shaft(b).x_bin,  b + density_scalefactor_inhib  * densityStruct_shaft(b).density,  'b')
    hold on
end
% Plot synapses
for b = 1:Nbranches
    spine_data = dataStruct_spine(b).Data;
    shaft_data = dataStruct_shaft(b).Data;
    
    Spines_y = b * ones( size(spine_data(:,1)) );
    Inhib_y  = b * ones( size(shaft_data(:,1)) );
    scatter( spine_data(:,1), Spines_y, size_scalefactor * spine_data(:,2).^2, 'MarkerFaceColor','r', 'MarkerEdgeColor','k')
    scatter( shaft_data(:,1), Inhib_y,  size_scalefactor * shaft_data(:,2).^2,  'MarkerFaceColor','b', 'MarkerEdgeColor','k')
end

LH(1) = plot(nan, nan, 'ok', 'MarkerFaceColor', 'b');
L{1} = 'Inhibitory';
LH(2) = plot(nan, nan, 'ok', 'MarkerFaceColor', 'r');
L{2} = 'Excitatory';
legend(LH, L);
xlim( [-40, 160] );
ylim( [0, Nbranches+1] );
set(gca,'YTick',1:Nbranches );
xlabel( 'Position [\mum]' );
ylabel( 'Branch id' );
title('Graphical Display w/ density profile')
hold off

end