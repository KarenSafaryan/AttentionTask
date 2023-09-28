function varargout = webcamcontrol(varargin)
% WEBCAMCONTROL MATLAB code for webcamcontrol.fig
%      WEBCAMCONTROL, by itself, creates a new WEBCAMCONTROL or raises the existing
%      singleton*.
%
%      H = WEBCAMCONTROL returns the handle to a new WEBCAMCONTROL or the handle to
%      the existing singleton*.
%
%      WEBCAMCONTROL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WEBCAMCONTROL.M with the given input arguments.
%
%      WEBCAMCONTROL('Property','Value',...) creates a new WEBCAMCONTROL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before webcamcontrol_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to webcamcontrol_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help webcamcontrol

% Last Modified by GUIDE v2.5 30-Sep-2013 15:47:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @webcamcontrol_OpeningFcn, ...
                   'gui_OutputFcn',  @webcamcontrol_OutputFcn, ...
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


% --- Executes just before webcamcontrol is made visible.
function webcamcontrol_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to webcamcontrol (see VARARGIN)

% Choose default command line output for webcamcontrol
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global vid src
vid = videoinput('winvideo',1,'RGB24_640x480');
set(vid,'ReturnedColorSpace','grayscale')
% set(vid,'VideoFormat','RGB24_1280x720f')
src = getselectedsource(vid);
preview(vid)

%%%%%%%%%% DUY EDITS %%%%%%%%
% do = digitalio('mcc','1'); %This line was commented out
% I added this line
do = digitalio('nidaq','Dev2');
%%%%%%%%%%%%%%%%%%%%%%%%
addline(do,0,'out');
putvalue(do,1)
% UIWAIT makes webcamcontrol wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = webcamcontrol_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in up.
function up_Callback(hObject, eventdata, handles)
% hObject    handle to up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global src
src.Tilt = src.Tilt+1;

% --- Executes on button press in right.
function right_Callback(hObject, eventdata, handles)
% hObject    handle to right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global src
src.Pan = src.Pan+1;

% --- Executes on button press in down.
function down_Callback(hObject, eventdata, handles)
% hObject    handle to down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global src
src.Tilt = src.Tilt-1;

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global src
src.Pan = src.Pan-1;

% --- Executes on slider movement.
function exposure_Callback(hObject, eventdata, handles)
% hObject    handle to exposure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global src
src.Exposure=get(handles.exposure,'value');

% --- Executes during object creation, after setting all properties.
function exposure_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exposure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function brightness_Callback(hObject, eventdata, handles)
% hObject    handle to brightness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global src
src.Brightness=get(handles.brightness,'value');

% --- Executes during object creation, after setting all properties.
function brightness_CreateFcn(hObject, eventdata, handles)
% hObject    handle to brightness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function zoom_Callback(hObject, eventdata, handles)
% hObject    handle to zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global src
src.Zoom=get(handles.zoom,'value');

% --- Executes during object creation, after setting all properties.
function zoom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function contrast_Callback(hObject, eventdata, handles)
% hObject    handle to contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global src
src.Contrast=get(handles.contrast,'value');

% --- Executes during object creation, after setting all properties.
function contrast_CreateFcn(hObject, eventdata, handles)
% hObject    handle to contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function threshval_Callback(hObject, eventdata, handles)
% hObject    handle to threshval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of threshval as text
%        str2double(get(hObject,'String')) returns contents of threshval as a double


% --- Executes during object creation, after setting all properties.
function threshval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in test.
function test_Callback(hObject, eventdata, handles)
% hObject    handle to test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid
global BW BWmask minx miny
if get(handles.ROIcheck,'value')==1
    img = getsnapshot(vid);
    figure
    [BW xi yi] = roipoly(img);
    minx = min(xi);
    miny = min(yi);
    BW = im2uint8(BW);
    for i = 1:size(BW,1)
        for j = 1:size(BW,2)
            if BW(i,j)==255
                BW(i,j) = 1;
                
            end
        end
    end
    BWmask = double(BW);
