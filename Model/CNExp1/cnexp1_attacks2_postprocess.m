clear all;

load('cnexp1_attacks2_resultsb.mat');
load('cnexp1_attacks1_results.mat');
load('run7run8_independent.mat');
load('run6.mat');


targets=run3_input.v1; %30 targets
seeds=run3_input.v2; %40 seeds

numOwners=12;
numAssets=120;

profitMatrix=zeros(length(targets),length(seeds),120);
for i=1:length(targets)
    for j=1:length(seeds)
        if ~isfield(run3_data{i,j},'profits')
            nanrow=ones(120,1)*NaN;
            profitMatrix(i,j,:)=nanrow;
            disp(run3_data{i,j});
        else
            profitMatrix(i,j,:)=run3_data{i,j}.profits';
        end
    end
end

%IM(target,client)

%Calculate Attacker's Incentive
runTime=400;
attackList=zeros(500,1);
[baselineProfits,DSim]=cnexp1_runscenario(attackList,runTime);

[ownership,toptierowners]=cnexp2_owenership_model(numOwners,numAssets);

IM=[];
AI=[];
AIbyowner=[];
for i=1:size(profitMatrix,1)
    for j=1:size(profitMatrix,2)
        IMt=squeeze(profitMatrix(i,j,:))-baselineProfits;
        IM(i,j,:)=IMt;
        IMbyowner=[];
        for k=1:numOwners
            IMbyowner(k)=sum(IMt(ownership(k,:)));
        end
        AI(i,j)=sum(IMt(IMt>0));
        AIbyowner(i,j)=sum(IMbyowner(IMbyowner>0));
    end
end

IM_avg=squeeze(mean(IM,2));
IM_max=squeeze(max(IM,[],2));
IM_min=squeeze(min(IM,[],2));

AI_avg=squeeze(mean(AI,2));
AI_max=squeeze(max(AI,[],2));
AI_min=squeeze(min(AI,[],2));

AIbyowner_avg=squeeze(mean(AIbyowner,2));
AIbyowner_max=squeeze(max(AIbyowner,[],2));
AIbyowner_min=squeeze(min(AIbyowner,[],2));

%These are for random strategies for the number of targets





profitMatrix=zeros(numAssets,numAssets);
for i=1:numAssets
        if ~isfield(run1_data{i,1},'profits')
            nanrow=ones(120,1)*NaN;
            profitMatrix(i,j,:)=nanrow;
            disp(run1_data{i,1});
        else
            profitMatrix(i,:)=run1_data{i,1}.profits;
        end
end

IM=[];
AIbyowner=[];
for i=1:size(profitMatrix,2)
    IMt=profitMatrix(i,:)-baselineProfits';
    IM(i,:)=IMt;
    IMbyowner=[];
        for k=1:numOwners
            IMbyowner(k)=sum(IMt(ownership(k,:)));
        end
       AI(i,j)=sum(IMt(IMt>0));
       AIbyowner(i,:)=IMbyowner; 
end

%Maximize AI by Owner
targetListArray={};
for Ntar=1:119
bestAI=0;
for i=1:numOwners
    C=nchoosek(1:numOwners,i);
    if i==1
        C=C';
    end
    for j=1:size(C,1)
        owners=C(j,:);
        AIslice=AIbyowner(:,owners);
        comp=sum(AIslice,2);
        [sortedComp,idx]=sort(comp,'descend');
        targetListID=idx(sortedComp>0);
        newAI=sum(sortedComp(1:Ntar));
        if newAI > bestAI
            bestAI=newAI;
            ownerList=owners;
            
            targetList=targetListID(1:(min(Ntar,end)));
        end
    end
end
targetListArray{Ntar}=targetList;
end


