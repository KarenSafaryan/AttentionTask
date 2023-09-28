function dispenseWater(watertime,delaytime)
    %watertime is seconds to dispense water
    %delaytime is time before water is dispensed
    if nargin<1
        watertime = [];
    end
    if isempty(watertime)
        watertime = 2;
    end
    
    if nargin<2
        delaytime = [];
    end
    if isempty(delaytime)
        delaytime = 1;
    end
    
    watertime2 = 0;
    
    %set up the analog output
    Aoutput = analogoutput('nidaq', 'dev1');
    addchannel(Aoutput,0);
    set(Aoutput, 'SampleRate', 8000)
    set(Aoutput, 'TriggerType', 'Manual')
    
    actualRate = get(Aoutput, 'SampleRate');
    
    %set up vac
    vac = digitalio('nidaq','dev1');
    addline(vac,0,'out');
    
    
    %set duration/length of step
    duration = 1; %set duration in seconds
    length = actualRate*duration;
    
    %generate 5v step for duration
    zeroesdelay = linspace(0,0,length*delaytime)'; %delay time before reward
    zeroes = linspace(0,0,length)';
    vstep = linspace(5,5,length*watertime)'; %duration of water pulse
    vstep2 = linspace(5,5,length*watertime2)'; %duration of second water pulse
    data1 = cat(1,zeroesdelay,vstep,zeroes,vstep2,zeroes); 
    
    %queue output
    putdata(Aoutput,data1)
    
    %start output
    disp('Output start')
    putvalue(vac,1);
    start(Aoutput)
    trigger(Aoutput)
    wait(Aoutput,31)
    stop(Aoutput)
    disp('Output stop')
    delete(Aoutput)
    clear Aoutput
    
    putvalue(vac,0);
    
end