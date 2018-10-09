x = rand(10,1);
y = rand(10,1);

data = [x y];

C = 1/10 * sum(data);
R = max(norm(data - C));

% Linear
P = @(L) max( 1 - norm(L-C)/(3*R), 0 ); 
z1 = probs(P,100);

% Quadratic
P = @(L) max( 1 - norm(L-C)^2/(9*R^2), 0);
z2 = probs(P,100);

% Radical 
P = @(L) max( 1 - sqrt(norm(L-C))/sqrt(3*R), 0);
z3 = probs(P,100);

function z = probs(P,resolution)
    X = linspace(-4,4,resolution);
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