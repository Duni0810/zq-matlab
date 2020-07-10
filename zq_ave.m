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

 size_P = size(Perf);%����һ������������һ��Ԫ���Ǿ����У��ڶ������У�
 M = zeros(1,size_P(1));%����һ��1*10�������

Perf_num = zeros(size(Perf));%����һ��10*10�������

t = size_P(1);%tΪ10
min_mean = zeros(t);%10*10�ľ���
ave = 0;
for i=1:t 
    min_r = min(Perf(:,t));%A(x,y)��ʾ��ά�����x�е�y��λ�õ�Ԫ�أ�xΪ:���ʾ���е��С���ˣ�A(:,1)�ͱ�ʾA�ĵ�1�е�����Ԫ��   1
    ave_vl = mean(mean(Perf(:,t)));%mean�����ֵ  
 
%     min_mean(i) = (min_r+ave)/2;
    min_mean(i) = 0.2*min_r+0.8*ave_vl;        %  ������С��ƽ��֮��ı���
 
    ave = ave + ave_vl;
end

ave = ave/t;

%  ����ƽ��ֵ�Ĳ�ֵ �ľ���
for j=1:t
    for i=1:t        
        Perf_num(i,j) = abs(Perf(i,j) - min_mean(j));%10*10�ľ���=
    end
end

%  ������Сֵ��Ϊ0
% function [Perf_num] = zero_mark(Perf_num)
    for j=1:t
        min_num = min(Perf_num(:,j));%�ҳ���j����С��Ԫ��
        for i=1:t
            if Perf_num(i,j) == min_num
                Perf_num(i,j) = 0;
                break;
            end
        end  
    end
%end
%zero_mark(Perf_num);

%���±�0
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
            Perf_select(i) = Perf(j,i);%�����޸�
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







        


    
