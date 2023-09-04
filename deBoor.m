function [point] = deBoor(k, x, t, c, p)
    % Evaluates S(x), the b-spline value at x. DeBoor's algorithm for
    % generating a B-spline curve.
    % 
    % Args
    % ----
    % k: index of knot interval that contains x
    % x: position on a range from [0,1], 0 = start point, 1 = end point
    % t: array of knot positions, needs to be padded
    % c: array of control points (2 x N)
    % p: degree of B-spline
    d = zeros(2,p+1);
    for j = 1:p+1
        d(:,j) = c(:,j+k-p);
    end

    for r = 1:p
        for j = p+1:-1:r+1
            alpha = (x - t(j+k-p)) / (t(j+1+k-r) - t(j+k-p));
            d(:,j) = (1.0 - alpha) * d(:,j-1) + alpha * d(:,j);
        end
    end
    
    point = d(:,p+1);
end