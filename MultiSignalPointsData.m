
% 设置文件夹路径
folderPath = 'D:\WorkSpace\Code\Dorsey_bugfixing\bin\x64\debug\PointsViewData'; % 修改为你的文件夹路径

% 获取目标目录下的所有条目
allEntries = dir(folderPath);

% 筛选文件夹条目
folders = allEntries([allEntries.isdir]);

% 排除 '.' 和 '..' 
folders = folders(~ismember({folders.name}, {'.', '..'}));

% 获取文件夹的完整路径或名称
%allFolderPaths = fullfile(targetFolder, {folders.name}); % 完整路径


% 初始化图表
figure;
hold on; % 允许绘制多条曲线在同一图表中
yoffset = 0; % 信号的初始偏移量
yoffsetStep = 5; % 每条信号的偏移步长
cmap = lines(10); % 生成10种颜色
idxdata = [];
for m = 1:length(folders)
    subfoler = fullfile(folderPath, folders(m).name);
    folderName = folders(m).name;
    csvFiles = dir(fullfile(subfoler, '*.csv'));
    fileLen = length(csvFiles);
    offset = 0; % 信号的初始偏移量
    curData = zeros(1,length(csvFiles));
    % 遍历所有 CSV 文件
    for k = 1:length(csvFiles)
        % 获取文件的完整路径
        filePath = fullfile(subfoler, csvFiles(k).name);
        
        % 读取 CSV 文件
        data = csvread(filePath); % 假设 CSV 文件只有一列信号数据
        t = 1:length(data); % 时间序列（假设采样间隔为1）
        
        [maxVal, idx] = max(data);
        correspondingValue = data(idx); % 找到原始数组中对应的值

        str1 = strcat(folderName," ", csvFiles(k).name," Max= " ,num2str(maxVal,2), " idx= " ,num2str(idx));
        
        curData(k)=idx;

         % 添加偏移后绘制信号
        plot(t + offset, data + yoffset, 'LineWidth', 1.5, 'DisplayName', str1,'Color', cmap(k, :));
        %plot(t + offset, data + yoffset, 'LineWidth', 1.5, 'DisplayName', str1);
       
        % 更新偏移量
        offset = offset + length(data);
    end
    idxdata = [idxdata;curData];
    yoffset = yoffset+ yoffsetStep;
end

disp("Idx");
disp(idxdata);
[rows, cols] = size(idxdata);
latData=(idxdata(2,:)-idxdata(1,:))/2.0;

disp(latData);

% 将数组转换为字符串数组
strLatArray = arrayfun(@num2str, latData, 'UniformOutput', false);

% 拼接为一个字符串（用逗号分隔）
strLat = strjoin(strLatArray, ', ');
strTitle = strcat("Lat= ",strLat);

% 图表设置
hold off;
title(strTitle);
xlabel('时间');
ylabel('幅值（带偏移）');
legend('show'); % 显示图例
grid on;