% Generate RGB versions from HSI images.

% 'root' variable contains root of the image data folder.
if ~exist('root', 'var')
    root = uigetdir;
end

% RGB Image from Specim RGB image data folder.
RGB_Dataset_specim = 'RGB_625_625';
rgbHighResPath = fullfile(root, RGB_Dataset_specim, 'images');

% 9 Bands HSI data from HSI data folder.



% Manifold alignment from HSI to RGB.
SemiSupervisedManifoldAlignment;