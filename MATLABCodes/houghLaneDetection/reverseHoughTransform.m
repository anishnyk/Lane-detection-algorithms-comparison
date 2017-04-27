function [ output ] = reverseHoughTransform(rho, theta, sourceWidth, sourceHeight)

k=1;
for x = 0:sourceWidth/2
    for y = 0:sourceHeight
        if abs(rho - x*cos(theta*pi/180) - y*sin(theta*pi/180)) < 1
            output(k,:) = [x y];
            k = k+1;
        end
    end
end

end

