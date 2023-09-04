classdef GuiObject < handle
    properties
        attributes;     % struct containing dimensions for the given object
                        % as well as the base position and orientation, any
                        % other definition variables are stored here
        base_T_object;  % the transform from object frame to robot base 
                        % frame
        points;         % the points defining the object's shape in its 
                        % frame
        plot_object;    % the object returned by the "plot" function, 
                        % reference this object to set the current points
                        % or change its visual attributes
    end
    
    methods (Abstract)
        initializeObject(obj, fig)
        
        updatePoints(obj, pose)
    end
    
    methods (Static)
        function [R] = rot2D(theta)
            % theta: angle of rotation in radians
            R = [cos(theta) -sin(theta);
                 sin(theta)  cos(theta)];
        end
        
        function [T] = trans2D(theta, d)
            % theta: angle of rotation in radians
            % d: [x;y] translation vector
            
            % Create the rotation matrix
            R = GuiObject.rot2D(theta);
    
            % Combine with translation
            T = [  R  , d;
                 [0,0], 1];
        end
    end
end