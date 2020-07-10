function [M,Perf_select,cost,Mean_square_erro] = zq_ave(Perf)
%Perf =  [ 1.0000    1.4142    4.1231    2.2361    2.8284    3.6056    4.4721    5.0000    4.1231    5.0990;
%    3.0000    3.1623    1.0000    3.6056    2.8284    2.2361    2.0000    3.0000    5.0000    5.8310;
%    2.2361    2.0000    1.0000    2.2361    1.4142    1.0000    1.4142    2.2361    3.6056    4.4721;
%    2.2361    1.4142    2.2361    1.0000         0        1.0000    2.0000    2.2361    2.2361    3.1623;
%    3.1623    2.2361    2.8284    1.4142    1.0000    1.4142    2.2361    2.0000    1.4142    2.2361;
%    4.0000    3.0000    4.2426    2.0000    2.2361    2.8284    3.6056    3.1623         0        1.0000;
 %   5.8310    5.0000    4.0000    4.2426    3.6056    3.1623    3.0000    2.0000    3.1623    3.0000;
%    6.3246    5.3852    7.0711    4.4721    5.0000    5.6569    6.4031    5.8310    2.8284    2.2361;
%    6.3246    5.3852    5.0990    4.4721    4.1231    4.0000    4.1231    3.1623    2.8284    2.2361;
%    6.7082    5.8310    5.0000    5.0000    4.4721    4.1231    4.0000    3.0000    3.6056    3.1623;

 %    ];

 size_P = size(Perf);%返回一个行向量，第一个元素是矩阵行，第二个是列，
 M = zeros(1,size_P(1));%返回一个1*10的零矩阵

Perf_num = zeros(size(Perf));%返回一个10*10的零矩阵

t = size_P(1);%t为10
min_mean = zeros(t);%10*10的矩阵
ave = 0;
for i=1:t 
    min_r = min(Perf(:,t));%A(x,y)表示二维矩阵第x行第y列位置的元素，x为:则表示所有的行。因此，A(:,1)就表示A的第1列的所有元素   1
    ave_vl = mean(mean(Perf(:,t)));%mean是求均值  
 
%     min_mean(i) = (min_r+ave)/2;
    min_mean(i) = 0.2*min_r+0.8*ave_vl;        %  调节最小、平均之间的比例
 
    ave = ave + ave_vl;
end

ave = ave/t;

%  求与平均值的差值 的矩阵
for j=1:t
    for i=1:t        
        Perf_num(i,j) = abs(Perf(i,j) - min_mean(j));%10*10的矩阵=
    end
end

%  将列最小值变为0
% function [Perf_num] = zero_mark(Perf_num)
    for j=1:t
        min_num = min(Perf_num(:,j));%找出第j列最小的元素
        for i=1:t
            if Perf_num(i,j) == min_num
                Perf_num(i,j) = 0;
                break;
            end
        end  
    end
%end
%zero_mark(Perf_num);

%重新标0
zeros_mark_num = zeros(1,10);
n = 1;
for i=1:t
    for j=1:t
        if Perf_num(i,j) == 0
            if find(zeros_mark_num == i)
                Perf_num = zero_mark(Perf_num,Perf,ave);
            else
                zeros_mark_num(n) = i;
                n = n+1;
            end

        end
    end
end          

for i=1:t
    for j=1:t
        if Perf_num(i,j) == 0
            if find(zeros_mark_num == i)
                Perf_num = zero_mark(Perf_num,Perf,ave);
            else
                zeros_mark_num(n) = i;
                n = n+1;
            end

        end
    end
end  


cost = 0;
Mean_square_erro = 0;
Perf_select = zeros(1,t);

for i=1:t
    for j=1:t
        if Perf_num(i,j)==0
            M(i) = j;
            Perf_select(i) = Perf(j,i);%做了修改
            cost = cost + Perf(j,i);
        end
    end
end

mean_Perf_select = mean(Perf_select)
for i = 1:t
    Mean_square_erro = Mean_square_erro + (Perf_select(i)-mean_Perf_select)^2;
end
Mean_square_erro = Mean_square_erro/t;
  
end







        


    
