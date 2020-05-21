

% 该程序用到
%  main.m :
%            主函数  

%  calc.m  ：
%            位置计算函数，实际上是将矩阵的点绘制到固定坐标位置
%        例如矩阵 array_f 中第一行第二列中的1 表示一架无人机。在模型场景中
%        他的位置实际上是(90, 30)，这个计算过程就是通过这个函数计算得到，知道他的功能就行。
%
%  move.m :
%            位置移动函数，该函数主要功能是做点的位置移动，不需要理会。
%
% my_function.m: 
%           算法函数，需要完成的算法函数，具体要完成什么在函数中有说明

% 


clc
clear all

symbol   = 'bo';  % 打点颜色符号(b. 蓝点； bo蓝圈)
symbol1  = 'wo';  % 打点颜色符号(w. 白点； wo白圈)
   
dt = 1; % 采样步距
v  = 1; % 速度


% 设置两点之间距离
width = 10;

% 做 8*8 矩阵 19 个点  字符：F  初始矩阵
array_f = [0 1 1 1 1 1 1 0;
           0 0 1 0 0 0 0 0;
           0 0 1 0 0 1 0 0;
           0 0 1 1 1 1 0 0;
           0 0 0 0 0 1 0 0;
           0 0 1 0 0 0 0 0;
           0 0 1 0 0 0 0 0;
           0 1 1 1 0 0 0 0];
       
% 做 8*8 矩阵 19 个点  字符：Z  目标矩阵
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


% 创建一个空的坐标图
axis([xmin xmax ymin ymax]); %设定坐标范围
figure(1);
hold on ; %保留绘图内容



% 初始化矩阵 

 %  该矩阵用于保存开始坐标位置 实际上是一个二维矩阵，矩阵的索引号就是 ID 号 第一位元素为 x 轴坐标，第二位元素为 y 轴坐标
 %   例如： id_sta_addr(7, 1) 表示 ID7 的无人机 X 轴坐标位置； 同理 id_sta_addr(7, 2)表示 ID7 的无人机 Y 轴坐标位置
id_sta_addr = zeros(19,2);  

%  该矩阵用于保存结束坐标位置
id_sto_addr = zeros(19,2);

%  该矩阵用于无人机在飞行过程中的临时坐标信息
id_cur_addr = zeros(19,2);

% 该矩阵用于保存所有无人机的最终要飞行的时间 是一个一维数组， 同上索引和就是ID号
% 例如 id_tm(1) 表示 ID1的无人机 飞行的时间
id_tm = zeros(19, 1);  

% 临时变量
index = 1;

% 给飞机实时编号，行扫描 安置无人机初始位置 实际上就是按比例显示F  这个函数不需要关心
% 他的工作就是 扫描 8*8 的矩阵，然后将矩阵中为 1 元素的位置按比例在图纸上用圆圈描绘出来
% 其中 两无人机的 位置宽带设置由 width 决定，如果 width = 10 ，则表示两无人机位置宽度为10个单位宽度
% 在该循环中 calc(i, j, width) 函数 是将 'F' 按比例放大并安置无人机到模型当中
% 其中 ID 的扫描顺序为: 第一行从左边第一列开始，到最后一列依次定义。
% 例如：array_f 中第一行第二列的 定义为 ID1;  array_f 中第一行第七列的 定义为 ID6; 以此类推
for i = 1: 8
	for j = 1: 8 
        % start 坐标
        if array_f(i, j) == 1
            % 做矩阵点位置应该实际场景
            [id_sta_addr(index, 1), id_sta_addr(index, 2)] = calc(i, j, width);
            % 安置飞机
            plot(id_sta_addr(index, 1), id_sta_addr(index, 2), 'bo');
            index = index + 1;            
        end
	end
end
    
% 临时变量  保存ID 变化的位置信息
temp_info = zeros(19, 2);  


% 算法部分  完成 my_function 函数即可
% temp_info 保存着各个ID的变化信息
temp_info = my_function(array_f, array_z);

% 将矩阵中各个 ID 的位置信息映射到 实际的位置上
% 其中 temp_info(id, 1) 表示的 id n 的 x 轴坐标; temp_info(id, 2)表示的 id n 的 y 轴坐标
for id=1:19
    [id_sto_addr(id, 1) , id_sto_addr(id, 2)] = calc(temp_info(id, 1), temp_info(id, 2), width);
end


pause(2);



% % 测试部分%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% id_sto_addr = id_sta_addr;
% 
% % calc(2, 2, width); 中(2,2)表示无人机终止位置坐标，width表示位宽
% %id_sto_addr(7, 1)； 中(8,1)表示8 表示 ID， 1 表示 X坐标， 2 表示Y坐标
% % 表示 ID 7的点 移动到(2,2) 的位置
% [id_sto_addr(7, 1) , id_sto_addr( 7, 2)] = calc(2, 2, width);
% [id_sto_addr(8, 1) , id_sto_addr( 8, 2)] = calc(3, 5, width);
% [id_sto_addr(9, 1) , id_sto_addr( 9, 2)] = calc(2, 6, width);
% [id_sto_addr(10, 1), id_sto_addr(10, 2)] = calc(4, 4, width);
% [id_sto_addr(11, 1), id_sto_addr(11, 2)] = calc(5, 4, width);
% [id_sto_addr(12, 1), id_sto_addr(12, 2)] = calc(8, 5, width);
% [id_sto_addr(13, 1), id_sto_addr(13, 2)] = calc(7, 6, width);
% [id_sto_addr(14, 1), id_sto_addr(14, 2)] = calc(8, 6, width);
% [id_sto_addr(16, 1), id_sto_addr(16, 2)] = calc(8, 1, width);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%计算 各个无人机运行时间
% 假设无人机 开始位置设置为（x1, y1），终止位置设置为(x2,y2) 则他们运行时间为:
%                   t =  sqrt((x1 - x2)^2 + (y1 - y2)^2) / v  （时间 = 路程 / 速度）
% 其中 sqrt 表示开根号
% 这里 使用一个循环则表示计算各个无人机 改变位置需要消耗的时间
 for i=1:19
	id_tm(i)=sqrt((id_sto_addr(i, 1)-id_sta_addr(i, 1))^2 + (id_sto_addr(i, 2)-id_sta_addr(i, 2))^2) / v; %计算这个 Step 的移动时间
 end

 % 前面使用的 for 循环已经 计算出所有飞机飞行或改变位置的消耗时间
 % 由于无人机的时间有长有短，所以要得到最后变化的队形，肯定是按照最长时间计算变化时间
 %这里就是获取最大的变化时间
max_tm = max(id_tm);

% 该部分有两重循环， 第一重循环是表示 时间 扫描表示的是时间更新 其中 dt 表示无人机飞行过程中的更新时间 默认dt = 1
% 如果 dt = 1则表示 1s 更新一次飞行状态
% 可以不用理会 这个  写算法用不到
 for t=0:dt:max_tm
     
    % 扫描19个点
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
    
    % 停顿一段时间显示
    pause(0.1);
end
        

fprintf('在任意两无人机距离为 %d 个单位时， 最大运行时间为 %f \n', width, ...
                                                                 max_tm);





