clc;
clear;

% Step 1: Read Image
img = imread('car2.jpg');
figure, imshow(img), title('Original Image');

% Step 2: Convert to Grayscale
if size(img,3) == 3
    gray_img = rgb2gray(img);
else
    gray_img = img;
end

% Step 3: Apply Manual Thresholding
bw = gray_img > 100;  % Adjust threshold as needed

% Step 4: Label Connected Components
[L, num] = bwlabel(bw);

% Step 5: Measure properties of image regions
stats = regionprops(L, 'BoundingBox', 'Area');

% Step 6: Filter regions based on area (to find likely number plate)
max_area = 0;
plate_region = [];

for i = 1:num
    area = stats(i).Area;
    bbox = stats(i).BoundingBox;
    
    aspect_ratio = bbox(3) / bbox(4);  % Width / Height
    
    if area > max_area && aspect_ratio > 2 && aspect_ratio < 6
        max_area = area;
        plate_region = bbox;
    end
end

% Step 7: Crop and Show Plate Region
if ~isempty(plate_region)
    plate_img = imcrop(gray_img, plate_region);
    
    % Show Result
    figure, imshow(plate_img);
    title('Detected Number Plate');
else
    disp('Number plate not detected.');
end
