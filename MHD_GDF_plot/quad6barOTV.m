% quadloadRotor.m
NumGLP = 6;

Xc = load('Xc.txt');
Yc = load('Yc.txt');

Q1 = load('Q1.txt');
Q2 = load('Q2.txt');
Q3 = load('Q3.txt');
Q4 = load('Q4.txt');
Q5 = load('Q5.txt');
Q6 = load('Q6.txt');
Q7 = load('Q7.txt');
Q8 = load('Q8.txt');

Nx = length(Xc);
Ny = length(Yc);

xc = zeros(Nx,Ny);
yc = zeros(Nx,Ny);

for j = 1:Ny
    xc(:,j) = Xc;
end

for i = 1:Nx
    yc(i,:) = Yc';
end

Q1 = reshape(Q1,Ny,Nx)';
Q2 = reshape(Q2,Ny,Nx)';
Q3 = reshape(Q3,Ny,Nx)';
Q4 = reshape(Q4,Ny,Nx)';
Q5 = reshape(Q5,Ny,Nx)';
Q6 = reshape(Q6,Ny,Nx)';
Q7 = reshape(Q7,Ny,Nx)';
Q8 = reshape(Q8,Ny,Nx)';

Qrho = Q1;
Qu = Q2./Q1;
Qv = Q3./Q1;
QE = Q5;
QB1 = Q6;
QB2 = Q7;
gamma = 5/3;
QP = (gamma - 1)*(QE - 0.5*Qrho.*(Qu.^2 + Qv.^2) - 0.5*(QB1.^2 + QB2.^2));
QC = sqrt(abs(gamma*QP./Qrho));
QMach = sqrt(Qu.^2 + Qv.^2)./QC;
QBP = 0.5*(QB1.^2 + QB2.^2);

Xc = xc(:,1);
Yc = yc(1,:)';

lambda(1) = -0.9324695142031520278123016;
lambda(2) = -0.6612093864662645136613996;
lambda(3) = -0.2386191860831969086305017;
lambda(4) = 0.2386191860831969086305017;
lambda(5) = 0.6612093864662645136613996;
lambda(6) = 0.9324695142031520278123016;

weight(1) = 0.1713244923791703450402961;
weight(2) = 0.3607615730481386075698335;
weight(3) = 0.4679139345726910473898703;
weight(4) = 0.4679139345726910473898703;
weight(5) = 0.3607615730481386075698335;
weight(6) = 0.1713244923791703450402961;

Nx = length(Xc)/NumGLP;
Ny = length(Yc)/NumGLP;

Xcc = zeros(1,Nx);
Ycc = zeros(1,Ny);
Q1c = zeros(Nx,Ny);
Q2c = zeros(Nx,Ny);
Q3c = zeros(Nx,Ny);
Q4c = zeros(Nx,Ny);
Q5c = zeros(Nx,Ny);
Q6c = zeros(Nx,Ny);
QPc = zeros(Nx,Ny);
QBPc = zeros(Nx,Ny);
QMachc = zeros(Nx,Ny);

for i = 1:Nx
    Xcc(i) = sum(Xc(NumGLP*(i - 1) + 1:NumGLP*i))/NumGLP;
end

for j = 1:Ny
    Ycc(j) = sum(Yc(NumGLP*(j - 1) + 1:NumGLP*j))/NumGLP;
end

hx1 = (Xcc(2) - Xcc(1))/2;
hy1 = (Ycc(2) - Ycc(1))/2;

for i = 1:Nx
    for j = 1:Ny
        for i1 = 1:NumGLP
            for j1 = 1:NumGLP
                Q1c(i,j) = Q1c(i,j) + 0.25*weight(i1)*weight(j1)*Q1(NumGLP*(i - 1) + i1,NumGLP*(j - 1) + j1);
                Q2c(i,j) = Q2c(i,j) + 0.25*weight(i1)*weight(j1)*Q2(NumGLP*(i - 1) + i1,NumGLP*(j - 1) + j1);
                Q3c(i,j) = Q3c(i,j) + 0.25*weight(i1)*weight(j1)*Q3(NumGLP*(i - 1) + i1,NumGLP*(j - 1) + j1);
                Q4c(i,j) = Q4c(i,j) + 0.25*weight(i1)*weight(j1)*Q4(NumGLP*(i - 1) + i1,NumGLP*(j - 1) + j1);
                Q5c(i,j) = Q5c(i,j) + 0.25*weight(i1)*weight(j1)*Q5(NumGLP*(i - 1) + i1,NumGLP*(j - 1) + j1);
                Q6c(i,j) = Q6c(i,j) + 0.25*weight(i1)*weight(j1)*Q6(NumGLP*(i - 1) + i1,NumGLP*(j - 1) + j1);
                QPc(i,j) = QPc(i,j) + 0.25*weight(i1)*weight(j1)*QP(NumGLP*(i - 1) + i1,NumGLP*(j - 1) + j1);
                QBPc(i,j) = QBPc(i,j) + 0.25*weight(i1)*weight(j1)*QBP(NumGLP*(i - 1) + i1,NumGLP*(j - 1) + j1);
                QMachc(i,j) = QMachc(i,j) + 0.25*weight(i1)*weight(j1)*QMach(NumGLP*(i - 1) + i1,NumGLP*(j - 1) + j1);
            end
        end
    end
end

xcc = zeros(Nx,Ny);
ycc = zeros(Nx,Ny);

for j = 1:Ny
    xcc(:,j) = Xcc;
end

for i = 1:Nx
    ycc(i,:) = Ycc';
end

Q1 = Q1c;
Q2 = Q2c;
Q3 = Q3c;
Q4 = Q4c;
Q5 = Q5c;
Q6 = Q6c;
QP = QPc;
QBP = QBPc;
QMach = QMachc;

xc = xcc;
yc = ycc;

figure(1);
contour(xc,yc,Q1,30);colormap(cool);
%mesh(xc,yc,Q1);colormap(cool);
title('Density')

figure(2);
contour(xc,yc,QP,15);colormap(cool);
title('Pressure')
