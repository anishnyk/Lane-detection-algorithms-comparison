function [ houghArray ] = houghTransform( x, y)

houghArray = zeros(800,90);
for theta = 1:2:90
    rho = round(((x*cos(theta*pi/180)) + (y*sin(theta*pi/180)))/3)*3 + 1;
    if rho>=1
        houghArray(rho,theta) = houghArray(rho, theta) + 1;
    end
end

end