function arrayModeling(mws,unitParams,codingMatrix)
%ARRAYMODELING 阵列建模
%

% 准备，获取阵列数据
rows = codingMatrix.size(1);
cols = codingMatrix.size(2);
xSize = unitParams.unitSize(1);
YSize = unitParams.unitSize(2);
zSize = unitParams.unitSize(3);
codeNum = unitParams.codeNum;
codeLayer = codingMatrix.codeLayer;
if codeNum~=codingMatrix.codeNum
    error("单元编码数与码本编码数不一致");
end

% 计算坐标
% 1. 解析单元尺寸
dx = xSize;
dy = YSize;
dz = zSize;

% 2. 定义一维坐标向量 (让阵列中心位于 x=0, y=0)
% 逻辑：((1到N) - 0.5) * 周期 - 总长/2
x_vec = ((1:cols) - 0.5) * dx - (cols * dx) / 2;

% 注意：MATLAB矩阵的行索引通常对应Y轴。
% 如果你想让矩阵的第一行对应物理上的"上方" (Y最大值)，需要翻转Y向量；
% 如果对应物理上的"下方" (Y最小值)，则保持递增。
% 这里假设矩阵第一行(r=1)对应物理空间的 Y 最小值（通常符合由下往上的建模习惯）
y_vec = ((1:rows) - 0.5) * dy - (rows * dy) / 2;

% 3. 利用 meshgrid 生成网格
% 注意 meshgrid 的参数顺序是 (x, y)，返回的是 (Y_grid, X_grid)
% 这样生成的 grid 维度正好是 (rows, cols)
[X_map, Y_map] = meshgrid(x_vec, y_vec);

% 4. 组装结果到三维矩阵
centers = zeros(rows, cols, 3);
centers(:, :, 1) = X_map; % X 坐标
centers(:, :, 2) = Y_map; % Y 坐标

% Z 坐标通常是固定的,不平移
Z_val = 0;
centers(:, :, 3) = Z_val;


%开始建模

% 1. 拉直坐标矩阵
% 将 [rows, cols, 3] 变为 [rows*cols, 3] 的二维矩阵
% 每一行包含一个单元的 [x, y, z]
list_centers = reshape(centers, [], 3);

% 2. 拉直编码矩阵
% 将 [rows, cols] 变为 [rows*cols, 1] 的列向量
for i = 1:codeLayer
    list_codes{i} = codingMatrix.codingMatrix{i}(:);
end

SetNormal = [0 0 1];
SetOrigin = [0 0 0];
SetUVector = [1 0 0];

activateWCS(mws,SetNormal,SetOrigin,SetUVector,false);

% 创建问题对话框，显示自定义消息
button = questdlg('检查基准编码单元命名是否为对应编码（仅数字）且所有单元中心均在全局坐标系原点处且重合。是否继续？', ...
    '警告标题', ...
    '确定', '取消', '取消'); % 默认选择“取消”

% 根据用户选择执行不同操作
switch button
    case '确定'
        disp('开始建模');
        for j = 1:codeLayer
            fprintf('当前层数%d\n',j);
            %平移单元
            for i=1:rows*cols
                translationObj(mws,sprintf('%d',list_codes{j}(i)),list_centers(i,1),list_centers(i,2),list_centers(i,3)+SetOrigin(3),true,1);
            end
            SetOrigin(3) = codingMatrix.layerDistance(j)+SetOrigin(3)+dz;
        end

        % 删除原有基准单元
        for i=1:codeNum
            deleteComponent(mws,sprintf('%d',i));
        end

    case '取消'
        error('程序被用户中断');
end


end

