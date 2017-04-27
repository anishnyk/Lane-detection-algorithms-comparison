function [ houghArray ] = houghTransform( x, y, startAngle )

houghArray = zeros(500,180);
for theta = startAngle:3:startAngle+89
    rho = ceil((x*cos(theta*pi/180)) + (y*sin(theta*pi/180))) + 1;
    
    houghArray(rho,theta) = houghArray(rho, theta) + 1;
end

end