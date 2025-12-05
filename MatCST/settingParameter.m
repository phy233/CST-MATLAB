function settingParameter(mws,paraName,paraValue)
%SETTINGPARAMETER 设定参数值
%   

% 1. 预处理：判断传入的是数字还是字符串
    if isnumeric(paraValue)
        % 如果是数字，转为字符串，建议保留足够精度
        valStr = sprintf('%.4f', paraValue);
    else
        % 如果已经是字符串（比如 '5*a'），直接用
        valStr = char(paraValue);
    end

    % 2. 构造标准的 VBA 命令行
    % 注意：CST VBA 中，StoreParameter 的第一个参数要加双引号
    % 第二个参数如果是数字可以不加，如果是表达式最好加，为了保险我们都加上双引号
    vba_cmd = sprintf('StoreParameter "%s", "%s"', paraName, valStr);

    % 3. 通过 AddToHistory 发送指令
    % 这样 MATLAB 只需要负责传字符串，不用关心 StoreParameter 的参数类型定义
    mws.invoke('AddToHistory', ['Set Param: ' paraName], vba_cmd);
end

