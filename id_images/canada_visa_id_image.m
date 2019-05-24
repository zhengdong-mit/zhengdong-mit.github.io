clc;
clear;
close all;

% ------------------------------------------------------------------------
% Parameters 
% ------------------------------------------------------------------------
real_height = 4.5;
real_width = 3.5;

img_width = 1050;
img_height = round(img_width / real_width * real_height);

head_size = 3.2;

b_remark = 0;

% ------------------------------------------------------------------------
% Read the image
% ------------------------------------------------------------------------
img = imread(fullfile(cd, 'zhengdong.jpg'));

figure;
imagesc(img);
axis image;
hold on;

if b_remark == 1 || ~exist(fullfile(cd, 'canada_visa_points.mat'), 'file')
    key_points = zeros(2, 4);
    % --------------------------------------------------------------------
    % Mark the top of the crown
    % --------------------------------------------------------------------
    title('Mark the top of the head');
    pt = ginput(1)';
    plot(pt(1), pt(2), 'r.', 'MarkerSize', 3);
    hold on;
    key_points(:, 1) = pt;
    
    % --------------------------------------------------------------------
    % Mark the bottom of the chin
    % --------------------------------------------------------------------
    title('Mark the bottom of the chin');
    pt = ginput(1)';
    plot(pt(1), pt(2), 'r.', 'MarkerSize', 3);
    hold on;
    key_points(:, 2) = pt;
    
    % --------------------------------------------------------------------
    % Mark the top of the left shoulder
    % --------------------------------------------------------------------
    title('Mark the top of the left shoulder');
    pt = ginput(1)';
    plot(pt(1), pt(2), 'r.', 'MarkerSize', 3);
    hold on;
    key_points(:, 3) = pt;
    
    % --------------------------------------------------------------------
    % Mark the top of the right shoulder
    % --------------------------------------------------------------------
    title('Mark the top of the right shoulder');
    pt = ginput(1)';
    plot(pt(1), pt(2), 'r.', 'MarkerSize', 3);
    hold on;
    key_points(:, 4) = pt;
    
    % --------------------------------------------------------------------
    % Mark two points as central symmetry axis
    % --------------------------------------------------------------------
    
    title('Mark two points as symmetrical axis');
    for t = 1:2
        pt = ginput(1)';
        plot(pt(1), pt(2), 'r.', 'MarkerSize', 3);
        hold on;
        key_points(:, 4 + t) = pt;
    end
    
    save(fullfile(cd, 'canada_visa_points.mat'), 'key_points');
else
    load(fullfile(cd, 'canada_visa_points.mat'), 'key_points');
end

% ------------------------------------------------------------------------
% Crop the image accordingly.
% ------------------------------------------------------------------------

key_points = round(key_points);
head_height_pix = key_points(2, 2) - key_points(2, 1);
whole_frame_pix = max(key_points(2, :)) - min(key_points(2, :));
if (whole_frame_pix / head_height_pix) > (real_height / head_size)
    error('The head size is too big!');
end

blanks_height = (real_height - whole_frame_pix / head_height_pix * head_size);
blanks_height_pix = blanks_height * (head_height_pix / head_size);

top_bound = round(key_points(2, 1) - (blanks_height_pix / 2));
bottom_bound = round(max(key_points(2, :)) + blanks_height_pix / 2);

height_pix = bottom_bound - top_bound + 1;
width_pix = height_pix / real_height * real_width;

central_axis = round((key_points(1, 5) + key_points(1, 6)) / 2);

left_bound = central_axis - round(width_pix / 2);
right_bound = central_axis + round(width_pix / 2) - 1;

figure;
imagesc(img); axis image;
hold on;
plot([left_bound, right_bound, right_bound, left_bound, left_bound], ...
    [top_bound, top_bound, bottom_bound, bottom_bound, top_bound], 'r-', 'LineWidth', 2);

% ------------------------------------------------------------------------
% Crop the image and save to the disk
% ------------------------------------------------------------------------
crop_img = img(top_bound:bottom_bound, left_bound:right_bound, :);
crop_img = imresize(crop_img, [img_height, img_width]);
imwrite(crop_img, fullfile(cd, 'canada_id_zhengdong.jpg'), 'JPEG');