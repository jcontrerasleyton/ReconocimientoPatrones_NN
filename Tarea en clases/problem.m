function [best_vp,best_net] = problem(net_type,m_data,m_target,momentum,lrate)

mkdir('Plots/Problem');
fileID = fopen('Plots/Problem/results.csv','w');
fileID2 = fopen('Plots/Problem/prom_mse.csv','w');
fileID3 = fopen('Plots/Problem/prom_c.csv','w');

fprintf(fileID,'\nProblem 1: \n');
fprintf(fileID2,'\nProblem 1: \n');
fprintf(fileID3,'\nProblem 1: \n');

fprintf(fileID,'Iteration;units;p;c_p;trp;c_tr;vp;c_val;tsp;c_ts;ne;be\n');
fprintf(fileID2,'Units;p_mean;p_std;trp_mean;trp_std;vp_mean;vp_std;tsp_mean;tsp_std\n');
fprintf(fileID3,'Units;cp_mean;cp_std;ctr_mean;ctr_std;cval_mean;cval_std;cts_mean;cts_std\n');

best_vp = -Inf;  %Inicializacion variables
best_net = patternnet(1); best_net0 = patternnet(1); %Inicializacion redes

p_p = []; trp_p = []; vp_p = []; tsp_p = []; %Performance por conjunto
c_pp = []; c_trp = []; c_valp = []; c_tsp = []; %Porcentaje de clasificacion por conjunto

%for u = 10:50:300
for u = 10:10
    best_vp0 = -Inf;
    for c = 1:1
        %Simulacion red neuronal
        [p,c_p,trp,c_tr,vp,c_val,tsp,c_ts,ne,be,net] = Neural_Network(net_type,m_data,m_target,momentum,lrate,u);
        
        %Resultados
        fprintf(fileID,'%d;%d;%f;%f;%f;%f;%f;%f;%f;%f;%d;%d\n',c,units,p,c_p,trp,c_tr,vp,c_val,tsp,c_ts,ne,be);
        
        %Agrupamiento 10 simulaciones
        p_p = [p_p p]; trp_p = [trp_p trp]; vp_p = [vp_p vp]; tsp_p = [tsp_p tsp];  
        c_pp = [c_pp c_p]; c_trp = [c_trp c_tr]; c_valp = [c_valp c_val]; c_tsp = [c_tsp c_ts];  
        
        folder = sprintf('Plots/Problem/Units_%d/Iteration_%d',u,c);
        file_maker(folder);
        
        [best_vp0,best_net0] = min(c_ts,net,best_vp0,best_net0); %Mejor red
    end
    
    %Promedio y desviacion estandar de 10 simulaciones (Performance)
    fprintf(fileID2,'%d;%f;%f;%f;%f;%f;%f;%f;%f\n',u, ...
        mean(p_p),std(p_p),mean(trp_p),std(trp_p),mean(vp_p),std(vp_p),mean(tsp_p),std(tsp_p));

    %Promedio y desviacion estandar de 10 simulaciones (Clasificacion)
    fprintf(fileID3,'%d;%f;%f;%f;%f;%f;%f;%f;%f\n',u, ...
        mean(c_pp),std(c_pp),mean(c_trp),std(c_trp),mean(c_valp),std(c_valp),mean(c_tsp),std(c_tsp));

    [best_vp,best_net] = min(mean(c_tsp),best_net0,best_vp,best_net); %Mejor red
end
    
fclose('all');

end

%Genera Graficos y Tablas
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

%Obtiene mejor porcentaje de clasificacion.
function [a,b] = min(first,value,best,best_value)
    if(first > best)
        best = first;
        best_value = value;
    end
    a = best; b = best_value;
end