%Maximize AI by Owner
targetListArrayMid={};
for Ntar=1:11
bestAI=0;
for i=1:numOwners
    C=nchoosek(1:numOwners,i);
    if i==1
        C=C';
    end
    for j=1:size(C,1)
        owners=C(j,:);
        AIslice=AIbyowner(:,owners);
        %AISlice is by target, need to combine to by mid-target
        comp=sum(AIslice,2);
        newTarget=1:numOwners;
        newTargetAI=[];
        for l=1:length(newTarget)
            newTargetAI(l)=sum(comp(ownership(l,:)));
        end
        [sortedComp,idx]=sort(newTargetAI,'descend');
        targetListID=idx(sortedComp>0);
        newAI=sum(sortedComp(1:Ntar));
        if newAI > bestAI
            bestAI=newAI;
            ownerList=owners;
            
            targetList=targetListID(1:(min(Ntar,end)));
        end
    end
end
targetListArrayMid{Ntar}=targetList;
end



targetListArrayTop={};
for Ntar=1:3
bestAI=0;
for i=1:numOwners
    C=nchoosek(1:numOwners,i);
    if i==1
        C=C';
    end
    for j=1:size(C,1)
        owners=C(j,:);
        AIslice=AIbyowner(:,owners);
        %AISlice is by target, need to combine to by mid-target
        comp=sum(AIslice,2);
        newTarget=1:4;
        newTargetAI=[];
        for l=1:length(newTarget)
            newTargetAI(l)=sum(comp(ownership(toptierowners(l),:)));
        end
        [sortedComp,idx]=sort(newTargetAI,'descend');
        targetListID=idx(sortedComp>0);
        newAI=sum(sortedComp(1:Ntar));
        if newAI > bestAI
            bestAI=newAI;
            ownerList=owners;
            
            targetList=targetListID(1:(min(Ntar,end)));
        end
    end
end
targetListArrayTop{Ntar}=targetList;
end


[output]=cnexp1_attacks1_runner(targetList,-1);
%output=realProfit;
realProfit=output.profits-baselineProfits;

%realIM=sum(sum(realProfit(ownership(ownerList,:))));
realProfitByOwner=[];
for k=1:numOwners
    realProfitByOwner(k)=sum(realProfit(ownership(k,:)));
end

realIM=sum(realProfitByOwner(realProfitByOwner>0));
nTargets=110;


figure;
hold all;
plot(targets,AIbyowner_avg,'-','LineWidth',2);
plot(targets,AIbyowner_max,'--','LineWidth',2);
plot(targets,AIbyowner_min,':','LineWidth',2);
plot(nTargets,realIM,'x','MarkerSize',18);
hold off;
legend('Average','Maximum','Minimum');
xlabel('Leaf Links Attacked');
ylabel('Attacker''s Incentive');
set(gca,'FontSize',18);
xlim([0 120]);



targets=run6_input.v1;
seeds=run6_input.v2;

profitMatrix=zeros(length(targets),length(seeds),120);
for i=1:length(targets)
    for j=1:length(seeds)
        if ~isfield(run6_data{i,j},'profits')
            nanrow=ones(120,1)*NaN;
            profitMatrix(i,j,:)=nanrow;
            disp(run6_data{i,j});
        else
            profitMatrix(i,j,:)=run6_data{i,j}.profits';
        end
    end
end


AIbyowner=[];
for i=1:size(profitMatrix,1)
    for j=1:size(profitMatrix,2)
        IMt=squeeze(profitMatrix(i,j,:))-baselineProfits;
        IMbyowner=[];
        for k=1:numOwners
            IMbyowner(k)=sum(IMt(ownership(k,:)));
        end
        AIbyowner(i,j)=sum(IMbyowner(IMbyowner>0));
    end
end

midtargets=targets;
AIbyowner_mid_avg=squeeze(mean(AIbyowner,2));
AIbyowner_mid_max=squeeze(max(AIbyowner,[],2));
AIbyowner_mid_min=squeeze(min(AIbyowner,[],2));


figure;
hold all;
plot(midtargets,AIbyowner_mid_avg,'-','LineWidth',2);
plot(midtargets,AIbyowner_mid_max,'--','LineWidth',2);
plot(midtargets,AIbyowner_mid_min,':','LineWidth',2);
%plot(nTargets,realIM,'x','MarkerSize',18);
hold off;
legend('Average','Maximum','Minimum');
xlabel('Middle Tier Links Attacked');
ylabel('Attacker''s Incentive');
set(gca,'FontSize',18);
xlim([0 12]);
