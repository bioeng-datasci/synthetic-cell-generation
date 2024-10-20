close all; clear all; clc;
%% save path
base_path = "C:\Users\kayla\Documents\synthetic cell generation";
dname = uigetdir('C:\');
if(~exist(fullfile(base_path, "synthetic_imgs"), "dir"))
    mkdir(fullfile(base_path, "synthetic_imgs"));
end

if(~exist(fullfile(base_path, "synthetic_labels"), "dir"))
    mkdir(fullfile(base_path, "synthetic_labels"));
end

%% inputs:
% number of cells, fluorescence level, size, shape, location, noise
num_imgs = 10;
radius = [10,15];
num_cells = 255; %can change to constant or distribution
int_level = 150; %can change to constant or distribution
img_size = 128; 
cell_shape = "filled-ellipse"; 
blur_sigma = 1;
minor_range = [0.75, 1];

%major (length), minor (length), yaw (degrees)
major = randi(radius, num_cells, 1);
minor = ceil((minor_range(1) + ((minor_range(2) - minor_range(1))).*rand(num_cells,1)).*major);
shape_params = [major, minor, randi([0, 360], num_cells, 1)];


location = "random"; %options - random, uniform
noise = true; %options - true/false for salt and pepper noise?

%% generate synthetic images:
%outputs, image in uint16, labels in unint 8 -- max number of cell counts = 255, background is 0

%get cell coordinates
if(location == "uniform")
    coords = [linspace(1, img_size, num_cells); linspace(1, img_size, num_cells)];
else
    coords = randi([1 img_size],2,num_cells); %default to random
end

coords = [coords' shape_params];
labels = (1:num_cells);

%get image labels
img_stack = zeros(img_size,img_size,num_cells);
for i=1:size(img_stack,3)
    img = insertShape(zeros(img_size,img_size,3), cell_shape, coords(i,:), 'Color', [1 0 0]);
    img = img(:,:,1);
    img(img>0) = 1*labels(i);
    img_stack(:,:,i) = img;
end

%pick highest value if overlap in image
overlap_mask = sum(img_stack>0, 3)>1;
overlap_vals = max(img_stack, [],3);
img_stack2 = sum(img_stack,3);
img_stack2(overlap_mask) = overlap_vals(overlap_mask);
figure; imagesc(img_stack2);

my_img = squeeze(sum(img_stack>0,3));
%convert to RGB 
my_img = rescale(my_img);
syn_img = zeros(img_size, img_size, 3);
syn_img(:,:,1) = my_img;
syn_img(:,:,2) = my_img;

figure; imagesc(syn_img)

if(noise)
    n1 = rand(img_size, img_size,1).*imnoise(zeros(img_size, img_size,1),'salt & pepper',0.02);
end
noise_img = 0.5*cat(3, n1, n1, zeros(size(n1)));
figure; imagesc(noise_img);
syn_img = imgaussfilt(syn_img, blur_sigma);
figure; imagesc(syn_img+noise_img)




