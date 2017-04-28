function [ output ] = reverseHoughTransform(rho, theta, sourceWidth, sourceHeight, beginRow, lane)

[z,~] = size(lane);
rowIncrement = 1/12*sourceHeight;
%output = zeros(ceil(sourceHeight*sourceWidth/36),2);
k=1;
for x = 0:sourceWidth/2
    for y = beginRow:beginRow+rowIncrement
        if abs(rho - x*cos(theta*pi/180) - y*sin(theta*pi/180)) < 1
            output(k,:) = [x y];
            k = k+1;
        end
    end
end

if k==1
    output(k,:) = lane(z,:);
end

end

