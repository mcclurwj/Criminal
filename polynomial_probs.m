function z = polynomial_probs(data,n,resolution,lim)
    C = mean(data,1);
    R = max( vecnorm(data-C,2,2) );
    P = @(L) max( 1 - (norm(L-C)/(3*R))^n, 0 ); 
    X = linspace(-lim,lim,resolution);
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