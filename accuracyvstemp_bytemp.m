load('W.mat');
load('thresholds.mat');
inference_data=struct;
dataindex=1;
dataindex=size(inference_data,2)+1;
N=50;
for temp=1:11
    load(sprintf('binnedspikes/sW %.3f.mat',thresholds(temp,1)));
    sW=thresholds(temp,1);
    binnedspikes0=binnedspikes;
    maxdatasize=size(binnedspikes0,1);    
    for datasize=maxdatasize%round(maxdatasize*10.^(0:-.25:-.25))
        errlist=[];
        binnedspikecountlist=[];
        for startpoint=1:round(maxdatasize/50):maxdatasize-datasize+1
            binnedspikes=binnedspikes0(startpoint:startpoint+datasize-1,:);
            binnedspikecount=sum(binnedspikes(:));
            binnedspikecountlist=[binnedspikecountlist,binnedspikecount];            
            run('runme_ising_from_simulation.m');
            run('finderror.m');
            errlist=[errlist,err];
        end
        inference_data(dataindex).sW=sW;
        inference_data(dataindex).binnedspikecount=mean(binnedspikecountlist);
        inference_data(dataindex).err=mean(errlist);        
        inference_data(dataindex).Jnew=Jnew;                 
        dataindex=dataindex+1;
        save inference_data_50.mat inference_data
    end 
end