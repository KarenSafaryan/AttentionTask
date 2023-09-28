[filename path1] = uigetfile('*.avi');
vid = VideoReader([path1 filename]);

nFrames = vid.NumberOfFrames;
vidHeight = vid.Height;
vidWidth = vid.Width;

mov(1:nFrames) = struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
           'colormap', []);
im = read(vid,100);
figure
imshow(im);
% bw = roipoly(im);
pixels = [];
n = 0;
for i=1:size(im,1)
    for j = 1:size(im,2)
        if bw(i,j) <1
            n = n+1;   
        end
    end
end
pixels = zeros(n,2);
c = 1;
for i=1:size(im,1)
    for j = 1:size(im,2)
        if bw(i,j) <1
            pixels(c,1) = i;
            pixels(c,2) = j;
            c=c+1;
        end
    end
end


% imshow(bw);
data = cell(nFrames-7000-800,2);
for k = 800:nFrames-7000
    im2 = read(vid,k);
    for i = 1:length(pixels)
        im2(pixels(i,1),pixels(i,2)) = 255;
    end
    
    [data{k,1} data{k,2}] = findpupil(im2,0);
    k
end

ymin = 349;
ymax = 86;
xmin = 60;
xmax = 429;
xd = xmax - xmin;
yd = ymax - ymin;

cdeg = c;
for i = 1:length(c)
    x=c(i,2);
    y=c(i,1);
    xp = (x-xmin)/(xd);
    yp = (y-ymin)/(yd);
    cdeg(i,2) = (xp)*90;
    cdeg(i,1) = (1-yp)*90;
    
    
end

