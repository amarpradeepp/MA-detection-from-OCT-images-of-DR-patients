clear all
close all
img=imread('3.jpg');
img_gray=rgb2gray(img);
[r c]=size(img_gray);
gaussian_filt=fspecial('gaussian',[3 3],1.5);
img_filt=imfilter(img_gray,gaussian_filt,'full');
figure, imshow(img_gray);
figure, imshow(img_filt);
img_canny_edge=edge(img_filt,'canny');
figure, imshow(img_canny_edge);
se1=[0 1 0;1 1 1;0 1 0];
se2=[1 0 0;0 1 0; 0 0 1];
se3=[0 0 1;0 1 0;1 0 0];
se4=strel('disk',1);
%img_dilate=imdilate(img_canny_edge,se2);
img_dilate=imdilate(img_canny_edge,se4);
img_dilate=imdilate(img_dilate,se4);
figure,imshow(img_dilate);
img_erode=imerode(img_dilate,se1);
%img_erode=imerode(img_erode,se1);
figure,imshow(img_erode);
CC = bwconncomp(img_erode);
        numPixels = cellfun(@numel,CC.PixelIdxList);
        [biggest,idx] = max(numPixels);
        img_dilate(CC.PixelIdxList{idx}) = 0;
        figure, imshow(img_dilate);  
             
% small_ele_removed=bwareaopen(img_dilate,75);
% figure,imshow(small_ele_removed);

 
% [r,c]=size(img);
% for i=1:r
%     for j=1:c
%         if (Area1(k)<=200)
%             img(i,j)=0;
%         end
%     end
% end
img_res8=bwareaopen(img_dilate,75,8);
figure, imshow(img_res8);
img_res4=bwareaopen(img_dilate,32,4);
sub_res1=imsubtract(img_res8,img_res4);
figure, imshow(sub_res1);
% mask = false(size(sub_res1));
% mask(93:155,36:137) = true;
% visboundaries(mask,'Color','b');
%  bw = activecontour(sub_res1, mask, 200, 'edge');
%  
%  visboundaries(bw,'Color','r');
% title('Blue - Initial Contour, Red - Final Contour');
%maxl=
% [r c]=find(l==max(max(l)));

res1=imfill(sub_res1);
figure,imshow(res1);
res1=imerode(res1,se4);
figure,imshow(res1);
% classes = imread('https://blogs.mathworks.com/images/steve/2011/freehand_segment.mat');
l=bwlabel(res1);
s = regionprops(l,'Centroid');
res1=logical(res1);
final=zeros(size(res1));
 for k = 1:numel(s)
       obj=(l==k);
       Area1(k) = regionprops(obj,'Area');
%       figure,imshow(obj)
       if(Area1(k).Area<500)
%            Area1(k).Area=0;  
        final=logical(imsubtract(res1,obj));
        res1=final;
       end
 end
 final=imresize(final,[r c]);
 figure,imshow(final);
 [rows,columns] = size(final);
ctr= 0;
for i = 1 : rows
    for j = 1 : columns 
        if final(i,j) == 1
            ctr = ctr + 1;
        end 
    end
end
fprintf('The size of the area affected by microaneurysms in this retina is : %d \n',ctr);
%  final=imsubtract(res1,Area1);
final=im2uint8(final);
figure, imshow(imadd(img_gray,final)),title('final');