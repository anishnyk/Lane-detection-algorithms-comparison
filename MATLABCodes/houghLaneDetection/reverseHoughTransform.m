function [ output ] = reverseHoughTransform(rho, theta, sourceWidth, beginRow, endRow)

k=1;
for x = 0:sourceWidth/2
    for y = beginRow:endRow
        if abs(rho - x*cos(theta*pi/180) - y*sin(theta*pi/180)) < 1
            output(k,:) = [x,y];
            k = k+1;
        end
    end
end

if k==1
    output(1,:) = [0,0];
end

end

