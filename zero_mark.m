function [Perf_num] = zero_mark(Perf_num,Perf,ave)
    size_P=size(Perf_num);
    t = size_P(1);
    for i=1:t
        x = find(Perf_num(i,:)==0);
        size_x = size(x);
%         Perf_v_second = zeros(1,size_x(2));
%         Perf_v_second_num = zeros(1,size_x(2));
        if size_x(2) > 1
           for n=2:(size_x(2))     
             if abs(Perf(i,x(n))-ave) > abs(Perf(i,x(n-1))-ave) 
                  Perf_num(i,x(n-1)) = 100;           
                  min_num = min(Perf_num(:,x(n-1)));
                  for m=1:t
                      if Perf_num(m,x(n-1)) == min_num
                          Perf_num(m,x(n-1)) = 0;
                          break;
                      end
                  end
              else
                  Perf_num(i,x(n)) = 100;
                  min_num = min(Perf_num(:,x(n)));
                  for m=1:t
                      if Perf_num(m,x(n)) == min_num
                          Perf_num(m,x(n)) = 0;
                          break;
                      end
                  end
             end
              
%              p = 1;
%              for n=1:(size_x(2))
%                Perf_num(i,x(n)) = 100;
%                min_num = min(Perf_num(:,x(n)));
%                for m=1:t
%                   if Perf_num(m,x(n)) == min_num
%                       Perf_v_second_num(p) = m;  % 列第二小的对应的行号
%                       Perf_v_second(p) = Perf_num(m,x(n));   %  列第二小的对应的值
%                       p = p+1;
%                       break;
%                   end
%                end      
%              end     
%              min_v_second = min(Perf_v_second);   %  行同0对应的列的第二小的值的最小值
%              for q=1;size_x(2)
%                  if Perf_v_second(q) == min_v_second
%                      Perf_num(Perf_v_second_num(q),x(q)) = 0;
%                  else
%                      Perf_num(i,x(q)) = 0;
%                  end
%              end
           end
        end 
    end
end