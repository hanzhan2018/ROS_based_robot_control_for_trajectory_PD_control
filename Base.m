classdef Base < GuiObject
    methods
        function obj = Base(L, W, fig, pose)
            % L: length of the robot {m}
            % W: width of the robot {m}
            % fig: figure to add the object to
            % pose: the current pose of the robot base [x, y, theta]
            %==============================================================
            % Base Attributes (values in meters/radians)
            %==============================================================
            % Pose relative to base_link
            obj.attributes.x = 0;
            obj.attributes.y = 0;
            obj.attributes.theta = 0;
            
            % Dimensions
            obj.attributes.length = L;
            obj.attributes.width = W;
            
            % Visual
            obj.attributes.LineWidth = 2;
            obj.attributes.FaceColor = [1, 0, 0];
            obj.attributes.EdgeColor = [0.5, 0, 0];
            obj.attributes.Alpha = 0.5;
            
            %==============================================================
            % Base Transform
            %==============================================================
            obj.base_T_object = obj.trans2D(obj.attributes.theta, ...
                                           [obj.attributes.x; ...
                                            obj.attributes.y]);
            
            %==============================================================
            % Base Points
            %==============================================================
            obj.points = [(obj.attributes.x + [-obj.attributes.length/2, obj.attributes.length/2, obj.attributes.length/2, -obj.attributes.length/2]);
                          (obj.attributes.y + [-obj.attributes.width/2,  -obj.attributes.width/2, obj.attributes.width/2,   obj.attributes.width/2])];
        
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
            
            % Create polygon object of the base
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