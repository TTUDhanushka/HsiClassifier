
class_cube = sky_cube;

%%

[sam_h, sam_w, sam_d] = size(class_cube);

class_avg = zeros(1, sam_d);
class_temp_cube = zeros(sam_h * sam_w, sam_d);

for i = 1: sam_h
    for j = 1:sam_w
        class_temp_cube((i-1) * sam_h + j, :) = class_cube(i,j,:);
    end
end

% for k = 1:sam_d
    class_avg(1, :) = mean(class_temp_cube, 1);
% end

figure()
hold on

set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [4 2]);

% Plot 25 sample characteristic curves on the same plot.
for n = 1:50
    plot(class_temp_cube(n,:),'Color',[0.8,0.8,0.8]);
end

% Plot the average curve.
plot(class_avg, 'LineWidth', 2, 'Color', [0,0,0]);

title("Reflectance characteristics of sky class.");     % Change the class name
xlabel('Bands');
xlim([0 204]);
ylim([0 1]);
ylabel('Reflectance');
hold off
