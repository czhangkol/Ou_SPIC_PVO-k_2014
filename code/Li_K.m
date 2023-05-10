function [Re EC MSE EC2 MSE2 NLmax] = Li_K(I,n1,n2,LM)
[d1 d2] = size(I);
NL   = zeros(floor(d1/n1),floor(d2/n2));
A    = zeros(floor(d1/n1),floor(d2/n2));
B    = zeros(floor(d1/n1),floor(d2/n2));
Dmax = zeros(floor(d1/n1),floor(d2/n2));
Dmin = zeros(floor(d1/n1),floor(d2/n2));
W    = zeros(floor(d1/n1),floor(d2/n2));
d1 = d1-2;
d2 = d2-2;
n = n1*n2;

for i = 1:floor(d1/n1)
    for j = 1:floor(d2/n2)
        Y = [I(n1*i+1,n2*(j-1)+1:n2*j+1) I(n1*i:-1:n1*(i-1)+1,n2*j+1)'];
        Z = [I(n1*i+2,n2*(j-1)+1:n2*j+2) I(n1*i+1:-1:n1*(i-1)+1,n2*j+2)'];
        t = 0;
        for k = 1:n1+n2
            t = t+abs(Y(k+1)-Y(k));
        end
        for k = 1:n1+n2+2
            t = t+abs(Z(k+1)-Z(k));
        end
        for k = 1:n1+1
            t = t+abs(I(n1*(i-1)+k,n2*j+1)-I(n1*(i-1)+k,n2*j+2));
        end
        for k = 1:n2+1
            t = t+abs(I(n1*i+1,n2*(j-1)+k)-I(n1*i+2,n2*(j-1)+k));
        end
        NL(i,j) = t;
        X = I(n1*(i-1)+1:n1*i,n2*(j-1)+1:n2*j);
        X = sort(X(:));
        if X(n)-X(1) > 0
            W(i,j) = 1;
            a = 1;
            for k = 1:n-1
                if X(k+1) == X(k)
                    a = a+1;
                else
                    break
                end
            end
            b = 1;
            for k = n-1:-1:1
                if X(k+1) == X(k)
                    b = b+1;
                else
                    break
                end
            end
            A(i,j) = a;
            B(i,j) = b;
            Dmax(i,j) = X(n-b+1)-X(n-b);
            Dmin(i,j) = X(a+1)-X(a);
        end
    end
end
NLmax = max(NL(:));
EC  = zeros(1,NLmax);
MSE = zeros(1,NLmax);
index = 0;
[n1 n2 NLmax];
for Scale = 1:NLmax
    index = index+1;
    for i = 1:floor(d1/n1)
        for j = 1:floor(d2/n2)
            if NL(i,j) < Scale && W(i,j) > 0
                % case 1
                if A(i,j) == 1
                    if Dmin(i,j) == 1
                        EC(index) = EC(index)+1;
                        MSE(index) = MSE(index)+A(i,j)/2;
                    else
                        MSE(index) = MSE(index)+A(i,j);
                    end
                end
                % case 2
                if B(i,j) == 1
                    if Dmax(i,j) == 1
                        EC(index) = EC(index)+1;
                        MSE(index) = MSE(index)+B(i,j)/2;
                    else
                        MSE(index) = MSE(index)+B(i,j);
                    end
                end
            end
        end
    end
end
EC2  = zeros(1,NLmax);
MSE2 = zeros(1,NLmax);
index = 0;
[n1 n2 NLmax];
for Scale = 1:NLmax
    index = index+1;
    for i = 1:floor(d1/n1)
        for j = 1:floor(d2/n2)
            if NL(i,j) < Scale && W(i,j) > 0
                if n == 4
                    % case 1
                    if A(i,j) == 2 && B(i,j) == 2
                        if Dmax(i,j) == 1
                            EC2(index) = EC2(index)+1;
                            MSE2(index) = MSE2(index)+B(i,j)/2;
                        else
                            MSE2(index) = MSE2(index)+B(i,j);
                        end
                    end
                    % case 2
                    if A(i,j) == 2 && B(i,j) < 2
                        if Dmin(i,j) == 1
                            EC2(index) = EC2(index)+1;
                            MSE2(index) = MSE2(index)+A(i,j)/2;
                        else
                            MSE2(index) = MSE2(index)+A(i,j);
                        end
                    end
                    % case 3
                    if A(i,j) < 2 && B(i,j) == 2
                        if Dmax(i,j) == 1
                            EC2(index) = EC2(index)+1;
                            MSE2(index) = MSE2(index)+B(i,j)/2;
                        else
                            MSE2(index) = MSE2(index)+B(i,j);
                        end
                    end
                else
                    % case 1
                    if A(i,j) == 2
                        if Dmin(i,j) == 1
                            EC2(index) = EC2(index)+1;
                            MSE2(index) = MSE2(index)+A(i,j)/2;
                        else
                            MSE2(index) = MSE2(index)+A(i,j);
                        end
                    end
                    % case 2
                    if B(i,j) == 2
                        if Dmax(i,j) == 1
                            EC2(index) = EC2(index)+1;
                            MSE2(index) = MSE2(index)+B(i,j)/2;
                        else
                            MSE2(index) = MSE2(index)+B(i,j);
                        end
                    end
                    
                end
            end
        end
    end
end
Re = zeros(50,4);
ECmax = EC(NLmax)+EC2(NLmax);
tmp = 0;
for Capacity = [5000+LM:1000:ECmax ECmax];
% for Capacity = [ECmax];
    
    H = zeros(1,NLmax);
    HC = zeros(1,NLmax);
    
    for i = 1:NLmax
        for j = NLmax:-1:1
            if EC(i)+EC2(j) >= Capacity
                H(i) = j;
                HC(i) = EC(i)+EC2(j);
            end
        end
    end
    
    D = zeros(1,NLmax);
    
    for i = 1:NLmax
        if H(i) > 0
            D(i) = (MSE(i)+MSE2(H(i)))/HC(i)*Capacity;
        end
    end
    
    imax = 0;
    Dismax = 100000000;
    jmax = 0;
    
    for i = 1:NLmax
        if D(i) > 0 && D(i) < Dismax
            imax = i;
            jmax = H(i);
            Dismax = D(i);
        end
    end
    
    ECbis = Capacity;
    MSEbis = 0;
    
    for i = 1:floor(d1/n1)
        for j = 1:floor(d2/n2)
            if NL(i,j) < imax && W(i,j) > 0 && ECbis > 0
                % case 1
                if A(i,j) == 1
                    if Dmin(i,j) == 1
                        ECbis = ECbis-1;
                        MSEbis = MSEbis+A(i,j)/2;
                    else
                        MSEbis = MSEbis+A(i,j);
                    end
                end
                % case 2
                if B(i,j) == 1
                    if Dmax(i,j) == 1
                        ECbis = ECbis-1;
                        MSEbis = MSEbis+B(i,j)/2;
                    else
                        MSEbis = MSEbis+B(i,j);
                    end
                end
            end
            if NL(i,j) < jmax && W(i,j) > 0 && ECbis > 0
                if n == 4
                    % case 1
                    if A(i,j) == 2 && B(i,j) == 2
                        if Dmax(i,j) == 1
                            ECbis = ECbis-1;
                            MSEbis = MSEbis+B(i,j)/2;
                        else
                            MSEbis = MSEbis+B(i,j);
                        end
                    end
                    % case 2
                    if A(i,j) == 2 && B(i,j) < 2
                        if Dmin(i,j) == 1
                            ECbis = ECbis-1;
                            MSEbis = MSEbis+A(i,j)/2;
                        else
                            MSEbis = MSEbis+A(i,j);
                        end
                    end
                    % case 3
                    if A(i,j) < 2 && B(i,j) == 2
                        if Dmax(i,j) == 1
                            ECbis = ECbis-1;
                            MSEbis = MSEbis+B(i,j)/2;
                        else
                            MSEbis = MSEbis+B(i,j);
                        end
                    end
                else
                    % case 1
                    if A(i,j) == 2
                        if Dmin(i,j) == 1
                            ECbis = ECbis-1;
                            MSEbis = MSEbis+A(i,j)/2;
                        else
                            MSEbis = MSEbis+A(i,j);
                        end
                    end
                    % case 3
                    if B(i,j) == 2
                        if Dmax(i,j) == 1
                            ECbis = ECbis-1;
                            MSEbis = MSEbis+B(i,j)/2;
                        else
                            MSEbis = MSEbis+B(i,j);
                        end
                    end
                end
            end
        end
    end
    
    if ECbis <= 0
        tmp = tmp + 1;
        Re(tmp,1) = imax;
        Re(tmp,2) = jmax;
        Re(tmp,3) = Capacity-LM;
        [d1 d2] = size(I);
        Re(tmp,4) = 10*log10(255^2*d1*d2/MSEbis);
    end
    
end

end
