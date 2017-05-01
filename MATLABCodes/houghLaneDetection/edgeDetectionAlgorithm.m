function [leftLane] = edgeDetectionAlgorithm(z)

% Import the source image and convert to grayscale
    if z<10
        filePath = strcat('../../../Assets/RoadMarkingDataset/roadmark_000', num2str(z), '.jpg');
    elseif z<100
        filePath = strcat('../../../Assets/RoadMarkingDataset/roadmark_00', num2str(z), '.jpg');
    else
        filePath = strcat('../../../Assets/RoadMarkingDataset/roadmark_0', num2str(z), '.jpg');
    end
    source = imread(filePath);
    I = rgb2gray(source);
    
    imshow(I);
    
    % Initialize global variables for threshold settings
    [sourceHeight, sourceWidth] = size(I);
    scanLineCount = 5;
    scanLineLength = ceil(sourceWidth/10);
    scanLineBeginHeight = ceil(3/4*sourceHeight);
    thresholdMajorWeight = 0.75;
    thresholdMinorWeight = 0.25;
    rowIncrement = 1/12*sourceHeight;
    leftThreshValue = zeros(scanLineCount,1);
    rightThreshValue = zeros(scanLineCount,1);

    % Calculate array of left and right threshold intensity values
    for i=1:scanLineCount
        scanRow = scanLineBeginHeight - (rowIncrement*(i-1)) ;

        leftScanColumnMid = ceil((7/24*sourceWidth) + (rowIncrement*(i-1)*sourceWidth/2/sourceHeight));
        leftThreshValue(i) = max(I(scanRow, leftScanColumnMid-(scanLineLength/2) : leftScanColumnMid+(scanLineLength/2)));

        rightScanColumnMid = floor((17/24*sourceWidth) - (rowIncrement*(i-1)*sourceWidth/2/sourceHeight));
        rightThreshValue(i) = max(I(scanRow, rightScanColumnMid-(scanLineLength/2) : rightScanColumnMid+(scanLineLength/2)));
    end

    % Calculate left and right lane threshold values
    leftLaneIntensity = mean(leftThreshValue);
    rightLaneIntensity = mean(rightThreshValue);

    leftThreshold = thresholdMajorWeight*leftLaneIntensity + thresholdMinorWeight*rightLaneIntensity;
    rightThreshold = thresholdMajorWeight*rightLaneIntensity + thresholdMinorWeight*leftLaneIntensity;

    % Initializing global variables for lane extraction
    scanLineCount = ceil(1/4*sourceHeight);
    scanLineLength = ceil(sourceWidth/10);
%     leftLane = zeros(scanLineCount,1);
%     rightLane = zeros(scanLineCount,1);
    
    % Identify points on the left and right lanes based on the calculated
    % threshold
    x=1;y=1;
    for i=1:scanLineCount
        scanRow = scanLineBeginHeight - (i-1);
        for j=0:scanLineLength
            leftScanColumn = ceil((1/3*sourceWidth) + ((i-1)*sourceWidth/2/sourceHeight)) - j;
            if I(scanRow, leftScanColumn) > leftThreshold
                leftLane(x,1) = leftScanColumn;
                leftLane(x,2) = scanRow;
                x = x + 1;
                break;
            end
        end

        for j=0:scanLineLength
            rightScanColumn = floor((2/3*sourceWidth) - ((i-1)*sourceWidth/2/sourceHeight)) + j;
            if I(scanRow, rightScanColumn) > rightThreshold
                rightLane(y,1) = rightScanColumn;
                rightLane(y,2) = scanRow;
                y = y + 1;
                break;
            end
        end
    end
    
%     line(leftLane(:,1), scanLineBeginHeight:-1:scanLineBeginHeight-scanLineCount+1, 'LineStyle','none','Marker','.');
%     line(rightLane(:,1), scanLineBeginHeight:-1:scanLineBeginHeight-scanLineCount+1, 'LineStyle','none','Marker','.');
%     line(leftLane(:,1), leftLane(:,2), 'LineStyle','none','Marker','.');
%     line(rightLane(:,1), rightLane(:,2), 'LineStyle','none','Marker','.');
    
%     leftFit = fit([scanLineBeginHeight:-1:scanLineBeginHeight-scanLineCount+1]', leftLane(:,1), 'poly2');
%     rightFit = fit([scanLineBeginHeight:-1:scanLineBeginHeight-scanLineCount+1]', rightLane(:,1), 'poly2');
    leftFit = fit(leftLane(:,2), leftLane(:,1), 'poly2');
    rightFit = fit(rightLane(:,2), rightLane(:,1), 'poly2');

    line(leftFit([scanLineBeginHeight:-1:scanLineBeginHeight-scanLineCount+1]'), scanLineBeginHeight:-1:scanLineBeginHeight-scanLineCount+1,'LineStyle','none','Marker','.');
    line(rightFit([scanLineBeginHeight:-1:scanLineBeginHeight-scanLineCount+1]'), scanLineBeginHeight:-1:scanLineBeginHeight-scanLineCount+1,'LineStyle','none','Marker','.');

end