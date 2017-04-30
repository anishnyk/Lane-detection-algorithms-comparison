function [ leftHoughArray, leftRho, leftTheta, leftLanes, beginRow] = houghSlotAlgorithm( z )

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
        scanRow = scanLineBeginHeight - (rowIncrement*(i-1));

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
    scanLineCount = ceil(5/12*sourceHeight);
    scanLineLength = ceil(sourceWidth/10);
    leftLane = zeros(scanLineCount,1);
    rightLane = zeros(scanLineCount,1);
    
    % Identify points on the left and right lanes based on the calculated
    % threshold
    for i=1:scanLineCount
        scanRow = (3/4*sourceHeight) - (i-1);
        for j=0:scanLineLength
            leftScanColumn = ceil((1/3*sourceWidth) + ((i-1)*sourceWidth/2/sourceHeight)) - j;
            if I(scanRow, leftScanColumn) > leftThreshold
                break;
            end
        end
        leftLane(i,1) = leftScanColumn;

        for j=0:scanLineLength
            rightScanColumn = floor((2/3*sourceWidth) - ((i-1)*sourceWidth/2/sourceHeight)) + j;
            if I(scanRow, rightScanColumn) > rightThreshold
                break;
            end
        end
        rightLane(i,1) = rightScanColumn;
    end
    
    imshow(source);
    
    % Initializing variables for Hough transform in horizontal slots
    scanLineCount = 5;
    scanLineBeginHeight = ceil(3/4*sourceHeight);
    rowIncrement = ceil(1/12*sourceHeight);
    leftHoughArray = zeros(200,31,scanLineCount);
    rightHoughArray = zeros(200,31,scanLineCount);
    
    for i=1:scanLineCount
        beginRow = (i-1)*rowIncrement + 1;
        endRow = beginRow + rowIncrement -1;
        
        for k=beginRow:endRow
            arr = houghTransform(leftLane(k,1), scanLineBeginHeight - (k-1));
            leftHoughArray(:,:,i) = leftHoughArray(:,:,i) + arr;
            arr = houghTransform(sourceWidth-rightLane(k,1), scanLineBeginHeight - (k-1));
            rightHoughArray(:,:,i) = rightHoughArray(:,:,i) + arr;
        end
        
        [colMax, rowIndex] = max(leftHoughArray(:,:,i));
        leftMax = max(colMax);
        k=1;
        leftRhoArr = [];
        leftThetaArr = [];
        for j=1:length(colMax)
            if colMax(j) == leftMax;
                leftRhoArr(k) = (rowIndex(j)-1)*3;
                leftThetaArr(k) = (j-1)*3;
                k=k+1;
            end
        end
        if length(leftRhoArr) > 1
            leftRho(i) = median(leftRhoArr);
            leftTheta(i) = median(leftThetaArr);
        else
            leftRho(i) = leftRhoArr;
            leftTheta(i) = leftThetaArr;
        end
        
        [colMax, rowIndex] = max(rightHoughArray(:,:,i));
        rightMax = max(colMax);
        k=1;
        rightRhoArr=[];
        rightThetaArr=[];
        for j=1:length(colMax)
            if colMax(j) == rightMax;
                rightRhoArr(k) = (rowIndex(j)-1)*3;
                rightThetaArr(k) = (j-1)*3;
                k=k+1;
            end
        end
        if length(rightRhoArr) > 1
            rightRho(i) = median(rightRhoArr);
            rightTheta(i) = median(rightThetaArr);
        else
            rightRho(i) = rightRhoArr;
            rightTheta(i) = rightThetaArr;
        end
        
        % Display the left and right lanes
        leftLanes = reverseHoughTransform(leftRho(i),leftTheta(i), sourceWidth, scanLineBeginHeight-(endRow-1), scanLineBeginHeight-(beginRow-1));
        line(leftLanes(:,1), leftLanes(:,2),'LineStyle','none','Marker','.');
        rightLanes = reverseHoughTransform(rightRho(i),rightTheta(i), sourceWidth, scanLineBeginHeight-(endRow-1), scanLineBeginHeight-(beginRow-1));
        line(sourceWidth-rightLanes(:,1), rightLanes(:,2),'LineStyle','none','Marker','.');
        pause(0.1);
    end
    
end

