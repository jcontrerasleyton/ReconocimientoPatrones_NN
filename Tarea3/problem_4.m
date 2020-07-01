function [best_vp,best_net] = problem_4(num,net_type,m_data,m_target,units)

mkdir('Plots/Problem_4');
fileID = fopen('Plots/Problem_4/results.csv','a');
fileID2 = fopen('Plots/Problem_4/prom_mse.csv','a');
fileID3 = fopen('Plots/Problem_4/prom_c.csv','a');

fprintf(fileID,'\nProblem 4.%d: \n',num);
fprintf(fileID2,'\nProblem 4.%d: \n',num);
fprintf(fileID3,'\nProblem 4.%d: \n',num);

fprintf(fileID,'iteration;p;c_p;trp;c_tr;vp;c_val;tsp;c_ts;ne;be\n');
fprintf(fileID2,'p_mean;p_std;trp_mean;trp_std;vp_mean;vp_std;tsp_mean;tsp_std\n');
fprintf(fileID3,'cp_mean;cp_std;ctr_mean;ctr_std;cval_mean;cval_std;cts_mean;cts_std\n');

p_p = []; trp_p = []; vp_p = []; tsp_p = []; %Performance por conjunto
c_pp = []; c_trp = []; c_valp = []; c_tsp = []; %Porcentaje de clasificación por conjunto

best_vp0 = -Inf; best_net = patternnet(1); %Inicialización variables y red

for c = 1:10
    %Simulación red neuronal
    [p,c_p,trp,c_tr,vp,c_val,tsp,c_ts,ne,be,net] = Neural_Network(net_type,m_data,m_target,0,0,units);
    
    %Resultados
    fprintf(fileID,'%d;%f;%f;%f;%f;%f;%f;%f;%f;%d;%d\n',c,p,c_p,trp,c_tr,vp,c_val,tsp,c_ts,ne,be);
    
    %Agrupamiento 10 simulaciones
    p_p = [p_p p]; trp_p = [trp_p trp]; vp_p = [vp_p vp]; tsp_p = [tsp_p tsp];
    c_pp = [c_pp c_p]; c_trp = [c_trp c_tr]; c_valp = [c_valp c_val]; c_tsp = [c_tsp c_ts];  
    
    folder = sprintf('Plots/Problem_4/Problem_4.%d/Iteration_%d',num,c);
    file_maker(folder);
    
    [best_vp0,best_net] = min(c_val,net,best_vp0,best_net); %Mejor red
end

%Promedio y desviación estandar de 10 simulaciones (Performance)
fprintf(fileID2,'%f;%f;%f;%f;%f;%f;%f;%f\n',...
    mean(p_p),std(p_p),mean(trp_p),std(trp_p),mean(vp_p),std(vp_p),mean(tsp_p),std(tsp_p));

%Promedio y desviación estandar de 10 simulaciones (Clasificación)
fprintf(fileID3,'%f;%f;%f;%f;%f;%f;%f;%f\n',...
    mean(c_pp),std(c_pp),mean(c_trp),std(c_trp),mean(c_valp),std(c_valp),mean(c_tsp),std(c_tsp));
    
best_vp = mean(c_valp); %Mejor tasa de clasificación

fclose('all');

end

%Genera Gráficos y Tablas
function file_maker(folder_name)
    name = {'roc','confusion','error','training','performance'};
    mkdir(sprintf('%s',folder_name)); 
    h = findobj('Type', 'figure');
    for k = 1:numel(h)
        if(k<6)
            print(sprintf('%s/%s',folder_name,name{k}),h(k),'-dpng')
        end
    end;
    close all
end

%Obtiene mejor porcentaje de clasificación.
function [a,b] = min(first,value,best,best_value)
    if(first > best)
        best = first;
        best_value = value;
    end
    a = best; b = best_value;
end