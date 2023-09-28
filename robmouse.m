function robmouse()
aout = analogoutput('mcc',1);
addchannel(aout,0);

import java.awt.*;
import java.awt.event.*;
rob=Robot;
rob.mouseMove(500,500)
dx = 0;dy = 0;
putdata(aout,[0])
set(aout,'TriggerType','Manual')
% set(aout,'TriggerFcn',cb(aout,dx,dy))
start(aout)
n = 0;
while ~KbCheck
    pause(.1)
    [x,y] = GetMouse(0);
    dx = x-500; dy = y-500;
    %disp([num2str(dx) ' ' num2str(dy)])
    rob.mouseMove(500,500);
%     putdata(aout,5*sqrt(dx^2+dy^2))
    putdata(aout,5*abs(dx+dy*1i))
%     trigger(aout)
    disp(20*abs(dx+dy*1i))
end
stop(aout)
end
function cb(aout,dx,dy)
    putdata(aout,[dx*5 dy*5])
    start(aout)
end

function calibrateBT()
calcell = zeros(2,3);

for i = 1:size(calcell,2)
    wait(KbCheck)
    [calcell(1,i) calcell(2,i)] = GetMouse(0);
end

for i = 1:2
    x1=calcell(1,i);y1=calcell(2,i);
    x2=calcell(1,i+1);y2=calcell(2,i+1);
    dx = x1-x2;dy = y1-y2;
    dt = abs(dx+dy*1i);
    disp(dt)
end
    


