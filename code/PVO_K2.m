function [performance, LM, T] = PVO_K2(Io)
performance = zeros(2,5000);
T = zeros(2,5000);
p1 = [];
p2 = [];
t1 = [];
t2 = [];
[LM I] = location_map(Io);

%原始版本用PVO_K函数


for n1 = 2:5
    for n2 = 2:5
        
        [Re EC MSE EC2 MSE2 NLmax] = Li_K(I,n1,n2,LM);
        for i = 1:length(Re)
            if Re(i,3) > 0
                t1 = [t1 Re(i,1)];
                t2 = [t2 Re(i,2)];
                p1 = [p1 Re(i,3)];
                p2 = [p2 Re(i,4)];
            end
        end
        [n1 n2];
    end
end
performance(1,1:length(p1)) = p1';
performance(2,1:length(p1)) = p2';
T(1,1:length(p1)) = t1';
T(2,1:length(p1)) = t2';

end