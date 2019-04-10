%bp.m​

%处理数据

clear

close all

echo on  %窗口响应执行过程

clc

pause

a=xlsread('learn.xls',1,'A2:A301');%样本时间序号

a1=xlsread('learn.xls',1,'A7:A301');%预测时间序号

b=xlsread('learn.xls',1,'C2:C301');%读取指数

for i=1:1:295

    y(i)=b(i+5);%理想输出

end       

for i=1:1:295

    for j=1:1:5

        x(j,i)=b(i+j-1);%输入

    end

end

a

x    %以前五日预测明天的大盘指数的输入矩阵

y    %理想的输出

%pause

[xn,minx,maxx,yn,miny,maxy]=premnmx(x,y) %数据归一化处理

xn

yn

%pause

tic;

%建立神经网络

net=newff(minmax(xn),[11,1],{'tansig','purelin'},'trainlm');

net.trainparam.show=50;    %显示迭代过程

net.trainparam.lr=0.5;    %学习率

net.trainparam.epochs=1000; %最大训练次数

net.trainparam.goal=1e-3;  %训练要求精度

net.trainparam.mc=0;     %动量因子

 [net,tr]=train(net ,xn,yn); %训练bp网络

t = toc;

t

pause

inputWeights=net.iw{1,1} %输入层权值

inputbias=net.b{1}      %输入层阈值

layerWeights=net.lw{2,1} %输出层权值

layerbias=net.b{2}       %输出层阈值

%对网络仿真预测

On = sim (net ,xn);

E=On-yn %计算误差

M=sse(E) 

N=mse(E)

%pause

 

a2=postmnmx(On,miny,maxy)

plot(a1,xn)

title('归一化处理后的样本','FontSize',12);

xlabel('统计时间2014.9.6-2015.11.10','FontSize',10);

ylabel('归一化后的上证指数','FontSize',10);

figure;

plot(a1,yn)

plot(a,b,'*');

title('上证指数预测收盘价格','FontSize',12);

xlabel('统计时间2014.9.1-2015.11.10','FontSize',10);

ylabel('上证指数','FontSize',10);

hold on

plot(a1,a2,'r+');

legend('实际值','r预测值');

echo off

pause 

clc
