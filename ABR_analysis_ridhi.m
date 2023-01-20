timemarks=[];
stimulus = data(7:end,2); % channel 1
response = data(7:end,3); % channel 3
rsv = zeros(200,1); % response sum vector

%recording
for j = 2:length(stimulus)
    if stimulus(j) > 0.005
        if length(timemarks) > 0
            if j - timemarks(end) > 2300 %time between stimulations, sample rate 10k
                timemarks = [timemarks j];
            end   
        else timemarks = [timemarks j];
        end
    end
    if length(timemarks) > 0
        iter_start = timemarks(end);
        iter_end = iter_start + 200;
        if j >= iter_start & j < iter_end
            q = j - iter_start + 1;
            rsv(q) = rsv(q) + response(j);
        end
    end
end

%average plot
av = rsv./length(timemarks);
plot(av)
ylim([-0.02 0.02]);


