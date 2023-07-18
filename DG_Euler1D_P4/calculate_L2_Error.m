% calculate_L2_Error.m
uhG = zeros(Nx,NumGLP,NumEq);

for i = 1:Nx
    for d = 1:dimPk
        for n = 1:NumEq
            for i1 = 1:NumGLP
                uhG(i,i1,n) = uhG(i,i1,n) + uh(i,d,n)*phiG(i1,d);
            end
        end
    end
end

ureal = zeros(Nx,NumGLP,NumEq);
for i = 1:Nx
    for j = 1:NumGLP
        ureal(i,j,1) = U1(Xc(i) + hx1*lambda(j) - tend);
        ureal(i,j,2) = U2(Xc(i) + hx1*lambda(j) - tend);
        ureal(i,j,3) = U3(Xc(i) + hx1*lambda(j) - tend);
    end
end

uE = abs(uhG - ureal);
L2_Error = zeros(NumEq,1);

for i = 1:Nx
    for i1 = 1:NumGLP
        L2_Error(1) = L2_Error(1) + hx1*weight(i1)*uE(i,i1,1)^2;
        L2_Error(2) = L2_Error(2) + hx1*weight(i1)*uE(i,i1,2)^2;
        L2_Error(3) = L2_Error(3) + hx1*weight(i1)*uE(i,i1,3)^2;
    end
end
L2_Error = sqrt(L2_Error);
L8_Error = max(max(uE(:,:,1)));