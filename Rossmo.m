% Load criminal data
criminal_file = 'data/peter_sutcliffe.csv';
[location_labels, data] = import_csv(criminal_file);

body_loc_rows = find(location_labels == 'Body');
x = data(body_loc_rows, 1);
y = data(body_loc_rows, 2);
crime_data = [x y];

% parameters for Rossmo's
buffer_size = 10;
f = 1.2;
g = 1.2;

% Run Rossmo's to find most likely place for next crime to occur
P = @(L) compute_rossmo_prob(L, crime_data, buffer_size, f, g);
[locX, locY, assoc_probs] = probs(P,101);

[max_val, index_of_max] = max(assoc_probs(:));
targetX = locX(index_of_max);
targetY = locY(index_of_max);

text = sprintf("The most likely place for the next crime to occur is at %d km east and %d km north.", targetX, targetY);
disp(text);
function [output_prob] = compute_rossmo_prob(L, crime_locations, buffer_size, outside_buffer_f, inside_buffer_g)
    copied_L = ones(size(crime_locations)) .* L;
    manhat_distances_to_crimes = sum(abs(copied_L - crime_locations),2);

    output_prob = 0;
    for i = 1:length(manhat_distances_to_crimes)
       curr_dist = manhat_distances_to_crimes(i,:);
       
       curr_crime_contribution = 0;
       if(curr_dist > buffer_size)
           curr_crime_contribution = 1 / curr_dist ^ outside_buffer_f;
       else
           curr_crime_contribution = buffer_size ^ (outside_buffer_f - inside_buffer_g) / (2*buffer_size - curr_dist) ^ inside_buffer_g;
       end
       
       output_prob = output_prob + curr_crime_contribution;
    end
end

function [Xg, Yg, z] = probs(P,resolution)
    X = transpose(linspace(0,100,resolution));
    Y = X;

    [Xg,Yg] = meshgrid(X,Y);
    Z = zeros(size(Xg));
    for i=1:resolution^2
        xx = Xg(i);
        yy = Yg(i);
        Z(i) = P([xx yy]);
    end
   
    z = Z/sum(sum(Z));
end