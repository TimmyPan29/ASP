% Ellipse parameters
lambda1 = 1.1;
lambda2 = 0.9;
J_min = 0.0965;

% Range for J(n) values to plot ellipses
increments = [0, 0.05, 0.1, 0.2, 0.3];

% Function to generate ellipse points
ellipse_points = @(J, lambda1, lambda2, num_points) ...
    arrayfun(@(theta) sqrt((J - J_min) / (lambda1 * cos(theta)^2 + lambda2 * sin(theta)^2)) ...
    * [cos(theta), sin(theta)], linspace(0, 2*pi, num_points), 'UniformOutput', false);

% Plotting setup
figure;
hold on;
colors = ['y', 'm', 'c', 'r', 'g']; % Colors for each ellipse

for i = 1:length(increments)
    J = J_min + increments(i);
    points = cell2mat(ellipse_points(J, lambda1, lambda2, 100));
    plot(points(:, 1), points(:, 2), 'Color', colors(i), 'LineWidth', 2);
end

xlabel('v1(n)');
ylabel('v2(n)');
title('Contour Plot of Constant J(n)');
axis equal;
grid on;
legend(arrayfun(@(x) ['J(n) = J_min + ', num2str(x)], increments, 'UniformOutput', false));
hold off;