%% Arri LogC4 AWG4 to XYZ Converter
% Author: Myles Stelling - PhD Student @ RIT MCSL
% Date: 03052026

function [arri_XYZ, arri_cc] = LogC42XYZ(in_im)
% This function takes in a serialized image encoded in Arri LogC4 AWG4 and
% converts the RGB values to XYZ. The decoding functions and matrix are
% from the Arri whitepaper on LogC4.

% Expects 3xN of Arri LogC4 encoded image normalized 0-1
% Returns XYZ tristimulus and chromaticity coordinates

% Constants from whitepaper
a = ((2^18) - 16) / 117.45;
b = (1023 - 95) / 1023;
c = 95 / 1023;
s = (7 * log(2) * 2^(7 - (14 * c / b))) / (a * b);
t = (2^((14 * -1 * (c / b)) + 6) - 64) / a;

% Apply the decoding conditionally 
arri_lin = zeros(size(in_im));
is_log = in_im >= c;

% Log part
arri_lin(is_log) = (2.^((14.*(in_im(is_log)-c)./b)+6)-64)./a;
% Linear part
arri_lin(~is_log) = (in_im(~is_log) - t) ./ s;

% Matrix from Arri for AWG4 to XYZ
AWG42XYZ = [0.704858320407232064 0.129760295170463003 0.115837311473976537;
            0.254524176404027025 0.781477732712002049 -0.036001909116029039;
            0 0 1.089057750759878429];

% Using matrix to transform to XYZ          
arri_XYZ = AWG42XYZ * arri_lin;

% Prevent division by zero for black pixels
sumXYZ = sum(arri_XYZ, 1);
sumXYZ(sumXYZ == 0) = inf;

% Compute chromaticity coordinates
arri_cc = arri_XYZ ./ sumXYZ;

end