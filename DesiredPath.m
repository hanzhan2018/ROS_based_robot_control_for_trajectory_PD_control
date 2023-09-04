classdef DesiredPath < GuiObject
    properties
        start_point;
        end_point;
        start_point_object;
        end_point_object;
        current_segment;
    end
    methods
        function obj = DesiredPath(fig, path)
            % fig: figure to add the object to
            % path: the path as an array of (x,y) points, Dim = 2 x N
            %       path = [x1, x2, x3, ... ; y1, y2, y3, ...]
            %==============================================================
            % Line Attributes (values in meters/radians)
            %==============================================================
            % Visual
            obj.attributes.LineWidth = 2;
            obj.attributes.Color = [0, 0, 1];
            obj.attributes.start_style = 'g*';
            obj.attributes.end_style = 'r*';
            obj.attributes.MarkerSize = 10;
            obj.attributes.CurrentSegmentColor = [0,1,0];
            obj.attributes.CurrentSegmentLineWidth = 2;
            
            %==============================================================
            % Path Points
            %==============================================================
            obj.points = path;
            obj.start_point = path(:, 1);
            obj.end_point = path(:, end);
        
            %==============================================================
            % Initialize the Object
            %==============================================================
            obj.initializeObject(fig);
        end
        
        function initializeObject(obj, fig)
            % fig: figure to add the object to

            % Set the current figure
            set(0, 'CurrentFigure', fig);
            hold on;
            
            % Create line object for the tracked path
            obj.plot_object = plot(obj.points(1,:), obj.points(2,:));
            
            % Format the object using the given attributes
            obj.plot_object.LineWidth = obj.attributes.LineWidth;
            obj.plot_object.Color = obj.attributes.Color;
            
            % Plot the starting and ending points;
            obj.start_point_object = plot(obj.start_point(1), obj.start_point(2), obj.attributes.start_style);
            obj.end_point_object = plot(obj.end_point(1), obj.end_point(2), obj.attributes.end_style);
            obj.start_point_object.MarkerSize = obj.attributes.MarkerSize;
            obj.end_point_object.MarkerSize = obj.attributes.MarkerSize;
            
            % Visualize the current segment for velocity control
            % Default visibility is 'off'
            obj.current_segment = plot(obj.points(1,1:2), obj.points(2,1:2));
            obj.current_segment.Color = obj.attributes.CurrentSegmentColor;
            obj.current_segment.LineWidth = obj.attributes.CurrentSegmentLineWidth;
            obj.current_segment.Visible = 'off';
        end
        
        function updatePoints(obj, path)
            % path: the path as an array of (x,y) points, Dim = 2 x N
            %       path = [x1, x2, x3, ... ; y1, y2, y3, ...]
            
            % Store the new set of points
            obj.points = path;
            
            % Plot the new path
            obj.plot_object.XData = obj.points(1,:);
            obj.plot_object.YData = obj.points(2,:);
            obj.start_point_object.XData = obj.points(1,1);
            obj.start_point_object.YData = obj.points(2,1);
            obj.end_point_object.XData = obj.points(1,end);
            obj.end_point_object.YData = obj.points(2,end);
        end
        
        function [path] = getPath(obj)
            path = obj.points;
        end
        
        function changeVisibility(obj, visible)
            % visible: boolean to turn the path "on" or "off"
            if (visible)
                obj.plot_object.Visible = 'on';
                obj.start_point_object.Visible = 'on';
                obj.end_point_object.Visible = 'on';
            else
                obj.plot_object.Visible = 'off';
                obj.start_point_object.Visible = 'off';
                obj.end_point_object.Visible = 'off';
            end
        end
        
        function updateCurrentSegment(obj, index)
            % index: the current path index for the segment starting point
            obj.current_segment.XData = obj.points(1,index:index+1);
            obj.current_segment.YData = obj.points(2,index:index+1);
        end
        
        function setSegmentVisibility(obj, visible)
            % visible: boolean to turn the path "on" or "off"
            if (visible)
                obj.current_segment.Visible = 'on';
            else
                obj.current_segment.Visible = 'off';
            end
        end
    end
end