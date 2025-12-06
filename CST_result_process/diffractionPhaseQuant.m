function [M_quantized,M_quantizedLabel] = diffractionPhaseQuant(M,levels)
%DIFFRACTIONPHASEQUANT 对衍射层训练结果进行量化

% 计算量化步长
    % levels个级别意味着有levels个量化值
    % 从-π到π总共2π的范围，需要levels-1个间隔
    step = 2*pi / (levels - 1);
    
    % 生成量化级别（从-π到π的均匀分布）
    quant_levels = linspace(-pi, pi, levels);
    
    % 初始化量化后的元胞数组
    M_quantized = cell(size(M));
    M_quantizedLabel = cell(size(M));
    
    % 遍历元胞数组中的每个矩阵
    for i = 1:numel(M)
        % 获取当前矩阵
        current_matrix = M{i};
        
        % 对矩阵中的每个元素进行量化
        quantized_matrix = zeros(size(current_matrix));
        quantized_label = zeros(size(current_matrix));
        
        % 使用最近的量化级别
        % 计算每个元素距离哪个量化级别最近
        for k = 1:numel(current_matrix)
            % 计算当前值与所有量化级别的距离
            [~, idx] = min(abs(current_matrix(k) - quant_levels));
            quantized_matrix(k) = quant_levels(idx);
            quantized_label(k) = idx;
        end
        
        
        % 将量化后的矩阵存入新的元胞数组
        M_quantized{i} = quantized_matrix;
        M_quantizedLabel{i} = quantized_label;
    end
end

