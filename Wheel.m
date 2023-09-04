classdef Wheel < GuiObject
    methods
        function obj = Wheel(L, W, location, fig, pose)
            % L: length of the robot {m}
            % W: width of the robot {m}
            % location: indicates whether the wheel position is in the
            % left front ('lf'), left back ('lb'), right front ('rf') or
            % right back ('rb');
            % fig: figure to add the object to
            % pose: the current pose of the robot base [x, y, theta]
            %==============================================================
            % Wheel Attributes (values in meters/radians)
            %==============================================================
            % Dimensions
            obj.attributes.length = 0.085;
            obj.attributes.width = 0.036;
            
            % Pose relative to base_link
            if (strcmp(location,'lf'))
                obj.attributes.x = L/2 - obj.attributes.length/2;
                obj.attributes.y = W/2 + obj.attributes.width/2;
            elseif (strcmp(location, 'lb'))
                obj.attributes.x = -(L/2 - obj.attributes.length/2);
                obj.attributes.y = W/2 + obj.attributes.width/2;
            elseif (strcmp(location, 'rf'))
                obj.attributes.x = L/2 - obj.attributes.length/2;
                obj.attributes.y = -(W/2 + obj.attributes.width/2);
            elseif (strcmp(location, 'rb'))
                obj.attributes.x = -(L/2 - obj.attributes.length/2);
                obj.attributes.y = -(W/2 + obj.attributes.width/2);
            else
                error("Wheel location must be one of the following {'lf', 'lb', 'rf', 'rb'}: %s", location);
            end
            obj.attributes.theta = 0;
            
            % Visual
            obj.attributes.LineWidth = 1;
            obj.attributes.FaceColor = [0, 0, 0];
            obj.attributes.EdgeColor = [0, 0, 0];
            obj.attributes.Alpha = 0.5;
            
            %==============================================================
            % Wheel Transform
            %==============================================================
            obj.base_T_object = obj.trans2D(obj.attributes.theta, ...
                                           [obj.attributes.x; ...
                                            obj.attributes.y]);
                                        
            %==============================================================
            % Wheel Points
            %==============================================================
            obj.points = [[-obj.attributes.length/2, obj.attributes.length/2, obj.attributes.length/2, -obj.attributes.length/2];
                          [-obj.attributes.width/2,  -obj.attributes.width/2, obj.attributes.width/2,   obj.attributes.width/2]];
        
       
            %==============================================================
            % Initialize the Object
            %==============================================================
            obj.initializeObject(fig, pose);
        end
        
        function initializeObject(obj, fig, pose)
            % fig: figure to add the object to
            % pose: the current pose [x, y, theta]
            
            % Set the current figure
            set(0, 'CurrentFigure', fig);
            hold on;
            
            % Create polygon object of the wheel
            points_transformed = obj.trans2D(pose(3), [pose(1);pose(2)])*obj.base_T_object*[obj.points;ones(size(obj.points,2), 1)'];
            pgon = polyshape(points_transformed(1:2,:)');
            
            % Add the base to the plot and save the object
            obj.plot_object = plot(pgon);
            
            % Format the object using the given attributes
            obj.plot_object.LineWidth = obj.attributes.LineWidth;
            obj.plot_object.FaceColor = obj.attributes.FaceColor;
            obj.plot_object.FaceAlpha = obj.attributes.Alpha;
            obj.plot_object.EdgeColor = obj.attributes.EdgeColor;
        end
        
        function updatePoints(obj, pose)
            % pose: the current pose of the robot base [x, y, theta]
            
            % Update the points with the new pose
            points_transformed = obj.trans2D(pose(3), [pose(1);pose(2)])*obj.base_T_object*[obj.points;ones(size(obj.points,2), 1)'];
            
            % Create new polygon
            pgon = polyshape(points_transformed(1:2,:)');
            
            % Replace with the new points
            obj.plot_object.Shape = pgon;
        end
    end
end