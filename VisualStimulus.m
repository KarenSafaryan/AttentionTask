function varargout = VisualStimulus(varargin)
% VISUALSTIMULUS M-file for VisualStimulus.fig
%      VISUALSTIMULUS, by itself, creates a new VISUALSTIMULUS or raises the existing
%      singleton*.
%
%      H = VISUALSTIMULUS returns the handle to a new VISUALSTIMULUS or the handle to
%      the existing singleton*.
%
%      VISUALSTIMULUS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VISUALSTIMULUS.M with the given input arguments.
%
%      VISUALSTIMULUS('Property','Value',...) creates a new VISUALSTIMULUS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VisualStimulus_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VisualStimulus_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VisualStimulus

% Last Modified by GUIDE v2.5 03-Mar-2012 12:53:51
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VisualStimulus_OpeningFcn, ...
                   'gui_OutputFcn',  @VisualStimulus_OutputFcn, ...
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


% --- Executes just before VisualStimulus is made visible.
function VisualStimulus_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VisualStimulus (see VARARGIN)

% Choose default command line output for VisualStimulus
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VisualStimulus wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VisualStimulus_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


    % If you don't use this mode "kPsychUseTextureMatrixForRotation" the
    % square that is drwn will rotate with angle...

    rotateMode = kPsychUseTextureMatrixForRotation;

   KbName('UnifyKeyNames');




    % Spatial frequency of the grating
    
    HeigthScreen = str2double (get(handles.Monitor_Height_Value,'String')); %Size of the screen in cm
    SubjectDistance = str2double (get(handles.Distance_mm_value,'String')); % Distance of the mouse from the screen in cm
    ScreenSize_Va = 2*atand(HeigthScreen/(2*SubjectDistance)); % Screen size expressed in degrees of visual angle
    
    freq = 1/360; % Frequency of the grating in cycles per pixel: Here 0.01 cycles per pixel:

    % Temporal frequency of the grating

    cyclespersecond = str2double (get(handles.TF_value,'String'));
    
    
    % Tilt angle of the grating:
    AnglefromMouse = 0;


% Amplitude of the grating in units of absolute display intensity range: A
% setting of 0.5 means that the grating will extend over a range from -0.5
% up to 0.5, i.e., it will cover a total range of 1.0 == 100% of the total
% displayable range. As we select a background color and offset for the
% grating of 0.5 (== 50% nominal intensity == a nice neutral gray), this
% will extend the sinewaves values from 0 = total black in the minima of
% the sine wave up to 1 = maximum white in the maxima. Amplitudes of more
% than 0.5 don't make sense, as parts of the grating would lie outside the
% displayable range for your computers displays:
 amplitude = str2double (get(handles.Contrast_Value,'String'))/200;

% Choose screen with maximum id - the secondary display on a dual-display
% setup for display:
screenid = 1; % This is the monitor on which the grating is projected
rect=Screen('Rect', screenid);
width = rect(RectRight) - rect(RectLeft);
height = rect(RectBottom)-rect(RectTop);
res = [width height];

    screenid2 = 2;   % Second monitor on which the mouse is moved 
    rect2=Screen('Rect', screenid2);
    width2 = rect2(RectRight) - rect2(RectLeft);
    height2 = rect2(RectBottom)-rect2(RectTop);
    res2 = [width2 height2];
   


% Open a fullscreen onscreen window on that display, choose a background
% color of 128 = gray, i.e. 50% max intensity:
win = Screen('OpenWindow', screenid, 128);
   
% Make sure the GLSL shading language is supported:
AssertGLSL;

% Retrieve video redraw interval for later control of our animation timing:
ifi = Screen('GetFlipInterval', win);

% Phase is the phase shift in degrees (0-360 etc.)applied to the sine grating:
phase = 0;

% Compute increment of phase shift per redraw:
phaseincrement = (cyclespersecond * 360) * ifi;

% Create an array for spike display

Spike_mem = [0 0];

