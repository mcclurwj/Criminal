largestdegree = 30;
resolution = 40;

nseq = [linspace(0,1,resolution) linspace(1,10,resolution)];

%This line will save your precious time
set(0,'DefaultFigureVisible','off');

for i=1:2*resolution
    n = nseq(i);
    P = @(L,nn) max( 1 - (point_to_line(L,points(1,:),points(end,:))...
                           /(2*D))^nn,0); 
    [X,Y,z] = probs(P,n,200,xlims,ylims);
    f = figure;
    surf(X,Y,z,'LineStyle','none');
    axis([xlims ylims 0 2.5e-4]);
    colormap(linspecer);
    shading interp;
    
    if (mod(i,10)==0)
        fprintf('%d / %d \n',i,2*resolution);
    end
    
    frame = getframe(f);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if i==1
        imwrite(imind,cm,'GenPolyLine.gif','gif','DelayTime',0.01,...
            'Loopcount',inf);
    else
        imwrite(imind,cm,'GenPolyLine.gif','gif','DelayTime',0.01,...
            'WriteMode','append');
    end
end

%This line might save you even more time
set(0,'DefaultFigureVisible','on');

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