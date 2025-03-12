clear all 
clc
SearchAgents_no=30; 
Max_iteration=100; 
Function_name='F1'; 
[lb,ub,dim,fobj]=Get_Functions_details(Function_name);
[RDChimp_score,~,RDChimp_curve]=RDChimp(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
display(['The best optimal value of the objective funciton found by RDChimp is : ', num2str(RDChimp_score)]);
figure('Position',[500 500 660 290],'WindowState', 'maximized')
semilogy(RDChimp_curve, 'color',[0, 0, 0], 'LineWidth', 2)
title(sprintf('函数名：%s', Function_name), 'FontSize', 14, 'FontWeight', 'bold')
xlabel('迭代次数', 'FontSize', 14, 'FontWeight', 'bold')
ylabel('最优值', 'FontSize', 14, 'FontWeight', 'bold')
xticks([0 100 200 300 400 500]);
grid on
box on
legend('RDChOA', 'FontSize', 10, 'Location', 'northeast')
set(gcf, 'Color', 'w');


