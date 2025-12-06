classdef codingMatrixTest

    properties(Constant)
        size = [10 10];
        codeLayer = 3;
        layerDistance = [12 12 12];
        codeNum = 4;
    end

    properties
        codingMatrix;
    end

    methods
        function obj = codingMatrixTest()
            rng(42); % 设置一个固定的种子（例如42）
            for i = 1:obj.codeLayer
            obj.codingMatrix{i} = randi([1,4], 10, 10); % 每次运行都会得到相同的矩阵
            end
        end
    end
end