function MEDevent2mat()
% Formatting code auto-generated by MATLAB 'import' function on 2016/03/24 17:24:26
% Pre and post processing wrapper for per-animal data extraction by BS 03/24/16
%


%%  find the file
[filename,filedirectory]=uigetfile('*');

%goto the file directory
cd(filedirectory)


%% Import data from text file.

%% Initialize variables.

delimiter = ' ';
startRow = 4;

%% Read columns of data as strings:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%s%s%s%s%s%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
textscan(fileID, '%[^\n\r]', startRow-1, 'ReturnOnError', false);
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric strings to numbers.
% Replace non-numeric strings with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[2,3,4,5,6,7]
    % Converts strings in the input cell array to numbers. Replaced non-numeric
    % strings with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(thousandsRegExp, ',', 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric strings to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end

%% Split data into numeric and cell columns.
rawNumericColumns = raw(:, [2,3,4,5,6,7]);
rawCellColumns = raw(:, [1,8,9]);


%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells

%% Create output variable
eventdata = raw;

%% Clear temporary variables
clearvars delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me rawNumericColumns rawCellColumns R;


%% extract the data just extracted for a particular animal

% select out indicies of start and end of event time block
kindex = find(cellfun(@(x) strcmp(x,'K:'),eventdata(:,1)));
lindex = find(cellfun(@(x) strcmp(x,'L:'),eventdata(:,1)));
nameindex = find(cellfun(@(x) strcmp(x,'Subject:'),eventdata(:,1)));

% and then use those to extrat the data from a particular rat, both for
% the event labels and event times



for ratindex = 1:length(nameindex);

eventstamps = (cellfun(@(x) x,eventdata(kindex(ratindex)+1:lindex(ratindex)-2,2:6)));
eventtimes = (cellfun(@(x) x,eventdata(lindex(ratindex)+1:lindex(ratindex)+lindex(ratindex)-kindex(ratindex)-2,2:6)));
ratname = cellfun(@(x) x,eventdata(nameindex(ratindex),2));

%linearize the data so its easy to work with
medeventstamps = eventstamps(:);
medeventtimes = eventtimes(:);


save(['rat_',num2str(ratname),'_day_',filename(2:end),'.mat'],'medevent*')
clear eventstamps eventtimes ratname
end
%plot the events, if you'd like
%scatter(eventtimes,eventstamps)



