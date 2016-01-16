
%% plot each neuron's mean waveform across a tetrode simply

clr = [0,0.4470,0.7410;...
    0.8500,0.3250,0.0980;...
    0.9290,0.6940,0.1250;...
    0.4940,0.1840,0.5560];

for ii = 1:length(spike) %for each neuron
    figure;
    for jj = 1:4 %tetrodes
     plot(squeeze(mean(spike(ii).waves(jj,:,:),3)),'color',clr(jj,:)),hold on
    end
end

