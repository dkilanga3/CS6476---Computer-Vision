function my_hog_features_pos = my_hog_get_positive_features(train_path_pos, feature_params)
% 'train_path_pos' is a string. This directory contains 36x36 images of
%   faces
% 'feature_params' is a struct, with fields
%   feature_params.template_size (default 36), the number of pixels
%      spanned by each train / test template and
%   feature_params.hog_cell_size (default 6), the number of pixels in each
%      HoG cell. template size should be evenly divisible by hog_cell_size.
%      Smaller HoG cell sizes tend to work better, but they make things
%      slower because the feature dimensionality increases and more
%      importantly the step size of the classifier decreases at test time.
%      (although you don't have to make the detector step size equal a
%      single HoG cell).


% 'features_pos' is N by D matrix where N is the number of faces and D
% is the template dimensionality, which would be
%   (feature_params.template_size / feature_params.hog_cell_size)^2 * 31
% if you're using the default vl_hog parameters

% Useful functions:
% vl_hog, HOG = VL_HOG(IM, CELLSIZE)
%  http://www.vlfeat.org/matlab/vl_hog.html  (API)
%  http://www.vlfeat.org/overview/hog.html   (Tutorial)
% rgb2gray

image_files = dir( fullfile( train_path_pos, '*.jpg') ); %Caltech Faces stored as .jpg
num_images = length(image_files);
% placeholder to be deleted. 100 random features.

% features_pos = rand(100, (feature_params.template_size / feature_params.hog_cell_size)^2 * 31);
my_hog_features_pos = [];
for indx=1:num_images
    fileName = image_files(indx).name;
    im = im2single(imread(fullfile(train_path_pos, fileName)));
%     if size(im,3) == 3
%         im = rgb2gray(im);
%     end 
    my_hog = my_HOG(im,feature_params.template_size);
    my_hog_features_pos = [my_hog_features_pos;my_hog];
end