global PupilPos
PupilPos = SetEyeWindow();
setGainExp(PupilPos);
input('Hit Enter to Continue');

close all
[FileName,PathName] = uiputfile;
global gainval exposureval
dio = digitalio('nidaq','Dev1');
line = addline(dio,1,'out');
cam=1;							% Camera NB to work with.
%pbreak=1;						% Delay use in between test or give a chance to see result on preview.
%nbdelay=0.05;						% Delay use in iteration changes.
%cint=25;						% Nb of iteration of test.
LucamCameraOpen(cam);           % Open Camera to work with.
LucamShowPreview(cam);					% Display preview of camera.
frameFormat=LucamGetFormat(cam)  ;
[ooffsetX,ooffsetY]=LucamGetOffset(cam);

LucamHidePreview(cam);
frameFormat.width=160*1;					% Prepare for new ROI window
frameFormat.height=120*1;
LucamSetFormat(frameFormat,cam);
LucamShowPreview(cam);
LucamSetExposure(exposureval,cam);   % set the exposure at 20 msec
LucamSetGain(gainval,cam);        % set the exposure at 2.0

LucamSetOffset(PupilPos(1)-80,PupilPos(2)-60,cam);
[ooffsetX,ooffsetY]=LucamGetOffset(cam);

fl=LucamListFrameRates(cam)
LucamSetFrameRate(fl(1),1);
vfFormat=LucamGetFrameRate(cam);

writer = VideoWriter([PathName FileName '.avi']);
writer.FrameRate = vfFormat;
open(writer);

xlist = [];
ylist = [];
duration = 30;
FrameRate = 1/vfFormat;
finalTime = datenum(clock + [0, 0, 0, 0, 0, duration]);
NFrame = 1;
ExpectedFrames = vfFormat * duration
% pause(.01)
% figure(1)
% % axis([0 frameFormat.width 0 frameFormat.height])
% axis([95 125 50 70])
% pause(.01)
ref = ceil(vfFormat*5);
xcenter=zeros(ref+1);
ycenter=zeros(ref+1);
% hold on
center = [0 0];
pause(.1)
global stopval
stopval = 0;
tic
%THIS LOOP STOPS WHEN YOU HIT THE STOP BUTTON ON THE setGainExp WINDOW
while stopval<1
% while(1)
    %tic  
    fr=LucamCaptureFrame(cam);%fr=LucamCaptureMonochromeFrame(cam);				% capture video frame.
    if mod(NFrame,2) == 0
        putvalue(dio,1);
    else
        putvalue(dio,0);
    end
    center = findpupil(fr,0);
    writeVideo(writer,fr);
    xlist(NFrame) = center(1);
    ylist(NFrame) = center(2);
    NFrame =  NFrame + 1;
    
    if mod(NFrame,60) == 0
        pause(0.000001)
        if stopval>0
            break ;
        end
    end

%     xcenter(Nframe) = center(1);
%     ycenter(Nframe) = center(2);
%     if NFrame > vfFormat*5
%         xcenter(mod(NFrame,ref)+1) = center(1);
%         ycenter(mod(NFrame,ref)+1) = center(2);
%     else
%         xcenter(NFrame) = center(1);
%         ycenter(NFrame) = center(2);
%     end
    
%     if NFrame > vfFormat*5
%         xlist.removeFirst();
%         xlist.add(center(1));
%         ylist.removeFirst();
%         ylist.add(center(2));
%     else
%         xlist.add(center(1));
%         ylist.add(center(2));
%     end
%     figure(1)
%     plot(xcenter,ycenter,'r+')
%     axis([95 125 50 70])
    %toc
  
end
% hold off

x=toc;
putvalue(dio,0);
disp(['Expected frame= ' num2str(x*vfFormat)]);
NFrame

LucamHidePreview(cam);				% Clear camera preview.
LucamCameraReset(cam);				% Bring camera to it's hardware default value.
LucamCameraClose(cam);					% Close camera.
close(writer);