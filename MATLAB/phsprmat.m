%% Phosphor Matrix Calculator
% Author: Myles Stelling - PhD Student @ RIT MCSL
% Date: 03052026

function [PM] = phsprmat(ccs)
% This funciton takes in the primary chromaticity coordinates (RGB and
% White point) of a given gamut and computes the 3x3 matrix needed to
% transform from linear RGB to XYZ. This is sometimes described as the
% 'phosphor matrix' referring to the phosphors of a CRT display as the
% primaries and the use of those to convert to colorimetry.

% Expects 4X3 mat in of RGBW chromaticity coordinates ([Rx Ry Rz; Gx Gy Gz; ...])

C = ccs(1:3,:)';

J = C \ ccs(4,:)' * (1/ccs(4,2));

Ji = J .* eye(3);

PM = C * Ji;

end