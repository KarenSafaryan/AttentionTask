function varargout = Visstim2013(varargin)
% VISSTIM2013 MATLAB code for Visstim2013.fig
%      VISSTIM2013, by itself, creates a new VISSTIM2013 or raises the existing
%      singleton*.
%
%      H = VISSTIM2013 returns the handle to a new VISSTIM2013 or the handle to
%      the existing singleton*.
%
%      VISSTIM2013('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VISSTIM2013.M with the given input arguments.
%
%      VISSTIM2013('Property','Value',...) creates a new VISSTIM2013 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Visstim2013_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Visstim2013_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Visstim2013

% Last Modified by GUIDE v2.5 19-May-2014 13:10:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Visstim2013_OpeningFcn, ...
                   'gui_OutputFcn',  @Visstim2013_OutputFcn, ...
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


% --- Executes just before Visstim2013 is made visible.
function Visstim2013_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Visstim2013 (see VARARGIN)

% Choose default command line output for Visstim2013
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Visstim2013 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Visstim2013_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in sfCheckBox1.
function sfCheckBox1_Callback(hObject, eventdata, handles)
% hObject    handle to sfCheckBox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sfCheckBox1


% --- Executes on button press in sfCheckBox2.
function sfCheckBox2_Callback(hObject, eventdata, handles)
% hObject    handle to sfCheckBox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sfCheckBox2


% --- Executes on button press in sfCheckBox3.
function sfCheckBox3_Callback(hObject, eventdata, handles)
% hObject    handle to sfCheckBox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sfCheckBox3


% --- Executes on button press in sfCheckBox4.
function sfCheckBox4_Callback(hObject, eventdata, handles)
% hObject    handle to sfCheckBox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sfCheckBox4


% --- Executes on button press in sfCheckBox5.
function sfCheckBox5_Callback(hObject, eventdata, handles)
% hObject    handle to sfCheckBox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sfCheckBox5


% --- Executes on button press in sfCheckBox6.
function sfCheckBox6_Callback(hObject, eventdata, handles)
% hObject    handle to sfCheckBox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sfCheckBox6


% --- Executes on button press in tfCheckBox1.
function tfCheckBox1_Callback(hObject, eventdata, handles)
% hObject    handle to tfCheckBox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tfCheckBox1


% --- Executes on button press in tfCheckBox2.
function tfCheckBox2_Callback(hObject, eventdata, handles)
% hObject    handle to tfCheckBox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tfCheckBox2


% --- Executes on button press in tfCheckBox3.
function tfCheckBox3_Callback(hObject, eventdata, handles)
% hObject    handle to tfCheckBox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tfCheckBox3


% --- Executes on button press in tfCheckBox4.
function tfCheckBox4_Callback(hObject, eventdata, handles)
% hObject    handle to tfCheckBox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tfCheckBox4


% --- Executes on button press in tfCheckBox5.
function tfCheckBox5_Callback(hObject, eventdata, handles)
% hObject    handle to tfCheckBox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tfCheckBox5


% --- Executes on button press in ContrastCb1.
function ContrastCb1_Callback(hObject, eventdata, handles)
% hObject    handle to ContrastCb1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ContrastCb1


% --- Executes on button press in ContrastCb2.
function ContrastCb2_Callback(hObject, eventdata, handles)
% hObject    handle to ContrastCb2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ContrastCb2


% --- Executes on button press in ContrastCb3.
function ContrastCb3_Callback(hObject, eventdata, handles)
% hObject    handle to ContrastCb3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ContrastCb3


% --- Executes on button press in ContrastCb4.
function ContrastCb4_Callback(hObject, eventdata, handles)
% hObject    handle to ContrastCb4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ContrastCb4


% --- Executes on button press in ContrastCb7.
function ContrastCb7_Callback(hObject, eventdata, handles)
% hObject    handle to ContrastCb7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ContrastCb7


% --- Executes on button press in ContrastCb6.
function ContrastCb6_Callback(hObject, eventdata, handles)
% hObject    handle to ContrastCb6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ContrastCb6


% --- Executes on button press in ContrastCb5.
function ContrastCb5_Callback(hObject, eventdata, handles)
% hObject    handle to ContrastCb5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ContrastCb5


% --- Executes on button press in OrientationCb1.
function OrientationCb1_Callback(hObject, eventdata, handles)
% hObject    handle to OrientationCb1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OrientationCb1


% --- Executes on button press in OrientationCb2.
function OrientationCb2_Callback(hObject, eventdata, handles)
% hObject    handle to OrientationCb2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OrientationCb2


% --- Executes on button press in OrientationCb3.
function OrientationCb3_Callback(hObject, eventdata, handles)
% hObject    handle to OrientationCb3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OrientationCb3


% --- Executes on button press in OrientationCb4.
function OrientationCb4_Callback(hObject, eventdata, handles)
% hObject    handle to OrientationCb4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OrientationCb4


% --- Executes on button press in OrientationCb5.
function OrientationCb5_Callback(hObject, eventdata, handles)
% hObject    handle to OrientationCb5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OrientationCb5


% --- Executes on button press in OrientationCb6.
function OrientationCb6_Callback(hObject, eventdata, handles)
% hObject    handle to OrientationCb6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OrientationCb6


% --- Executes on button press in OrientationCb7.
function OrientationCb7_Callback(hObject, eventdata, handles)
% hObject    handle to OrientationCb7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OrientationCb7


% --- Executes on button press in OrientationCb8.
function OrientationCb8_Callback(hObject, eventdata, handles)
% hObject    handle to OrientationCb8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OrientationCb8




function RepeatBt_Callback(hObject, eventdata, handles)
% hObject    handle to RepeatBt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RepeatBt as text
%        str2double(get(hObject,'String')) returns contents of RepeatBt as a double


% --- Executes during object creation, after setting all properties.
function RepeatBt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RepeatBt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BlankDurBt_Callback(hObject, eventdata, handles)
% hObject    handle to BlankDurBt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BlankDurBt as text
%        str2double(get(hObject,'String')) returns contents of BlankDurBt as a double


% --- Executes during object creation, after setting all properties.
function BlankDurBt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BlankDurBt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StimDurBt_Callback(hObject, eventdata, handles)
% hObject    handle to StimDurBt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StimDurBt as text
%        str2double(get(hObject,'String')) returns contents of StimDurBt as a double


% --- Executes during object creation, after setting all properties.
function StimDurBt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StimDurBt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DiodeOnCb.
function DiodeOnCb_Callback(hObject, eventdata, handles)
% hObject    handle to DiodeOnCb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DiodeOnCb


% --- Executes on button press in DirectionPosCb.
function DirectionPosCb_Callback(hObject, eventdata, handles)
% hObject    handle to DirectionPosCb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DirectionPosCb


% --- Executes on button press in DirectionNegCb.
function DirectionNegCb_Callback(hObject, eventdata, handles)
% hObject    handle to DirectionNegCb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DirectionNegCb


% --- Executes on button press in SquareWavesCb.
function SquareWavesCb_Callback(hObject, eventdata, handles)
% hObject    handle to SquareWavesCb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SquareWavesCb


% --- Executes on button press in RandomizeCb.
function RandomizeCb_Callback(hObject, eventdata, handles)
% hObject    handle to RandomizeCb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RandomizeCb


% --- Executes on button press in startV.
function startV_Callback(hObject, eventdata, handles)
% hObject    handle to startV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global params vals;
params = struct();
sFreq = getSpatialFreq(hObject, eventdata, handles);
tFreq = getTemporalFreq(hObject, eventdata, handles);
cnt = getContrast(hObject, eventdata, handles);
ori = getOrientation(hObject, eventdata, handles);
%get some vars
numPres= length(sFreq)*length(tFreq)*length(ori);
param = {sFreq tFreq cnt ori};
paramL = [length(sFreq) length(tFreq) length(cnt) length(ori)];
[paramIter index]= max(paramL);

%get all possible combination of parameters
combos = getCombos(param,paramL,paramIter,index,numPres);

for i = 1:(size(combos,2)/paramIter) %for each block
    for j = 1:paramIter
        combos(index,j+((i-1)*paramIter))=param{index}(j);
    end
end
numPres = size(combos,2);

h=daqhwinfo('nidaq');
daq = h(1).BoardNames(1);
%***LASER STUFF***
sr = 10000; %sample rate in hz
aoDuring = analogoutput('nidaq','Dev1');
aoAfter = analogoutput('nidaq','Dev1');

if strcmp(daq,'PCIe-6341') || get(handles.sci2pcheck,'value')==1
    addchannel(aoDuring,[0 1])
    addchannel(aoAfter,[0 1]);
    sci2p=1;
else
    addchannel(aoDuring,[0 1]);
    addchannel(aoAfter,[0 1]);
    sci2p=1;
end
set(aoDuring, 'SampleRate', sr);
set(aoDuring.Channel, 'UnitsRange', [-5 5]);
set(aoDuring, 'TriggerType', 'Manual');
set(aoDuring, 'RepeatOutput', inf);


set(aoAfter, 'SampleRate', sr);
set(aoAfter.Channel, 'UnitsRange', [-5 5]);
set(aoAfter, 'TriggerType', 'Manual');
set(aoAfter, 'RepeatOutput', inf);

dDuration = str2double(get(handles.StimDurBt,'string')); 
aDuration = str2double(get(handles.BlankDurBt,'string'));
[dBlue dGreen] = getLaserStim(dDuration,sr,handles);
[aBlue aGreen] = getLaserStim(aDuration,sr,handles);

%***DIAGNOSTIC AO***
to = linspace(0,2*pi,sr*1);
zo = zeros(1,sr*1); 

%***AI VM***
vm = analoginput('nidaq','Dev1');
addchannel(vm,1);
set(vm,'SampleRate',3000);
ActualRate = get(vm,'SampleRate');
set(vm,'SamplesPerTrigger',dDuration*ActualRate)
set(vm,'TriggerType','Manual')
set(vm,'InputType','SingleEnded')
%***SINE GRATING STUFF***
rotateMode = kPsychUseTextureMatrixForRotation;

sheight = 30; sdistance = 30;
% Screen size in degrees of visual angle
HeigthScreen = sheight; %Size of the screen in cm
SubjectDistance = sdistance; % Distance of the mouse from the screen in cm
ScreenSize_Va = 2*atand(HeigthScreen/(2*SubjectDistance)); % Screen size expressed in degrees of visual angle

%Screen Parameters
screenid = 1; % This is the monitor on which the grating is projected
if sci2p==1
    screenid =2;
end
rect=Screen('Rect', screenid);
width = rect(RectRight) - rect(RectLeft);
height = rect(RectBottom)-rect(RectTop);
res = [width height];

% Open a fullscreen onscreen window on that display, choose a background
% color of 128 = gray, i.e. 50% max intensity:
win = Screen('OpenWindow', screenid, 156.7);
% Screen('Flip',win);
% Make sure the GLSL shading language is supported:
AssertGLSL;

% Retrieve video redraw interval for later control of our animation timing:
ifi = Screen('GetFlipInterval', win);

% Phase is the phase shift in degrees (0-360 etc.)applied to the sine grating:
phase = 0;

% Build a procedural sine grating texture for a grating with a support of
% res(1) x res(2) pixels and a RGB color offset of 0.5 -- a 50% gray.
gratingtex = CreateProceduralSineGrating(win, res(1), res(2), [0.5 0.5 0.5 0.0]);
KbReleaseWait;

diode = get(handles.DiodeOnCb,'value');
%***LOOPS***
iter = 1;
bcheck =0;
if get(handles.laserAfterVstim,'value')==1
    putdata(aoAfter,[aBlue' aGreen']);
end
figure(1)

spikearr = zeros(numel(ori),1);
while iter <= str2double(get(handles.RepeatBt,'string'))
    presInd = 1;
    
    if get(handles.RandomizeCb,'value') == 1
        randper = randperm(size(combos,2));
        random = zeros(size(combos,1),size(combos,2));
        for i = 1:length(randper)
            random(:,i) = combos(:,randper(i));
        end
    else
        random = combos;
    end
        
    while presInd<=numPres 
        tic;
        if presInd>1 || iter>1
            if sci2p==1
                putdata(aoDuring,[zo' zo']);
                
            else
                putdata(aoDuring,[zo' zo' zo' zo']);
            end
            start(aoDuring)
            trigger(aoDuring)
            stop(aoDuring)
%             data = getdata(vm);
%             disp(size(data))
%             plot(data)
        end
        
        if get(handles.laserAfterVstim,'value') ==1
            start(aoAfter)
            trigger(aoAfter)
        end
        if bcheck ==1, break;end
        counter = 1;
        disp([num2str(iter) ' ' num2str(presInd)])
        
        %get spikes
        
        
        
        %Calculate actual frequency
        Spatial_freq = random(1,presInd);
        Total_cycles = ScreenSize_Va * Spatial_freq;
        freq = Total_cycles/height;
        % Temporal frequency of the grating
        cyclespersecond = random(2,presInd);
        % Compute increment of phase shift per redraw:
        phaseincrement = (cyclespersecond * 360) * ifi;
        %Set Contrast
        contrast = random(3,presInd)/200;
        %set angle
        AnglefromMouse = random(4,presInd)+180;
        duration = str2double(get(handles.BlankDurBt,'string'));
        rotAngle = AnglefromMouse-180; SpatialFreq = freq;
        
        %contrast and orienation
        y0 = .2*(random(3,presInd)/100)*sin((rotAngle+1)*to);
        %spatial freq and temporal freq
        y1 = 1*(random(1,presInd)*sin((cyclespersecond)*to));
        
        if get(handles.laserDuringVstim,'value')==1
            if sci2p == 1
                putdata(aoDuring,[y0' y1']);
            else
                putdata(aoDuring,[y0' y1' dBlue' dGreen']);
            end
        else
            if sci2p ==1
                putdata(aoDuring,[y0' y0']);
            else
                putdata(aoDuring,[y0' y1' zo' zo']);
            end
        end

        if presInd ==1 && iter ==1
            vbl = Screen('Flip', win);    
        end
        
        Screen('FillRect',win,[250 250 250], [0 0 50 50]);
        Screen('Flip', win);
        
        x =toc;
        finalTime = datenum(clock + [0, 0, 0, 0, 0, duration-x]);
        count = 1;
       
        while datenum(clock)<finalTime
            if count == 1
                finalframe = dDuration*60;
                count = 2;
                if get(handles.threshold,'value')>0 && presInd>1

                    spike = 0;
                    data = getdata(vm);
                    i = 1;
                    while i<numel(data)
                        if data(i)>0
                            spike = spike+1;
                            while data(i)>0 && i<numel(data)
                                i=i+1;
                            end 
                        else
                            i = i +1;
                        end
                    end
                    disp(['Angle= ' num2str(AnglefromMouse-180) '.  NumSpikes= ' num2str(spike)])
                    angle = random(4,presInd-1);
                    ind = find(angle==ori);
                    spikearr(ind) = spikearr(ind) + spike;
                    pause(.001)
                    figure(1)
                    h=polar(degtorad(ori'),spikearr,'rs--');
                    set(h,'markersize',10,'markerfacecolor','r');
                    drawnow;
%                     figure(2)
%                     plot(spikearr)
                end
            end
            if KbCheck
                stop(aoAfter)
                putdata(aoAfter,[zo' zo']);
                start(aoAfter); trigger(aoAfter);
                stop(aoAfter);
                bcheck =1 ;
                dDuration =.06;
                break
            end
            
        end
        
        if get(handles.laserAfterVstim,'value')==1
            stop(aoAfter)
            putdata(aoAfter,[aBlue' aGreen']);
        end
        stop(aoDuring);
        start(aoDuring);
        start(vm);
        trigger(vm);
        z=toc;
%         duration = str2double(get(handles.StimDurBt,'string'));
%         finalTime = datenum(clock + [0, 0, 0, 0, 0, duration]);
%         trigger(aoDuring)
        tic;
%         while datenum(clock)<finalTime && bcheck==0
       for counter = 1:(dDuration*60)
            
            phase = phase + phaseincrement;
            Screen('DrawTexture', win, gratingtex, [], [], AnglefromMouse, [], [], [], [], rotateMode, [phase, freq, contrast, 0]);
            if counter ==1,trigger(aoDuring); end
            
            if diode == 1
%                 if (mod(counter,2)==1) || (mod(counter,4)==0)
%                     Screen('FillRect',win,[250 250 250], [0 0 50 50]);
%                 elseif (mod(counter,2)==0) || (mod(counter,4)==3) 
%                     Screen('FillRect',win,[0 0 0], [0 0 50 50]);
%                 end
                
                    Screen('FillRect',win,[0 0 0],[0 0 50 50]);
                
            end
            vbl = Screen('Flip', win, vbl + 0.5 * ifi);
            if counter == finalframe
                Screen('FillRect',win,[250 250 250], [0 0 50 50]);
                Screen('Flip', win);
            end
        end
        
        z=toc;
        stop(aoDuring)
        presInd = presInd+1;
        
    end
    iter = iter +1;
    
    if bcheck ==1, break;end
    if iter>str2double(get(handles.RepeatBt,'string')) && get(handles.laserAfterVstim,'value')==1
        stop(aoAfter);
    end
end
stop(aoDuring)
stop(aoAfter)
if sci2p ==0
    putdata(aoDuring,[zo' zo' zo' zo']);
else
    putdata(aoDuring,[zo' zo']);
end
start(aoDuring)
trigger(aoDuring)
stop(aoDuring)
putdata(aoAfter,[zo' zo']); start(aoAfter);trigger(aoAfter); stop(aoAfter);
delete(aoDuring);
delete(aoAfter);
pause(2)
Screen('CloseAll');
daqreset

function [Blue Green] = getLaserStim(duration,sr,handles)
% PulseIntensity = str2double(get(handles.laserInt,'string'));
% PulseFreq = str2double(get(handles.laserFreq,'string'));
% PulseDuration= str2double(get(handles.laserPD,'string'));

PulseFreq = str2double(get(handles.laserFreq,'string'));
PulseIntensity = 5*(str2double(get(handles.laserInt,'String'))/100);
PulseDuration = PulseFreq*(str2double (get(handles.laserPD,'String'))*1e-1);


t = linspace(0,2*pi,sr*1);
z=zeros(1,sr*1);
% t = linspace(0,2*pi,10000);
%     z=zeros(1,10000);
if (get(handles.bLaser,'Value') == get(handles.bLaser,'Max'))
    Blue= PulseIntensity*(square(PulseFreq*t,PulseDuration)+1);
    Blue = Blue/2;
else
    Blue = z ; 
end

if (get(handles.gLaser,'Value') == get(handles.gLaser,'Max'))
    Green= PulseIntensity*(square(PulseFreq*t,PulseDuration)+1);
    Green = Green/2;
else
    Green = z;
end


function sel = getSpatialFreq(hObject, eventdata, handles)
global params
params.cpd1 = get(handles.sfCheckBox1,'Value');
params.cpd2 = get(handles.sfCheckBox2,'value');
params.cpd4= get(handles.sfCheckBox3,'value');
params.cpd8= get(handles.sfCheckBox4,'value');
params.cpd16 = get(handles.sfCheckBox5,'value');
params.cpd32 = get(handles.sfCheckBox6,'value');
multi = [params.cpd1 params.cpd2 params.cpd4 params.cpd8 params.cpd16 params.cpd32];
values = [.01 .02 .04 .08 .16 .32];
sel = getSelValues(multi,values);


function sel= getTemporalFreq(hObject, eventdata, handles)
global params
params.hz1 = get(handles.tfCheckBox1,'value');
params.hz2 = get(handles.tfCheckBox2,'value');
params.hz3 = get(handles.tfCheckBox3,'value');
params.hz4 = get(handles.tfCheckBox4,'value');
params.hz5 = get(handles.tfCheckBox5,'value');
multi = [params.hz1 params.hz2 params.hz3 params.hz4 params.hz5];
values = [1 2 3 4 5];
sel = getSelValues(multi,values);

function sel = getContrast(hObject, eventdata, handles)
global params;
params.cnt100 = get(handles.ContrastCb1,'value'); 
params.cnt75 = get(handles.ContrastCb2,'value');
params.cnt50 = get(handles.ContrastCb3,'value');
params.cnt40 = get(handles.ContrastCb4,'value');
params.cnt25 = get(handles.ContrastCb5,'value');
params.cnt15 = get(handles.ContrastCb6,'value');
params.cnt125 = get(handles.ContrastCb7,'value');
multi = [params.cnt100 params.cnt75 params.cnt50 params.cnt40 params.cnt25...
    params.cnt15 params.cnt125];
values = [100 75 50 40 25 15 12.5];
sel = getSelValues(multi,values);

function sel = getOrientation(hObject, eventdata, handles)
global params;
params.ori0 = get(handles.OrientationCb1,'value');
params.ori30 = get(handles.OrientationCb2,'value');
params.ori45 = get(handles.OrientationCb3,'value');
params.ori60 = get(handles.OrientationCb4,'value');
params.ori90 = get(handles.OrientationCb5,'value');
params.ori120 = get(handles.OrientationCb6,'value');
params.ori135 = get(handles.OrientationCb7,'value');
params.ori150 = get(handles.OrientationCb8,'value');
multi = [params.ori0 params.ori30 params.ori45 params.ori60 params.ori90...
    params.ori120 params.ori135 params.ori150];
values = [0 30 45 60 90 120 135 150];
sel = getSelValues(multi, values);
values = [180 210 225 240 270 300 315 330];
sel2 = getSelValues(multi,values);

if get(handles.DirectionNegCb,'value') == 1 && get(handles.DirectionPosCb,'value') == 1
    sel = [sel sel2];
elseif get(handles.DirectionNegCb,'value') == 1
    sel = sel2;
    
end
x =1;


function selected = getSelValues(multi, values)
selected = [];
n = 1;
for i = 1:length(values)
    if multi(i)>0
        selected(n) = values(i);
        n = n+1;
    end
end

function combos = getCombos(param,paramL,paramIter,index,numPres)
ind = 0;
for i =1:length(param)
    if paramL(i)>1 && i~=index
        ind = ind+1;
    end
end

gate = 0;
combos = zeros(length(param),numPres);

for i = 1:length(param) %for each parameter
    
    if paramL(i)==1
        for j=1:numPres
            combos(i,j)=param{i}(1);
        end
        
    elseif paramL(i)>1 && i ~=index
        
        if ind == 1 %if only one independent
            for j=0:paramL(i)-1 %for each block
                for k=1:paramIter %for each spot
                    combos(i,k+(j*paramIter))=param{i}(j+1); %
                end
            end
        end
        
        if ind>1 && gate ==0 %if two independent
%             for j=1:((numPres/paramIter)/paramL(i))-1 %for each block of presentation
            
            for j = 0:numPres/paramIter-1; %for each paramIter
                for k=1:paramIter %for each spot
                    
                    if j<=paramL(i)-1
                        combos(i,k+(j*paramIter))=param{i}(j+1);
                    else
                        val = mod(j,paramL(i))+1;
                        combos(i,k+(j*paramIter))=param{i}(val);
                    end
                end
            end
            gate = 1;
        elseif ind>1 && gate ==1 %if three independent
            div = numPres/paramL(i);
            for j=0:(numPres/div)-1 %for each block
                for k=1:div %for each spot
                    combos(i,k+(j*div))=param{i}(j+1);
                end
            end
            gate =2;
        elseif ind>1 && gate ==2
            temp = combos;
            for x = 2:paramL(i)
                combos = [combos temp];
            end
            numPres = numPres*x;
            div = length(combos)/length(temp);
            for j=0:div-1 %for each block
                for k=1:length(temp)%for each spot
                    combos(i,k+(j*length(temp)))=param{i}(j+1);
                end
            end
        end
    end
end


% --- Executes on button press in gLaser.
function gLaser_Callback(hObject, eventdata, handles)
% hObject    handle to gLaser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gLaser


% --- Executes on button press in bLaser.
function bLaser_Callback(hObject, eventdata, handles)
% hObject    handle to bLaser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bLaser


% --- Executes on button press in mLaser.
function mLaser_Callback(hObject, eventdata, handles)
% hObject    handle to mLaser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mLaser


% --- Executes on button press in laserStandalone.
function laserStandalone_Callback(hObject, eventdata, handles)
% hObject    handle to laserStandalone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of laserStandalone
if get(handles.laserStandalone,'value')==1
    set(handles.laserStart,'visible','on')
end
if get(handles.laserStandalone,'value')==0
    set(handles.laserStart,'visible','off')
end

% --- Executes on button press in laserDuringVstim.
function laserDuringVstim_Callback(hObject, eventdata, handles)
% hObject    handle to laserDuringVstim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of laserDuringVstim


% --- Executes on button press in laserAfterVstim.
function laserAfterVstim_Callback(hObject, eventdata, handles)
% hObject    handle to laserAfterVstim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of laserAfterVstim


% --- Executes on button press in laserDAVstim.
function laserDAVstim_Callback(hObject, eventdata, handles)
% hObject    handle to laserDAVstim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of laserDAVstim
if get(handles.laserDAVstim,'value') == 1
    set(handles.laserDuringVstim,'value',1);
    set(handles.laserAfterVstim,'value',1);
end
if get(handles.laserDAVstim,'value') == 0
    set(handles.laserDuringVstim,'value',0);
    set(handles.laserAfterVstim,'value',0);
end


function laserPD_Callback(hObject, eventdata, handles)
% hObject    handle to laserPD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of laserPD as text
%        str2double(get(hObject,'String')) returns contents of laserPD as a double


% --- Executes during object creation, after setting all properties.
function laserPD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to laserPD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function laserFreq_Callback(hObject, eventdata, handles)
% hObject    handle to laserFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of laserFreq as text
%        str2double(get(hObject,'String')) returns contents of laserFreq as a double


% --- Executes during object creation, after setting all properties.
function laserFreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to laserFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function laserInt_Callback(hObject, eventdata, handles)
% hObject    handle to laserInt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of laserInt as text
%        str2double(get(hObject,'String')) returns contents of laserInt as a double


% --- Executes during object creation, after setting all properties.
function laserInt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to laserInt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in laserStart.
function laserStart_Callback(hObject, eventdata, handles)
% hObject    handle to laserStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if get(handles.laserStart,'BackgroundColor')==[.1 .75 .1];
    set(handles.laserStart,'string','Stop Laser');
    set(handles.laserStart,'BackgroundColor',[1 0 0])
    if (~isempty(daqfind))
        stop(daqfind)
    end

    ao = analogoutput('nidaq','Dev1');
    addchannel(ao,[2 3]);
    set(ao, 'SampleRate', 10000);
    set(ao.Channel, 'UnitsRange', [-5 5]);
    set(ao, 'TriggerType', 'Manual');
    set(ao, 'RepeatOutput', inf);
    t = linspace(0,2*pi,10000);
    z=zeros(1,10000);

    PulseFreq = str2double(get(handles.laserFreq,'string'));
    PulseIntensity = 5*(str2double(get(handles.laserInt,'String'))/100);
    PulseDuration = PulseFreq*(str2double (get(handles.laserPD,'String'))*1e-1);

    if (get(handles.bLaser,'Value') == get(handles.bLaser,'Max'))
        Blue= PulseIntensity*(square(PulseFreq*t,PulseDuration)+1); 
    else
        Blue = z ; 
    end
    if (get(handles.gLaser,'Value') == get(handles.gLaser,'Max'))
        Green= PulseIntensity*(square(PulseFreq*t,PulseDuration)+1);
    else
        Green = z;
    end

    if (get(handles.mLaser,'Value') == get(handles.mLaser,'Max')),
        set(ao, 'RepeatOutput', 1);
       while get(handles.mLaser,'Value') == get(handles.mLaser,'Max'),
        Run = MovementTracking;
        if Run == 1
            putdata(ao, [Blue' Green']),
        else
            putdata(ao, [z' z']);

        end
            start (ao);
            trigger (ao);
            %pause (0.1)
         stop (ao);
       end
    else
    putdata(ao, [Blue' Green']);
    start (ao);
    trigger (ao),
    end
else
    set(handles.laserStart,'string','Start Laser');
    set(handles.laserStart,'BackgroundColor',[.1 .75 .1])
    if (~isempty(daqfind))
        stop(daqfind)
    end
    ao = analogoutput('nidaq','Dev1');
    addchannel(ao,[2 3]);
    set(ao, 'SampleRate', 10000);
    set(ao.Channel, 'UnitsRange', [-5 5]);
    set(ao, 'TriggerType', 'Manual');
    set(ao, 'RepeatOutput', inf);

    stop (ao);
    z=zeros(1,10000);

    putdata(ao, [z' z']);
    start (ao);
    trigger (ao);
    stop (ao);
    delete (ao);
end


% --- Executes on button press in threshold.
function threshold_Callback(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of threshold



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


% --- Executes on button press in sci2pcheck.
function sci2pcheck_Callback(hObject, eventdata, handles)
% hObject    handle to sci2pcheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sci2pcheck