end
findpupil(getsnapshot(vid).*BW,1,BWmask,str2double(get(handles.threshval,'String')));


% --- Executes on button press in ROIcheck.
function ROIcheck_Callback(hObject, eventdata, handles)
% hObject    handle to ROIcheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ROIcheck


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid BW BWmask minx miny
mx = minx;
my = miny;

mouseID = get(handles.mouseID,'string');
basedir = ['C:\Users\tracker\Desktop\Videos\' mouseID];
if ~exist(basedir)
    mkdir(basedir);
    num = 1;
else
    directory = dir(basedir);
    c=1;
    for i = 1:length(directory)
        temp = directory(i).name; 
        l = length(temp);
        if length(temp)>2 && strcmp(temp(l-2:l),'avi')
            c = c+1;
        end
    end
    num = c;
end
center = [0 0];
logfile = VideoWriter([basedir '\' mouseID '_' num2str(num)], 'Grayscale AVI');
psize = analogoutput('mcc',1);
px = analogoutput('mcc',2);
addchannel(px,0);
py = analogoutput('mcc',2);
addchannel(py,1);
di = digitalio('mcc',1);
addline(di,8,'in');
chans = addchannel(psize,0);
counter = 0;
thresh = str2double(get(handles.threshval,'string'));
arr = zeros(108000,4);
pause(.1)
preview = get(handles.prevpup,'value');
disp('start vid loop')
while ~KbCheck
    pause(.05)
    tic
    while getvalue(di) == 1 && ~KbCheck
        if counter == 0
            tic
            open(logfile);
            disp(['started vid ' num2str(num)])
        end
        img = getsnapshot(vid);
        writeVideo(logfile,img);
        [center area] = findpupil(img.*BW,preview,BWmask,thresh,center);
%         arr(counter+1,1)=toc;
%         arr(counter+1,2)=center(1);
%         if numel(center)==1
%             arr(counter+1,3) = NaN;
%         else
%             arr(counter+1,3)=center(2);
%         end
%         arr(counter+1,4)=area;
%         [toc center(1) center(2) area];
        if ~isnan(area)
            putsample(psize,(area/1200))
            putsample(px,5*(center(1)-mx)/240)
            putsample(py,5*(center(2)-my)/100)
        else
            putsample(psize,0)
            putsample(px,0)
            putsample(py,0)
        end
%         if mod(counter,2)==0
%             putvalue(dio,1)
%         else
%             putvalue(dio,0)
%         end
        counter = counter+1;
    end
    x=toc;
    if counter>0
        disp(counter/x);
        counter =0;
%         close(figure(2))
        putsample(psize,0);
        putsample(px,0)
        putsample(py,0)
%         for i = 1:length(arr)
%             if arr(i,1) == 0
%                 tarr = arr(1:i,:);
%                 break
%             end
%         end
%         save([basedir '\' mouseID '_' num2str(num) '.mat'],'tarr')
        arr = zeros(108000,4);
        close(logfile);
        num = num +1;
        logfile = VideoWriter([basedir '\' mouseID '_' num2str(num)], 'Grayscale AVI');
    end
end
disp('stopped video')
% close(logfile);
% save([basedir '\' mouseID '_' num2str(num) '.mat'],'arr')
% delete(ao);
% --- Executes on button press in prevpup.
function prevpup_Callback(hObject, eventdata, handles)
% hObject    handle to prevpup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of prevpup


% --- Executes on button press in preview.
function preview_Callback(hObject, eventdata, handles)
% hObject    handle to preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid
preview(vid)



function mouseID_Callback(hObject, eventdata, handles)
% hObject    handle to mouseID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mouseID as text
%        str2double(get(hObject,'String')) returns contents of mouseID as a double


% --- Executes during object creation, after setting all properties.
function mouseID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mouseID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
