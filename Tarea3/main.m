function main()

%Lectura archivos
[m_data,m_target,m_data1,m_data2,data_tst,data_tst1,data_tst2] = lectura();

fclose('all');
mkdir 'Plots/'
rmdir 'Plots/' s

%---------------------Problem 1 (Momentum 0.0 vs 0.9)---------------------
[best_vp1,best_lr1,best_net1] = problem_1(1,'traingdm',m_data,m_target,0); %Momentum 0 
[best_vp2,best_lr2,best_net2] = problem_1(2,'traingdm',m_data,m_target,0.9); %Momentum 0.9

%Calculo mejor tasa de aprendizaje y momentum
best_lr = best_lr1;
best_momentum = 0;
if(best_vp2 > best_vp1)
    best_lr = best_lr2;
    best_momentum = 0.9;
end

fileID = fopen('Plots/Problem_1/prom_c.csv','a');
fprintf(fileID,'\nbest_lr;best_momentum\n');
fprintf(fileID,'%f;%f \n',best_lr,best_momentum);
fclose(fileID);

%---------------------Problem 2 (Unidades Gradiente Descendiente)---------------------
[best_vp3,best_unit1,best_net3] = problem_2_3(2,'traingdm',m_data,m_target,best_momentum,best_lr);

%---------------------Problem 3 (Unidades Levenberg-Marquardt)---------------------
[best_vp4,best_unit2,best_net4] = problem_2_3(3,'trainlm',m_data,m_target,0,0);

%---------------------Mejor entre 2 y 3---------------------
best_unit = best_unit1;
if(best_vp4 > best_vp3)
    best_unit = best_unit2;
end

%---------------------Problem 4 (Arquitectura [29+5] vs [29+5+5])---------------------
[best_vp5,best_net5] = problem_4(1,'trainlm',m_data1,m_target,best_unit);
[best_vp6,best_net6] = problem_4(2,'trainlm',m_data2,m_target,best_unit);

%Calculo mejor capa de entrada
best_input = 34;
if(best_vp6 > best_vp5)
    best_input = 39;
end

fileID = fopen('Plots/Problem_4/prom_c.csv','a');
fprintf(fileID,'\nbest imput: %d\n',best_input);
fclose(fileID);


%---------------------Problem 5 (Clasificacion tst.txt con mejor red)---------------------

best = [best_vp1 best_vp2 best_vp3 best_vp4 best_vp5 best_vp6];
best_n = max(best);

if(best_n == best_vp1)
    out = sim(best_net1, data_tst');
elseif(best_n == best_vp2)
    out = sim(best_net2, data_tst');
elseif(best_n == best_vp3)
    out = sim(best_net3, data_tst');
elseif(best_n == best_vp4)
    out = sim(best_net4, data_tst');
elseif(best_n == best_vp5)
    out = sim(best_net5, data_tst1');
elseif(best_n == best_vp6)
    out = sim(best_net6, data_tst2');
end

%Umbral de decision 0.5
for i = 1:length(out)
    num = abs(out(i:i));
    if(num >= 0.5)
        out(i:i) = 1;
    else
        out(i:i) = 0;
    end
end

mkdir('Plots/Problem_5/');
dlmwrite('Plots/Problem_5/tst_labels.txt',out');

end


