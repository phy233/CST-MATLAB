clear;
close all;
clc;

fileaddr = 'E:\seu\10.1002adom.202001609\array_test.cst';

mws = initializeCSTproj(fileaddr);

arrayModeling(mws,unitParamsTest, codingMatrixTest);
