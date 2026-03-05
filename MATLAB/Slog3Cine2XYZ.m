%% SLog3SG3.Cine to XYZ Converter
% Author: Myles Stelling - PhD Student @ RIT MCSL
% Date: 03052026

function [sony_XYZ, sony_cc] = Slog3Cine2XYZ(in_im)
% This function takes in a serialized image encoded in Sony Slog3 SG3.Cine 
% and converts the RGB values to XYZ. The decoding functions are from the 
% Sony Slog3 witepaper and the matrix was computed based on the primaries
% for SG3.Cine in the same whitepaper.

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

% Apply SGamut3.Cine to XYZ Matrix
SG3Cine2XYZ = [0.599083920758327 0.248925516115424 0.102446490177921;
               0.215075820115587 0.885068501743728 -0.100144321859316;
              -0.0320658495445058 -0.0276583906794915 1.14878199098388];
         
% Convert linear RGB to XYZ
sony_XYZ = SG3Cine2XYZ * sony_lin;

% Sum tristimulus for chromaticity coordinate computation
sumXYZ = sum(sony_XYZ, 1);
    
% Avoid division by zero
sumXYZ(sumXYZ <= 0) = NaN; 

% Compute chromaticity coordinates
sony_cc = sony_XYZ ./ sumXYZ;
end