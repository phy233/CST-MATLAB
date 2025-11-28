function figure = CSTSPhaseDrawer(data,Ismerge,IsUnwrap)
% 对处理后的S参数的相位进行绘图，Ismerge==1则合并在一个窗口，否则分开
rawdata = data;

if (IsUnwrap)
    for i = 1:numel(rawdata)
        currentTable = rawdata{i};
        
        % 2. 提取数据
        phaseDeg = currentTable{:, 3};
        
        % 3. 核心算法：角度 -> 弧度 -> 解缠 -> 角度
        % unwrap 函数默认识别 pi (180度) 的跳变
        phaseRad = deg2rad(phaseDeg); 
        phaseRadUnwrapped = unwrap(phaseRad); 
        phaseDegUnwrapped = rad2deg(phaseRadUnwrapped);
        
        % 4. 将处理后的数据写回表格
        currentTable{:, 3} = phaseDegUnwrapped;
        
        % 更新 Cell
        rawdata{i} = currentTable;
    end
else
    return;
end


if (Ismerge)
    for i = 1:numel(rawdata)
        % 逐张取表
        rawphase = rawdata{i};
        rawphase(:,2) = [];

        plot(rawphase{:,1}, rawphase{:,2}, 'LineWidth', 2);
        hold on; % 保持当前图形
        xlabel("频率/GHz");
        ylabel("相位/deg");
    end
else
    for i = 1:numel(rawdata)
        % 逐张取表
        rawphase = rawdata{i};
        rawphase(:,2) = [];

        plot(rawphase{:,1}, rawphase{:,2}, 'LineWidth', 2);
        xlabel("频率/GHz");
        ylabel("相位/deg");
    end
end
end