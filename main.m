clc
clear all

symbol   = 'bo';  % 打点颜色符号(b. 蓝点； bo蓝圈)
symbol1  = 'go';  % 打点颜色符号(w. 白点； wo白圈)
    
% 两点之间距离
width = 10;

% 做 8*8 矩阵 19 个点
array_f = [0 1 1 1 1 1 1 0;
           0 0 1 0 0 0 0 0;
           0 0 1 0 0 1 0 0;
           0 0 1 1 1 1 0 0;
           0 0 0 0 0 1 0 0;
           0 0 1 0 0 0 0 0;
           0 0 1 0 0 0 0 0;
           0 1 1 1 0 0 0 0];
       

array_z = [0 1 1 1 1 1 1 0;
           0 1 0 0 0 1 0 0;
           0 0 0 0 1 0 0 0;
           0 0 0 1 0 0 0 0;
           0 0 0 1 0 0 0 0;
           0 0 1 0 0 0 0 0;
           0 0 0 0 0 1 0 0;
           1 1 1 1 1 1 0 0];

       
xmin = 0;xmax = 100;ymin = 0;ymax = 100; %场景的范围
axis([xmin xmax ymin ymax]); %设定坐标范围
figure(1);
hold on ; %保留绘图内容

% 绘制初始图像
% for i = 1: 8
%    for j = 1: 8 
%        if array_f(i, j) == 1
%            plot((j - 1) * width + 10, 80 - (i - 1) * width + 10, 'bo');
%        end
% 
%    end
% end

id_sta_addr = zeros(19,2);
id_sto_addr = zeros(19,2);
id_cur_addr = zeros(19,2);
id_tm = zeros(19, 1);         %保存移动时间
index = 1;

% 给飞机实时编号，行扫描
for i = 1: 8
   for j = 1: 8 
       % start 坐标
       if array_f(i, j) == 1
            id_sta_addr(index, 1) = (j - 1) * width + 10 ;
            id_sta_addr(index, 2) = 80 - (i - 1) * width + 10;
            index = index + 1;
            % 打点
            plot((j - 1) * width + 10, 80 - (i - 1) * width + 10, 'bo');
       end
   end
end

dt = 1;
v  = 1;

%xa = 10; ya = 10; xb = 30; yb = 30;


% 测试部分
 for i=1:19
    j = 1;
	id_sto_addr(i, 1) = id_sta_addr(i, 1);
    id_sto_addr(i, 2) = id_sta_addr(i, 2);
    j = j + 1;
 end
 
%  7  (1, 2) -> (2, 2)
id_sto_addr(7, 1) = (2 - 1) * width + 10;
id_sto_addr(7, 2) = 80 - (2 - 1) * width + 10;

% 8   (3, 3) -> (3, 5)
id_sto_addr(8, 1) = (5 - 1) * width + 10;
id_sto_addr(8, 2) = 80 - (3 - 1) * width + 10;

% 9   (3, 6) -> (2, 6)
id_sto_addr(9, 1) = (6 - 1) * width + 10;
id_sto_addr(9, 2) = 80 - (2 - 1) * width + 10;

% 10   (4, 3) -> (4, 4)
id_sto_addr(10, 1) = (4 - 1) * width + 10;
id_sto_addr(10, 2) = 80 - (4 - 1) * width + 10;

% 11   (4, 4) -> (5, 4)
id_sto_addr(11, 1) = (4 - 1) * width + 10;
id_sto_addr(11, 2) = 80 - (5 - 1) * width + 10;

% 12   (4, 5) -> (8, 5)
id_sto_addr(12, 1) = (5 - 1) * width + 10;
id_sto_addr(12, 2) = 80 - (8 - 1) * width + 10;

% 13   (4, 6) -> (7, 6)
id_sto_addr(13, 1) = (6 - 1) * width + 10;
id_sto_addr(13, 2) = 80 - (7 - 1) * width + 10;

% 14   (5, 6) -> (8, 6)
id_sto_addr(14, 1) = (6 - 1) * width + 10;
id_sto_addr(14, 2) = 80 - (8 - 1) * width + 10;

% 16   (7, 3) -> (8, 1)
id_sto_addr(16, 1) = (1 - 1) * width + 10;
id_sto_addr(16, 2) = 80 - (8 - 1) * width + 10;



 for i=1:19
	id_tm(i)=sqrt((id_sto_addr(i, 1)-id_sta_addr(i, 1))^2 + (id_sto_addr(i, 2)-id_sta_addr(i, 2))^2) / v; %计算这个 Step 的移动时间
 end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%tm=sqrt((xb-xa)^2 + (yb-ya)^2) / v; %计算这个 Step 的移动时间
 
% 保留前点坐标
%pre_x = 0;
%pre_y = 0;

max_tm = max(id_tm);
% id scan
 for t=0:dt:max_tm
     
    for index = 1:19
        % 单点移动
        [id_cur_addr(index, 1), id_cur_addr(index, 2)] = move(index,       ...
                                                              id_sta_addr, ...
                                                              id_sto_addr, ...
                                                              id_cur_addr, ...
                                                              t,           ...
                                                              id_tm,       ...
                                                              v);

    end
    pause(0.1);
end
        
% t = move(10, 10, 30, 30, 1, 1);
% t






