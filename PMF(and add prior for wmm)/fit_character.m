






clc;clear;close all;
restoredefaultpath;
addpath(genpath(pwd));

ps = defaultps;
load(ps.libname,'lib');

args=[];
mlib =lib;
args.lib = mlib;


%  can be: perfect, bg_noise, boundary_box, box_occlusion, grid_lines, line_clutter, or line_deletion
args.imperfection='perfect';  
%args.imperfection='output_saltpepper_noise_10_test';
%args.imperfection='output_patches_noise_10_test';
%args.imperfection='output_grid_noise_10_test';
%args.imperfection='output_detection_noise_10_test';

%args.imperfection='saltpepper_noise';  
%args.imperfection='patches_noise';
%args.imperfection='grid_noise';
%args.imperfection='deletion_noise';
%args.imperfection='clutter_noise';
%args.imperfection='border_noise';
 

args.usePretrain=false;
args.intensity=1;       %%% 0,1,2                                                    %%%%%%%%%  Here the noise's intensity.
args.verbose=true;
args.lambda=2.0;
args.numTrains=1; % 1-shot
args.numRuns=1; % 1 is for quick evaluation. It is 50 in the paper.      %%% numrun10 = 10;        
args.iterationTol=100; % 50 is for quick evaluation. It is 1000 in the paper. 
args.fastTraining=true;% 'true' is for quick evaluation. It is 'false' in the paper.  

% 1-shot
args.maxInk=6; % width   。。
args.maxGlobalShift=60; % global location。。
args.maxLocalShift=5; % local location。。
args.maxGlobalScale=2.5; % affine 。。
args.maxLocalScale=1.1; 
args.maxGlobalRotation=90; %。。
args.maxLocalRotation=20;  %。。
args.control=5; % shape

assert(0==args.intensity||1==args.intensity||2==args.intensity);   
if strcmp(args.imperfection,'perfect')
    testFolder = 'PMF_one-shot-classification_data/test'  
    %testFolder = 'data/MNIST_mini/testing'
    resultFolder='output/character/perfect'
else
    testFolder = ['PMF_one-shot-classification_noise/',...
        args.imperfection,'/',num2str(args.intensity)]      % ???????? args.imperfection ???????????? 'noise'????args.intensity ???????????? 50??????ò×????????????????????????????????????·???????? 'data/noisyMNIST_tests_mini/noise/50'
                                                            % testFolder = ['data/noisyMNIST_tests_mini/',...args.imperfection,'/',num2str(args.intensity)]  
    resultFolder=['output/character/',args.imperfection,'/',num2str(args.intensity)]
end

if 7~=exist(resultFolder,'dir')
    mkdir(resultFolder);
end

%parpool('local',5);
verbose=args.verbose;

trainFolder='PMF_one-shot-classification_data/train';     
%trainFolder='data/MNIST_mini/training';
logTime=datestr(now,'yyyymmdd-HHMMSS');

numRuns=args.numRuns;
numTrains=args.numTrains;

argsModeler=args;
args.logTime=logTime;

numTests=1;
numClasses=3;             %%%%%%%%%%%%%%%%%% 10 clasess.
Rs=cell(numRuns,1);

resultFileName=[resultFolder,'/pmf-',logTime,'.mat'];
wrongs=-Inf(numRuns,numTests);

usePretrain=args.usePretrain;
if usePretrain
    assert(false);
    load('data/premodels100.mat','premodels');
    premodels=premodels;
end

%parfor iRun=1:numRuns  

for iRun=1:numRuns  % numRuns = 1
    R=[];
    if usePretrain
        models=premodels(:,(iRun-1)*numTrains+1:iRun*numTrains);
    else
        models=cell(numClasses,numTrains);   % 10 x 1的一个cell数组
        fprintf('\nRun%d Training...\n',iRun);
        for iClass=1:numClasses    % 从1-10循环
            imfolder=dir(fullfile(trainFolder,num2str(iClass-1)));  % Imfolder 表示的就是图片文件夹所在的路径
            if verbose
                fprintf('\nRun%d Class%d: ',iRun,iClass);
            end
            for iTrain=1:numTrains   % numTrains = 1
                modelWithName=[];                                     % MATLAB中的数组索引从1开始而非从0开始，因此imfolder(3)对应的是结构体数组中的第三个元素，而不是第二个。
                imFullName=imfolder(2+(iRun-1)*numTrains+iTrain);     % imFullName=imfolder(2+(iRun-1)*numTrains+iTrain); 这个 2+(iRun-1)*numTrains+iTrain：是索引。 imFullName将包含指定目录下第2+(iRun-1)*numTrains+iTrain个图片的完整路径和文件名。 这里应该是从图片文件0的第3的一个图片索引。但是为什么是第3个图片呢？？
                modelWithName.imname=imFullName.name;              
                img=imread(fullfile(trainFolder,num2str(iClass-1),modelWithName.imname));  % fullfile(trainFolder,num2str(iClass-1)：'data\character\trainning\0'。modelWithName：'10093.bmp'
                
                img=imcomplement(img);  %%%%%%
                
                %img=imresize(img,[65,65]);
                %img=imresize(img,[75,75]);
                
               % img=padarray(img,[15,15]);
                %img(img<128)=0;    % 将所有像素值小于128的像素置为0。    感觉这里可以改成将小于200像素的点都变为0. 
                %img(img>=128)=1;   % 将所有像素值大于等于128的像素置为1。
                
                %img(img<100)=0;
                %img(img>=100)=1;
                
               % img(img<50)=0;
                %img(img>=50)=1;
                
                img=logical(img);  % 将一个灰度图像img转换为逻辑图像。代码中的logical函数将像素值非零的像素转换为1，像素值为零的像素转换为0。因此，执行该代码后，所有非零的像素将变为1，所有为零的像素将变为0。需要注意的是，将灰度图像转换为逻辑图像会丢失一部分信息，因为逻辑图像只能表示像素值为0或1的图像。
                
                modelWithName.model=fit_motorprograms(img,1,true,true,args.fastTraining);
                
                close all;
                models{iClass,iTrain}=modelWithName;
                if verbose
                    fprintf(1,'Train%d ',iTrain);
                end
            end
            
        end
        R.models=models;
        
    end
       
    args
     
    Ts=cell(numTests,numClasses);
   
    
    
    
    for iTest=1:numTests
        wrong=0;
        fprintf('\nRun%d Testing...\n',iRun);
        for iClass=1:numClasses
            T=Modeler.runTesting(iRun,numTests,models,iClass,iTest,testFolder,argsModeler,verbose);
            wrong=wrong+T.wrong;
            Ts{iTest,iClass}=T;
        end
        wrongs(iRun,iTest)=wrong;
        R.Ts=Ts;
        Rs{iRun}=R;
     
        args
        fprintf(resultFileName,['\niRun=',num2str(iRun),...
            ' iTest=',num2str(iTest),...
            ' wrongOfThisTest=',num2str(wrong),'\n\n']);
        
    end
    
end

wrongs_=wrongs(wrongs>-1);
accuracy=1-mean(wrongs_)/numClasses;
deviation=std(wrongs_,1)/numClasses;

fprintf(['\n\ndeviation=',num2str(deviation),...
    ' accuracy=',num2str(accuracy),'\n\n']);

save(resultFileName);
fprintf(['saved to ',resultFileName,'\n']);

