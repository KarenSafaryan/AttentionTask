function varargout = eyetrackergui(varargin)
% EYETRACKERGUI MATLAB code for eyetrackergui.fig
%      EYETRACKERGUI, by itself, creates a new EYETRACKERGUI or raises the existing
%      singleton*.
%
%      H = EYETRACKERGUI returns the handle to a new EYETRACKERGUI or the handle to
%      the existing singleton*.
%
%      EYETRACKERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EYETRACKERGUI.M with the given input arguments.
%
%      EYETRACKERGUI('Property','Value',...) creates a new EYETRACKERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before eyetrackergui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to eyetrackergui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help eyetrackergui

% Last Modified by GUIDE v2.5 24-Jun-2013 11:07:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @eyetrackergui_OpeningFcn, ...
                   'gui_OutputFcn',  @eyetrackergui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before eyetrackergui is made visible.
function eyetrackergui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to eyetrackergui (see VARARGIN)

% Choose default command line output for eyetrackergui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes eyetrackergui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = eyetrackergui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in calibrate.
function calibrate_Callback(hObject, eventdata, handles)
% hObject    handle to calibrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PupilPos gainval exposureval
gainval = str2double(get(handles.gainText,'string'));
exposureval = str2double(get(handles.expText,'string'));
setGainExp(PupilPos);
set(handles.gainText,'string',num2str(gainval))
set(handles.expText,'string',num2str(exposureval))


% --- Executes on button press in saveDirBut.
function saveDirBut_Callback(hObject, eventdata, handles)
% hObject    handle to saveDirBut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global inc FileName PathName
[FileName PathName] = uiputfile;
set(handles.saveDirText,'string',[PathName FileName])
inc = 1;
% --- Executes on button press in record.
function record_Callback(hObject, eventdata, handles)
% hObject    handle to record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global PupilPos gainval exposureval inc
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

writer = VideoWriter([get(handles.saveDirText,'string') '.avi']);
writer.FrameRate = vfFormat;
open(writer);

stop =0;
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
    
%     if mod(NFrame,60) == 0
%         pause(0.000001)
%         if stopval>0
%             break ;
%         end
%     end
    if KbCheck
        stop=1;
        break
    end
end
% hold off

x=toc;
putvalue(dio,0);
disp(['Expected frame= ' num2str(x*vfFormat)]);
NFrame
inc = inc +1;
global gate
gate =1;

save([get(handles.saveDirText,'string') '-pos.mat'],'xlist','ylist');
if stop ==1
    global FileName PathName
    stopval =1;
    if gate == 1
        str = [PathName FileName  num2str(inc)];
        set(handles.saveDirText,'string',str);
        gate = 0;
    end
end

LucamHidePreview(cam);				% Clear camera preview.
LucamCameraReset(cam);				% Bring camera to it's hardware default value.
LucamCameraClose(cam);					% Close camera.
close(writer);

% --- Executes on button press in setROI.
function setROI_Callback(hObject, eventdata, handles)
% hObject    handle to setROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PupilPos gainval exposureval
PupilPos= SetEyeWindow();
% set(handles.calibrate,'visible','on');

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stopval inc gate FileName PathName
stopval =1;
if gate == 1
    str = [PathName FileName  num2str(inc)];
    set(handles.saveDirText,'string',str);
    gate = 0;
end


% --- Executes on button press in update.
function update_Callback(hObject, eventdata, handles)
% hObject    handle to update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gainval exposureval
set(handles.gainText,'string',num2str(gainval))
set(handles.expText,'string',num2str(exposureval))
