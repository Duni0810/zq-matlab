clear all
clc;

symbol   = 'bo';  % 打点颜色符号(b. 蓝点； bo蓝圈)
symbol1  = 'go';  % 打点颜色符号(w. 白点； bo蓝圈)
%相关参数设定
T = 100; %仿真时间 s
dt = 2; %步进时间 s
vmin = 1;vmax = 1.5; %速度范围

tmin = 0.5;tmax = 0.5; %停顿时间范围 s

xmin = 0;xmax = 100;ymin = 0;ymax = 50; %场景的范围
tex=0; %初始化运行时间记忆变量
axis([xmin xmax ymin ymax]); %设定坐标范围
figure(1);
hold on ; %保留绘图内容

xa=unifrnd(0,100,[1,1]); %随机发生起始点坐标
ya=unifrnd(0,50,[1,1]);

% 消除前一点坐标
pre_x = 0;
pre_y = 0;

while (1)
    xb=unifrnd(0,100,[1,1]); %随机发生一个路点坐标
    yb=unifrnd(0,50,[1,1]);
    v=unifrnd(vmin,vmax,[1,1]); %随机发生一个速度值，速度大小服从均匀分布
    tp=unifrnd(tmin,tmax,[1,1]); %随机发生一个停顿时间，停顿时间服从均匀分布
    tm=sqrt((xb-xa)^2+(yb-ya)^2)/v; %计算这个 Step 的移动时间
    
    if xa==xb && ya==yb %在出发点和目的点坐标相同时单独处理
        pre_x = xa;
        pre_y = xb;
        plot(x, y, symbol);
        
        pause(tp); %停止一段时间
        tex=tex+tp; %更新运行时间记忆变量
        
    else
        if T-tex>=tm; %本次 Step 内仿真时间不会到
 
            for t=0:dt:tm
                
                plot(pre_x, pre_y, symbol1);
                
                x=xa+v*((xb-xa)/sqrt((xb-xa)^2+(yb-ya)^2))*t;
                y=ya+v*((yb-ya)/sqrt((xb-xa)^2+(yb-ya)^2))*t;

                plot(x,y, symbol);
                pre_x = x;
                pre_y = y;    
                pause(0.5)
                tex=tex+dt; %更新运行时间记忆变量
                
            end
            if T-tex>=tp;
                pause(tp); %停止一段时间
                tex=tex+tp; %更新运行时间记忆变量
            else
            	pause(T-tex); %时间到
                return
            end
            
        else %本次 Step 内仿真时间会到
            for t=0:dt:T-tex
                
                plot(pre_x,pre_y, symbol1);
                
                x=xa+v*((xb-xa)/sqrt((xb-xa)^2+(yb-ya)^2))*t;
            	y=ya+v*((yb-ya)/sqrt((xb-xa)^2+(yb-ya)^2))*t;
                plot(x,y, symbol);
                
                pre_x = x;
                pre_y = y;
                
            end
            
            return %时间到
        end
    end
    
    xa=xb;ya=yb; %将目标点更新为新 Step 的起点
    
    %delete(xb,yb)
end