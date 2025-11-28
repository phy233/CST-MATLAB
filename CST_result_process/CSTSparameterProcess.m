function dataCell = CSTSparameterProcess(filePath)
% CSTSparameterProcess 读取CST导出的S参数TXT文件，进行子表分割
%   dataCell = CSTSparameterProcess(filePath)
%
%   输入: filePath - txt文件的完整路径
%   输出: dataCell - 一个元胞数组，每个元胞包含一个子图的 Table 数据
%
%   注意:
%   1. 会自动处理表头中的特殊字符使其符合MATLAB变量命名规范。
%   2. 会提取对应的Parameters信息存储在表格的 UserData 属性中（可选）。

% 1. 打开文件
fid = fopen(filePath, 'r');
if fid == -1
    error('无法打开文件，请检查路径是否正确。');
end

% 2. 读取所有行到内存（适用于一般CST数据大小，若数据极大建议逐行处理）
% 使用 textscan 读取整个文件内容为字符串单元数组
rawContent = textscan(fid, '%s', 'Delimiter', '\n', 'Whitespace', '');
fileLines = rawContent{1};
fclose(fid);

% 3. 初始化变量
dataCell = {};          % 存储最终结果的Cell
blockStartIndices = []; % 存储每个子图起始行的索引

% 4. 寻找每个数据块的起始位置
% CST导出数据通常以 #Parameters 开头
for i = 1:length(fileLines)
    if startsWith(fileLines{i}, '#Parameters')
        blockStartIndices = [blockStartIndices; i];
    end
end

if isempty(blockStartIndices)
    error('未在文件中找到 #Parameters 标记，请确认文件格式是否为CST导出格式。');
end

% 添加文件结束位置作为最后一个区块的边界
blockStartIndices = [blockStartIndices; length(fileLines) + 1];

% 5. 循环处理每个数据块
numBlocks = length(blockStartIndices) - 1;
fprintf('检测到 %d 个数据子图，开始处理...\n', numBlocks);

for k = 1:numBlocks
    idxStart = blockStartIndices(k);
    idxEnd = blockStartIndices(k+1) - 1;

    % --- 步骤 A: 获取参数信息 (第一行) ---
    paramLine = fileLines{idxStart};
    % 去除开头的 #Parameters =
    paramString = strrep(paramLine, '#Parameters = ', '');

    % --- 步骤 B: 处理表头 (第二行) ---
    % 根据你的描述，表头在 #Parameters 的下一行
    headerLineIdx = idxStart + 1;
    if headerLineIdx > idxEnd
        warning('第 %d 个块没有表头行，跳过。', k);
        continue;
    end

    rawHeaderLine = fileLines{headerLineIdx};

    % 清洗表头字符串：去除开头的 #，去除双引号 "
    cleanHeaderLine = strrep(rawHeaderLine, '#', '');
    cleanHeaderLine = strrep(cleanHeaderLine, '"', '');

    % 分割表头获取列名
    colNames = strsplit(strtrim(cleanHeaderLine));
    % 合并表头
    indices = [1, 2, 3];  % 指定要合并的下标
    selectedCells = colNames(indices);  % 提取指定元胞
    mergedStr{1} = strjoin(selectedCells, '');  % 合并（无分隔符）

    indices = [4, 5, 6];  % 指定要合并的下标
    selectedCells = colNames(indices);  % 提取指定元胞
    mergedStr{2} = strjoin(selectedCells, '');  % 合并（无分隔符）

    indices = [7, 8, 9, 10, 11];  % 指定要合并的下标
    selectedCells = colNames(indices);  % 提取指定元胞
    mergedStr{3} = strjoin(selectedCells, '');  % 合并（无分隔符）

    colNames = mergedStr;
    % 移除可能产生的空列名
    colNames = colNames(~cellfun('isempty', colNames));

    % 关键：将列名转换为合法的MATLAB变量名
    % CST的表头如 "SZmin(2),Zmax(2)..." 包含括号和逗号，MATLAB不支持
    validColNames = matlab.lang.makeValidName(colNames);

    % --- 步骤 C: 提取数值数据 ---
    % 数据通常从表头后的分割线(#-----)之后开始，或者直接开始
    % 我们从 headerLineIdx + 1 开始寻找第一个非注释行
    dataStartIdx = headerLineIdx + 1;
    while dataStartIdx <= idxEnd && startsWith(fileLines{dataStartIdx}, '#')
        dataStartIdx = dataStartIdx + 1;
    end

    % 提取数据行
    if dataStartIdx <= idxEnd
        dataLines = fileLines(dataStartIdx:idxEnd);

        % 将字符串数据转换为数值矩阵
        % 移除可能的空行
        dataLines = dataLines(~cellfun('isempty', dataLines));

        if isempty(dataLines)
            tempTable = table(); % 空表
        else
            % 方法：将 cell 字符串数组转为字符矩阵，再用 str2num 智能转换
                % str2num 会自动保留二维结构，并处理空格/Tab分隔符
                try
                    % char(dataLines) 会把不同长度的行补空格对齐
                    dataMatrix = str2num(char(dataLines)); 
                catch
                    warning('第 %d 个块包含无法转换的字符，跳过。', k);
                    tempTable = table();
                    dataCell{k, 1} = tempTable;
                    continue;
                end

            % --- 步骤 D: 构建 Table 并存入 Cell ---
            % 确保列数匹配
            if size(dataMatrix, 2) == length(validColNames)
                tempTable = array2table(dataMatrix, 'VariableNames', validColNames);
            else
                % 如果列数不匹配（有时CST表头和数据列对不上），使用默认命名
                warning('第 %d 个块表头列数(%d)与数据列数(%d)不符，使用默认列名。', ...
                    k, length(validColNames), size(dataMatrix, 2));
                tempTable = array2table(dataMatrix);
            end
        end
    else
        tempTable = table();
    end

    % (可选) 将参数字符串存入表格的 UserData 属性，方便后续查询
    tempTable.Properties.UserData = paramString;

    % 存入总 Cell
    dataCell{k, 1} = tempTable;
end

fprintf('处理完成。共生成 %d 个 Table。\n', length(dataCell));
end