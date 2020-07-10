clear all
%C=[2 15 13 4;10 4 14 15;9 14 16 13;7 8 11 9];

symbol   = 'bo';  % �����ɫ����(b. ���㣻 bo��Ȧ)
symbol1  = 'wo';  % �����ɫ����(w. �׵㣻 wo��Ȧ)
   
dt = 1; % ��������
v  = 1; % �ٶ�

% ����֮�����
width = 10;

%------------------------------------------------------------------------
%  ���Լ��м��غϵ�
array_f =[0     2     2     2     2     2     2     0;     %�����д���ĵ���Ϊ 2
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

T0=zeros(10,3);        %Ҫ���б仯�ĵ�����꼯��
n = 1;
for i=1:8
    for j=1:8
        if array_f(i,j) == 1
            T0(n,:) = [i,j,0];
            n = n + 1;
        end
    end
end
%Z����ת��Ϊ����T1��
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

%ƥ��2
%[Matching,Cost]=Hungarian4(C);
[M,Perf_select,cost,Mean_square_erro] = zq_ave(C)

Perf_select

%---------------------------------------------------------------------------------------%

%������ۣ�ȡ�������������ߵ�Ķ�Ӧ���
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
%     ��ģ 

%�����ķ�Χ       
xmin = 0;xmax = width * 8 + 20;ymin = 0;ymax = width * 8 + 20; 

axis([xmin xmax ymin ymax]); %�趨���귶Χ
figure(1);
hold on ; %������ͼ����

% ��ʼ������
id_sta_addr = zeros(19,2);
id_sto_addr = zeros(19,2);
id_cur_addr = zeros(19,2);
id_tm = zeros(19, 1);         %�����ƶ�ʱ��
index = 1;

% ���ɻ�ʵʱ��ţ���ɨ�� �������˻���ʼλ�� ʵ���Ͼ��ǰ�������ʾF
for i = 1: 8
	for j = 1: 8 
        % start ����
        if array_f(i, j) == 1
            % �������λ��Ӧ��ʵ�ʳ���
            [id_sta_addr(index, 1), id_sta_addr(index, 2)] = calc(i, j, width);
            % ���÷ɻ�
            plot(id_sta_addr(index, 1), id_sta_addr(index, 2), 'bo');
            index = index + 1;            
        end
	end
end  
for i = 1: 8
	for j = 1: 8 
        % start ����
        if array_f(i, j) == 2         
            % �������λ��Ӧ��ʵ�ʳ���
            [id_sta_addr(index, 1), id_sta_addr(index, 2)] = calc(i,j, width);
            % ���÷ɻ�
            plot(id_sta_addr(index, 1), id_sta_addr(index, 2), 'ro');
            index = index + 1;                    
        end
	end
end
  
pause(2);


% ���Բ���--------------------------------------------------
id_sto_addr = id_sta_addr;

% calc(2, 2, width); ��(2,2)��ʾ���˻���ֹλ�����꣬width��ʾλ��
%id_sto_addr(7, 1)�� ��(8,1)��ʾ8 ��ʾ ID�� 1 ��ʾ X���꣬ 2 ��ʾY����
% ��ʾ ID 7�ĵ� �ƶ���(2,2) ��λ��
for i=1:t
    p = M(1,i);
    if p == 0
        [id_sto_addr(i, 1) , id_sto_addr( i, 2)] =calc(10, 10, width);  %�Ƴ������
    elseif p<20
        [id_sto_addr(i, 1) , id_sto_addr( i, 2)] =calc(T1(p,1), T1(p,2), width);
    end
end

%--------------------------------------------------------------------------------------------------

%���� �������˻�����ʱ��
 for i=1:19
	id_tm(i)=sqrt((id_sto_addr(i, 1)-id_sta_addr(i, 1))^2 + (id_sto_addr(i, 2)-id_sta_addr(i, 2))^2) / v; %������� Step ���ƶ�ʱ��
 end

 %��ȡ�������ʱ��
max_tm = max(id_tm);
disp(id_tm);
%״̬  �Ƿ��Ѿ�����ָ��λ��
id_status = zeros(19,1);
% id scan



id_cur_addr = id_sta_addr;

 for t=0:dt:max_tm  
     
    for index = 1:19
        % �����ƶ�
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
    
	%�ж��Ƿ�Ϊ�վ���
    if isempty(find(id_status == 0))
        break;
    end

 end
 
 
 
fprintf(' ����ʱ��Ϊ��%d s \r\n', t);
    
    