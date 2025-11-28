function figure = CSTSAmpDrawer(data,Ismerge)
% 对处理后的S参数的幅值进行绘图，Ismerge==1则合并在一个窗口，否则分开
rawdata = data;

if (Ismerge)
    for i = 1:numel(rawdata)
        % 逐张取表
        rawphase = rawdata{i};
        rawphase(:,3) = [];

        plot(rawphase{:,1}, rawphase{:,2}, 'LineWidth', 2);
        hold on; % 保持当前图形
        xlabel("频率/GHz");
        ylabel("相位/deg");
    end
else
    for i = 1:numel(rawdata)
        % 逐张取表
        rawphase = rawdata{i};
        rawphase(:,3) = [];

        plot(rawphase{:,1}, rawphase{:,2}, 'LineWidth', 2);
        xlabel("频率/GHz");
        ylabel("相位/deg");
    end
end
end