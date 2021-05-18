% Super pixel clustering.

imgCopy = higResRgb;

no_Of_Superpixels = 100;


[L,N] = superpixels(imgCopy, no_Of_Superpixels);

figure
BW = boundarymask(L);
imshow(imoverlay(imgCopy,BW,'cyan'),'InitialMagnification',67)

