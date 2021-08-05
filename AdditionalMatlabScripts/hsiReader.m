function hsiData = hsiReader(filename)
    hsiCube = hypercube(filename);
    
    reflectanceData = hsiCube.DataCube;
     
    hsiData = RotateHsiImage(reflectanceData, -90);
end