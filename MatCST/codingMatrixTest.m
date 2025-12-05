classdef codingMatrixTest

    properties
        size = [5,5];

        codeNum = 4;
    end

    properties
        codingMatrix;
    end

    methods
        function obj = codingMatrixTest()
            rng(42); % 设置一个固定的种子（例如42）
            obj.codingMatrix = randi([1,4], 5, 5); % 每次运行都会得到相同的矩阵
        end
    end
end