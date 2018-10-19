function d = point_to_line(x, a, b)
%a and b are the two points that define the line segment.
    num = -(a(1)-x(1))*(b(1)-a(1)) - (a(2)-x(2))*(b(2)-a(2));
    den = (b(1)-a(1))^2 + (b(2)-a(2))^2;
    t_hat = num/den;
    t_star = min( max(t_hat,0),1 );
    d = norm( a + t_star*(b-a) - x);