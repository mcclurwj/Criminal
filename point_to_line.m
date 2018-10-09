function d = point_to_line(x, a, b)
    d_ab = norm(a-b);
    d_ax = norm(a-x);
    d_bx = norm(b-x);

    if dot(a-b,x-b)*dot(b-a,x-a)>=0
        A = [a,1;b,1;x,1];
        d = abs(det(A))/d_ab;        
    else
        d = min(d_ax, d_bx);
    end