R = 1;
m = 20;
bimodal_data = zeros(2*m,2);

P1 = [1 1];
for j=1:m
    x = (rand()-0.5)*R + P1(1);
    y = (rand()-0.5)*R + P1(2);
    while 1
        if ((x-P1(1))^2 + (y-P1(2))^2 > R^2)
            x = (rand()-0.5)*2*R + P1(1);
            y = (rand()-0.5)*2*R + P1(2);
        else
            break
        end
    end
    bimodal_data(j,:) = [x,y];
end

r = 0.3;
P2 = [3 2];
for j=m+1:2*m
    x = (rand()-0.5)*r + P2(1);
    y = (rand()-0.5)*r + P2(2);
    while 1
        if ((x-P2(1))^2 + (y-P2(2))^2 > r^2)
            x = (rand()-0.5)*2*r + P2(1);
            y = (rand()-0.5)*2*r + P2(2);
        else
            break
        end
    end
    bimodal_data(j,:) = [x,y];
end

%%%%

scatter(bimodal_data(:,1), bimodal_data(:,2), 5, 'r');
axis([P1(1)-R P2(1)+r P1(2)-R P2(2)+r]);