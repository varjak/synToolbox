function [Inhib, Spines] = Transform_dataStruct_into_Inhib_and_Spines(dataStruct)

%% Slice dataStruct regarding type of synapse
dataStruct_spine = dataStruct(strcmp({dataStruct.Synapse}, 'spines'));
dataStruct_shaft = dataStruct(strcmp({dataStruct.Synapse}, 'shaft'));

%% Create new structs
Nbranches = size(dataStruct_shaft, 1); % This assumes there are equal number of branches in exci and inhi data
Inhib = struct('Distances',cell(Nbranches,1), 'Sizes', [] , 'BranchSize', [] ,'interDistances',[], 'x_bin', [], 'x_hit', [], 'density', []);
Spines = struct('Distances',cell(Nbranches,1), 'Sizes', [], 'BranchSize', [],'interDistances',[], 'x_bin', [], 'x_hit', [], 'density', []);

%% Populate structs
for b = 1:Nbranches
    Inhib(b).Distances = dataStruct_shaft(b).Data(:,1);
    Inhib(b).Sizes = dataStruct_shaft(b).Data(:,2);
    Inhib(b).BranchSize = dataStruct_shaft(b).Data(:,3);
    
    Spines(b).Distances = dataStruct_spine(b).Data(:,1);
    Spines(b).Sizes = dataStruct_spine(b).Data(:,2);
    Spines(b).BranchSize = dataStruct_spine(b).Data(:,3);
    
end

end