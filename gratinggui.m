%CODE WRITTEN BY MICKY EINSTEIN
%INSTIGATES main.m
%gratinggui.m passes variables to main.m to run behavioral task

function varargout = gratinggui(varargin)
% GRATINGGUI M-file for gratinggui.fig
%      GRATINGGUI, by itself, creates a new GRATINGGUI or raises the existing
%      singleton*.
%
%      H = GRATINGGUI returns the handle to a new GRATINGGUI or the handle to
%      the existing singleton*.
%
%      GRATINGGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRATINGGUI.M with the given input arguments.
%
%      GRATINGGUI('Property','Value',...) creates a new GRATINGGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gratinggui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gratinggui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gratinggui

% Last Modified by GUIDE v2.5 18-Jul-2014 16:35:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gratinggui_OpeningFcn, ...
                   'gui_OutputFcn',  @gratinggui_OutputFcn, ...
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


% --- Executes just before gratinggui is made visible.
function gratinggui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gratinggui (see VARARGIN)

set(gcf, 'Units' , 'pixels');
set(gcf, 'Position', [-1000, 0, 634, 313]);

% Choose default command line output for gratinggui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gratinggui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gratinggui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Start.
function Start_Callback(hObject, eventdata, handles)
% hObject    handle to Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%GET GRATING INFORMATION  --> store in 'gratinginfo'
angle = str2double(get(handles.Angle,'String'));
cycleS= str2double(get(handles.cycleS,'String'));
freq = str2double(get(handles.Freq,'String'));
duration = str2double(get(handles.Duration,'String'));
contrast = str2double(get(handles.Contrast,'String'));
height = str2double(get(handles.height,'String'));
distance = str2double(get(handles.sdistance, 'String'));
pref = get(handles.pref,'Value');
npref = get(handles.npref, 'Value');
gratinginfo = [angle cycleS freq contrast duration height distance pref npref];

%GET WATER DISPENSER INFORMATION   --> store in 'waterDispenserinfo'
watertime = str2double(get(handles.watertime,'String'));
delaytime = str2double(get(handles.delaytime, 'String'));
cleartime = str2double(get(handles.cleartime, 'String'));
v2delay = str2double(get(handles.v2delay, 'String'));
waterDispenserinfo = [watertime delaytime cleartime v2delay];

%GET EXPERIMENT INFORMATION
numtrials = str2double(get(handles.numtrials,'String'));
itiTime = str2double(get(handles.itiTime,'String'));
punishTime = str2double(get(handles.punishTime, 'String'));
pretrial = get(handles.pretrial,'Value');
vstim = get(handles.vstim,'Value');
aDescTask = get(handles.aDescTask,'Value');
distractor = get(handles.distractor,'Value');
experimentinfo = [numtrials itiTime punishTime pretrial vstim aDescTask distractor];

%GET AUDITORY CUE INFORMATION
auditoryfreq = str2double(get(handles.auditoryfreq,'String'));
auditoryduration = str2double(get(handles.auditoryduration,'String'));
interval = str2double(get(handles.interval,'String'));
freqpref = str2double(get(handles.freqpref,'String'));
auditoryinfo = [auditoryfreq auditoryduration interval freqpref];

%GET OUTPUT FILE INFORMATION
if get(handles.outputcheckbox, 'Value') == get(handles.outputcheckbox,'Max')
    outputCheck = 1.0;
else
    outputCheck = 0.0;
end

mouse = get(handles.mouse,'String');
if outputCheck == 1 %% if we are saving a file
%     try
    [count lcell] = createfile_Callback(hObject, eventdata, handles,1);
%     catch err
%         disp('Matlab could not find the previous files. Make sure that the "mice" folder is selected!!')
%     end
    
    %create output file name
    val=0; tasks = {'' 'a' 'v' 'va' 'av'};
    if vstim>0 && aDescTask>0
        if distractor == 0
            val = 4;
        else
            val = 5;
        end
    elseif aDescTask>0
        val = 2;
    else
        if count(2)>0
            val = 3;
        else
            val =1;
        end
    end
    dformat = 'mm-dd'; d = datestr(now,dformat);
    if count(val)>0
        pastfile = lcell{count(val),val};
    else
        if val == 1 && count(val) == 0
            pastfile = '          ';
        elseif count(val-1)>0
            pastfile = lcell{count(val-1),val-1};
        else
            pastfile = lcell{count(val-2),val-2};
        end
    end
    if count(val)<9
        z = '00';
    else
        z = '0';
    end
    append = 0;
    letter = isletter(pastfile);
    for i = 1:numel(letter)
        if letter(i)==1
            ind = i+6;
            break
        end
    end
