clc;
clear;
close all;

% t0 = 0;%图像最小值
% y0 = 0;
% 
% ta =0.2997;%计算图像中值
% t1 = 0.7;%固定
% ya = 0.3;
% y1 = 1;
% 
% %下面几个参数，重点理解下
% g0 = 0.1;
% gf = 1;
% gb =7 ;
% gs =1 ;
% g1 =0.3;

t0 = 0;%图像最小值
y0 = 0;

ta =0.2997;%计算图像中值
t1 = 0.7;%固定

ya = 0.3;%越大，增强部分提升越大，抑制部分，压缩更小
y1 = 1;

%下面几个参数，重点理解下
g0 = 0.1;%越大，增强部分不变，抑制部分，压缩更小
gf = 1;%越大，增强部分不变，抑制部分，压缩更大

gb =7; %越大，增强部分越大，抑制部分，压缩更大

gs =1 ;%越大，增强部分越大，抑制不变
g1 =0.3;%越大，增强部分越小，抑制不变




% t0 = stGradingProcPara.t0;
% y0 = stGradingProcPara.y0;
%
% ta = stGradingProcPara.ta;
% ya = stGradingProcPara.ya;%越大，增强部分提升越大，抑制部分，压缩更小
%
% t1 = stGradingProcPara.t1;
% y1 = stGradingProcPara.y1;
%
% g0 = stGradingProcPara.g0;%越大，增强部分不变，抑制部分，压缩更小
% gf = stGradingProcPara.gf;%越大，增强部分不变，抑制部分，压缩更大
% gb = stGradingProcPara.gb;%越大，增强部分越大，抑制部分，压缩更大
% gs = stGradingProcPara.gs;%越大，增强部分越大，抑制不变
% g1 = stGradingProcPara.g1;%越大，增强部分越小，抑制不变

%防止t0越界
t0l = ta-(ya-y0)/gf;
t0u = ta-(ya-y0)/gb;
t0 = min(max(t0, t0l), t0u);

%防止t1越界
t1l = ta - (y1-ya)/gb;
t1u = ta+(y1-ya)/gs;
t1 = min(max(t1, t1l), t1u);

wf = ((ta-t0)*gb-ya+y0)/(gb-gf);
hf = wf*gf;

ws = ((t1-ta)*gb-y1+ya)/(gb-gs);
hs = ws*gs;

tf = t0+wf;
ts = t1-ws;

S_Lut=zeros(1,1001);
for h=0:0.001:1
    cnt=int16(h/0.001)+1;
    if(h<=t0)
        S_Lut(1,cnt)=y0;
    end
    if(h>t0&&h<=tf)
        x=(h-t0)/wf;
        g0f = g0*wf/hf;
        pf = (1-gb*wf/hf)/log(g0f);
        data = x*(power(g0f, 1-power(x, pf)));       
        S_Lut(1,cnt)=y0+hf*data;
    end
    if (h>tf&&h<=ts)
        x=h-tf;
        S_Lut(1,cnt)=y0+hf+gb*x;
    end
    if(h>ts&&h<=t1)
        x=(t1-h)/ws;
        g1s = g1*ws/hs;
        ps = (1-gb*ws/hs)/log(g1s);
        data =x*(power(g1s, 1-power(x, ps)));       
        S_Lut(1,cnt)=y1-hs*data;        
    end
    if(h>t1)
        S_Lut(1,cnt)=y1;
    end
end

h=0:0.001:1;
plot(h,S_Lut,"r")
hold on



test
test