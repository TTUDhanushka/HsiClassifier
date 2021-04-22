
figure()
hold on;

for n = 33:36
    plot(training_Data(:,n).','Color',[0.8,0.8,0.8]);
    
end

hold off;

title("Reflectance characteristics of undefined class.");     % Change the class name
xlabel('Bands');
xlim([0 204]);
ylim([-0.2 1]);
ylabel('Reflectance');