%     ind = strfind(pastfile,'ME')+6;
    
    if val > 3 %for va and av tasks
        pastval = pastfile(ind:ind+1);
        theSameTask = strcmp(pastval,tasks{val});
    else
        theSameTask =1;
    end
    if strcmp(pastfile(1:5),d) && theSameTask == 1
        append = input('Append to old file? 1 (Yes), 0 (No)? :');
        if append == 1
            fileID = pastfile;
        end
    end
    if append == 0
        fileID = [d mouse '_' tasks{val} z num2str(count(val)+1) '.mat'];
    end
    outputFile = fileID; %get(handles.outputfile,'String');
    d = dir;
    s = 0;
    for i = 1:length(d)
        temp = d(i).name;
        if exist(temp) == 7 && strcmp(temp,mouse)
            outputFile = [pwd '\' temp '\' outputFile];
            s = 1;
        end
    end
else
    outputFile = '';
    s=1;
    append = 0;
end

if s == 0 && get(handles.outputcheckbox,'value')>0
    button = input('Create dir? 1 (yes) or 0 (no): ');
     if button == 0
        clear all
        return
    else
        mkdir([pwd '\' mouse]);
        outputFile = [pwd '\' mouse '\' outputFile];
    end
    H2Ocell = cell(5,2);
    initial = input('Enter weight prior to H20 Deprivation: ');
    H2Ocell{4,1} = initial;
end

if exist(outputFile,'file') >0 && outputCheck >0
    if get(handles.outputcheckbox,'value')>0
        button = input(['Overwrite ' fileID '? 1 (yes) or 0 (no): ']);
        if append ==1 && button == 1
            button = input('Are you sure about this? 1 (yes) or 0 (no): ');
                if button == 1
                    append = 0;
                else
                    disp('Go back, set everything up right, and hit start!')
                    clear all
                    return
                end
        elseif append ==1 && button == 0
            disp('Appending to previous file');
        elseif button == 0
            clear all
            return
        end
    end
end
outputfileinfo = {outputFile,outputCheck,mouse,append};

%get water code
H2Ofile = [pwd '\' mouse '\' mouse '.H2O'];
if get(handles.outputcheckbox,'value')>0 %if we are saving a file
    check = 0;
    count = 0;
    while check == 0
        if exist(H2Ofile,'file')>0 %if the h20 file already exists
            load(H2Ofile,'-mat','H2Ocell');
            ind = size(H2Ocell,2);
            if ~strcmp(date,H2Ocell{1,ind}) %if first entry for date
                H2Ocell{1,1+ind} = date;
            end
            ind = size(H2Ocell,2);
            if isempty(H2Ocell{2,ind}) || count>0 %if no init water entered
                initwater = input('Enter initial H2O: ');
                H2Ocell{2,ind} = initwater;
            end
            if isempty(H2Ocell{4,ind}) || count>0 %if no weight entered
                H2Ocell{4,ind} = input('Enter weight(g): ');
            end
            save(H2Ofile,'H2Ocell');

        else %if the animal has never been on the task

            H2Ocell{1,2} = date; H2Ocell{2,1} = input('Enter initial H2O: ');
            H2Ocell{4,2} = input('Enter weight(g): ');
            save(H2Ofile,'H2Ocell');
        end
        
        check = input('Did you enter the correct weight and initial water? 1 (yes) or 0 (no): ');
        count = count +1;
    end
end

%Send GUI info to main
attrig2check=1;
while attrig2check ==1
    [tnum attrig2check] = main(gratinginfo,waterDispenserinfo,experimentinfo, auditoryinfo,outputfileinfo,outputFile,handles);
    if attrig2check == 1
        append = 1;
        outputfileinfo = {outputFile,outputCheck,mouse,append};
    end
end
if get(handles.outputcheckbox,'value')>0
    watercheck = 0;
    while watercheck ==0
        finalwater = input('Enter final H2O (if not final, enter 0): ');
        watercheck = input('Is the final H20 correct? 1 (yes) or 0 (no): ');
    end
    if finalwater ~= 0
        ind = size(H2Ocell,2);
        H2Ocell{3,ind} = finalwater;
    end
    ind = size(H2Ocell,2);
    if isempty(H2Ocell{5,ind})
        H2Ocell{5,ind} = tnum;
    elseif append == 1
        H2Ocell{5,ind} = tnum;
    else
        H2Ocell{5,ind} = H2Ocell{5,ind}+tnum;
    end
    save(H2Ofile,'H2Ocell');
    disp([mouse ' received ' num2str(H2Ocell{2,ind}-H2Ocell{3,ind})])
end
clear all

function Angle_Callback(hObject, eventdata, handles)
% hObject    handle to Angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Angle as text
%        str2double(get(hObject,'String')) returns contents of Angle as a
%        double


% --- Executes during object creation, after setting all properties.
function Angle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cycleS_Callback(hObject, eventdata, handles)
% hObject    handle to cycleS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cycleS as text
%        str2double(get(hObject,'String')) returns contents of cycleS as a double


% --- Executes during object creation, after setting all properties.
function cycleS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cycleS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Freq_Callback(hObject, eventdata, handles)
% hObject    handle to Freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Freq as text
%        str2double(get(hObject,'String')) returns contents of Freq as a double


% --- Executes during object creation, after setting all properties.
function Freq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Duration_Callback(hObject, eventdata, handles)
% hObject    handle to Duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Duration as text
%        str2double(get(hObject,'String')) returns contents of Duration as a double


% --- Executes during object creation, after setting all properties.
function Duration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Contrast_Callback(hObject, eventdata, handles)
% hObject    handle to Contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Contrast as text
%        str2double(get(hObject,'String')) returns contents of Contrast as a double


% --- Executes during object creation, after setting all properties.
function Contrast_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function height_Callback(hObject, eventdata, handles)
% hObject    handle to height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of height as text
%        str2double(get(hObject,'String')) returns contents of height as a double


% --- Executes during object creation, after setting all properties.
function height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sdistance_Callback(hObject, eventdata, handles)
% hObject    handle to sdistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sdistance as text
%        str2double(get(hObject,'String')) returns contents of sdistance as a double


% --- Executes during object creation, after setting all properties.
function sdistance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sdistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function watertime_Callback(hObject, eventdata, handles)
% hObject    handle to watertime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of watertime as text
%        str2double(get(hObject,'String')) returns contents of watertime as a double


% --- Executes during object creation, after setting all properties.
function watertime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to watertime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function delaytime_Callback(hObject, eventdata, handles)
% hObject    handle to delaytime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of delaytime as text
%        str2double(get(hObject,'String')) returns contents of delaytime as a double


% --- Executes during object creation, after setting all properties.
function delaytime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delaytime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numtrials_Callback(hObject, eventdata, handles)
% hObject    handle to numtrials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numtrials as text
%        str2double(get(hObject,'String')) returns contents of numtrials as a double


% --- Executes during object creation, after setting all properties.
function numtrials_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numtrials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function itiTime_Callback(hObject, eventdata, handles)
% hObject    handle to itiTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of itiTime as text
%        str2double(get(hObject,'String')) returns contents of itiTime as a double


% --- Executes during object creation, after setting all properties.
function itiTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to itiTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function punishTime_Callback(hObject, eventdata, handles)
% hObject    handle to punishTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of punishTime as text
%        str2double(get(hObject,'String')) returns contents of punishTime as a double


% --- Executes during object creation, after setting all properties.
function punishTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to punishTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function auditoryfreq_Callback(hObject, eventdata, handles)
% hObject    handle to auditoryfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of auditoryfreq as text
%        str2double(get(hObject,'String')) returns contents of auditoryfreq as a double


% --- Executes during object creation, after setting all properties.
function auditoryfreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to auditoryfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function auditoryduration_Callback(hObject, eventdata, handles)
% hObject    handle to auditoryduration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of auditoryduration as text
%        str2double(get(hObject,'String')) returns contents of auditoryduration as a double


% --- Executes during object creation, after setting all properties.
function auditoryduration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to auditoryduration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function interval_Callback(hObject, eventdata, handles)
% hObject    handle to interval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of interval as text
%        str2double(get(hObject,'String')) returns contents of interval as a double


% --- Executes during object creation, after setting all properties.
function interval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to interval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function outputfile_Callback(hObject, eventdata, handles)
% hObject    handle to outputfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outputfile as text
%        str2double(get(hObject,'String')) returns contents of outputfile as a double


% --- Executes during object creation, after setting all properties.
function outputfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outputfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in outputcheckbox.
function outputcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to outputcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
one = get(handles.outputcheckbox,'Value');
if one == 1
    set(handles.mouse,'Visible','on');
    set(handles.createfile,'Visible','on');
    set(handles.text22,'Visible','on');
    set(handles.waterhist,'Visible','on');
else
    set(handles.mouse,'Visible','off');
    set(handles.createfile,'Visible','off');
    set(handles.text22,'Visible','off');
    set(handles.waterhist,'Visible','off');
end
% Hint: get(hObject,'Value') returns toggle state of outputcheckbox



function mouse_Callback(hObject, eventdata, handles)
% hObject    handle to mouse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mouse as text
%        str2double(get(hObject,'String')) returns contents of mouse as a double


% --- Executes during object creation, after setting all properties.
function mouse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mouse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cleartime_Callback(hObject, eventdata, handles)
% hObject    handle to cleartime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cleartime as text
%        str2double(get(hObject,'String')) returns contents of cleartime as a double


% --- Executes during object creation, after setting all properties.
function cleartime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cleartime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pref.
function pref_Callback(hObject, eventdata, handles)
% hObject    handle to pref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pref


% --- Executes on button press in npref.
function npref_Callback(hObject, eventdata, handles)
% hObject    handle to npref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of npref


% --- Executes on button press in pretrial.
function pretrial_Callback(hObject, eventdata, handles)
% hObject    handle to pretrial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.pretrial,'Value')==1
    set(handles.pref,'Value',1);
else
    set(handles.pref,'Value',0);
end
% Hint: get(hObject,'Value') returns toggle state of pretrial



function v2delay_Callback(hObject, eventdata, handles)
% hObject    handle to v2delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v2delay as text
%        str2double(get(hObject,'String')) returns contents of v2delay as a double


% --- Executes during object creation, after setting all properties.
function v2delay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v2delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function flushtime_Callback(hObject, eventdata, handles)
% hObject    handle to flushtime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of flushtime as text
%        str2double(get(hObject,'String')) returns contents of flushtime as a double


% --- Executes during object creation, after setting all properties.
function flushtime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flushtime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in flush.
function flush_Callback(hObject, eventdata, handles)
% hObject    handle to flush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
flushtime = str2double(get(handles.flushtime,'String'));
dispenseWater(flushtime,5);


% --- Executes on button press in vstim.
function vstim_Callback(hObject, eventdata, handles)
% hObject    handle to vstim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
one = get(handles.aDescTask,'Value');
two = get(handles.vstim,'Value');
if one ==1 && two == 1
    set(handles.distractor,'Visible','on');
    set(handles.Start,'Position',...
        [51.4285 .14999 16.1428 1.65]);
    set(handles.buffer,'visible','on');
    set(handles.threshold,'visible','on');
else
    set(handles.distractor,'Visible','off');
    set(handles.Start,'Position',...
        [51.4285 .14999 16.5714 2.85]);
    set(handles.buffer,'visible','off','value',0)
    set(handles.threshold,'visible','off')
end
% Hint: get(hObject,'Value') returns toggle state of vstim


% --- Executes on button press in aDescTask.
function aDescTask_Callback(hObject, eventdata, handles)
% hObject    handle to aDescTask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
one = get(handles.aDescTask,'Value');
two = get(handles.vstim,'Value');
if one ==1 && two == 1
    set(handles.distractor,'Visible','on');
    set(handles.Start,'Position',...
        [51.4285 .14999 16.1428 1.65]);
    set(handles.buffer,'visible','on');
    set(handles.threshold,'visible','on');
else
    set(handles.distractor,'Visible','off');
    set(handles.Start,'Position',...
        [51.4285 .14999 16.5714 2.85]);
    set(handles.buffer,'visible','off')
    set(handles.threshold,'visible','off')
    set(handles.buffer,'value',0);
end
% Hint: get(hObject,'Value') returns toggle state of aDescTask



function freqpref_Callback(hObject, eventdata, handles)
% hObject    handle to freqpref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of freqpref as text
%        str2double(get(hObject,'String')) returns contents of freqpref as a double


% --- Executes during object creation, after setting all properties.
function freqpref_CreateFcn(hObject, eventdata, handles)
% hObject    handle to freqpref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in distractor.
function distractor_Callback(hObject, eventdata, handles)
% hObject    handle to distractor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.distractor,'Value') == 0
    set(handles.distractor,'String','Auditory Distractor');
else
    set(handles.distractor,'String','Visual Distractor');
end
% Hint: get(hObject,'Value') returns toggle state of distractor


% --- Executes on button press in pumptoggle.
function pumptoggle_Callback(hObject, eventdata, handles)
% hObject    handle to pumptoggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.psycht,'value') ==0
    devset = 'Dev1';
else
    devset = 'Dev2';
end
dio = digitalio('nidaq',devset);
addline(dio,3,'out');
if get(handles.pumptoggle,'Value') == 0
    putvalue(dio,0);
    set(handles.pumptoggle,'String','Pump Off')
else
    putvalue(dio,1);
    set(handles.pumptoggle,'String','Pump On')
end
% Hint: get(hObject,'Value') returns toggle state of pumptoggle


% --- Executes on button press in drop.
function drop_Callback(hObject, eventdata, handles)
% hObject    handle to drop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dropoutput = analogoutput('nidaq', 'dev1');
vac = digitalio('nidaq','dev1');
line = addline(vac,3,'out');

% putvalue(vac,1)
addchannel(dropoutput,0);
set(dropoutput, 'SampleRate', 8000)
set(dropoutput, 'TriggerType', 'Manual')
actualRate = get(dropoutput, 'SampleRate');
length = actualRate*1; %1 second in frames
watertime = str2double(get(handles.watertime,'String')); %time to dispense water
zeroes = linspace(0,0,length)';
vstep = linspace(5,5,length*watertime)';
v2delay = str2double(get(handles.v2delay, 'String'));
zeromiddle = linspace(0,0,length*v2delay)';
data = cat(1,vstep,zeromiddle,vstep,zeromiddle,vstep,zeromiddle,vstep,zeroes);

putdata(dropoutput,data)
start(dropoutput)
trigger(dropoutput)
disp('drop dispensed');
finalTime = datenum(clock + [0, 0, 0, 0, 0, 2]);
while datenum(clock) < finalTime
end
stop(dropoutput)
delete(dropoutput)
putvalue(vac,0);
delete(vac)


% --- Executes on button press in buffer.
function buffer_Callback(hObject, eventdata, handles)
% hObject    handle to buffer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of buffer



function threshold_Callback(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of threshold as text
%        str2double(get(hObject,'String')) returns contents of threshold as a double


% --- Executes during object creation, after setting all properties.
function threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in op.
function op_Callback(hObject, eventdata, handles)
% hObject    handle to op (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of op


% --- Executes on button press in prefbuf.
function prefbuf_Callback(hObject, eventdata, handles)
% hObject    handle to prefbuf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of prefbuf



function nprefbufnum_Callback(hObject, eventdata, handles)
% hObject    handle to nprefbufnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nprefbufnum as text
%        str2double(get(hObject,'String')) returns contents of nprefbufnum as a double


% --- Executes during object creation, after setting all properties.
function nprefbufnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nprefbufnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pnp.
function pnp_Callback(hObject, eventdata, handles)
% hObject    handle to pnp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pnp



function pnpnum_Callback(hObject, eventdata, handles)
% hObject    handle to pnpnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pnpnum as text
%        str2double(get(hObject,'String')) returns contents of pnpnum as a double


% --- Executes during object creation, after setting all properties.
function pnpnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pnpnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in waterhist.
function waterhist_Callback(hObject, eventdata, handles)
% hObject    handle to waterhist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mouse = get(handles.mouse,'String');
H2Ofile = [pwd '\' mouse '\' mouse '.H2O'];
load(H2Ofile,'-mat','H2Ocell')
tempcell = cell(4,size(H2Ocell,2));
arr = zeros(2,size(H2Ocell,2));
for i = 1:size(H2Ocell,2)
    if ~isempty(H2Ocell{3,i}) && ~isempty(H2Ocell{2,i})
        arr(1,i) = H2Ocell{2,i} - H2Ocell{3,i};
    else
        arr(1,i) = NaN;
    end
    arr(2,i) = H2Ocell{4,i};
    tempcell{1,i} = H2Ocell{1,i};
    tempcell{2,i} = arr(1,i);
    tempcell{3,i} = H2Ocell{4,i};
    tempcell{4,i} = H2Ocell{5,i};
end
figure
subplot(1,2,1)
plot(arr(1,:))
title('water')
subplot(1,2,2)
plot(arr(2,:))
delta = (arr(2,1)-arr(2,length(arr)))/arr(2,1);
title(['Weight - Delta = ' num2str(delta)])
disp(tempcell)


%H2Ocell has three rows: date, init,final



% --- Executes during object creation, after setting all properties.
function prefbufnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prefbufnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in createfile.
function [count lcell] = createfile_Callback(hObject, eventdata, handles,opt)
% hObject    handle to createfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if nargin<4
    opt = 0;
end

mouseID = get(handles.mouse,'string');
directory = [pwd '\' mouseID];
try
[lcell count] = getPerSum(directory); %count contains 
catch err
    if opt == 0 
        disp('Matlab could not find the previous files. Make sure that the "mice" folder is selected!!')
        return
    else
        rethrow(err)
    end
end
if opt == 1
    return
end
disp('Recent tasks completed: ')
for i = 1:length(count)
    if count(i)>0
        disp(lcell{count(i),i})
    end
end



    
function [lcell count] = getPerSum(directory) %for each mouse
if nargin<1
    directory = uigetdir();
end
% for each file, find the dprime avg
%write algorithm to create consecutive plots from file names
l = dir(directory);
lcell = cell(40,5);
count = zeros(1,5);
x=10;
for i = 1:length(l)
    if length(l(i).name)>10 %screen non task files
        
         ind = strfind(l(i).name,'ME'); ind = ind+6;
         letter = isletter(l(i).name);
        for j = 1:numel(letter)
            if letter(j)==1
                ind = j+6;
                break
            end
        end
%         ind = strfind(l(i).name,'PB'); ind = ind+6;
        file = l(i).name;
        if ~isletter(file(ind)) && ~strcmp(file(1),'a') %if visual task
            col = 1;
        else
            if ind == strfind(file,'av')
                col = 5; %auditory -> col =2
            elseif strcmp(file(ind),'a') || strcmp(file(1),'a')
                col = 2;
            elseif ind == strfind(file,'va')
                col = 4; %
            elseif strcmp(file(ind),'v')
                col = 3; %remedial vis
            elseif ~isempty(strfind(file,'r'))
                col = 0;
            else
                col = 0;
            end
        end
        if col>0
            count(col) = count(col)+1;
            for j = 1:size(lcell,1)
                if isempty(lcell{j,col})
                    lcell{j,col} = file;
                    break
                end
            end
        end
    end
end

lcell = sortBySession(lcell);

dprimecell = lcell;
% for i = 1:size(dprimecell,2) %session
%     for j = 1:size(dprimecell,1) %file
%         if ~isempty(dprimecell{j,i})
%             dprimecell{j,i} = getDprime([directory '\' dprimecell{j,i}]);
%         end
%     end
% end

function lcell = sortBySession(lcell)
%sort by session number
for i = 1:size(lcell,2) %for session type column
    oldorder= [];
    for j = 1:size(lcell,1) %for each file
        if ~isempty(lcell{j,i})
            if isempty(strfind(lcell{j,i},'d'))
                ind = length(lcell{j,i})-5;
            else
                ind = strfind(lcell{j,i},'d')-2;
            end
            oldorder = [oldorder str2double(lcell{j,i}(ind:ind+1))];
        end
    end
    temp = lcell(1:length(oldorder),i);
    if ~isempty(oldorder)
        for k = 1:length(oldorder)
            lcell{oldorder(k),i}= temp{k};
        end
    end

end

return


% --- Executes during object creation, after setting all properties.
function createfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to createfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in psycht.
function psycht_Callback(hObject, eventdata, handles)
% hObject    handle to psycht (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of psycht
if get(handles.psycht,'value')==1
    set(handles.ipsycht,'visible','on')
    set(handles.ipsycht,'value',0)
else
    set(handles.ipsycht,'visible','off')
    set(handles.ipsycht,'value',0)
end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Start.
function Start_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in htally.
function htally_Callback(hObject, eventdata, handles)
% hObject    handle to htally (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of htally


% --- Executes on button press in ipsycht.
function ipsycht_Callback(hObject, eventdata, handles)
% hObject    handle to ipsycht (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ipsycht


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
water = digitalio('nidaq','dev1');
addline(water,1,'out');

duration = str2double(get(handles.objwatertime,'string')); % set time on in seconds.

finalTime = datenum(clock + [0, 0, 0, 0, 0, duration]); %set turn off time

putvalue(water,1) %turn on valve
while datenum(clock) < finalTime %wait until time to turn off
end
putvalue(water,0) %turn off valve



function objwatertime_Callback(hObject, eventdata, handles)
% hObject    handle to objwatertime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of objwatertime as text
%        str2double(get(hObject,'String')) returns contents of objwatertime as a double


% --- Executes during object creation, after setting all properties.
function objwatertime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to objwatertime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
