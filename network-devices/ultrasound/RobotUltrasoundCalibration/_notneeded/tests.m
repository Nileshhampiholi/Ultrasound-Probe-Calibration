I = imread('D:\Users\stefa\anderes\Dropbox\Uni\Thesis\_Code\Ultraschall\UltraschallImages\_images\2\fileoutpos.txt_18.jpg'); % http://en.wikipedia.org/wiki/File:Canadian_maple_leaf_2.jpg

%I = imcomplement(I);
I = medfilt2(I, [8 8]);
I = I(1:440,:);
[rows, columns, numberOfColorBands] = size(I);
imshow(I);

surf(double(I),'EdgeColor','none');
colormap jet
axis([0 columns 0 rows min(double(I(:))) max(double(I(:)))])

%%
if isempty(find(without == 5,1))
    disp('Moin')
end

%%

C = [1,2;3,3;2,5;5,1]
C = sortrows(C,2)
C(1:2,:) = sortrows(C(1:2,:),1)