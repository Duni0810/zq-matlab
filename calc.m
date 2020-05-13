
% 坐标映射 矩阵坐标映射到实际模型坐标
% 例如：
%矩阵坐标(1, 2) ->  (10, 80)
function [x, y] = calc(ox, oy, width)

    x = (oy - 1) * width + 10 ;
    y = (width * 8) - (ox - 1) * width + 10;
end