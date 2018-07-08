   
function [img]=maxConnectDomain(I)  
%get the max connected domain of the images
if length(size(I))>2  
    I = rgb2gray(I);  
end  
if ~islogical(I)  
    imBw = im2bw(I);                          
else  
    imBw = I;  
end  
imBw = im2bw(I);                        % 
imLabel = bwlabel(imBw);                %
stats = regionprops(imLabel,'Area');    %  
area = cat(1,stats.Area);  
index = find(area == max(area));        %  
img = ismember(imLabel,index);          %

