% logfile = VideoWriter('test.avi', 'Motion JPEG AVI');
% open(logfile);
% ao = analogoutput('mcc','1');
% chans = addchannel(ao,0);
% dio = digitalio('mcc','1');
% addline(dio,0,'out');

vid = videoinput('winvideo',1,'RGB24_640x480');
set(vid,'ReturnedColorSpace','grayscale')
% set(vid,'VideoFormat','RGB24_1280x720f')
src = getselectedsource(vid);
% set(src,'zoom',7);
% set(src,'exposure',-6);
% set(src,'brightness',155);
img = getsnapshot(vid);
mask = [];
BW = roipoly(img);
BW = im2uint8(BW);
for i = 1:size(BW,1)
    for j = 1:size(BW,2)
        if BW(i,j)==255
            BW(i,j) = 1;
            mask = [mask ; i j];
        end
    end
end
BWmask = double(BW);

% Pupil = impoint(gca,[]);
% PupilPos = getPosition(Pupil);
close all
% set(vid,'ROIPosition',[PupilPos(1)-300 PupilPos(2)-200 500 500])
preview(vid)
counter = 0;

pause(1)
tic
while ~KbCheck
%     writeVideo(logfile,getsnapshot(vid));
%     pause(.5)
    
    [center area] = findpupil(getsnapshot(vid).*BW,1,BWmask);
    if ~isnan(area)
        putsample(ao,[(area/500)-4])
    else
        putsample(ao,0)
    end
%     if mod(counter,2)==0
%         putvalue(dio,1)
%     else
%         putvalue(dio,0)
%     end
    counter = counter+1;
end
toc
putvalue(dio,0)
close(logfile);
disp('ended')
