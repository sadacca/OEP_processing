
%% plot each neuron's mean waveform across a tetrode simply

clr = [0,0.4470,0.7410;...
    0.8500,0.3250,0.0980;...
    0.9290,0.6940,0.1250;...
    0.4940,0.1840,0.5560];
mm=length(spike);
meanwave = zeros(length(spike),4,32);
for ii = 1:length(spike) %for each neuron
    figure;
    for jj = 1:4 %tetrodes
        meanwave(ii,jj,:)=squeeze(mean(spike(ii).waves(jj,:,:),3));
     plot(squeeze(meanwave(ii,jj,:)),'color',clr(jj,:)),hold on

        [minval(ii,jj) mintime(ii,jj)] = min(meanwave(ii,jj,:));
        [maxval1(ii,jj) maxtime1(ii,jj)] = max(meanwave(ii,jj,1:mintime(ii,jj)));
        [maxval2(ii,jj) maxtime2(ii,jj)] = max(meanwave(ii,jj,mintime(ii,jj):end));
        maxtime2(ii,jj)=maxtime2(ii,jj)++mintime(ii,jj);
        
        posratio(ii,jj) = (minval(ii,jj)+maxval1(ii,jj))/(abs(minval(ii,jj)) +abs(maxval1(ii,jj)));
        minmaxtime(ii,jj) = maxtime2(ii,jj)-mintime(ii,jj);
        maxmintime(ii,jj) = -maxtime1(ii,jj)+mintime(ii,jj);
        maxmaxtime(ii,jj) = -maxtime1(ii,jj)+maxtime2(ii,jj);
        
    end
    plot(squeeze(-posratio(ii,:)),squeeze(minmaxtime(ii,:)/25),'o','color',[ii/mm, ii/mm, ii/mm]), hold on
end


        