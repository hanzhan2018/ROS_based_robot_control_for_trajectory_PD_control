% main: Main function that creates and runs the simulation node
%
%   Topics
%   ----------
%   Published: /robot/pose
%   Message Type: turtlesim/Pose
%   Info: The 2D pose of the robot including (x,y) position and the
%         orientation angle. Also contains the current linear and angular
%         velocities.
%
%   Published: /desired_path/index
%   Message Type: std_msgs/Int32
%   Info: The index of the desired path array that references the first
%         point in the currently tracked segment of the path.
%
%   Subscribed: /robot/cmd_vel
%   Message Type: geometry_msgs/Twist
%   Info: The linear and angular velocity of the robot. The linear velocity
%         command comes from Twist.Linear.X and the angular velocity
%         command comes from Twist.Angular.Z.
%
%   Subscribed: /reset
%   Message Type: std_msgs/Empty
%   Info: Resets the robot to the starting pose at 0 velocity.
%
%   Author: Kyle Larsen
%   Date: 21 Apr 2020

function [] = main()

% Initialize node
robot_sim = RobotSim();

%=========================================================================%
% Configuration Parameters
%=========================================================================%
% Operation mode
% {1 = 'testing', 0 = 'recording'}
% 1: does not generate plots, allows you to send a message to the /reset 
%    topic to restart the robot.
% 0: when the robot reaches the end of the path, the simulation ends and 
%    plots are generated.
testing_mode = 0;

% Simulation Frequency
% Set the frequency in Hz at which the simulation tries to run
% Try 10 Hz for testing
% If your computer can handle it, move up towards 30 Hz for recording
% Your controller should be close to this, preferably slightly faster
frequency = 20; % Hz
robot_sim.setSimulationFrequency(frequency);

%=========================================================================%
% Set Desired Path
%=========================================================================%
% Load the control points for the desired path
file = load('desired_path.mat');
control_points = file.control_points;
resolution = file.resolution;
desired_path = bspline(control_points, resolution);
robot_sim.setDesiredPath(desired_path);

%=========================================================================%
% Simulation Loop
%=========================================================================%
while (~robot_sim.shutdown_simulation)
    if (robot_sim.exit_for_processing)
        if (testing_mode)
            pause(1);
        else
            break;
        end
    else
        robot_sim.spinOnce();

        % Include a pause here so "closeFigure()" works
        pause(0.001);
    end
end

%=========================================================================%
% Data Results
%=========================================================================%
% Get desired path
desired_path = robot_sim.getDesiredPath();

% Get tracked path for when time starts running
tracked_data = robot_sim.getTrackedData();
nonzero_time_index = find(tracked_data(7,:) > 0, 1);
tracked_data = tracked_data(:,nonzero_time_index-1:end);

% Compute errors for each point along the tracked path
cross_track_errors = zeros(1, size(tracked_data, 2));
heading_errors = zeros(size(cross_track_errors));

%--- Calculate Path Errors ---%
for i = 1:length(cross_track_errors)
    % Get segment points and define vectors
    p1 = desired_path(:, int32(tracked_data(6,i)));
    p2 = desired_path(:, int32(tracked_data(6,i)+1));
    path_heading = atan2(p2(2) - p1(2), p2(1) - p1(1));
    theta_pr = path_heading + pi; % reverse path direction
    v_r = [tracked_data(1,i);tracked_data(2,i)] - p2;

    % Rotate the robot vector to find the along-track and cross-track
    % errors
    v_r_rotate = RobotSim.rot2D(-theta_pr)*v_r;

    % Cross-track error
    cte = v_r_rotate(2);
    cross_track_errors(i) = cte;
    
    % Path heading
    heading_errors(i) = wrapToPi(path_heading - tracked_data(3,i));
    
end

%--- Print out key values ---%
fprintf("=============================\n");
fprintf("        Final Results\n");
fprintf("=============================\n");

if (~isempty(tracked_data))

% Time
fprintf("Time to complete: %0.3g sec\n", tracked_data(7, end));
%--- Cross Track Errors
fprintf("Cross Track (m)\n");
% Max magnitude cross-track error
fprintf("    Max error: %0.3f\n", max(abs(cross_track_errors)));
% Avg magnitude cross-track error
fprintf("    Average magnitude: %0.3f\n", mean(abs(cross_track_errors)));
% Avg cross-track error
fprintf("    Average error: %0.3f\n", mean(cross_track_errors));
%--- Heading errors
fprintf("Heading (rad)\n");
% Max magnitude heading error
fprintf("    max error: %0.3f\n", max(abs(heading_errors)));
% Avg magnitude heading error
fprintf("    Average magnitude: %0.3f\n", mean(abs(heading_errors)));
% Avg heading error
fprintf("    Average error: %0.3f\n", mean(heading_errors));

% Plot cross-track errors against time
figure(2);
hold off;
plot(tracked_data(7,:), cross_track_errors, 'r-');
hold on;
plot([tracked_data(7,1), tracked_data(7,end)], [0, 0], 'k:');
xlabel('time (s)');
ylabel('cross-track error (m)');
xlim([0 tracked_data(7,end)]);
title('Path Tracking Results');

% Plot heading errors against time
figure(3);
hold off;
plot(tracked_data(7,:), heading_errors, 'b-');
hold on;
plot([tracked_data(7,1), tracked_data(7,end)], [0, 0], 'k:');
xlabel('time (s)');
ylabel('heading error (rad)');
xlim([0 tracked_data(7,end)]);
title('Heading Errors');

else
    
fprintf("No Data Collected\n");
fprintf("A velocity command must be sent to '/robot/cmd_vel' before data begins collecting.\n");

end

end