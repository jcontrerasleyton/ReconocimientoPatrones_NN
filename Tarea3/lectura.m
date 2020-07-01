function [m_data,m_target,m_data1,m_data2,data_tst,data_tst1,data_tst2] = lectura()

%----------------------------------
list = {'./tr.txt', './va.txt', './ts.txt'};
data_tst = importdata('./tst.txt','\t',0);

m_data = []; m_data1 = []; m_data2 = []; data_tst1 = []; data_tst2 = [];
m_target = [];

%-------Concatenación conjuntos de datos-------
for c = list
    file = c{:};
    matrix = importdata(file,'\t',0);
    
    data = matrix(:,1:end-1);
    target = matrix(:,end);
    
    m_data = vertcat(m_data, data);
    m_target = vertcat(m_target, target);
end

%---------------(29+5, 29+5+5)----------------
[m_data1,m_data2] = new_matrix(m_data);

%---------------tst(29+5, 29+5+5)----------------
[data_tst1,data_tst2] = new_matrix(data_tst);

end

function [m1,m2] = new_matrix(m)
m1 = [m abs(m(:,13)-m(:,17))];
m1 = [m1 abs(m(:,14)-m(:,18))];
m1 = [m1 abs(m(:,14)-m(:,17))];
m1 = [m1 abs(m(:,14)-m(:,24))];
m1 = [m1 abs(m(:,14)-m(:,20))];
%--------------------------
m2 = [m1 abs(m(:,13)-m(:,24))];
m2 = [m2 abs(m(:,13)-m(:,12))];
m2 = [m2 abs(m(:,13)-m(:,20))];
m2 = [m2 abs(m(:,13)-m(:,23))];
m2 = [m2 abs(m(:,13)-m(:,13))];
end