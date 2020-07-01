function [best_vp,best_unit,best_net] = problem_2_3(num,net_type,m_data,m_target,best_momentum,best_lr)

mkdir (sprintf('Plots/Problem_%d',num));
fileID = fopen(sprintf('Plots/Problem_%d/results.csv',num),'w');
fileID2 = fopen(sprintf('Plots/Problem_%d/prom_mse.csv',num),'w');
fileID3 = fopen(sprintf('Plots/Problem_%d/prom_c.csv',num),'w');

fprintf(fileID,'\nProblem %d: \n',num);
fprintf(fileID2,'\nProblem %d: \n',num);
fprintf(fileID3,'\nProblem %d: \n',num);

fprintf(fileID,'iteration;units;learning_rate;momentum;p;c_p;trp;c_tr;vp;c_val;tsp;c_ts;ne;be\n');
fprintf(fileID2,'units;learning_rate;momentum;p_mean;p_std;trp_mean;trp_std;vp_mean;vp_std;tsp_mean;tsp_std\n');
fprintf(fileID3,'units;learning_rate;momentum;cp_mean;cp_std;ctr_mean;ctr_std;cval_mean;cval_std;cts_mean;cts_std\n');

lunit = [0 6 12 16]; %Unidades de capa oculta

best_unit = 0; best_vp = -Inf; best_vp1 = -Inf; %Inicialización variables
best_net = patternnet(1); best_net0 = patternnet(1); %Inicialización redes

for units = lunit
    p_p = []; trp_p = []; vp_p = []; tsp_p = []; %Performance por conjunto
    c_pp = []; c_trp = []; c_valp = []; c_tsp = []; %Porcentaje de clasificación por conjunto
    best_vp0 = -Inf;
    for c = 1:10
        %Simulación red neuronal
        [p,c_p,trp,c_tr,vp,c_val,tsp,c_ts,ne,be,net] = Neural_Network(net_type,m_data,m_target,best_momentum,best_lr,units);
        
        %Resultados
        fprintf(fileID,'%d;%d;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f;%d;%d\n',c,units, ...
            best_lr,best_momentum,p,c_p,trp,c_tr,vp,c_val,tsp,c_ts,ne,be);
        
        %Agrupamiento 10 simulaciones
        p_p = [p_p p]; trp_p = [trp_p trp]; vp_p = [vp_p vp]; tsp_p = [tsp_p tsp];
        c_pp = [c_pp c_p]; c_trp = [c_trp c_tr]; c_valp = [c_valp c_val]; c_tsp = [c_tsp c_ts];  
        
        folder = sprintf('Plots/Problem_%d/m_%.1f_lr_%.3f_unit_%d/Iteration_%d',num,best_momentum,best_lr,units,c);
        file_maker(folder);
    
        [best_vp0,best_net0] = min(c_val,net,best_vp0,best_net0); %Mejor red
    end
    
    %Promedio y desviación estandar de 10 simulaciones (Performance)
    fprintf(fileID2,'%d;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f\n',units,best_lr,best_momentum, ...
        mean(p_p),std(p_p),mean(trp_p),std(trp_p),mean(vp_p),std(vp_p),mean(tsp_p),std(tsp_p));
    
    %Promedio y desviación estandar de 10 simulaciones (Clasificación)
    fprintf(fileID3,'%d;%f;%f;%f;%f;%f;%f;%f;%f;%f;%f\n',units,best_lr,best_momentum, ...
        mean(c_pp),std(c_pp),mean(c_trp),std(c_trp),mean(c_valp),std(c_valp),mean(c_tsp),std(c_tsp));
    
    [best_vp,best_unit] = min(mean(c_valp),units,best_vp,best_unit); %Mejor cantidad unidades
    [best_vp1,best_net] = min(mean(c_valp),best_net0,best_vp1,best_net); %Mejor red
end

fprintf(fileID3,'\nbest_unit;best_vp\n');
fprintf(fileID3,'%f;%f\n',best_unit,best_vp);

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