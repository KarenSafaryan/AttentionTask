%analyzeEyeData

[filename,path1] = uigetfile()
x=10;
load([path1 filename],'tarr')
arr = tarr;
newarr = [];
for i = 1:length(arr)
    if ~arr(i,1)==0
        newarr=[newarr; arr(i,:)];
    else
        break
    end
end


framerate = length(newarr)/newarr(length(newarr),1);

ymax = 29;
ymin = 200;
xmax = 317;
xmin = 90;

xd = xmax - xmin;
yd = ymax - ymin;

c = newarr;
for i = 1:length(c)
    x=c(i,2);
    y=c(i,3);
    xp = (x-xmin)/(xd);
    yp = (y-ymax)/(yd);
    newarr(i,2) = (xp)*130;
    newarr(i,3) = (yp)*130;
end

xlswrite([path1 filename(1:length(filename)-3) 'xls'],newarr)



x=10;