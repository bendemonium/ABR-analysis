%input dialogue
prompt = {'Stimulus Frequency','Sample Rate','Response Threshold'};
dlgtitle = 'Params';
dims = [1 35];
definput = {'4','20000','0.005'};
answer = inputdlg(prompt,dlgtitle,dims,definput);
stim_time  = 0.9 * (1/(str2num(answer{1})));
sample_rate = str2num(answer{2});
threshold = str2num(answer{3});
min_int = stim_time*sample_rate; %time between stimulations

timemarks=[];
stimulus = data(:,2); % channel 1
response = data(:,3); % channel 3
rsv = zeros(200,1); % response sum vector

%recording
for j = 2:length(stimulus)
    if stimulus(j) > threshold
        if ~isempty(timemarks)
            if j - timemarks(end) > min_int 
                timemarks = [timemarks j];
            end   
        else timemarks = [timemarks j];
        end
    end
    if ~isempty(timemarks)
        iter_start = timemarks(end);
        iter_end = iter_start + 200;
        if j >= iter_start && j < iter_end
            q = j - iter_start + 1;
            rsv(q) = rsv(q) + response(j);
        end
    end
end

%average plot
av = rsv./length(timemarks);
figure('name','AVERAGE RESPONSE','NumberTitle','off');
plot(av, 'r','LineWidth',1.5)
ylim([-0.006 0.006]);
title('Average Response Plot');
ylabel('Response (V)');


