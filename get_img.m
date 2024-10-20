function [syn_img, syn_labels] = get_img(radius, num_cells, img_size, difficulty)

%% set parameters
cell_shape = "filled-ellipse"; 
blur_sigma = 1;
minor_range = [0.75, 1]; %minor axis must be smaller than major axis, sets range for amount smaller than major axis

major = randi(radius, num_cells, 1); %vary size of major axis
minor = ceil((minor_range(1) + ((minor_range(2) - minor_range(1))).*rand(num_cells,1)).*major); %minor axis is random fraction of major axis within range 
shape_params = [major, minor, randi([0, 360], num_cells, 1)]; %(major, minor, yaw) of length num_cells
artifact_radius = (0.25+0.25*rand(num_cells, 1)).*minor; %used to generate the darker centers in cells shown in example image

%set difficulty value based on expected challenge for a model to learn the
%segmentation
if(difficulty == "Easy") %uniform spacing, constant intensity, no noise/artifact
    int_level = [150,150];
    location = "uniform";
    noise = false;
    artifact = false;
elseif(difficulty == "Low") %random spacing, random intensity, no noise/artifact
    int_level = [10,150];
    location = "random";
    noise = false;
    artifact = false;
else
    int_level = [10,150]; %random spacing, random intensity, with noise/artifact
    location = "random";
    noise = true;
    artifact = true;
end


%% generate synthetic images and labels

%get cell coordinates with uniform spacing -- will have spaces blank if
%num_cells is not a perfect square
if(location == "uniform")
    X=linspace(1, img_size, ceil(sqrt(num_cells)));
    coords = table2array(combinations(X,X))';
    coords = coords(:,1:num_cells);
else
    coords = randi([1 img_size],2,num_cells); %default to random spacing
end

artifact_coords = [coords' artifact_radius]; %combine coordinates and circle params for dark cell centers
coords = [coords' shape_params]; %combine coordinates and ellipse params

%get image labels
labels = (1:num_cells);
img_stack = zeros(img_size,img_size,num_cells);

%separate array for each cell so we can deal with overlapping cells and
%make it easy to generate bounding boxes if needed for training and
%evaluation later
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
syn_labels = img_stack2;

%generate dark centers for cells -- but give them a low, variable intensity
tmp_img = ones(img_size,img_size);
if(artifact)
    artifact_img = insertShape(zeros(img_size,img_size,3), "filled-circle", artifact_coords, 'Color', [1 0 0]);
    artifact_img = squeeze(artifact_img(:,:,1))==0;
    tmp_img(~artifact_img) = 0.25+0.25*rand(1);
end

%generate synthetic image from labels with variable intensity for each cell
for i = 1:size(img_stack,3)
    img_stack(:,:,i) = (img_stack(:,:,i)>0)*randi(int_level,1);
end

%reshape and add dark centers to cells
my_img = squeeze(sum(img_stack,3));
my_img = tmp_img.*my_img;

%convert to RGB
my_img = rescale(my_img);
syn_img = zeros(img_size, img_size, 3);
syn_img(:,:,1) = my_img;
syn_img(:,:,2) = my_img;

%smooth boundaries using a gaussian filter
syn_img = imgaussfilt(syn_img, blur_sigma);

%add salt & pepper noise
if(noise)
    n1 = rand(img_size, img_size,1).*imnoise(zeros(img_size, img_size,1),'salt & pepper',0.02);
    noise_img = 0.5*cat(3, n1, n1, zeros(size(n1)));
    syn_img = syn_img+noise_img;
end

%convert colormap to save labels for easy visualization
cmap = parula(max(syn_labels(:)));
syn_labels = ind2rgb(syn_labels, cmap);

end