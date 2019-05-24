% ------------------------------------------------------------------------
% Parameters of the canvas
% ------------------------------------------------------------------------
photo_size = [4, 6];
src_size = [2, 2];
bkg_gray = 64;
src_image = imread(fullfile(cd, 'zhengdong_2015_12_2.jpg'));

if size(src_image, 3) == 1
    src_image = repmat(src_image, 1, 1, 3);
end
% ------------------------------------------------------------------------
% Crop the centering region of the image to adjust the aspect ratio
% ------------------------------------------------------------------------
H = size(src_image, 1);
W = size(src_image, 2);

aspect_ratio = src_size(1) / src_size(2);
if H / W > aspect_ratio
    % Shorter
    crop_length = ceil((H - W * aspect_ratio) / 2);
    top_bnd = 1 + crop_length;
    bottom_bnd = H - crop_length;
    src_image = src_image(top_bnd:bottom_bnd, :, :);
elseif H / W < aspect_ratio
    % Narrower
    crop_length = ceil((W - H / aspect_ratio) / 2);
    left_bnd = 1 + crop_length;
    right_bnd = W - crop_length;
    src_image = src_image(:, left_bnd:right_bnd, :);
end

% ------------------------------------------------------------------------
% Decide the layout
% ------------------------------------------------------------------------
H = size(src_image, 1);
W = size(src_image, 2);

canvas_H = round(H / src_size(1) * photo_size(1));
canvas_W = round(canvas_H / photo_size(1) * photo_size(2));

N_r = floor(photo_size(1) / src_size(1));
N_c = floor(photo_size(2) / src_size(2));

img_gap = min((canvas_H - N_r * H) / (N_r + 1), ...
    (canvas_W - N_c * W) / (N_c + 1));

bound_gap_H = floor((canvas_H - N_r * H - img_gap * (N_r - 1)) / 2);
bound_gap_W = floor((canvas_W - N_c * W - img_gap * (N_c - 1)) / 2);

% ------------------------------------------------------------------------
% Layout the image
% ------------------------------------------------------------------------
big_image = bkg_gray * ones(canvas_H, canvas_W, 3);
for r = 1:N_r
    for c = 1:N_c
        start_r = bound_gap_H + (r - 1) * (H + img_gap) + 1;
        start_c = bound_gap_W + (c - 1) * (W + img_gap) + 1;
        end_r = start_r + H - 1;
        end_c = start_c + W - 1;
        
        big_image(start_r:end_r, start_c:end_c, :) = src_image;
    end
end

figure;
imshow(uint8(big_image));

imwrite(uint8(big_image), ...
    fullfile(cd, sprintf('big_image_canvas_%dx%d_img_%dx%d.jpg', ...
    photo_size(1), photo_size(2), src_size(1), src_size(2))), 'JPEG');