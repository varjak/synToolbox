function [dataStruct_cell] = Partition_dataStruct(dataStruct, unique_cell_numbers, distinguish_cells)

%% Insert dataStruct or partitions (distinguished by Cell) into cell array
if distinguish_cells
    Ncell = size(unique_cell_numbers,2);
    dataStruct_cell = cell(1,Ncell);
    for c = 1:Ncell
        dataStruct_cell{c} = dataStruct([dataStruct.Cell]==unique_cell_numbers(c));
    end
else
    dataStruct_cell = {dataStruct};
end

end