function uh = MRWENO_Limiter(uh)

global dimPk Nx bcL bcR phiGL phiGR hx Ck NumEq gamma
uhb = zeros(Nx + 2,dimPk,NumEq);
uhb(2:end - 1,:,:) = uh;
uhR = zeros(Nx + 1,NumEq); uhL = zeros(Nx + 1,NumEq);
ujump = zeros(Nx + 1,NumEq);

uhmod = uh;

% set_bc
if bcL == 1
    uhb(1,:,:) = uh(end,:,:);
elseif bcL == 2
    uhb(1,:,:) = uh(2,:,:);
end

if bcR == 1
    uhb(end,:,:) = uh(1,:,:);
elseif bcR == 2
    uhb(end,:,:) = uh(end - 1,:,:);
end

% KXRCF Detector: find the trouble cells
for i = 1:Nx + 1
    for n = 1:NumEq
        for d = 1:dimPk
            uhR(i,n) = uhR(i,n) + uhb(i,d,n)*phiGR(d);
            uhL(i,n) = uhL(i,n) + uhb(i + 1,d,n)*phiGL(d);
        end
    end
end
% calculate the jump
for i = 1:Nx + 1
    ujump(i,:) = uhL(i,:) - uhR(i,:);
end
% calculate the indicator
is_trouble_cell = zeros(1,Nx);
Ind = zeros(1,Nx);
for i = 1:Nx
    for n = 1:NumEq
        Ind = (abs(ujump(i + 1,n)) + abs(ujump(i,n)))/(hx^2*max([abs(uhL(i,n)),abs(uhR(i,n))]) + 1e-16);
        if Ind > Ck
            is_trouble_cell(i) = 1;
        end
    end
end

for i = 1:Nx
    if is_trouble_cell(i) == 1
        
        polMid = zeros(NumEq,dimPk);
        polLeft = zeros(NumEq,dimPk);
        polRight = zeros(NumEq,dimPk);
        
        for d = 1:dimPk
            for n = 1:NumEq
                polMid(n,d) = uh(i,d,n);
                polLeft(n,d) = uhb(i,d,n);
                polRight(n,d) = uhb(i + 2,d,n);
            end
        end
        
        v = uh(i,1,2)/uh(i,1,1);
        p = pressure(uh(i,1,1),uh(i,1,2),uh(i,1,3));
        c = sqrt(gamma*p/uh(i,1,1));
        H = (uh(i,1,3) + p)/uh(i,1,1);

        R1 = [1;v - c;H - v*c];
        R2 = [1;v;0.5*v^2];
        R3 = [1;v + c;H + v*c];

        R = [R1,R2,R3];

        L = R\eye(3);
        
        polMid = L*polMid;
        polLeft = L*polLeft;
        polRight = L*polRight;
        
        polmod = zeros(NumEq,dimPk);
        for n = 1:NumEq
            polmod(n,:) = MR(polMid(n,:),polLeft(n,:),polRight(n,:));
        end
        polmod = R*polmod;
        for n = 1:NumEq
            uhmod(i,:,n) = polmod(n,:);
        end
    end
    
end

uh = uhmod;

end
