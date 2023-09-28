function calibrateBT()
calcell = zeros(2,3);

for i = 1:size(calcell,2)
    pause(1)
    
    while ~KbCheck
    end
    
    
    
    
    
    
    [calcell(1,i) calcell(2,i)] = GetMouse(0);
    disp(i)
    
    
    
end

for i = 1:2
    x1=calcell(1,i);y1=calcell(2,i);
    x2=calcell(1,i+1);y2=calcell(2,i+1);
    dx = x1-x2;dy = y1-y2;
    dt = abs(dx+dy*1i);
    disp(dt)
end