function [path] = bspline(points, resolution)
    % Generate the knot vector
    p = 3; % order of the polynomial
    t_inner = linspace(0, 1, size(points, 2) - (p - 1));
    t = [zeros(1,p),t_inner];
    t = [t,t(end)*ones(1,p)];

    x = linspace(0,1,resolution);
    k = zeros(size(x));
    
    for i = 1:length(x)
        for j = 1:length(t_inner)
            if (x(i) >= t_inner(j))
                if (j == length(t_inner))
                    k(i) = j+p-2;
                else
                    k(i) = j+p-1;
                end
            end
        end
    end

    % Create spline line
    path = zeros(2,length(x));
    for i = 1:length(x)
        path(:,i) = deBoor(k(i), x(i), t, points, p);
    end
end