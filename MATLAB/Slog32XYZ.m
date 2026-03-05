%% SLog3SG3 to XYZ Converter
% Author: Myles Stelling - PhD Student @ RIT MCSL
% Date: 03052026

function [sony_XYZ, sony_cc] = Slog32XYZ(in_im)
% This function takes in a serialized image encoded in Sony Slog3 SGamut3 
% and converts the RGB values to XYZ. The decoding functions are from the 
% Sony Slog3 witepaper and the matrix was computed based on the primaries
% for SGamut3 in the same whitepaper.

% Expects 3xN of Slog3 encoded image normalized 0-1
% Returns XYZ tristimulus and chromaticity coordinates

% Split for linear/log according to Sony whitepaper
break_pt = 171.2102946929 / 1023; 
sony_lin = zeros(size(in_im));
    
% Inverse OETF
cond = in_im >= break_pt;
sony_lin(cond) = (10.^((in_im(cond) .* 1023.0 - 420.0) ./ 261.5)) .* (0.18 + 0.01) - 0.01;
sony_lin(~cond) = (in_im(~cond) .* 1023.0 - 95.0) .* 0.01125 ./ (171.2102946929 - 95.0);
    
% Clip negative values to zero
sony_lin = max(sony_lin, 0);

% Apply SGamut3 to XYZ Matrix
SG32XYZ = [0.706482713192319, 0.128801049790558, 0.115172164068795;
           0.270979670813492, 0.786606411220906, -0.0575860820343976;
          -0.009677845386196, 0.004600037492519, 1.09413555865355];

% Convert linear RGB to XYZ
sony_XYZ = SG32XYZ * sony_lin;

% Sum tristimulus for chromaticity coordinate computation                
sumXYZ = sum(sony_XYZ, 1);
    
% Avoid division by zero
sumXYZ(sumXYZ <= 0) = NaN; 

% Compute chromaticity coordinates
sony_cc = sony_XYZ ./ sumXYZ;
end