classdef TrackedPath < GuiObject
    properties
        path_time;
    end
    methods
        function obj = TrackedPath(fig, pose, velocity, index, time)
            % fig: figure to add the object to
            % pose: the current pose of the robot base [x, y, theta]
            % velocity: the current velocity [linear, angular]
            % index: the first index of the current desired path segment
            % time: the time of this pose
            %==============================================================
            % Line Attributes (values in meters/radians)
            %==============================================================
            % Visual
            obj.attributes.LineWidth = 1;
            obj.attributes.Color = [1, 0, 0];
            
            %==============================================================
            % Path Points
            %==============================================================
            % [x; y; theta;velocity_x; velocity_y; time]
            obj.points = double([double(pose(1));double(pose(2));double(pose(3));double(velocity(1));double(velocity(2));double(index);double(time)]);
            
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
            
            % Create line object for the tracked path
            obj.plot_object = plot(pose(1), pose(2));
            
            % Format the object using the given attributes
            obj.plot_object.LineWidth = obj.attributes.LineWidth;
            obj.plot_object.Color = obj.attributes.Color;
        end
        
        function updatePoints(obj, pose, velocity, index, time)
            % pose: the current pose of the robot base [x, y, theta]
            % velocity: the current velocity [linear, angular]
            % index: the first index of the current desired path segment
            % time: the time of this pose
            
            % Add point to path
            obj.points = double([double(obj.points), [double(pose(1));double(pose(2));double(pose(3));double(velocity(1));double(velocity(2));double(index);double(time)]]);
            
            % Add a new point to the plot line
            obj.plot_object.XData = [obj.plot_object.XData, pose(1)];
            obj.plot_object.YData = [obj.plot_object.YData, pose(2)];
        end
        
        function [data] = getData(obj)
            data = double(obj.points);
        end
        
        function resetPath(obj, start_pose)
            % Erase all the points except the first
            obj.points = double(obj.points(:,1));
            obj.points(1) = start_pose(1);
            obj.points(2) = start_pose(2);
            obj.points(3) = start_pose(3);
            obj.points(7) = 0.0; % reset time
            
            % Update the plotted line
            obj.plot_object.XData = obj.points(1,1);
            obj.plot_object.YData = obj.points(2,1);
        end
    end
end