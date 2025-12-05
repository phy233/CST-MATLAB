classdef unitParamsTest

    % --- 常量属性 (Constant) ---
    % 这些值在所有实例中都是一样的，不可修改
    properties(Constant)
        unitSize = [13 13 3];
        freq = 8e9;
        codeNum = 4;
    end

    % --- 普通属性 (Properties) ---
    % 这里只定义变量名，或者赋简单的初始值
    properties
        % 建议使用 Cell Array ({}) 存储字符串，
        % 因为如果有多个控制参数（如 {'ly1', 'ly2'}），Cell 更通用
        controlParam = {'ly1'}; 
        
        IsMultiStruct = true;
        
        % 这里只声明 codeParam 这个容器，不要在这里赋值
        codeParam 
    end

    % --- 方法 (Methods) ---
    methods
        % 构造函数：函数名必须与类名(unitParamsTest)完全一致
        % 只有在这里才能使用 'obj' 并进行逻辑运算
        function obj = unitParamsTest()
            
            % 1. 准备数据
            % 注意：Table 通常按列存储，建议转置为列向量 (')
            c_data = (1:obj.codeNum)'; 
            l_data = [2; 4; 6; 8]; 
            p_data = [180; 90; 0; -90];
            
            % 2. 数据校验 (工程习惯：防止手动输入的数据长度不对)
            if length(l_data) ~= obj.codeNum
                error('Error: ly1 data length does not match codeNum.');
            end
            
            % 3. 创建并赋值 Table
            % 直接将数据传入 table 函数是最简单的方法
            obj.codeParam = table(c_data, l_data, p_data, ...
                'VariableNames', {'Code', 'ly1', 'phase'});
        end
    end
end