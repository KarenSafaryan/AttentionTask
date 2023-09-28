%WRITTEN BY MICKY EINSTEIN - einsteim@ucla.edu
%Main takes arguments from gratinggui.m to run the behavioral task.
%First parameters are initialized, then a while loop is used to run the
%experiment. The code is segmented into various parts denoted by comments.
function main(gratinginfo, waterDispenserinfo, experimentinfo, auditoryinfo,outputfileinfo,outputFile)

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
%     win = Screen('OpenWindow', screenid, 128);
%     Screen('Flip',win);
    % Make sure the GLSL shading language is supported:
    
    screenNumber = screenid;
    
    gratingsize = 2000;
    
    white = WhiteIndex(screenid);
    black = BlackIndex(screenid);
    gray = round((white+black)/2);
    if gray == white, gray=white / 2; end
    
    inc = white - gray;
    
    [w screenRect] = Screen('OpenWindow',screenNumber, gray);
    AssertGLSL;
    p = ceil(1/freq);
    
    fr = freq*2*pi;
    
    texsize = gratingsize/2;
    visiblesize = 2*texsize+1;
    x = meshgrid(-texsize:texsize+p,1);
    
    grating = gray + inc*cos(fr*x);
    gratingtex = Screen('MakeTexture',w,grating);
    
    mask=ones(2*texsize+1, 2*texsize+1, 2) * gray;
    [x,y]=meshgrid(-1*texsize:1*texsize,-1*texsize:1*texsize);
    mask(:, :, 2)=white * (1 - exp(-((x/90).^2)-((y/90).^2)));
    masktex=Screen('MakeTexture', w, mask);
        
%     priorityLevel=MaxPriority(w); %#ok<NASGU>
    
    dstRect=[0 0 visiblesize visiblesize];
    dstRect=CenterRect(dstRect, screenRect);
    % Retrieve video redraw interval for later control of our animation timing:
    ifi=Screen('GetFlipInterval', w);
    waitframes = 1;
    waitduration = waitframes * ifi;
    
    p=1/freq;
    
    shiftperframe = cyclespersecond * p*waitduration;

