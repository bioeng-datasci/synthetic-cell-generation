function ui_start
% ADDME  Creates the UI for synthetic cell image and label generation.
%   Change the sliders and buttons to generate different types of images
%
%   Press the "preview" button to see an example. Note that some
%   combinations of parameters generate unrealistic images. Suggested
%   paramaters are intitally selected for you.
%
%   Press the "generate" button to save generated images. Note that for ease
%   of viewing saved images, the data format is set to view well as an RGB
%   image, rather than uint16/uint8.

close all; clear; clc;

%set up ui figure
fig = uifigure;
fig.Name = "Synthetic Data Generation App";
fig.Position = [321   107   950   650];

%set number of images
num_img_sld = uislider(fig,'Position',[55 250 150 3], 'Limits', [10 50], 'Value', 30);
num_img_lbl = uilabel(fig, 'Text',"Number of Images", "Position", [55 175 150 50]);

%set number of cells
num_cell_sld = uislider(fig,'Position',[55 350 150 3], 'Limits', [10 255], 'Value', 64);
num_cell_lbl = uilabel(fig, 'Text',"Number of Cells", "Position", [55 275 150 50]);

%set radius bounds
radius_sld = uislider(fig,"range","Limits",[10 50],"Value",[20 30], "Position", [55 450 150 3]);
radius_lbl = uilabel(fig, 'Text',"Major Axis Range", "Position", [55 375 150 50]);

%difficulty and image size button groups
sz_bg = uibuttongroup(fig,'Position',[55 75 100 85]);
sz_rb1 = uiradiobutton(sz_bg,'Position',[10 60 91 15], "Text","128", "Value", false);
sz_rb2 = uiradiobutton(sz_bg,'Position',[10 38 91 15], "Text","256", "Value", true);
sz_rb3 = uiradiobutton(sz_bg,'Position',[10 16 91 15], "Text","512", "Value", false);
sz_bg_lbl = uilabel(fig, 'Text',"Image Size", "Position", [55 25 150 50]);

diff_bg = uibuttongroup(fig,'Position',[175 75 100 85]);
diff_rb1 = uiradiobutton(diff_bg,'Position',[10 60 91 15], "Text","Easy", "Value", false);
diff_rb2 = uiradiobutton(diff_bg,'Position',[10 38 91 15], "Text","Low", "Value", false);
diff_rb3 = uiradiobutton(diff_bg,'Position',[10 16 91 15], "Text","Moderate", "Value", true);
diff_bg_lbl = uilabel(fig, 'Text',"Difficulty", "Position", [175 25 150 50]);

%preview and generate images functionality
im = uiimage(fig, "Position", [385 100 512 512], 'ScaleMethod', 'none');
preview_btn = uibutton(fig, "Text","Preview", "Position", [500 55 75 30], "ButtonPushedFcn", ...
    {@previewButtonPushed, radius_sld, num_cell_sld, sz_bg, diff_bg, im});

generate_btn = uibutton(fig, "Text","Generate", "Position", [700 55 75 30], "ButtonPushedFcn", ...
    {@generateButtonPushed, num_img_sld, radius_sld, num_cell_sld, sz_bg, diff_bg, fig});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function previewButtonPushed(src, event, radius, num_cells, sz_bg, diff_bg, im)
        %callback for preview button
        
        %get image size
        img_size = get_img_size(sz_bg);

        %get difficulty
        difficulty = get_difficulty(diff_bg);

        %get and set preview image
        [syn_img, ~] = get_img(floor(radius.Value), floor(num_cells.Value), img_size, difficulty);
        im.ImageSource = syn_img;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function generateButtonPushed(src, event, num_imgs, radius, num_cells, sz_bg, diff_bg, fig)
        %callback for generate button

        %select folders for saving images
        base_path = uigetdir(matlabroot,"Select folder to save images");
        if(~exist(fullfile(base_path, "synthetic_imgs"), "dir"))
            mkdir(fullfile(base_path, "synthetic_imgs"));
        end

        if(~exist(fullfile(base_path, "synthetic_labels"), "dir"))
            mkdir(fullfile(base_path, "synthetic_labels"));
        end

        %get image size
        img_size = get_img_size(sz_bg);

        %get difficulty
        difficulty = get_difficulty(diff_bg);

        %generate each image and label pair
        for i = 1:num_imgs.Value
            [syn_img, syn_labels] = get_img(floor(radius.Value), floor(num_cells.Value), img_size, difficulty);
            imwrite(syn_img,fullfile(base_path, "synthetic_imgs", sprintf("img_%03d.png", i)))
            imwrite(rescale(syn_labels),fullfile(base_path, "synthetic_labels", sprintf("img_%03d.png", i)))
        end

        close(fig)
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function [img_size] = get_img_size(sz_bg)
        %Helper function to get image size from toggle buttons.

        if(sz_bg.Children(1).Value == true)
            img_size = 512;
        elseif(sz_bg.Children(2).Value == true)
            img_size = 256;
        else
            img_size = 128;
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function [difficulty] = get_difficulty(diff_bg)
        %Helper function to get difficulty from toggle buttons.
        if(diff_bg.Children(1).Value == true)
            difficulty = "Moderate";
        elseif(diff_bg.Children(2).Value == true)
            difficulty = "Low";
        else
            difficulty = "Easy";
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end