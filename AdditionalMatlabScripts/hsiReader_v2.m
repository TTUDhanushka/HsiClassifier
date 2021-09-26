%%
% Input image re0arranged to 512 x 512 x 1 x 9 (height x width x color_depth x image_bands)

function hsiData = hsiReader_v2(filename)
    hsiCube = hypercube(filename);
    
    reflectanceData = hsiCube.DataCube;
     
    rearrangedData = reshape(reflectanceData, 512, 512, 9, 1);
    
    hsiData = RotateHsiImage(rearrangedData, -90);
end