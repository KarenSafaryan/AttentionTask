escbreak = 0;
temptnum = 0;

% pref = gratinginfo(8);
% npref = gratinginfo(9);
binsize = 30;
daq = daqhwinfo('nidaq');
% append = outputfileinfo{4};

% Grating info
gratinginfo(1) = 45;
gratinginfo(2) = 2;
gratinginfo(3) = 0.04;
gratinginfo(4) = 100;
gratinginfo(5) = 3;
gratinginfo(6) = 30;
gratinginfo(7) = 30;

% Experiment info
experimentinfo(1) = 500;
experimentinfo(2) = 3;
experimentinfo(3) = 6.5;

% Outputfile info

% Water Dispenser Info
%intialize params
expdelay=linspace(0,0,length*.025)';    %account for delay in experimental loop
% delaytime = waterDispenserinfo(2);      %time to delay water distribution
% watertime = waterDispenserinfo(1);      %time to dispense water
% cleartime = waterDispenserinfo(3);
% v2delay = waterDispenserinfo(4);

waterDispenserinfo(1) = 0.0145;         % watertime
waterDispenserinfo(2) = 1.95;           % delaytime
waterDispenserinfo(3) = 0;              % cleartime
waterDispenserinfo(4) = 0.05;           % delaytime

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

opto = digitalio('nidaq',devset);
line4 = addline(opto,2,'out');
