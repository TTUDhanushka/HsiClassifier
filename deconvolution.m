%% Devoncolution operation

u =[2 7 4 9]
v = [1 0 1]

[q, r] = deconv(u, v)


%% Convolution

k = conv(v, q) + r

if (u == k)
    fprintf("they are same")
else
    fprintf("different")
end


%%
convolution_kernel = [0 0 0.1 0 0; 0 0.2 0.25 0.2 0; 0.1 0.2 0.25 0.2 0.1; 0 0.2 0.25 0.2 0; 0 0 0.1 0 0];

imagePath = 'C:\Users\Admin\Documents\Python Scripts\test_0_0.png';

img = imread(imagePath);
image_gray = rgb2gray(img);


figure()
imshow(image_gray)

kernel = fspecial('gaussian', [9 9], 2)

convImage = uint8( conv2(kernel, image_gray))
figure()
imshow(convImage)

convImage2 = uint8( conv2(convolution_kernel, image_gray))
figure()
imshow(convImage2)