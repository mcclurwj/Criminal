largestdegree = 30;
resolution = 40;

nseq = [linspace(0,1,resolution) linspace(1,10,resolution)];

X = linspace(-4,4,200);
Y = X;

for i=1:2*resolution
    n = nseq(i);
    P = @(L) max( 1 - (norm(L-C)/(3*R))^n, 0 ); 
    z = probs(P,200);
    f = figure;
    surf(X,Y,z,'LineStyle','none');
    axis([-4 4 -4 4 0 8e-4]);
    colormap(linspecer);
    shading interp;
    
    if (mod(i,10)==0)
        fprintf('%d / %d \n',i,2*resolution);
    end
    
    frame = getframe(f);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if i==1
        imwrite(imind,cm,'test.gif','gif','DelayTime',0.01,...
            'Loopcount',inf);
    else
        imwrite(imind,cm,'test.gif','gif','DelayTime',0.01,...
            'WriteMode','append');
    end
end



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