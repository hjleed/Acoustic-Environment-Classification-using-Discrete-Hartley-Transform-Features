function [confusionMat, AccFolds, Acc, Std] = evaluation2013(numfolds, foldsGTlist, foldstestlist)
% This functio computes confusion matrix, accuracy and std
% using DCASE2013 databases

% For paper: DOI: 10.1109/CCECE.2017.7946646

% To cite:

% @inproceedings{jleed2017acoustic,
%   title={Acoustic environment classification using discrete hartley transform features},
%   author={Jleed, Hitham and Bouchard, Martin},
%   booktitle={Electrical and Computer Engineering (CCECE), 2017 IEEE 30th Canadian Conference on},
%   pages={1--4},
%   year={2017},
%   organization={IEEE}
% }

%%
%numfolds=5;

% Initialize
classList = {'bus','busystreet','office','openairmarket','park','quietstreet','restaurant','supermarket','tube','tubestation'};
N=length(classList);
confusionMat = zeros(N,N);
AccFolds = zeros(1,numfolds);


fid1 = fopen(foldsGTlist,'r');
fid2 = fopen(foldstestlist,'r');

% For each fold
for i=1:numfolds
    tline1 = fgetl(fid1);
    fid =fopen(tline1,'r');
    t1 = textscan(fid, '%s %s');
    fclose(fid);
    fileIDGT = t1{1};
    classIDGT = t1{2};

%     Load classification output
    tline2 = fgetl(fid2);
    fid =fopen(tline2,'r');
    t2 = textscan(fid, '%s %s');
    fclose(fid);
    fileID = t2{1};
    classID = t2{2};
    
    % Compute confusion matrix per fold
    confusionMatTemp = zeros(N,N);
    for j=1:length(classIDGT)
        pos = strmatch(fileIDGT{j}, fileID, 'exact');
        posClassGT = strmatch(classIDGT{j}, classList, 'exact');
        posClass = strmatch(classID{pos}, classList, 'exact');
        confusionMatTemp(posClassGT,posClass) = confusionMatTemp(posClassGT,posClass) + 1;
    end
    
    % Compute accuracy per fold
    AccFolds(i) = sum(diag(confusionMatTemp))/sum(sum(confusionMatTemp));
    confusionMat = confusionMat + confusionMatTemp;
    
end
% fclose(fid1);
% fclose(fid2);


% Compute global accuracy and std
Acc = mean(AccFolds);
Std = std(AccFolds);
% dlmwrite('myFile.txt', confusionMat,'delimiter',' ');
%%
AccFolds=AccFolds.*100;
fHand = figure;
aHand = axes('parent', fHand);
title(sprintf('Average Accuracy=%f %%',Acc*100))
hold(aHand, 'on')
colors = hsv(numel(AccFolds));
for i = 1:numel(AccFolds)
    bar(i, AccFolds(i), 'parent', aHand, 'facecolor', colors(i,:));
end
set(gca, 'XTick', 1:numel(AccFolds), 'XTickLabel', {'1-fold','2-fold','3-fold','4-fold','5-fold'})

 xlabel('folds', 'FontSize', 15, 'FontWeight', 'bold');
 ylabel('accuracy %', 'FontSize', 15, 'FontWeight', 'bold');
%% %%%%%%%%%%%%%%%%%%%% plotting confusion matrix %%%%%%%%%%%%%%%%%
 figure;
 confusionMat=10.*confusionMat;
%     % Clean up the figure junk matlab generates
%     set(gcf, 'DockControls', 'off');
%     set(gcf, 'ToolBar', 'none');

    imagesc(confusionMat);
    axis square; % Correct for stretching
    set(gca, 'TickLength', [0 0]); % No ticks
    set(gca, 'YTickLabel', classList);

    % writing numbers    
    textStrings = num2str(confusionMat(:),'%0.2f');  %# Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding

[x,y] = meshgrid(1:N);  %# Create x and y coordinates for the strings
hStrings = text(x(:),y(:),textStrings(:),...      %# Plot the strings
                'HorizontalAlignment','center');
midValue = mean(get(gca,'CLim'));  %# Get the middle value of the color range
textColors = repmat(confusionMat(:) > midValue,1,3);  %# Choose white or black for the
                                                  %#   text color of the strings so
                                                   %#   they can be easily seen over
                                                   %#   the background color
set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors


    % Create rotated labels on the confusion matrix
    % Inspired by a script from Andrew Bliss on MATLAB Central, nice!
    % http://www.mathworks.com/matlabcentral/fileexchange/8722-rotate-tick-label
    set(gca, 'XTickLabel', []); % Clear original x ticks, replace with text command
    xVals = 1:N;
    yVals = repmat(N + (.1 * N), N, 1);
    text(xVals, yVals, classList, 'HorizontalAlignment', 'right', 'rotation', 30, 'FontWeight', 'bold');
    set(gca, 'FontWeight', 'bold');

    % Shift over and up a bit, to make room for axis labels and legend
    set(gca, 'OuterPosition', [0 .05 1 1]);

    xLabelPosition = get(get(gca, 'XLabel'), 'Position');
    xLabelPosition(2) = N + (.25 * N); % Set position of x label lower than normal
    xlabel('Predicted Labels', 'FontSize', 15, 'FontWeight', 'bold', 'Position', xLabelPosition);
    ylabel('True Labels', 'FontSize', 15, 'FontWeight', 'bold');
    title(sprintf('Accuracy=%f %%',Acc*100))
    colorbar;    colormap cool
end