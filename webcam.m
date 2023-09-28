[filename p] = uigetfile('*.avi');
reader = VideoReader([p filename]);

vid = read(reader);
% center = cell(1,size(vid,4));
% xind = zeros(size(vid,4),1);
% yind = zeros(size(vid,4),1);
% 
% for i = 1:size(vid,4)
%     center{i} = findpupil(vid(:,:,:,i));
%     xind(i) = center{i}(1);
%     yind(i) = center{i}(2);
% end
% 
% figure
% plot(xind,yind)
% axis([0 size(vid,2) 0 size(vid,1)])
