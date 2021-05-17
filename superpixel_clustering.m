% Super pixel clustering.

no_Of_Superpixels = 5;

[L,N] = superpixels(higResRgb, no_Of_Superpixels);

figure
BW = boundarymask(L);
imshow(imoverlay(higResRgb,BW,'cyan'),'InitialMagnification',67)

