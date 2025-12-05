close all;
clear;
clc;

data = CSTSparameterProcess('E:\seu\PNN\屎\unit\Export\data3.txt');
Ismerge = 1;
IsUnwrap = 1;

figure;
CSTSPhaseDrawer(data,Ismerge,IsUnwrap);
legend("编码1","编码2","编码3","编码4","编码5","编码6","编码7","编码8");
figure;
CSTSAmpDrawer(data,Ismerge);
legend("编码1","编码2","编码3","编码4","编码5","编码6","编码7","编码8");
