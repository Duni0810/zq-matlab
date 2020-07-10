
function [x, y, status] = move(id, id_sta_addr, id_sto_addr, id_cur_addr, id_status, t, id_tm, v)

    symbol   = 'bo';  % 打点颜色符号(b. 蓝点； bo蓝圈)
    symbol1  = 'wo';  % 打点颜色符号(w. 白点； wo白圈)

	if (round (id_cur_addr(id, 1)) == round (id_sto_addr(id, 1)) && round (id_cur_addr(id, 2)) == round (id_sto_addr(id, 2)))
        x = id_sto_addr(id, 1);
        y = id_sto_addr(id, 2);

        status = 1;
        return;
	end
    status = 0;

    % 消除前一点
    plot(id_cur_addr(id, 1), id_cur_addr(id, 2), symbol1);
    
    x = id_cur_addr(id,1) + ((id_sto_addr(id,1)-id_cur_addr(id,1))/sqrt((id_sto_addr(id,1)-id_cur_addr(id,1))^2+(id_sto_addr(id,2)-id_cur_addr(id,2))^2));
    y = id_cur_addr(id,2) + ((id_sto_addr(id,2)-id_cur_addr(id,2))/sqrt((id_sto_addr(id,1)-id_cur_addr(id,1))^2+(id_sto_addr(id,2)-id_cur_addr(id,2))^2));
    
	for p = 1: 19
	% id不等   floor  取整函数
        if id ~= p
                
            % 存在碰撞点
            if (sqrt( (id_cur_addr(p,1)-id_cur_addr(id,1))^2 + (id_cur_addr(p,2)-id_cur_addr(id,2))^2) < 3)     
                
                if ((id_cur_addr(id,1) > id_cur_addr(p,1)) && (id_cur_addr(id,2) > id_cur_addr(p,2)))
                    x = id_cur_addr(id, 1) + 1;
                    y = id_cur_addr(id, 2);
                    
                elseif ((id_cur_addr(id,1) < id_cur_addr(p,1)) && (id_cur_addr(id,2) > id_cur_addr(p,2)))
                    x = id_cur_addr(id, 1) - 1;
                    y = id_cur_addr(id, 2); 
                    
                elseif ((id_cur_addr(id,1) < id_cur_addr(p,1)) && (id_cur_addr(id,2) < id_cur_addr(p,2)))
                    x = id_cur_addr(id, 1) - 1;
                    y = id_cur_addr(id, 2); 
                
                elseif ((id_cur_addr(id,1) > id_cur_addr(p,1)) && (id_cur_addr(id,2) < id_cur_addr(p,2)))
                    x = id_cur_addr(id, 1) + 1;
                    y = id_cur_addr(id, 2); 
                    
                else 
                    x = id_cur_addr(id, 1) - 1;
                    y = id_cur_addr(id, 2) - 1;  
                end
                
            
            end
        end
	end
    
    
	plot(x,y, symbol);

end