% Build a procedural sine grating texture for a grating with a support of
% res(1) x res(2) pixels and a RGB color offset of 0.5 -- a 50% gray.
gratingtex = CreateProceduralSineGrating(win, res(1), res(2), [0.5 0.5 0.5 0.0]);

% Wait for release of all keys on keyboard, then sync us to retrace:
KbReleaseWait;
escapeKey = KbName('ESCAPE');
spaceKey = KbName('SPACE');
ReturnKey = KbName('RETURN');
ClearKey = KbName('C');
PauseKey = KbName('P');
PauseAsked = 0;

HideCursor;
vbl = Screen('Flip', win);
% analog output
angleout = analogoutput('nidaq','dev1');
addchannel(angleout,0:1)

SR = 3000;
ntime = .0255;
stime = 1/SR;
fperloop = ceil(ntime/stime);

%analog input
ai = analoginput('nidaq','dev1');
addchannel(ai,1);
set(ai,'SampleRate',SR)
set(ai,'SamplesPerTrigger',Inf);
set(ai,'inputtype','singleended')
% set(ai,'LogToDiskMode','Overwrite')
% set(ai,'LogFileName','log.daq')
% set(ai,'LoggingMode', 'disk') 

n = 0;
% Animation loop: Repeats until keypress...

[ keyIsDown, TimeKeyDown, keyCode ] = KbCheck; % required for the first // ~keyCode(escapeKey)
oldTime = GetSecs;
hold on;
first = 0;
spike = 0;
start(ai);
spikecount = [];
tic
while ~keyCode(escapeKey)
    if first ==0
        first = 1;
    else
        data = peekdata(ai,75);
        i = 1;
        spike = 0;
        while i <= numel(data)
            if data(i)>0
                spike = spike+1;
                toc
                spikecount = [spikecount AnglefromMouse];
%                 i=i+2;
            end
            i = i+1;
        end
        if spike> 10
            spike = 10;
        end
    end
    % If temporal frequency or contrast have been changed, applies
    
    [ keyIsDown, TimeKeyDown, keyCode ] = KbCheck;
    
   if keyCode(ReturnKey)
        
        amplitude = str2double (get(handles.Contrast_Value,'String'))/200;
        cyclespersecond = str2double (get(handles.TF_value,'String'));
        phaseincrement = (cyclespersecond * 360) * ifi;
      
        
   end
   
      
   % Follow the movement of the mouse
    
    [mx, my, buttons]=GetMouse(screenid2);
     position = [(mx*width/width2) (my*height/height2)];
     mx = position (1);
     my = position (2);
    AnglefromMouse = (atand((my-(height/2))/(mx-(width/2))));
 
    % Provisory, will work with spike TTL
    
    if keyCode(spaceKey) || spike >0
        if (TimeKeyDown - oldTime) > 0.1
        Spike_mem = [Spike_mem; position];
        oldTime = TimeKeyDown;
        end
   oldTime = TimeKeyDown;
    end
    
    if keyCode(ClearKey) 
         Spike_mem = [0 0];
    end
    
    if keyCode(PauseKey) 
         PauseAsked = abs(PauseAsked - 1);
    end
    
    if (PauseAsked ==1)
        ShowCursor;
    else
        HideCursor;
        
     
    %   Create the plot with the mouse and spike position
    cla %clear the axes before plotting
    plot((position(:,1)-(width/2))* 0.16/(height/2), -1*(position(:,2)-(height/2))* 0.16/(height/2),'r+',...
    (Spike_mem(:,1)-(width/2))* 0.16/(height/2), -1*(Spike_mem(:,2)-(height/2))* 0.16/(height/2),'.');
    
    end
    
    if (mx-(width/2)) < 0
       phase = phase + phaseincrement;
    else
      phase = phase - phaseincrement;
    end

    Spatial_freq = sqrt (((my-(height/2)).^2) + (mx-(width/2)).^2) * 0.16/(height/2);
    Total_cycles = ScreenSize_Va * Spatial_freq;
    freq = Total_cycles/height; % in cycle per pixel
    
    if (mx-(width/2))<0
