classdef BaseXAxis < GuiObject
    methods
        function obj = BaseXAxis(L, fig, pose)
            % L: length of the robot {m}
            % W: width of the robot {m}
            % fig: figure to add the object to
            % pose: the current pose of the robot base [x, y, theta]
            %==============================================================
            % X Axis Attributes (values in meters/radians)
            %==============================================================
            % Pose relative to base_link
            obj.attributes.x = 0;
            obj.attributes.y = 0;
            obj.attributes.theta = 0;
            
            % Dimensions
            obj.attributes.length = 0.75*L;
            
            % Visual
            obj.attributes.LineWidth = 1;
            obj.attributes.Color = [1, 0, 0];
            
            %==============================================================
            % X Axis Transform
            %==============================================================
            obj.base_T_object = obj.trans2D(obj.attributes.theta, ...
                                           [obj.attributes.x; ...
                                            obj.attributes.y]);
            
            %==============================================================
            % X Axis Points
            %==============================================================
            obj.points = [[obj.attributes.x, obj.attributes.length];
                          [obj.attributes.y, obj.attributes.y]];
        
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
            
            % Create line object of the X axis
            points_transformed = obj.trans2D(pose(3), [pose(1);pose(2)])*obj.base_T_object*[obj.points;ones(size(obj.points,2), 1)'];
            obj.plot_object = plot(points_transformed(1,:),points_transformed(2,:));
            
            % Format the object using the given attributes
            obj.plot_object.LineWidth = obj.attributes.LineWidth;
            obj.plot_object.Color = obj.attributes.Color;
        end
        
        function updatePoints(obj, pose)
            % pose: the current pose of the robot base [x, y, theta]
            
            % Update the points with the new pose
            points_transformed = obj.trans2D(pose(3), [pose(1);pose(2)])*obj.base_T_object*[obj.points;ones(size(obj.points,2), 1)'];
            
            % Replace with the new points
            obj.plot_object.XData = points_transformed(1,:);
            obj.plot_object.YData = points_transformed(2,:);
        end
    end
end