clc
clear all

symbol   = 'bo';  % 打点颜色符号(b. 蓝点； bo蓝圈)
symbol1  = 'wo';  % 打点颜色符号(w. 白点； wo白圈)
   
dt = 1; % 采样步距
v  = 1; % 速度


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

%场景的范围       
xmin = 0;xmax = width * 8 + 20;ymin = 0;ymax = width * 8 + 20; 
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


% 给飞机实时编号，行扫描 做起飞处理
for i = 1: 8
	for j = 1: 8 
        % start 坐标
        if array_f(i, j) == 1
            % 做矩阵点位置应该实际场景
            [id_sta_addr(index, 1), id_sta_addr(index, 2)] = calc(i, j, width);
            index = index + 1;            
        end
	end
end



%计算 各个无人机起飞运行时间
 for i=1:19
	id_tm(i)=sqrt((id_sta_addr(i, 1)-id_sto_addr(i, 1))^2 + (id_sta_addr(i, 2)-id_sto_addr(i, 2))^2) / v; %计算这个 Step 的移动时间
 end

max_tm = max(id_tm);
% id scan
 for t=0:dt:max_tm
     
    for index = 1:19
        % 单点移动
        [id_cur_addr(index, 1), id_cur_addr(index, 2)] = move(index,       ...
                                                              id_sto_addr, ...
                                                              id_sta_addr, ...
                                                              id_cur_addr, ...
                                                              t,           ...
                                                              id_tm,       ...
                                                              v);

    end
    pause(0.1);
 end


 % 做位置调整到指定位置
for i=1:19
    plot(id_cur_addr(i, 1), id_cur_addr(i, 2), symbol1);
    plot(id_sta_addr(i, 1), id_sta_addr(i, 2), symbol);
end


% 起飞完成 等待三秒做队形变化
pause(3);



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
            % 做矩阵点位置应该实际场景
            [id_sta_addr(index, 1), id_sta_addr(index, 2)] = calc(i, j, width);
            % 安置飞机
            %plot(id_sta_addr(index, 1), id_sta_addr(index, 2), 'bo');
            index = index + 1;            
        end
	end
end
    
    

%%算法替代部分 这里只是模型验证
% 测试部分%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

id_sto_addr = id_sta_addr;

% 表示 ID 7的点 移动到(2,2) 的位置
[id_sto_addr(7, 1) , id_sto_addr( 7, 2)] = calc(2, 2, width);
[id_sto_addr(8, 1) , id_sto_addr( 8, 2)] = calc(3, 5, width);
[id_sto_addr(9, 1) , id_sto_addr( 9, 2)] = calc(2, 6, width);
[id_sto_addr(10, 1), id_sto_addr(10, 2)] = calc(4, 4, width);
[id_sto_addr(11, 1), id_sto_addr(11, 2)] = calc(5, 4, width);
[id_sto_addr(12, 1), id_sto_addr(12, 2)] = calc(8, 5, width);
[id_sto_addr(13, 1), id_sto_addr(13, 2)] = calc(7, 6, width);
[id_sto_addr(14, 1), id_sto_addr(14, 2)] = calc(8, 6, width);
[id_sto_addr(16, 1), id_sto_addr(16, 2)] = calc(8, 1, width);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%计算 各个无人机运行时间
 for i=1:19
	id_tm(i)=sqrt((id_sto_addr(i, 1)-id_sta_addr(i, 1))^2 + (id_sto_addr(i, 2)-id_sta_addr(i, 2))^2) / v; %计算这个 Step 的移动时间
 end

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
        

fprintf('在任意两无人机距离为 %d 个单位时， 最大运行时间为 %f \n', width, ...
                                                                 max_tm)





