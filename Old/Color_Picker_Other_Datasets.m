% Color picker on RGB images
file = 'G:\11. Machine Learning Datasets\yamaha_v0\train\iid000002\labels.png';
[I, m ] = imread(file);
RGB = ind2rgb8(I,m);
img_rgb = imread('G:\11. Machine Learning Datasets\yamaha_v0\train\iid000000\rgb.jpg');
figure()
imshow(RGB, [])
info = imfinfo(file)