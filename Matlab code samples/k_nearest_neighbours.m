% K Nearest Neighbour from the scartch.

% kNN experiment with hospital dataset
load hospital;

dataQuery = [20 162; 30 169; 40 168; 50 170; 60 171];

dataPoints = 100;
inputH = zeros( dataPoints, 2);


for i = 1:dataPoints
     inputH(i, 1) = hospital.Age(i);
     inputH(i, 2) = hospital.Weight(i);
end

distanceMatrix = [];

for n = 1: dataPoints
    for pts = 1:length(dataQuery)
        distanceMatrix(n, pts) =  sqrt((inputH(n, 1) - dataQuery(pts,1))^2 + (inputH(n, 2) - dataQuery(pts,2))^2);
    end
end

    k = 1;
    
    predictions = zeros(1, k);
    
for pre = 1:length(dataQuery)
    [a, id] = sort(distanceMatrix(:, pre));
           
    predictions(1, pre) = id(1);
          
    resAge =  hospital.Age(predictions(1, pre))
    resWeight =  hospital.Weight(predictions(1, pre))
    
end