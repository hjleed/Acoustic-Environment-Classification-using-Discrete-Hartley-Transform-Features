
function main()
% "Acoustic Environment Classification using Discrete Hartley Transform Features"
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

numfolds  =5;
addpath([pwd filesep 'evaluation_2013']);
[confusionMat1, AccFolds1, Acc1, Std1] = evaluation2013(numfolds, 'foldsGTlist13.txt', 'Hfoldsrestlist13.txt');
numfolds  =4;
addpath([pwd filesep 'evaluation_setup2016']);
[confusionMat2, AccFolds2, Acc2, Std2] = evaluation2016(numfolds, 'foldsGTlist16.txt', 'Hfoldsrestlist16.txt');