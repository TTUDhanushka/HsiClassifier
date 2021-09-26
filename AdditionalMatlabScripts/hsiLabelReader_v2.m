%%
% Input image re0arranged to 512 x 512 x 1 x 9 (height x width x color_depth x image_bands)

function labelData = hsiLabelReader_v2(filename)
    hsiLabels = read(filename);
         
    labelData = reshape(hsiLabels, 512, 512, 1, 12);

end