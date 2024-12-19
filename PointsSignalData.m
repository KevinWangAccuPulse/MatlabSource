% 设置文件夹路径
folderPath = 'D:\WorkSpace\Code\Dorsey_bugfixing\bin\x64\debug\PointsViewData\TSE1 1 - 2'; % 修改为你的文件夹路径

% 获取文件夹内所有 CSV 文件
csvFiles = dir(fullfile(folderPath, '*.csv'));

% 检查是否找到 CSV 文件
if isempty(csvFiles)
    error('未在指定文件夹中找到任何 CSV 文件！');
end

% 初始化图表
figure;
hold on; % 允许绘制多条曲线在同一图表中
offset = 0; % 信号的初始偏移量

% 遍历所有 CSV 文件
for k = 1:length(csvFiles)
    % 获取文件的完整路径
    filePath = fullfile(folderPath, csvFiles(k).name);
    
    % 读取 CSV 文件
    data = csvread(filePath); % 假设 CSV 文件只有一列信号数据
    t = 1:length(data); % 时间序列（假设采样间隔为1）
   
     % 添加偏移后绘制信号
    plot(t + offset, data, 'LineWidth', 1.5, 'DisplayName', csvFiles(k).name);
   
    % 更新偏移量
    offset = offset + length(data);
end

% 图表设置
hold off;
title('多个 CSV 文件信号绘制');
xlabel('时间');
ylabel('幅值（带偏移）');
legend('show'); % 显示图例
grid on;