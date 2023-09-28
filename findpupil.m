function [center area B] = findpupil(frame,opt,mask,thresh,prevcenter)
% [filename path1] = uigetfile('*.fig');
if nargin<1
    [f p] = uigetfile;
    frame = imread([p f],'tif');
    frame = frame(:,:,1:3);
    opt=1;
end

im = im2bw(frame,thresh);
im = (1-im).*mask;

bw = bwareaopen(im,200);
bw = imfill(bw,'holes');

if opt ==1
    figure(2)
    imshow(bw)
end

%find boundaries and map
[B,L] = bwboundaries(bw,'noholes');
measurements = regionprops(L);
try
    area = {measurements.Area};
    area = cell2mat(area);
    if length(area)>1
        dist = zeros(1,length(area));
        for i = 1:length(area)
            center = measurements(i).Centroid;
            dist(i) = abs(center(2) - prevcenter(2));
        end
        [center index] = min(dist);
        center = measurements(index).Centroid;
        area = area(index);
    else
        center = measurements.Centroid;
    end
catch err
    area = NaN;
    center = NaN;
    
end

end


