% Load criminal data
criminal_file = 'data/richard_ramirez.csv';
[location_labels, data] = import_csv(criminal_file);

body_loc_rows = find(location_labels == 'Body');
x = data(body_loc_rows, 1);
y = data(body_loc_rows, 2);
crime_data = [x y];

% parameters for Rossmo's
buffer_size = 2;
f = 1.2;
g = 1.2;

% Split crime data into validation/test sets
num_rows = length(crime_data);
first_test_row = ceil(2/3 * num_rows);
for i = first_test_row:num_rows
    curr_crime_data = crime_data(1:i-1, :);
    curr_location = crime_data(i, :);
    
    currX = curr_location(1);
    currY = curr_location(2);
    
    % Run Rossmo's to find most likely place for next crime to occur
    P = @(L) compute_rossmo_prob(L, curr_crime_data, buffer_size, f, g);
    [locX, locY, assoc_probs, norm_sum] = probs(P,101);
    currLocProb = P(curr_location) / norm_sum;
    [max_val, index_of_max] = max(assoc_probs(:));
    predictedX = locX(index_of_max);
    predictedY = locY(index_of_max);
    

    dist = sqrt((predictedX - currX)^2 + (predictedY - currY)^2);
    % Display results (most likely place and heatmap)
    text = sprintf("\\hline\n$(%0.2f, %0.2f)$ & $%0.3f\\%%$ & $(%d, %d)$ & $%0.3f\\%%$ & $%0.2f$ \\\\", currX, currY, currLocProb*100, predictedX, predictedY, max_val*100, dist);
    disp(text);
end

xran = [0 100];
yran = [0 100];
imagesc(xran, yran, assoc_probs);
plotdata(crime_data, ones(size(crime_data,1),1), xran, yran);
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
           curr_crime_contribution = 1 / (2*buffer_size - curr_dist) ^ inside_buffer_g;
       end
       
       output_prob = output_prob + curr_crime_contribution;
    end
end

function [Xg, Yg, z, norm_sum] = probs(P,resolution)
    X = transpose(linspace(0,100,resolution));
    Y = X;

    [Xg,Yg] = meshgrid(X,Y);
    Z = zeros(size(Xg));
    for i=1:resolution^2
        xx = Xg(i);
        yy = Yg(i);
        Z(i) = P([xx yy]);
    end
   
    norm_sum = sum(sum(Z));
    z = Z/norm_sum;
end

function plotdata(X, Y, x1ran, x2ran)
    hold on;
    ind = find(Y>0);
    plot(X(ind,1), X(ind,2), 'bo');
    ind = find(Y<0);
    plot(X(ind,1), X(ind,2), 'gx');
    axis([x1ran x2ran]);
    axis xy;
    text(X(:,1)+.2,X(:,2), int2str([1:length(Y)]'));
    xlabel('East (km)');
    ylabel('North (km)');
    title("Peter Sutcliffe's Murders");
end