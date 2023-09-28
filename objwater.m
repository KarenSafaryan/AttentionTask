water = digitalio('nidaq','dev1');
addline(water,1,'out');

duration = .1; % set time on in seconds.

finalTime = datenum(clock + [0, 0, 0, 0, 0, duration]); %set turn off time

putvalue(water,1) %turn on valve
while datenum(clock) < finalTime %wait until time to turn off
end
putvalue(water,0) %turn off valve
