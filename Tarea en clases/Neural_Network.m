function [p,corr_p,trp,corr_tr,vp,corr_val,tsp,corr_ts,ne,be,net] = Neural_Network(net_type, train_data, train_target, momentum, lr, layers)
% Solve a Pattern Recognition Problem with a Neural Network
% Script generated by Neural Pattern Recognition app
% Created 27-Oct-2017 19:34:32
%
% This script assumes these variables are defined:
%
%   train_data - input data.
%   train_target - target data.

%x = train_data';
%t = train_target';

x = train_data;
t = train_target;

% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
%trainFcn = 'trainlm';  % Scaled conjugate gradient backpropagation.

% Create a Pattern Recognition Network
if(layers > 0)
    hiddenLayerSize = layers;
else
    hiddenLayerSize = [];
end
net = patternnet(hiddenLayerSize);
net.trainFcn = net_type; 

%Params
net.trainParam.epochs = 5000;
net.trainParam.mc = momentum;
net.trainParam.lr = lr; 
net.trainParam.show = 100;
net.trainParam.goal = 0.01; 

% Hiden and Output functions
if(layers > 0)
    net.biases{1}.learnFcn = 'learngdm';
    net.layers{1}.transferFcn = 'tansig'; % Hiden Layers tranfer function
    net.layers{2}.transferFcn = 'purelin'; % Output Layer transfer function
else
    net.layers{1}.transferFcn = 'purelin'; % Output Layer transfer function
end

% Choose Input and Output Pre/Post-Processing Functions
% For a list of all processing functions type: help nnprocess
net.input.processFcns = {'removeconstantrows','mapminmax'};
net.output.processFcns = {'removeconstantrows','mapminmax'};

% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivide
net.divideFcn = 'dividerand';  % Divide data by block
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
net.performFcn = 'mse';  % Mean Squared Error

% Choose Plot Functions
% For a list of all plot functions type: help nnplot
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotconfusion', 'plotroc'};

% Train the Network
[net,tr] = train(net,x,t);

% Test the Network
y = net(x);
e = gsubtract(t,y);
performance = perform(net,t,y);
tind = vec2ind(t);
yind = vec2ind(y);
percentErrors = sum(tind ~= yind)/numel(tind);

% Recalculate Training, Validation and Test Performance
trainTargets = t .* tr.trainMask{1};
valTargets = t .* tr.valMask{1};
testTargets = t .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,y);
valPerformance = perform(net,valTargets,y);
testPerformance = perform(net,testTargets,y);

%Tasa de acierto
[c_p,cm,ind,per] = confusion(t,y);
corr_p = 1-c_p;

[c_tr,cm,ind,per] = confusion(trainTargets,y);
corr_tr = 1-c_tr;

[c_val,cm,ind,per] = confusion(valTargets,y);
corr_val = 1-c_val;

[c_ts,cm,ind,per] = confusion(testTargets,y);
corr_ts = 1-c_ts;

%Error
e1 = gsubtract(trainTargets,y);
e2 = gsubtract(valTargets,y);
e3 = gsubtract(testTargets,y);

p = performance;
trp = trainPerformance;
vp = valPerformance;
tsp = testPerformance;
tr = tr;
ne = tr.num_epochs;
be = tr.best_epoch;

% View the Network
%view(net)

%Plots
h = figure;
h; plotperform(tr);
set(h, 'Visible', 'off');

h = figure;
h; plottrainstate(tr);
set(h, 'Visible', 'off');

h = figure;
h; ploterrhist(e1,'Training',e2,'Validation',e3,'Test');
set(h, 'Visible', 'off');

h = figure;
h; plotconfusion(trainTargets,y,'Training',valTargets,y,'Val',testTargets,y,'Test',t,y,'All');
set(h, 'Visible', 'off');

h = figure;
h; plotroc(trainTargets,y,'Training',valTargets,y,'Val',testTargets,y,'Test',t,y,'All');
set(h, 'Visible', 'off');

% Deployment
% Change the (false) values to (true) to enable the following code blocks.
% See the help for each generation function for more information.
if (false)
    % Generate MATLAB function for neural network for application
    % deployment in MATLAB scripts or with MATLAB Compiler and Builder
    % tools, or simply to examine the calculations your trained neural
    % network performs.
    genFunction(net,'myNeuralNetworkFunction');
    y = myNeuralNetworkFunction(x);
end
if (false)
    % Generate a matrix-only MATLAB function for neural network code
    % generation with MATLAB Coder tools.
    genFunction(net,'myNeuralNetworkFunction','MatrixOnly','yes');
    y = myNeuralNetworkFunction(x);
end
if (false)
    % Generate a Simulink diagram for simulation or deployment with.
    % Simulink Coder tools.
    gensim(net);
end
