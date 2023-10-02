
RGB=imread('testCoinImage3.png');
% Convert RGB image to chosen color space
X = im2gray(RGB);
X = imadjust(X);

% Find circles
[centers,radii,~] = imfindcircles(X,[25 75],'ObjectPolarity','bright','Sensitivity',0.85);
BW = false(size(X,1),size(X,2));
[Xgrid,Ygrid] = meshgrid(1:size(BW,2),1:size(BW,1));
for n = 1:10
    BW = BW | (hypot(Xgrid-centers(n,1),Ygrid-centers(n,2)) <= radii(n));
end

% Create masked image.
maskedImage = X;
maskedImage(~BW) = 0;
testCoinMask = imbinarize(maskedImage);
IsolatedImg = X;
IsolatedImg(~testCoinMask)=0;
imgedge = edge(IsolatedImg);
IsolatedImg(~imgedge)=0;

X = imadjust(IsolatedImg);

% Threshold image - global threshold
BW = imbinarize(X);

% Close mask with disk
radius = 15;
decomposition = 0;
se = strel('disk', radius, decomposition);
BW = imclose(BW, se);

% Open mask with disk
radius = 8;
decomposition = 0;
se = strel('disk', radius, decomposition);
BW = imopen(BW, se);

% Create masked image.
maskedImage = RGB;
maskedImage(~BW) = 0;












BW_out = BW;
BW_out = bwpropfilt(BW_out, 'Area', [2000, 5000]);
con_comp = bwlabel(BW_out, 8);
unique_labels1 = unique(con_comp);
nDimes = max(unique_labels1) ;

BW_out = BW;
BW_out = bwpropfilt(BW_out, 'Area', [5500, 6500]);
con_comp = bwlabel(BW_out, 8);
unique_labels2 = unique(con_comp);
nNickels = max(unique_labels2) ;

BW_out = BW;
BW_out = bwpropfilt(BW_out, 'Area', [7000, 8000]);
con_comp = bwlabel(BW_out, 8);
unique_labels3 = unique(con_comp);
nQuarters = max(unique_labels3) ;

BW_out = BW;
BW_out = bwpropfilt(BW_out, 'Area', [10000, 13000]);
con_comp = bwlabel(BW_out, 8);
unique_labels4 = unique(con_comp);

nFiftyCents = max(unique_labels4) ;

USD = (nDimes *0.1)+(nNickels*0.05)+(nQuarters*0.25)+(nFiftyCents*0.5);
montage({RGB , maskedImage});