%***********************ANALOG OUTPUT***************************   
    %set up the analog output
    Aoutput = analogoutput('nidaq', 'dev1');
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
    %predrop=linspace(5,5,length*.005)';
    
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
    data2 = cat(1,expdelay,sin((vstimangle+1)*t)');  %preferred
    if vstimangle+91 < 360
        data3 = cat(1,expdelay,sin((vstimangle+91)*t)'); %non-preferred
    else
        data3 = cat(1,expdelay,sin((vstimangle+91-360)*t)');
    end

    %if off by 1 frame, sync data output
    d1size = size(data1); d2size = size(data2);
    if d1size(1)<d2size(1)
        d2ind = d2size(1);
        data2(d2ind) = [];
        data3(d2ind) =[];
    end
    
    %if miss, create AO data and output for a clearing water pulse
    cleart = cleartime;% .055; %%anything smaller than this, and sometimes water isn't cleared
    clearvstep = linspace(5,5,length*cleart)';
    clearzero = linspace(0,0,length*(.7))';
    zerovstep = linspace(0,0,length*cleart)';
    data5 = cat(1,clearvstep,clearzero);
    data6 = cat(1,zerovstep,clearzero);
    
    clearoutput = analogoutput('nidaq', 'dev1');
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
    dio = digitalio('nidaq','Dev1');
    line = addline(dio,0:1,'out');
    vac = digitalio('nidaq','Dev1');
    line2 = addline(vac,3,'out');
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
    
    AI = analoginput('nidaq','Dev1');
    addchannel(AI,0);

    inputduration = duration; %Duration in seconds
    set(AI,'SampleRate',250)
    ActualRate = get(AI,'SampleRate');
    durationFrames = inputduration*ActualRate; %duration in frames
    set(AI,'SamplesPerTrigger',durationFrames)
    set(AI,'TriggerType','Manual')
    
    trialnumber = 1;
    numtrials = experimentinfo(1);
    
%************************INITIALIZE SOME VARS*******************
    lickSpikearray = [0];
    tallybin = [];
    tally = [0 0 0 0 0];
    tallyp = [0 0 0 0 0];
    hitmiss = [0 0 0];
    crfa = [0 0 0];
    hit = 0;
    miss = 0;
    cr = 0;
    fa = 0;
    mode = 0;
    trials = {};
    figure(5)
    set(figure(5),'Position',[1 58 100 373]);
    panel = uipanel(figure(5),'Title','Trials');
    mTextBox = uicontrol(panel,'style','text');
    set(mTextBox,'String',trials...
    ,'Position',[20 20 100 370],...
    'horizontalalignment','left');
    
    
    
    
%************************EXPERIMENT LOOP************************
    while trialnumber<=numtrials
        tic

        figure(1)
        set(figure(1),'Position',[1 500 554 373])%position on current monitor
        clf(figure(1));
        figure(2)
        set(figure(2),'Position',[101 58 453 373])
        figure(3)
        set(figure(3),'Position',[555 58 453 373])
        figure(4)
        set(figure(4),'Position',[555 500 453 373])

        
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
            else
                orientationKey = mod(round(rand*100),2);
            end

            %if specified in GUI to have all pref or npref
            if pref == 1 || trialnumber<3 && npref==0  %first two trials are pref
                orientationKey = 0;
            elseif npref == 1
                orientationKey = 1;
            end
            
            %Choose which angle grating to output
            if orientationKey == 1 %non-preferred condition
                
                %Distractor task code
                if experimentinfo(5)==1 && experimentinfo(6)==1
                    
                    %counters, no more than 3x in a row
                    if dpref==3
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
                        else
                            putdata(descSound,[nonPrefData nonPrefData])
                            dnpref = dnpref +1;
                            dpref = 0;
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
                        else
                            dnpref = dnpref +1;
                            dpref = 0;
                            putdata(Aoutput,[data4 data3])
                            AnglefromMouse = angle+90;
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
                    if dpref==3
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
                        else
                            putdata(descSound,[nonPrefData nonPrefData])
                            dnpref = dnpref +1;
                            dpref = 0;
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
                        else  %non-preferred
                            putdata(Aoutput,[data1 data3])
                            AnglefromMouse = angle+90;
                            dnpref = dnpref +1;
                            dpref = 0;
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
        
        counter =0;  %for diode square
        gate = 0;   %reset gate
        
        x = toc;
        
        if trialnumber==1
            pause(2)%AVOID INITIAL FLICKER
            vbl = Screen('Flip', w);
        end
        
        %play pretrial auditory cue
        putdata(Soundout, [sounddata sounddata])
        finalTime = datenum(clock + [0, 0, 0, 0, 0, auditoryinfo(3)-x]);
        soundcount = 0;
        while datenum(clock) < finalTime
            if soundcount == 0
                start(Soundout)
                trigger(Soundout)
                putvalue(vac,1);
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
            xoffset = mod(counter*shiftperframe,p);
            
            srcRect = [xoffset 0 xoffset + visiblesize visiblesize];
            % Draw the grating, centered on the screen, with given rotation 'angle',
            % sine grating 'phase' shift and amplitude, rotating via set 'rotateMode'. 
            if experimentinfo(5) == 1.0
                Screen('DrawTexture', w, gratingtex, srcRect, dstRect, AnglefromMouse);
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

            % Show it at next retrace:
            vbl = Screen('Flip', w, vbl + (waitframes - 0.5) * ifi);
%             if datenum(clock)>halfTime && pumpgate ==0
%                 if experimentinfo(6)==1
%                     putvalue(dio,[1 1]);
%                 else
%                     putvalue(dio,[0 1]);
%                 end
%                 pumpgate =1;
%             end
            
        end
%         Screen('FillRect',w,[250 250 250], [0 0 50 50]);
%         Screen('Flip', w);
        %wait(Aoutput,duration+1);
        wait(AI,duration + 1)
        stop(Aoutput);
        if experimentinfo(6)==1
            putvalue(dio,[0 1]);
        end
       
    %*********************ANALYZE AINPUT**************************
        tic
        data = getdata(AI);
        lickSpikes = [];
        lickBool = 0; %Records whether the animal licked or not
        
        %For loop to extract when animal was licking
        %Send this data to lickSpike - 2D array [time voltage]
        for n=1:durationFrames
            temp=data(n);
            if temp>1.7
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
            putvalue(dio,[0 1]);
            if lickBool==0
                putdata(clearoutput,[data5 data6]);
                start(clearoutput)
                trigger(clearoutput)
            end
            while clearTime>datenum(clock)
            end
            putvalue(dio,[0 0]);
            disp('Clear');
        else
            putvalue(dio,[0,0]);
        end
        putvalue(vac,0);
        %determine hit/miss/cr/fa
        if (orientationKey == 0) && (lickBool == 1) %Hit
            performance = strcat(sprintf('%d',trialnumber),' : Hit');
            cat(1,hitmiss,[trialnumber 1 0]);
            hit = hit +1;
            mode =1;
        elseif (orientationKey == 0) && (lickBool == 0) %Miss
            performance = strcat(sprintf('%d',trialnumber),' : Miss!!!');
            cat(1,hitmiss,[trialnumber 0 1]);
            miss = miss + 1;
            mode=2;
        elseif (orientationKey == 1) && (lickBool == 0) %CR
            performance = strcat(sprintf('%d',trialnumber),' : CR');
            cat(1,crfa, [trialnumber 1 0]);
            cr = cr +1;    
            mode=3;
        elseif (orientationKey == 1) && (lickBool == 1) %FA
            performance = strcat(sprintf('%d',trialnumber),' : FA!!!');
            cat(1,crfa, [trialnumber 0 1]);
            fa = fa +1;
            mode=4;
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
                    
                else
                    tallybin = cat(1,tallybin,[trialnumber crp hitp]);
                    dhit = hitp/100; dfa= fap/100;
                end
                if dhit == 1
                    dhit =.99;
                elseif dhit == 0
                    dhit = .01;
                end
                if dfa == 1
                    dfa = .99;
                elseif dfa == 0
                    dfa = .01;
                end
                %dprime = norminv(dhit)-norminv(dfa);
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
                plot(tallyp(:,1),tallyp(:,2),tallyp(:,1),tallyp(:,3),tallyp(:,1),...
                    tallyp(:,4),tallyp(:,1),tallyp(:,5));
                xlabel('Trial Number');
                ylabel('Percentage');
                title('Percentage');
                legend('Hit','Miss','CR','FA','Location','NorthWest');

                figure(4)
                plot(tallybin(:,1), tallybin(:,2),tallybin(:,1),tallybin(:,3));
                legend('CR','Hit','Location','NorthWest');
                xlabel('Trial Number');
                ylabel('Percent')
                s = sprintf('%d', binsize);
                title(strcat('Bin percent - Bin size=',s));

                %Save file after every trial
                if outputfileinfo{1,2}==1
                    mouse = outputfileinfo(3);
                    save(outputFile);   
                end
                
                gate = 2;
            end
            if datenum(clock)>clearend && gate == 2 && mode ==2
                stop(clearoutput)
                disp('yay');
                gate = 0;
            end
        end
        if KbCheck
            trialnumber = numtrials +1;
            break
        end
        trialnumber = trialnumber+1;
    end
    
    
    %Export data to .mat file
    if outputfileinfo{1,2} == 1
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
    clear all
end
    