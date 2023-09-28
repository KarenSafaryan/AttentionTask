
function PupilPos = SetEyeWindow()

cam=1;							% Camera NB to work with.
%pbreak=1;						% Delay use in between test or give a chance to see result on preview.
%nbdelay=0.05;						% Delay use in iteration changes.
%cint=25;						% Nb of iteration of test.
LucamCameraOpen(cam);           % Open Camera to work with.
LucamShowPreview(cam);					% Display preview of camera.

fr=LucamCaptureFrame(cam);	% capture video frame.
fig = figure('Name','LucamCaptureFrame test');		% Prepare a display window.
imshow(fr);
Pupil = impoint (gca,[]);
PupilPos = getPosition(Pupil);
Pupil = wait(Pupil);
close(fig)
LucamHidePreview(cam);				% Clear camera preview.
LucamCameraReset(cam);				% Bring camera to it's hardware default value.
LucamCameraClose(cam);	