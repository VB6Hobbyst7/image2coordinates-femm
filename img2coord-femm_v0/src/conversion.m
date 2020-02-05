% ----------------------------------------------------------------------------------------------
% | Here is the codes that was used to construct this part of the toolbox                      |
% | References used in the code:                                                               |
% | Image Analyst (2015). Image Segmentation Tutorial                                          |
% | https://www.mathworks.com/matlabcentral/fileexchange/25157-image-segmentation-tutorial),   |
% | MATLAB Central File Exchange. Retrieved February 4, 2020.                                  |
% | (c) 2015                                                                                   |
% ----------------------------------------------------------------------------------------------


function [conv,remove] = conversion(img,realvalue,objref,removal)

objreferencia = objref;
valorreal = realvalue;
rem = removal;
%% Separating images for calculation from other areas
RGB = img;
if size(RGB,3)==3
   img = rgb2gray(img);
   RGB = imbinarize(img);
   RGB = imcomplement(RGB);
end
assignin('base','RGB',RGB)
bw = RGB;
[B2,L ,num , A] = bwboundaries(bw);

blobMeasurements = regionprops(bw, 'all');
numberOfBlobs = size(blobMeasurements, 1);
hold on;

boundaries = bwboundaries(bw);
numberOfBoundaries = size(num, 1);

textFontSize = 14;	% Used to control size of "blob number" labels put atop the image.
labelShiftX = -7;
blobECD = zeros(1, numberOfBlobs);

    for k = 1 : numberOfBlobs           % Loop through all blobs.
      
        blobArea = blobMeasurements(k).Area;		% Get area.
        blobCentroid = blobMeasurements(k).Centroid;
        blobDiameter = blobMeasurements(k).EquivDiameter;% Get centroid one at a time
    % 	blobECD(k) = sqrt(4 * blobArea / pi);					% Compute ECD - Equivalent Circular Diameter.
        text(blobCentroid(1) + labelShiftX, blobCentroid(2), num2str(k), 'FontSize', textFontSize, 'FontWeight',  'Bold','Color','c');
    end
hold off
%% Calculating the real area using the reference object
for k = 1 : numberOfBlobs           
        convertidos = blobMeasurements(k).Area*valorreal/blobMeasurements(objreferencia).Area; % Get area.
       	fprintf(2,'#%2d %11.1f \n', k, convertidos);
end


labeledImage = bwlabel(bw, 8); 
%% Removing the reference object
if rem==1
    allBlobAreas = [blobMeasurements.Area];
    allowableAreaIndexes = allBlobAreas ~= blobMeasurements(objreferencia).Area;
    keeperIndexes = find(allowableAreaIndexes);
    % Extract only those blobs that meet our criteria, and
    % eliminate those blobs that don't meet our criteria.
    % Note how we use ismember() to do this.
    keeperBlobsImage = ismember(labeledImage, keeperIndexes);
    remove = keeperBlobsImage;
else
    remove = img;    
end

convertion = valorreal/blobMeasurements(objreferencia).Area;
conv = convertion;

