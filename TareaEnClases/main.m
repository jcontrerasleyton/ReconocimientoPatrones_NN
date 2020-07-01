%Lectura archivos
%tr = csvread('train.csv', 1, 0);
load('tr.mat')

%for i = 1:10
%    a = reshape(data(i,:,:),[28 28]);
%    imshow(a');
%end

n = size(tr, 1);
targets = tr(:,1);
targets(targets == 0) = 10;
targetsd = dummyvar(targets);
inputs = tr(:,2:end);

inputs = inputs';
targets = targets';
targetsd = targetsd';

%---------------------Entrenamiento---------------------
fclose('all');
mkdir 'Plots/'
rmdir 'Plots/' s

[best_vp1,best_net] = problem('trainlm',inputs,targetsd,0,0); 

ts = csvread('test.csv', 1, 0);
out = sim(best_net, ts');

[M,I] = max(out);

dlmwrite('Plots/ts_lab.txt',out');
dlmwrite('Plots/ts_labels.txt',I');

