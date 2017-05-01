function [ houghArray ] = houghTransform( x, y)

houghArray = zeros(200,31);
for theta = 1:31
    rho = round(((x*cos((theta-1)*3*pi/180)) + (y*sin((theta-1)*3*pi/180)))/3) + 1;
    if rho>=1
        houghArray(rho,theta) = houghArray(rho, theta) + 1;
    end
end

end