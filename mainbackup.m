%WRITTEN BY MICKY EINSTEIN - einsteim@ucla.edu
%Main takes arguments from gratinggui.m to run the behavioral task.
%First parameters are initialized, then a while loop is used to run the
%experiment. The code is segmented into various parts denoted by comments.
function [temptnum attrig2check] = main(gratinginfo, waterDispenserinfo, experimentinfo, auditoryinfo,outputfileinfo,outputFile,handles)
    escbreak = 0;
    temptnum = 0;
    angle = gratinginfo(1) + 180;
    cycleS = gratinginfo(2);
    spatialf = gratinginfo(3);
    contrast = gratinginfo(4);
    duration = gratinginfo(5);
    sheight = gratinginfo(6);
    sdistance = gratinginfo(7);
    pref = gratinginfo(8);
    npref = gratinginfo(9);
    itiTime = experimentinfo(2);
    punishTime = experimentinfo(3);
    binsize = 30;
    daq = daqhwinfo('nidaq');
    append = outputfileinfo{4};
    
    
    %****************SINE GRATING*******************
    rotateMode = kPsychUseTextureMatrixForRotation;
    
    % Spatial frequency of the grating
    HeigthScreen = sheight; %Size of the screen in cm
    SubjectDistance = sdistance; % Distance of the mouse from the screen in cm
    ScreenSize_Va = 2*atand(HeigthScreen/(2*SubjectDistance)); % Screen size expressed in degrees of visual angle

    % Temporal frequency of the grating
    cyclespersecond = cycleS;

    %Set Contrast
    amplitude = contrast/200;

    %Screen Parameters
    if strcmp(daq.BoardNames{1},'PCI-6229')
        screenid = 1;
    else
        screenid = 2; % This is the monitor on which the grating is projected
    end
    
    x=10;
    
    rect=Screen('Rect', screenid);
    width = rect(RectRight) - rect(RectLeft);
    height = rect(RectBottom)-rect(RectTop);
    res = [width height];
    
    %Calculate actual frequency
    Spatial_freq = spatialf;
    Total_cycles = ScreenSize_Va * Spatial_freq;
    freq = Total_cycles/height; % in cycle per pixel

    % Open a fullscreen onscreen window on that display, choose a background
    % color of 128 = gray, i.e. 50% max intensity:
    win = Screen('OpenWindow', screenid, 156.7);
    Screen('Flip',win);
    % Make sure the GLSL shading language is supported:
    AssertGLSL;

    % Retrieve video redraw interval for later control of our animation timing:
    ifi = Screen('GetFlipInterval', win);
   
    % Phase is the phase shift in degrees (0-360 etc.)applied to the sine grating:
    phase = 0;

    % Compute increment of phase shift per redraw:
    phaseincrement = ceil((cyclespersecond * 360) * ifi);

    % Build a procedural sine grating texture for a grating with a support of
    % res(1) x res(2) pixels and a RGB color offset of 0.5 -- a 50% gray.
    gratingtex = CreateProceduralSineGrating(win, res(1), res(2), [0.5 0.5 0.5 0.0]);

    % Wait for release of all keys on keyboard, then sync us to retrace:
    KbReleaseWait;
%     escapeKey = KbName('ESCAPE');
%     spaceKey = KbName('SPACE');
%     ReturnKey = KbName('RETURN');
%     ClearKey = KbName('C');
%     PauseKey = KbName('P');
%     PauseAsked = 0;
   
