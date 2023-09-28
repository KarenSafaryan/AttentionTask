function varargout = setGainExp(varargin)
% SETGAINEXP MATLAB code for setGainExp.fig
%      SETGAINEXP, by itself, creates a new SETGAINEXP or raises the existing
%      singleton*.
%
%      H = SETGAINEXP returns the handle to a new SETGAINEXP or the handle to
%      the existing singleton*.
%
%      SETGAINEXP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SETGAINEXP.M with the given input arguments.
%
%      SETGAINEXP('Property','Value',...) creates a new SETGAINEXP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before setGainExp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to setGainExp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help setGainExp

% Last Modified by GUIDE v2.5 24-Jun-2013 18:43:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @setGainExp_OpeningFcn, ...
                   'gui_OutputFcn',  @setGainExp_OutputFcn, ...
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


% --- Executes just before setGainExp is made visible.
function setGainExp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to setGainExp (see VARARGIN)

% Choose default command line output for setGainExp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global gainval exposureval
set(handles.gain,'string',gainval);
set(handles.exposure,'string',exposureval);
% UIWAIT makes setGainExp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = setGainExp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function gain_Callback(hObject, eventdata, handles)
% hObject    handle to gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gain as text
%        str2double(get(hObject,'String')) returns contents of gain as a double


% --- Executes during object creation, after setting all properties.
function gain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function exposure_Callback(hObject, eventdata, handles)
% hObject    handle to exposure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of exposure as text
%        str2double(get(hObject,'String')) returns contents of exposure as a double


% --- Executes during object creation, after setting all properties.
function exposure_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exposure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global PupilPos gainval exposureval stopval

stopval = 0;
cam=1;							% Camera NB to work with.
LucamCameraOpen(cam);           % Open Camera to work with.
LucamShowPreview(cam);	
frameFormat=LucamGetFormat(cam)  ;
[ooffsetX,ooffsetY]=LucamGetOffset(cam);
gate = get(handles.fpreview,'value');
if get(handles.fpreview,'value') <1
    LucamHidePreview(cam);
    frameFormat.width=160*1;					% Prepare for new ROI window
    frameFormat.height=120*1;
    LucamSetFormat(frameFormat,cam);
    LucamSetOffset(PupilPos(1)-80,PupilPos(2)-60,cam);
    LucamShowPreview(cam);
else
%     LucamSetFormat(frameFormat,cam);
end
LucamSetExposure(str2double(get(handles.exposure,'string')),cam);   % set the exposure at 20 msec
LucamSetGain(str2double(get(handles.gain,'string')),cam); 
duration = 500;
finalTime = datenum(clock + [0, 0, 0, 0, 0, duration]);
while datenum(clock) < finalTime
    fr=LucamCaptureFrame(cam);
    if get(handles.fpreview,'value')<1
        findpupil(fr,1);
    end

    if stopval>0 || KbCheck
        if gate<1
            close(1)
        end
        break
    end
%     if KbCheck
%         
%         close(1)
%         break
%     end
        % set the exposure at 2.0
end
LucamHidePreview(cam);				% Clear camera preview.
LucamCameraReset(cam);				% Bring camera to it's hardware default value.
LucamCameraClose(cam);

gainval= str2double(get(handles.gain,'string'));
exposureval = str2double(get(handles.exposure,'string'));



% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stopval gainval exposureval
stopval = 1;
gainval= str2double(get(handles.gain,'string'));
exposureval = str2double(get(handles.exposure,'string'));


% --- Executes on button press in fpreview.
function fpreview_Callback(hObject, eventdata, handles)
% hObject    handle to fpreview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fpreview
