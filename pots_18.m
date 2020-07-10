clear all
%C=[2 15 13 4;10 4 14 15;9 14 16 13;7 8 11 9];

symbol   = 'bo';  % 打点颜色符号(b. 蓝点； bo蓝圈)
symbol1  = 'wo';  % 打点颜色符号(w. 白点； wo白圈)
   
dt = 1; % 采样步距
v  = 1; % 速度

% 两点之间距离
width = 10;

%------------------------------------------------------------------------
%  测试加中间重合点
array_f =[0     2     2     2     2     2     2     0;     %不进行处理的点标记为 2
     0     0     1     0     0     0     0     0;
     0     0     1     0     0     1     0     0;
     0     0     1     1     1     1     0     0;
     0     0     0     0     0     1     0     0;
     0     0     1     0     0     0     0     0;
     0     0     1     0     0     0     0     0;
     0     2     2     2     0     0     0     0;];

array_z =[0     2     2     2     2     2     2     0;
     0     1     0     0     0     1     0     0;
     0     0     0     0     1     0     0     0;
     0     0     0     1     0     0     0     0;
     0     0     0     1     0     0     0     0;
     0     0     1     0     0     0     0     0;
     0     0     0     0     0     1     0     0;
     1     2     2     2     1     1     0     0;];

T0=zeros(10,3);        %要进行变化的点的坐标集合
n = 1;
for i=1:8
    for j=1:8
        if array_f(i,j) == 1
            T0(n,:) = [i,j,0];
            n = n + 1;
        end
    end
end
%Z矩阵转换为坐标T1：
T1=zeros(10,3);
n = 1;
for i=1:8
    for j=1:8
        if array_z(i,j) == 1
            T1(n,:) = [i,j,0];
            n = n + 1;
        end
    end
end


%--------------------------------------------------------------------------------------------

t=length(T0);
C=zeros(t,t);           
    for i=1:t        
     for j=1:t
       a=(T0(i,1)-T1(j,1))^2;
       b=(T0(i,2)-T1(j,2))^2;
       c=(T0(i,3)-T1(j,3))^2;
       d=sqrt(a+b+c);
       C(j,i)=d;
     end  
    end
  c =C; 
  disp(c);

%-------------------------------------------------------------------------- 

%匹配2
%[Matching,Cost]=Hungarian4(C);
[M,Perf_select,cost,Mean_square_erro] = zq_ave(C)

Perf_select

%---------------------------------------------------------------------------------------%

%计算代价，取出并清零代价最高点的对应编号
max_cost=max(Perf_select);
for i=1:t
    if Perf_select(i) == max_cost
        max_cost_num = i;
        break;
    end
end

max_cost_num
for i=1:t
    if i==max_cost_num 
        M(i)=0;
        break;
    end
end


%---------------------------------------------------------------------------------------%
%     建模 

%场景的范围       
xmin = 0;xmax = width * 8 + 20;ymin = 0;ymax = width * 8 + 20; 

axis([xmin xmax ymin ymax]); %设定坐标范围
figure(1);
hold on ; %保留绘图内容

% 初始化矩阵
id_sta_addr = zeros(19,2);
id_sto_addr = zeros(19,2);
id_cur_addr = zeros(19,2);
id_tm = zeros(19, 1);         %保存移动时间
index = 1;

% 给飞机实时编号，行扫描 安置无人机初始位置 实际上就是按比例显示F
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
for i = 1: 8
	for j = 1: 8 
        % start 坐标
        if array_f(i, j) == 2         
            % 做矩阵点位置应该实际场景
            [id_sta_addr(index, 1), id_sta_addr(index, 2)] = calc(i,j, width);
            % 安置飞机
            plot(id_sta_addr(index, 1), id_sta_addr(index, 2), 'ro');
            index = index + 1;                    
        end
	end
end
  
pause(2);


% 测试部分--------------------------------------------------
id_sto_addr = id_sta_addr;

% calc(2, 2, width); 中(2,2)表示无人机终止位置坐标，width表示位宽
%id_sto_addr(7, 1)； 中(8,1)表示8 表示 ID， 1 表示 X坐标， 2 表示Y坐标
% 表示 ID 7的点 移动到(2,2) 的位置
for i=1:t
    p = M(1,i);
    if p == 0
        [id_sto_addr(i, 1) , id_sto_addr( i, 2)] =calc(10, 10, width);  %移除多余点
    elseif p<20
        [id_sto_addr(i, 1) , id_sto_addr( i, 2)] =calc(T1(p,1), T1(p,2), width);
    end
end

%--------------------------------------------------------------------------------------------------

%计算 各个无人机运行时间
 for i=1:19
	id_tm(i)=sqrt((id_sto_addr(i, 1)-id_sta_addr(i, 1))^2 + (id_sto_addr(i, 2)-id_sta_addr(i, 2))^2) / v; %计算这个 Step 的移动时间
 end

 %获取最大运行时间
max_tm = max(id_tm);
disp(id_tm);
%状态  是否已经到达指定位置
id_status = zeros(19,1);
% id scan



id_cur_addr = id_sta_addr;

 for t=0:dt:max_tm  
     
    for index = 1:19
        % 单点移动
        [id_cur_addr(index, 1), id_cur_addr(index, 2), id_status(index)] = move(index,       ...
                                                                                id_sta_addr, ...
                                                                                id_sto_addr, ...
                                                                                id_cur_addr, ...
                                                                                id_status,   ...
                                                                                t,           ...
                                                                                id_tm,       ...
                                                                                v);

    end
    pause(0.1);
    
	%判断是否为空矩阵
    if isempty(find(id_status == 0))
        break;
    end

 end
 
 
 
fprintf(' 运行时间为：%d s \r\n', t);
    
    