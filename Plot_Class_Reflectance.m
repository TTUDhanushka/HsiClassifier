
class_cube = tree_cube_Ref;

%%

[sam_h, sam_w, sam_d] = size(class_cube);

class_avg = zeros(1, sam_d);
class_temp_cube = zeros(sam_h * sam_w, sam_d);

for i = 1: sam_h
    for j = 1:sam_w
        class_temp_cube((i-1) * sam_h + j, :) = class_cube(i,j,:);
    end
end

% Mean class
class_avg(1, :) = mean(class_temp_cube, 1);


% Create a temprary datacube using selected bands
if exist('bSet')
    
    % Cube with selected bands
    class_temp_cube_FewBands = zeros(sam_h * sam_w, length(bSet));
    class_avg_FewBands = zeros(1, length(bSet));
    
    for i = 1: sam_h
        for j = 1:sam_w
            for bandId = 1:length(bSet)
                class_temp_cube_FewBands((i-1) * sam_h + j, bandId) = class_cube(i,j,bSet(bandId));
            end
        end
    end

    class_avg_FewBands(1, :) = mean(class_temp_cube_FewBands, 1);
end


figure()
hold on

set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [4 2]);

% Plot 25 sample characteristic curves on the same plot.
for n = 4000:4025
    plot(class_temp_cube(n,:),'Color',[0.8,0.8,0.8]);
end

% % Plot the average curve.
% plot(class_avg, 'LineWidth', 2, 'Color', [0,0,0]);

% Plot the average curve with selected bands.
if exist('bSet')
    plot( bSet, class_avg_FewBands, 'LineWidth', 2, 'Color', [0, 0, 1]);
end

title("Reflectance characteristics of Tree class.");     % Change the class name
xlabel('Bands');
xlim([0 204]);
ylim([0 1]);
ylabel('Reflectance');
%legend('','','','','','','','','','','','','','','','','','','','','','','','','','','avg','selected bands')
hold off

%% Selected bands for the class