%***********************ANALOG OUTPUT***************************   
    %set up the analog output
    Aoutput = analogoutput('nidaq', devset);
    addchannel(Aoutput,0:1);
    set(Aoutput, 'SampleRate', 8000)
    set(Aoutput, 'TriggerType', 'Manual')
    actualRate = get(Aoutput, 'SampleRate');
    length = actualRate*1; %1 second in frames
    
    %intialize params
    expdelay=linspace(0,0,length*.025)'; %account for delay in experimental loop
    delaytime = waterDispenserinfo(2); %time to delay water distribution
    watertime = waterDispenserinfo(1); %time to dispense water
    cleartime = waterDispenserinfo(3);
    v2delay = waterDispenserinfo(4);

    
    %an assortment of zeroes (for delays and resetting the output channel)
    zeroesdelay = linspace(0,0,length*delaytime)'; %delay time before reward
    zerotime = length*.001+(length*(duration - watertime - delaytime));
    zeroes = linspace(0,0,zerotime)'; %end the vstep
    zeroes1 = linspace(0,0,length*watertime)'; %0 vstep for non-preferred (data4)
    zeromiddle = linspace(0,0,length*v2delay)';
    zeroendtime = zerotime - (3*length*v2delay) - (3*(watertime)*length);% -(length*.005);
    zeroend = linspace(0,0,zeroendtime)';
    
    if watertime > 0    %normal case...
        vstep = linspace(5,5,length*watertime)'; %duration of water pulse
        vstep2 = linspace(5,5,length*(watertime))'; %duration of followup water pulse
        data1 = cat(1,expdelay,zeroesdelay,vstep,zeromiddle,vstep2,zeromiddle,vstep2,zeromiddle,vstep2,zeroend);%zeromiddle,vstep2,zeroend); %set up AO pattern for preferred
        data4 = cat(1,expdelay,zeroesdelay,zeroes1,zeroes); %non-preferred
    
    else    %In the case that you don't want to dispense water ever..
        data1 = cat(1,expdelay,zeroesdelay,zeroes); %set up analog output pattern for preferred
        data4 = cat(1,expdelay,zeroesdelay,zeroes); %set up AO for non-preferred
    end
    
    %generate sin wave to indicate orientation -Vstim1
    t = linspace(0,2*pi,(length*delaytime)+(length*watertime)+(length*.001+(length*(3 - watertime - delaytime))));
    vstimangle = angle-180;
    data2 = cat(1,expdelay,sin((vstimangle+1)*duration*t)');  %preferred
    if vstimangle+91 <= 360
        data3 = cat(1,expdelay,sin((vstimangle+91)*duration*t)'); %non-preferred
    else
        data3 = cat(1,expdelay,sin((vstimangle+91-360)*duration*t)');
    end

    %if off by 1 frame, sync data output
    d1size = size(data1); d2size = size(data2);
    if d1size(1)<d2size(1)
        d2ind = d2size(1);
        data2(d2ind) = [];
        data3(d2ind) =[];
    end
    
    data2(size(data2,1)) = 0;
    for i = size(data3,1)-20:size(data3,1)
        data3(i) = 0;
        data2(i) = 0;
    end

    
    %if miss, create AO data and output for a clearing water pulse
    cleart = cleartime;% .055; %%anything smaller than this, and sometimes water isn't cleared
    clearvstep = linspace(5,5,length*cleart)';
    clearzero = linspace(0,0,length*(.7))';
    zerovstep = linspace(0,0,length*cleart)';
    data5 = cat(1,clearvstep,clearzero);
    data6 = cat(1,zerovstep,clearzero);
    
    clearoutput = analogoutput('nidaq', devset);
    addchannel(clearoutput,0:1);
    set(clearoutput, 'SampleRate', 8000)
    set(clearoutput, 'TriggerType', 'Manual')
    
    %Initialize counters to ensure that no stimulus is played more than
    %three times in a row
    avoidpref = 0;
    avoidnpref = 0;
    dpref = 0;
    dnpref = 0;
    
    %**********************Digital out****************************
    
    %dio is for telling winEDR whether the preferred or non-preferred audio
    %stimulus is being played. Preferred=1step, non-pref = steps at refresh
    %rate frequency
    dio = digitalio('nidaq',devset);
    line = addline(dio,0:1,'out');
    
    vac = digitalio('nidaq',devset);
    if strcmp(daq.BoardNames{1},'PCI-6229')
        line2 = addline(vac,3,'out');
    else
        line2 = addline(vac,3,'out');
    end
 
%**************************SOUND CARD*****************************    
    %Soundout is for the auditory cue (beep at beginning)
    Soundout = analogoutput('winsound');
    addchannel(Soundout,1:2);
    set(Soundout,'SampleRate', 40000)
    set(Soundout,'TriggerType', 'Manual')
    actualRate = get(Soundout, 'SampleRate');
    
    %set duration
    durationsound = auditoryinfo(2); %set duration in seconds
    soundlength = durationsound*actualRate; %duration in bins
    
    %generate sound
    u = linspace(0,2*pi,soundlength);
    sounddata = sin(auditoryinfo(1)*u)'; %auditoryinfo(1) is the frequency
    
    %Auditory discrimination task script
    if experimentinfo(6) == 1
        descSound = analogoutput('winsound');
        addchannel(descSound,1:2);
        set(descSound,'SampleRate',40000);
        set(descSound,'TriggerType','Manual');
        
        presentationLength = duration *actualRate;
        freqPref = auditoryinfo(4);
        
        prefTime = linspace(0,2*pi,presentationLength);
        prefData = sin(freqPref*prefTime)';
        nonPrefData = sin(freqPref*2*prefTime)';
    end
    
    
%**************************ANALOG INPUT***************************
    
    AI = analoginput('nidaq',devset);
    addchannel(AI,0);
    inputduration = duration; %Duration in seconds
    set(AI,'SampleRate',250)
    ActualRate = get(AI,'SampleRate');
    durationFrames = inputduration*ActualRate; %duration in frames
    set(AI,'SamplesPerTrigger',durationFrames)
    set(AI,'TriggerType','Manual')
    set(AI,'InputType','SingleEnded')
     
    trialnumber = 1;
    numtrials = experimentinfo(1);
    
%************************INITIALIZE SOME VARS*******************
    lickSpikearray = [0];
    dprimebin = [];
    tallybin = [];
    tally = [0 0 0 0 0];
    tallyp = [0 0 0 0 0];
    hitmiss = [0 0 0];
    crfa = [0 0 0];
    hit = 0;
    miss = 0;
    cr = 0;
    fa = 0;
    hcr = 0; hhit=0;
    mode = 0;
    trials = {};
    figure(5)
    if strcmp(daq.BoardNames{1},'PCI-6229')
        xx = 1;
        yy = 500;
        computerid = 0;
    else
        computerid = 1;
        xx = -1599;
        yy = 680;
    end
        
    set(figure(5),'Position',[xx yy-442 100 373]);
    panel = uipanel(figure(5),'Title','Trials');
    mTextBox = uicontrol(panel,'style','text');
    set(mTextBox,'String',trials...
    ,'Position',[20 20 100 322],...
    'horizontalalignment','left');
    if get(handles.pnp,'value')==1
        pnp = str2double(get(handles.pnpnum,'value'));
    else
        pnp = .5;
    end
    if get(handles.prefbuf,'value')==1
        pbuftrials = str2double(get(handles.prefbufnum,'string'))+str2double(get(handles.nprefbufnum,'string'));
    else
        pbuftrials = 2;
    end

    vdpref = 0;vdnpref = 0; adpref = 0;adnpref =0;
    disttally = [];
    factor = 4; %%for setting trial equality, see just below
    contally = zeros(1,6); %for psycht
    if append == 1
        h = handles;
        load(outputFile,'tally','temptnum','lickSpikes','dprimebin','dprime','tallybin','lickSpikearray','disttally',...
            'hit','miss','cr','fa','contally')
        trialnumber = temptnum;
        handles = h;
    end
    attrig2check = 0; %%this is the check to restart at t170/340.
    
    
%************************EXPERIMENT LOOP************************
    while trialnumber<=numtrials
        tic
        
        figure(1)
        set(figure(1),'Position',[xx yy 554 373])%position on current monitor
        clf(figure(1));
        figure(2)
        set(figure(2),'Position',[xx+100 yy-442 453 373])
        figure(3)
        set(figure(3),'Position',[xx+554 yy-442 453 373])
        figure(4)
        set(figure(4),'Position',[xx+554 yy 453 373])
        if get(handles.htally,'value')>0 && str2num(get(handles.threshold,'string'))<trialnumber
            figure(6)
            set(figure(6),'Position',[xx+554+453 yy 453/2 373/2])
        end
        %Randomly pick preferred or non-preferred stimulus
        %!!!! the code below will pick the correct visual and auditory
        %stimuli for all test conditions: regular or pretrial
                                            %distractor
                                           %task,visual,auditory
      
        if experimentinfo(4) == 0         %REGULAR MODE
            %counters to ensure that the preferred/non-preferred are not
            %displayed more than 3x in a row.
            if avoidpref == 3
                orientationKey = 1;
            elseif avoidnpref == 3
                orientationKey = 0;
            elseif (hit+miss)>(cr+fa+factor)
                orientationKey = 1;
            elseif (cr+fa)>(hit+miss+factor)
                orientationKey = 0;
            else
                if pnp==.5
                    orientationKey = mod(round(rand*100),2);
                else
                    o = round(rand*100);
                    if o<pnp*100
                        orientationKey = 0;
                    else
                        orientationKey = 1;
                    end
                    factor = 100;
                end
            end

            %if specified in GUI to have all pref or npref
            if pref == 1 || trialnumber<=pbuftrials && npref==0  %first two trials are pref
                if trialnumber<=str2double(get(handles.prefbufnum,'string'))...
                        || pref ==1
                    orientationKey = 0;
                    avoidpref = 0;
                else
                    orientationKey = 1;
                    avoidnpref = 0;
                end
            elseif npref == 1
                orientationKey = 1;
            end
            if get(handles.buffer,'value')==1
                av = get(handles.distractor,'value'); %0 = v, 1 = a
                if trialnumber<=str2double(get(handles.threshold,'string'))
                    if av == 0
                        experimentinfo(6) = 0;
                    else
                        experimentinfo(5)= 0;
                    end
                else
                    experimentinfo(5) = 1;
                    experimentinfo(6) = 1;
                end    
            end
            
            %Choose which angle grating to output
            if orientationKey == 1 %non-preferred condition
                
                %Distractor task code
                if experimentinfo(5)==1 && experimentinfo(6)==1
                    
                    %counters, no more than 3x in a row
                    
                    if get(handles.op,'value')>0
                        if orientationKey ==1
                            randdist = 0;
                        else
                            randdist = 1;
                        end
                    elseif dpref==3
                        randdist = 1;
                    elseif dnpref==3
                        randdist = 0;
                    else
                        randdist= mod(round(rand*100),2);
                    end

                    %if 0-->auditory distractor, visual stim determines water
                    %distribution
                    if experimentinfo(7) == 0
                        AnglefromMouse = angle+90;
                        putdata(Aoutput,[data4 data3])%%CUE AOUTPUT
                        
                        %determine what distractor stim should be played
                        if randdist == 0
                            putdata(descSound,[prefData prefData])
                            dpref = dpref + 1;
                            dnpref = 0;
                            adpref = adpref+1;
                        else
                            putdata(descSound,[nonPrefData nonPrefData])
                            dnpref = dnpref +1;
                            dpref = 0;
                            adnpref = adnpref+1;
                        end

                    %visual distractor, auditory stim determines water
                    else
                        putdata(descSound,[nonPrefData,nonPrefData])
                        
                        %determine distractor stim
                        if randdist ==0
                            dpref = dpref + 1;
                            dnpref = 0;
                            putdata(Aoutput,[data4 data2])
                            AnglefromMouse = angle;
                            vdpref =vdpref +1;
                        else
                            dnpref = dnpref +1;
                            dpref = 0;
                            putdata(Aoutput,[data4 data3])
                            AnglefromMouse = angle+90;
                            vdnpref = vdnpref+1;
                        end
                    end

                %Just visual task
                elseif experimentinfo(5) ==1
                    AnglefromMouse = angle+90;
                    putdata(Aoutput,[data4 data3])%%CUE AOUTPUT
                
                %Just Auditory Task
                elseif experimentinfo(6)==1   %just auditory task
                    putdata(descSound,[nonPrefData nonPrefData]);
                    AnglefromMouse = angle+90;
                    putdata(Aoutput,[data4 data4])  
                end

                %counter to ensure stimulus not presented more than 3 times
                %in a row
                avoidnpref = avoidnpref+1;
                avoidpref = 0;
            
            elseif orientationKey == 0 %preferred condition
                
                %this is the distractor task
                if experimentinfo(5)==1 && experimentinfo(6)==1
                    %counters: distractor stim not presented 3x in a row
                    
                    if get(handles.op,'value')>0
                        if orientationKey ==1
                            randdist = 0;
                        else
                            randdist = 1;
                        end
                    elseif dpref==3
                        randdist = 1;
                    elseif dnpref==3
                        randdist = 0;
                    else
                        randdist= mod(round(rand*100),2);
                    end
                    
                    %if 0-->auditory distractor, visual stim determines water
                    %distribution
                    if experimentinfo(7) == 0
                        AnglefromMouse = angle;
                        putdata(Aoutput,[data1 data2])%%CUE AOUTPUT
                        
                        %determine what distractor stim should be shown
                        if randdist == 0
                            putdata(descSound,[prefData prefData])
                            dpref = dpref +1;
                            dnpref = 0;
                            adpref = adpref +1;
                        else
                            putdata(descSound,[nonPrefData nonPrefData])
                            dnpref = dnpref +1;
                            dpref = 0;
                            adnpref = adnpref +1;
                        end

                    %Visual distractor, auditory stim determines water distribution
                    else
                        putdata(descSound,[prefData,prefData])
                        
                        %determine what distractor stim should be shown
                        if randdist ==0  %preferred
                            putdata(Aoutput,[data1 data2])
                            AnglefromMouse = angle;
                            dpref = dpref +1;
                            dnpref = 0;
                            vdpref = vdpref+1;
                        else  %non-preferred
                            putdata(Aoutput,[data1 data3])
                            AnglefromMouse = angle+90;
                            dnpref = dnpref +1;
                            dpref = 0;
                            vdnpref = vdnpref+1;
                        end
                    end

                elseif experimentinfo(5) ==1   %visual task
                    AnglefromMouse = angle;
                    putdata(Aoutput,[data1 data2])%%CUE AOUTPUT
                
                elseif  experimentinfo(6) == 1  %auditory task
                    putdata(descSound,[prefData prefData]);
                    AnglefromMouse = angle;
                    putdata(Aoutput,[data1 data4])%%CUE AOUTPUT
                end

                %counter: stimulus not presented more than 3 times in a row
                avoidpref = avoidpref + 1;
                avoidnpref = 0;
            end
            
        else            %THIS IS PRE-TRIAL MODE, bars at random orientations are shown
            orientationKey = 0;
            if experimentinfo(5) == 1
                t = linspace(0,2*pi,(length*delaytime)+(length*watertime)+(length*.001+(length*(3 - watertime - delaytime))));
                randangle = mod(round(rand*100),12);
                AnglefromMouse = 30*randangle;
                data2 = cat(1,expdelay,sin((AnglefromMouse+1)*t)');
                d2size = size(data2);
                if d1size(1)<d2size(1)
                    d2ind = d2size(1);
                    data2(d2ind) = [];
                end
                putdata(Aoutput,[data1 data2]);
            elseif experimentinfo(6) == 1
                putdata(Aoutput,[data1 data4]);
                randf = mod(round(rand*100),8)+2;
                randfreq = randf*1000;
                prefData = sin(randfreq*prefTime)';
                putdata(descSound,[prefData prefData]);
            end
            
        end
        
        if get(handles.psycht,'value')==1 && experimentinfo(5) ==1
            if trialnumber ==1
                contrasts = [100 75 50 40 30 20];              
            end
            randc = (mod(round(rand*100),6)+1)/200;
            if max(contally)>min(contally)+2
                [~, randc] = min(contally);
            end
            amplitude = contrasts(randc);
            contally(randc) = contally(randc)+1;
        end
        
        
        counter =0;  %for diode square
        gate = 0;   %reset gate
        soundcount = 0;
        putdata(Soundout, [sounddata sounddata])
        if trialnumber==1 || trialnumber == temptnum
             vbl = Screen('Flip', win);
%              start(Soundout)
%              trigger(Soundout)
        end
        x = toc;
        %play pretrial auditory cue
        
        finalTime = datenum(clock + [0, 0, 0, 0, 0, auditoryinfo(3)-x]);
        putvalue(vac,0)
        while datenum(clock) < finalTime
            if soundcount == 0
%                 start(Soundout)
%                 trigger(Soundout)
                soundcount = 1;
            end
        end

        %configure which dio is played to winEDR
        if experimentinfo(5)==1 && experimentinfo(6)==1 && experimentinfo(7) == 0
        
            if randdist == 0 || (experimentinfo(4) == 1 && experimentinfo(6)==1)
                putvalue(dio,[1 0]);
            else
                gate = 1;
            end
               
        elseif orientationKey==0 && experimentinfo(6)==1
            putvalue(dio,[1 0]);
        elseif orientationKey ==1 && experimentinfo(6) ==1
            gate =1;
        end
        
        %Start AInput
        start(AI)
        trigger(AI)
        %Start Aoutput
        start(Aoutput)
        trigger(Aoutput)
        %If auditory task is enabled
        if experimentinfo(6)==1
            start(descSound)
            trigger(descSound)
        end
        
%**************************ANIMATION LOOP**************************
        finalTime = datenum(clock + [0, 0, 0, 0, 0, duration]);
        halfTime = datenum(clock + [0, 0, 0, 0,0, duration-.5]);
        pumpgate = 0;
        while datenum(clock) < finalTime

            % Draw the grating, centered on the screen, with given rotation 'angle',
            % sine grating 'phase' shift and amplitude, rotating via set 'rotateMode'. 
            if experimentinfo(5) == 1.0
                Screen('DrawTexture', win, gratingtex, [], [], AnglefromMouse, [], [], [], [], rotateMode, [phase, freq, amplitude, 0]);
            end

            %Flashing square for diode and pref/non-pref audio digital out
            if (mod(counter,4) == 0) || mod(counter,4) == 1
                if gate ==1
                    putvalue(dio,[1 0]);
                end
            elseif (mod(counter,4) == 2) || mod(counter,4) == 3
                
                if gate==1
                    putvalue(dio,[0 0]);
                end
            end
            counter = counter+1;
            if experimentinfo(5)>0
                Screen('FillRect',win,[0 0 0],[0 0 50 50]);
            else
%                 Screen('FillRect',win,[250 250 250],[0 0 50 50]);
                Screen('FillRect',win,[0 0 0],[0 0 50 50]);
            end
            % Show it at next retrace:
            vbl = Screen('Flip', win, vbl + 0.5 * ifi);
             phase = phase + phaseincrement;
%             if datenum(clock)>halfTime && pumpgate ==0
%                 if experimentinfo(6)==1
%                     putvalue(dio,[1 1]);
%                 else
%                     putvalue(dio,[0 1]);
%                 end
%                 pumpgate =1;
%             end
            
        end
        if experimentinfo(6)==1
            putvalue(dio,[0 1]);
        end
        putvalue(vac,1)
        Screen('FillRect',win,[250 250 250], [0 0 50 50]);
        Screen('Flip', win);
    %*********************ANALYZE AINPUT**************************
        tic
        wait(AI,.5)
        data = getdata(AI);
        lickSpikes = [];
        lickBool = 0; %Records whether the animal licked or not
        
        %For loop to extract when animal was licking
        %Send this data to lickSpike - 2D array [time voltage]
        for n=1:durationFrames
            temp=data(n);
            if temp>1
                sec = n/ActualRate;
                if (sec>2) && (lickBool ==0)
                    lickBool = 1;
                end
                %spikedata = [sec temp];
                %lickSpikes = cat(1, lickSpikes, spikedata);
                lickSpikes = cat(2, sec, lickSpikes);
            end
        end
        
        %if miss remove water droplet
        if (orientationKey == 0) && cleartime>0 %&& lickBool == 0 %Suck up on miss
            clearTime = datenum(clock + [0, 0, 0, 0, 0, (cleartime)]);
            if lickBool==0
                putdata(clearoutput,[data5 data6]);
                start(clearoutput)
                trigger(clearoutput)
            end
            while clearTime>datenum(clock)
            end
            disp('Clear');
        else
        end
%         putvalue(vac,0)
        %determine hit/miss/cr/fa
        if (orientationKey == 0) && (lickBool == 1) %Hit
            performance = strcat(sprintf('%d',trialnumber),' : Hit');
            if experimentinfo(5)==1 && experimentinfo(6) ==1 && randdist==1
                hhit = hhit+1;
            end
            cat(1,hitmiss,[trialnumber 1 0]);
            hit = hit +1;
            mode =1;
        elseif (orientationKey == 0) && (lickBool == 0) %Miss
            performance = strcat(sprintf('%d',trialnumber),' : Miss!!!');
            cat(1,hitmiss,[trialnumber 0 1]);
            miss = miss + 1;
            mode=2;
        elseif (orientationKey == 1) && (lickBool == 0) %CR
            if experimentinfo(5)==1 && experimentinfo(6)==1 && randdist == 0
                performance = strcat(sprintf('%d',trialnumber),' : H-CR');
                hcr = hcr+1;
            else
                performance = strcat(sprintf('%d',trialnumber),' : CR');
            end
            cat(1,crfa, [trialnumber 1 0]);
            cr = cr +1;    
            mode=3;
        elseif (orientationKey == 1) && (lickBool == 1) %FA
            performance = strcat(sprintf('%d',trialnumber),' : FA!!!');
            cat(1,crfa, [trialnumber 0 1]);
            fa = fa +1;
            mode=4;
        end
%         putvalue(vac,0)
        if experimentinfo(7)==0 %aud
            disttally = [disttally; adpref adnpref];
        else
            disttally = [disttally; vdpref vdnpref];
        end
        gate =1;
        x=toc;
        itiTime = experimentinfo(2) - x;
        
        %mode 1,2,3,4 = hit, miss, CR, FA
        if mode == 1 || mode == 3
            finalTime = datenum(clock + [0, 0, 0, 0, 0, itiTime]);
        elseif mode == 2 || mode == 4
            finalTime = datenum(clock + [0, 0, 0, 0, 0, itiTime + punishTime]);
        end
        clearend = datenum(clock + [0, 0, 0, 0, 0, (itiTime-.3)]);
        while datenum(clock) < finalTime
            if gate ==1
                %Create spike raster plot
                figure(1)
                t = lickSpikes;
                plot([t;t],[ones(size(t));zeros(size(t))],'k-')
                xlabel('Time (seconds)')
                title(strcat('trial ',num2str(trialnumber)))
                axis([0 duration 0 1])
                lickSpiketracker = {lickSpikes};
                lickSpikearray = cat(2,lickSpikearray,lickSpiketracker);

                %Create plot to track progress realtime
                tally = cat(1,tally,[trialnumber hit miss cr fa]);
                hitp = (hit/(hit+miss))*100;
                missp = (miss/(hit+miss))*100;
                crp = (cr/(cr+fa))*100;
                fap = (fa/(cr+fa))*100;
                tallyp = cat(1,tallyp,[trialnumber hitp missp crp fap]);

                if trialnumber>binsize && pref == 0;
                    hitbin = tally(trialnumber,2) - tally(trialnumber-binsize,2);
                    missbin = tally(trialnumber,3)- tally(trialnumber-binsize,3);
                    crs = tally(trialnumber,4) - tally(trialnumber - binsize,4);
                    fas = tally(trialnumber,5) - tally(trialnumber - binsize,5);
                    crsp = (crs/(crs+fas))*100;
                    hitsp = (hitbin/(hitbin+missbin))*100;
                    tallybin = cat(1,tallybin,[trialnumber crsp hitsp]);
                    dhit = hitsp/100; dfa = (100-crsp)/100;
                    if dhit == 1, dhit = .99; elseif dhit ==0, dhit = .01; end; 
                    if dfa == 0, dfa = .01; elseif dfa == 1, dfa = .99; end;
                    dprime = norminv(dhit)-norminv(dfa);
                    dprimebin = cat(1,dprimebin,[trialnumber dprime]);
                else
                    tallybin = cat(1,tallybin,[trialnumber crp hitp]);
                    dhit = hitp/100; dfa= fap/100;
                    if dhit == 1, dhit = .99; elseif dhit ==0, dhit = .01; end; 
                    if dfa == 0, dfa = .01; elseif dfa == 1, dfa = .99; end;
                    dprime = norminv(dhit)-norminv(dfa);
                    dprimebin = cat(1,dprimebin,[trialnumber dprime]);
                end
%                 putvalue(vac,0)
                trials = cat(1,performance,trials);
                set(mTextBox,'String',trials);
                
                %Create figures for realtime data tracking
                figure(2)
                plot(tally(:,1),tally(:,2),tally(:,1),tally(:,3),tally(:,1), tally(:,4),...
                    tally(:,1),tally(:,5));
                title('Totals');
                xlabel('Trial Number');
                ylabel('Sum');
                legend('Hit','Miss','CR','FA','Location','NorthWest');

                figure(3)
%                 plot(tallyp(:,1),tallyp(:,2),tallyp(:,1),tallyp(:,3),tallyp(:,1),...
%                     tallyp(:,4),tallyp(:,1),tallyp(:,5));
                plot(dprimebin(:,1),dprimebin(:,2));
                xlabel('Trial Number');
                ylabel('Dprime');
                title('Dprimebin');
                legend('Dprime','Location','NorthWest');
                
                    putvalue(vac,0);
              
                figure(4)
                plot(tallybin(:,1), tallybin(:,2),tallybin(:,1),tallybin(:,3));
                legend('CR','Hit','Location','NorthWest');
                xlabel('Trial Number');
                ylabel('Percent')
                s = sprintf('%d', binsize);
                title(strcat('Bin percent - Bin size=',s));
                msgstr = lastwarn;
                if ~isempty(msgstr) && computerid == 1
                    temptnum =trialnumber+1;
                    escbreak = 1;
                    trialnumber = numtrials +1;
                    disp('Matlab failed!! Restart Matlab and the task. Thanks!')
                    return
                end
                buffer = str2double(get(handles.threshold,'string'));
                if get(handles.htally,'value')>0 && buffer<trialnumber
                    figure(6)
                    htallydata = [hit-tally(buffer,2)-hhit,hhit,cr-tally(buffer,4)-hcr,hcr];
                    bar(htallydata);
                    Labels = {'hit', 'h-hit', 'cr', 'h-cr'};
                    set(gca, 'XTick', 1:4, 'XTickLabel', Labels);
                    ylim([0,max(htallydata) *1.2])
                    for i = 1:numel(htallydata)
                        text(i-.1,htallydata(i) +.4,num2str(htallydata(i)),...
                            'VerticalAlignment','top','Fontsize',8);
                    end
                end
                %Save file after every trial
                if outputfileinfo{1,2}==1
                    mouse = outputfileinfo(3);
                    save(outputFile);   
                end
%                 putvalue(vac,0);
                if (trialnumber == 170 || trialnumber == 170*2) && ~isempty(strfind(outputFile,'Attentionrig-2'))...
                        && experimentinfo(5)>0 %%visual task
                    attrig2check =1;
                end
                gate = 2;
            end
            if datenum(clock)>clearend && gate == 2 && mode ==2
%                 stop(clearoutput)
%                 disp('yay');
                gate = 0;
            end
            if KbCheck || attrig2check == 1
                temptnum =trialnumber+1;
                escbreak = 1;
                trialnumber = numtrials +1;
                break
            end
            putvalue(vac,0)
        end
        
        putvalue(vac,0)
        trialnumber = trialnumber+1;
    end
    
        
    
    %Export data to .mat file
    if outputfileinfo{1,2} == 1
        trialnumber = temptnum;
        mouse = outputfileinfo(3);
        save(outputFile);
    end
    Screen('CloseAll');
    delete(AI)
    delete(Aoutput)
    delete(clearoutput)
    delete(Soundout)
    if experimentinfo(6)==1
        delete(descSound)
    end
    delete(dio)
    putvalue(vac,0)
    if attrig2check==0 %%if you stopped the task manually
        s = input('Close all charts? 1 or 0: ');
        if s==1
            close(1);close(2);close(3);close(4);close(5);
            if get(handles.htally,'value')>0
                close(6);
            end
        end
    end
    if escbreak == 1
        return
    else
        temptnum = trialnumber;
        return
    end
    clear all
end

    