%         disp(AnglefromMouse+180)
        ang = 5*((AnglefromMouse+180)/360);
    elseif (my-(height/2)) < 0
        ang = 5*((AnglefromMouse+360)/360);
%         disp(AnglefromMouse+360);
    else
        ang = 5*((AnglefromMouse)/360);
%         disp(AnglefromMouse)
    end
    
    putsample(angleout,[Spatial_freq*10 ang])
    if buttons(1) % If right click the orientation and spatial frequency are displayed 
        if (mx-(width/2)) < 0
    set(handles.Orientation_value_Disp,'String',num2str(AnglefromMouse+180));
        elseif (my-(height/2)) < 0
    set(handles.Orientation_value_Disp,'String',num2str(AnglefromMouse+360));        
        else
    set(handles.Orientation_value_Disp,'String',num2str(AnglefromMouse)); 
        end
    set(handles.SF_value_disp,'String',num2str(Spatial_freq));
    end
   drawnow; % applies the changes
    
    % Draw the grating, centered on the screen, with given rotation 'angle',
    % sine grating 'phase' shift and amplitude, rotating via set
    % 'rotateMode'. Note that we pad the last argument with a 4th
    % component, which is 0. This is required, as this argument must be a
    % vector with a number of components that is an integral multiple of 4,
    % i.e. in our case it must have 4 components:
    Screen('DrawTexture', win, gratingtex, [], [], AnglefromMouse, [], [], [], [], rotateMode, [phase, freq, amplitude, 0]);
 %   Screen('DrawDots', win2, position,10 ,[255 0 0 0],[0 0],1);
  %  Screen('DrawingFinished', win2);

    % Show it at next retrace:
    vbl = Screen('Flip', win, vbl + 0.5 * ifi);
    
    
    n=n+1;
end
x=toc;
stop(ai)
disp(x/n)
% We're done. Close the window. This will also release all other
% ressources:
Screen('CloseAll');
ShowCursor;
% Bye bye!
putsample(angleout,[0 0])
delete(angleout);
clear all

return;



function Orientation_value_Disp_Callback(hObject, eventdata, handles)
% hObject    handle to Orientation_value_Disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Orientation_value_Disp as text
%        str2double(get(hObject,'String')) returns contents of Orientation_value_Disp as a double



% --- Executes during object creation, after setting all properties.
function Orientation_value_Disp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Orientation_value_Disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SF_value_disp_Callback(hObject, eventdata, handles)
% hObject    handle to SF_value_disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SF_value_disp as text
%        str2double(get(hObject,'String')) returns contents of SF_value_disp as a double


% --- Executes during object creation, after setting all properties.
function SF_value_disp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SF_value_disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Monitor_Height_Value_Callback(hObject, eventdata, handles)
% hObject    handle to Monitor_Height_Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Monitor_Height_Value as text
%        str2double(get(hObject,'String')) returns contents of Monitor_Height_Value as a double


% --- Executes during object creation, after setting all properties.
function Monitor_Height_Value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Monitor_Height_Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Distance_mm_value_Callback(hObject, eventdata, handles)
% hObject    handle to Distance_mm_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Distance_mm_value as text
%        str2double(get(hObject,'String')) returns contents of Distance_mm_value as a double


% --- Executes during object creation, after setting all properties.
function Distance_mm_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Distance_mm_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TF_value_Callback(hObject, eventdata, handles)
% hObject    handle to TF_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TF_value as text
%        str2double(get(hObject,'String')) returns contents of TF_value as a double


% --- Executes during object creation, after setting all properties.
function TF_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TF_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Contrast_Value_Callback(hObject, eventdata, handles)
% hObject    handle to Contrast_Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Contrast_Value as text
%        str2double(get(hObject,'String')) returns contents of Contrast_Value as a double


% --- Executes during object creation, after setting all properties.
function Contrast_Value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Contrast_Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2



