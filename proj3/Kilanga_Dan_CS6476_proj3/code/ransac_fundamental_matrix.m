% RANSAC Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by Henry Hu

% Find the best fundamental matrix using RANSAC on potentially matching
% points

% 'matches_a' and 'matches_b' are the Nx2 coordinates of the possibly
% matching points from pic_a and pic_b. Each row is a correspondence (e.g.
% row 42 of matches_a is a point that corresponds to row 42 of matches_b.

% 'Best_Fmatrix' is the 3x3 fundamental matrix
% 'inliers_a' and 'inliers_b' are the Mx2 corresponding points (some subset
% of 'matches_a' and 'matches_b') that are inliers with respect to
% Best_Fmatrix.

% For this section, use RANSAC to find the best fundamental matrix by
% randomly sample interest points. You would reuse
% estimate_fundamental_matrix() from part 2 of this assignment.

% If you are trying to produce an uncluttered visualization of epipolar
% lines, you may want to return no more than 30 points for either left or
% right images.

function [ Best_Fmatrix, inliers_a, inliers_b] = ransac_fundamental_matrix(matches_a, matches_b)


%%%%%%%%%%%%%%%%
row_a = size(matches_a,1);
indices = randsample(row_a,8);
a_sample = matches_a(indices,:);
b_sample = matches_b(indices,:);
F_matrix = estimate_fundamental_matrix(a_sample, b_sample);
[inliers_a, inliers_b, ratio] = compute_ratio(F_matrix, matches_a, matches_b);
best_ratio = ratio;
Best_Fmatrix = F_matrix;
N = floor(log(1-0.99)/log(1-ratio^8));
%N = 10000;
for indx=1:N
    indices = randsample(row_a,8);
    a_sample = matches_a(indices,:);
    b_sample = matches_b(indices,:);
    F_matrix = estimate_fundamental_matrix(a_sample, b_sample);
    [a_inliers, b_inliers, ratio] = compute_ratio(F_matrix, matches_a, matches_b);
    if ratio > best_ratio
        best_ratio = ratio;
        Best_Fmatrix = F_matrix;
        inliers_a = a_inliers;
        inliers_b = b_inliers;
        if floor(log(1-0.99)/log(1-ratio^8)) > index
            N = floor(log(1-0.99)/log(1-ratio^8));
        else
            break
        end
    end
end
            

%%%%%%%%%%%%%%%%

% Your ransac loop should contain a call to 'estimate_fundamental_matrix()'
% that you wrote for part II.

% %placeholders, you can delete all of this
% Best_Fmatrix = estimate_fundamental_matrix(matches_a(1:10,:), matches_b(1:10,:));
% inliers_a = matches_a(1:30,:);
% inliers_b = matches_b(1:30,:);

    function [inliers_a, inliers_b, potential_ratio] = compute_ratio(potential_F_matrix, matches_a, matches_b)
       matches_a = [matches_a ones(row_a,1)];
       matches_b = [matches_b ones(row_a,1)];
       dist = diag(matches_a*potential_F_matrix*matches_b');
%        [dist dist_indx] = sort(dist, 'ascend');
       potential_ratio = sum(dist<0.5)/sum(dist);
       inliers_indices = find(dist<0.5);
%        inliers_a = matches_a(dist_indx,:);
%        inliers_a = inliers_a(1:30,1:end-1);
%        inliers_b = matches_b(dist_indx,:);
%        inliers_b = inliers_b(1:30,1:end-1);
       
       inliers_a = matches_a(inliers_indices,:);
       %inliers_a = inliers_a(1:70,1:end-1);
       inliers_a = inliers_a(:,1:end-1);
       inliers_b = matches_b(inliers_indices,:);
       %inliers_b = inliers_b(1:70,1:end-1);
       inliers_b = inliers_b(:,1:end-1);
    end

end

