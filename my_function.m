%
% 待完成的算法函数
%
% 功能: 该函数应该完成的是将各个ID的无人机飞行的位置计算出来，保存到sto_addr即可。
%   例如: sto_addr(ID, 1)  保存的是移动后X轴坐标; sto_addr(ID, 2)  保存的是移动后Y轴坐标; 
%
%
% 传入两个 矩阵，一个矩阵为开始矩阵sta; 另一个矩阵为目标矩阵
% 返回值sto_addr为 ID 变化位置信息 其中索引号就是ID号,第一个元素表示为x轴坐标 第二个元素表示为y轴坐标
% 例如:  sto_addr(7, 1)， sto_addr(7, 2) 分别表示 ID7  移动到(1,2)的位置(第一行第二列)

function [sto_addr] = my_function(sta, sto)

    %  该矩阵用于保存结束坐标位置
    sto_addr = zeros(19,2);
    
    % todo 待完成的算法

end