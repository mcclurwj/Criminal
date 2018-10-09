n = 8; % #points
m = 60; % #samples
r = 0.5; %point spacing
R = 0.5; %sampling radius

nn = 1/3;

points = zeros(n,2);
points(1,:) = [1 1];
data = zeros(n*m,2);

for i=2:n
    points(i,:) = points(i-1,:) + [r r];
end

for i=1:n
    P = points(i,:);
    for j=1:m
        x = (rand()-0.5)*2*R + P(1);
        y = (rand()-0.5)*2*R + P(2);
        data(j+(i-1)*m,:) = [x,y];
    end
end

xmin = min( data(:,1) );
xmax = max( data(:,1) );
ymin = min( data(:,2) );
ymax = max( data(:,2) );

xlims = [xmin-2*R xmax+2*R];
ylims = [ymin-2*R ymax+2*R];

dists = zeros(n*m,1);
for i=1:m*n
    dists(i) = point_to_line(data(i,:),points(1,:),points(end,:));
end
D = max(dists);

P = @(L,nn) max( 1 - (point_to_line(L,points(1,:),points(end,:))/(2*D))^nn,...
    0);
[X,Y,z] = probs(P,nn,200,xlims,ylims);

function [X,Y,z] = probs(P,nn,resolution,xlims,ylims)
    X = linspace(xlims(1),xlims(2),resolution);
    Y = linspace(ylims(1),ylims(2),resolution);

    [Xg,Yg] = meshgrid(X,Y);
    Z = zeros(size(Xg));
    for i=1:resolution^2
        xx = Xg(i);
        yy = Yg(i);
        Z(i) = P([xx yy],nn);
    end

    z = Z/sum(sum(Z));
end