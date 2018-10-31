%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Synapse Toolbox
%
% This script loads and analysis data from inhib. and excit. synapses: 
% - distance along branch; 
% - intensity;
% - branch length;
%
% The data is stored in .csv files in \data. The analysis functions are in
% \src.
%
% Authors: Prof. Paulo Aguiar & Gustavo Caetano
% Emails:  pauloaguiar@ineb.up.pt & gmlcaetano@gmail.com
% Institutions: i3S/INEB
% Credits: Prof. Juan Burrone from KCL and his research team for providing 
% all data files.
%
%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
close all
clc

%% Add functions path
main_folder   = cd;
src_folder = [main_folder, '\src'];
addpath(src_folder)

%% Load Data
[dataStruct, distinguish_cells, error_flag] = Load_Data();   % Assumes a rigid data/file format
return
%% Terminate in case of load error
if error_flag
    return
end

%% Display Branches
% Display_Branches(dataStruct);

%% Distance Histograms
figure
subplot(2,2,1)
Histogram_Distance_exci(dataStruct, distinguish_cells)
subplot(2,2,2)
Histogram_Distance_inhi(dataStruct, distinguish_cells);
subplot(2,2,3)
Histogram_Distance_exci_norm(dataStruct, distinguish_cells);
subplot(2,2,4)
Histogram_Distance_inhi_norm(dataStruct, distinguish_cells);

%% Intensity Histograms
figure
subplot(2,2,1)
Histogram_Intensity_exci(dataStruct, distinguish_cells)
subplot(2,2,2)
Histogram_Intensity_inhi(dataStruct, distinguish_cells);
subplot(2,2,3)
Histogram_Intensity_exci_norm(dataStruct, distinguish_cells);
subplot(2,2,4)
Histogram_Intensity_inhi_norm(dataStruct, distinguish_cells);

%% Intensity vs Distance normalized by branch length
Intensity_vs_Distance_norm(dataStruct, distinguish_cells)

%% Total Intensity and Number in exci vs inhi, per branch
figure
subplot(1,2,1)
Total_Intensity_exci_vs_inhi(dataStruct, distinguish_cells)
subplot(1,2,2)
Total_Number_exci_vs_inhi(dataStruct, distinguish_cells)

%% Total Intensity vs Branch Length
figure
subplot(1,2,1)
Total_Intensity_vs_BranchLength_exci(dataStruct, distinguish_cells)
subplot(1,2,2)
Total_Intensity_vs_BranchLength_inhi(dataStruct, distinguish_cells)

%% Analyse spine and inhibitory intensities in each branch half
figure
subplot(2,1,1)
Total_Intensity_halves_exci(dataStruct)
subplot(2,1,2)
Total_Intensity_halves_inhi(dataStruct)

%% Interdistance Histograms
% Per branch
Histogram_interdistance_branches_inhi(dataStruct)
Histogram_interdistance_branches_exci(dataStruct)

% All
figure
subplot(2,1,1)
Histogram_interdistance_inhi(dataStruct, distinguish_cells)
subplot(2,1,2)
Histogram_interdistance_exci(dataStruct, distinguish_cells)

%% Interintensity Distribution
Distance_around_syn_exci(dataStruct, distinguish_cells)

%% Inhibitory Periodicity w/ Auto-correlation
InterDistances_autoCorr_inhi(dataStruct)

%% Excitatory Periodicity w/ Auto-correlation
InterDistances_autoCorr_exci(dataStruct)

%% Excitatory Density around Inhibitory synapses
Density_exci_around_syn_inhi(dataStruct, distinguish_cells)

%% Mean Inhibitory intensity vs Excitatory density
Intensity_inhi_vs_Density_exci(dataStruct, distinguish_cells)

%% Inhibitory intensity vs distance to nearest neighbor
Intensity_vs_distance_NN_inhi(dataStruct, distinguish_cells)





