function activateWCS(mws,SetNormal,SetOrigin,SetUVector,Activate)
%ACTIVATEWCS 激活坐标系
%   此处显示详细说明

%SetNormal = [0 0 1]
%SetOrigin = [0 0 0]
%SetUVector = [1 0 0]
%Activate = 1 or 0;


if Activate == 1
WCS = invoke(mws,'WCS');
invoke(WCS,'ActivateWCS','local');
invoke(WCS,'SetNormal',num2str(SetNormal(1)),num2str(SetNormal(2)),num2str(SetNormal(3)));
invoke(WCS,'SetOrigin',num2str(SetOrigin(1)),num2str(SetOrigin(2)),num2str(SetOrigin(3)));
invoke(WCS,'SetUVector',num2str(SetUVector(1)),num2str(SetUVector(2)),num2str(SetUVector(3)));
end
if Activate == 0
  WCS = invoke(mws,'WCS');
  invoke(WCS,'ActivateWCS','Global'); 
end


end

