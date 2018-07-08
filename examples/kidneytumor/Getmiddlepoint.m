function array = Getmiddelpoint( A )
%x y为中心，d分别为中心到四边的距离
% Files = dir('d:\train_label\*.bmp');
%  A=imread(strcat('d:\train_label\',Files(1).name));
%%A为二值图，且病灶由白色填充
[row col]=size(A);
f=find(A>0);%标注为病灶的点
m=size(f,1);
for i=1:m
    temp(i,2)=floor(f(i)/row);
    temp(i,1)=f(i)-temp(i,2)*row;
end
x=single(round(mean(temp(:,1))));
y=single(round(mean(temp(:,2))));
d_1=single(round(y-min(temp(:,2))));%distance to leftedge
d_2=single(round(max(temp(:,2))-y));%distance to rightedge
d_3=single(round(x-min(temp(:,1))));%distance to topedge
d_4=single(round(max(temp(:,1))-x));%distance to lowedge
 array=[x y d_1 d_2 d_3 d_4];
end

