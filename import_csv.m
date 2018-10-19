function [labels, data] = import_csv(filename)
    labels_and_data = importdata(filename);
    data = labels_and_data.data;
    labels = categorical(labels_and_data.textdata(2:end,1));
end