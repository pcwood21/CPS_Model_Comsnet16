clear all;

load('run9.mat'); %Actual AI
load('AIbyowner.mat'); %SA' Strategy Basis
load('run13.mat'); %Defender's Basis
load('run13_addendum.mat');
load('baselineProfits.mat');
load('targetListArray.mat');

targets=[run13_input.v1 120];
sigmas=run13_input.v2;

numOwners=12;
numAssets=120;

[ownership,toptierowners]=cnexp2_owenership_model(numOwners,numAssets);

profitMatrix=zeros(length(targets),length(sigmas),120);
for i=1:length(targets)
    for j=1:length(sigmas)
        if i==120
            profits=run13_addendum{j}.profits;
        else
            profits=run13_data{i,j}.profits;
        end
        
        profitMatrix(i,j,:)=profits;
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
       AIbyowner(i,j,:)=IMbyowner; 
    end
end

defendtargetListArray={};
for q=1:length(sigmas)
for Ntar=1:119
bestAI=0;
targetList=[];
for i=1:numOwners
    C=nchoosek(1:numOwners,i);
    if i==1
        C=C';
    end
    for j=1:size(C,1)
        owners=C(j,:);
        AIslice=squeeze(AIbyowner(:,q,owners));
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
defendtargetListArray{Ntar,q}=targetList;
end
end


%AI by owner for sigma=0
load('cnexp1_attacks1_results.mat');
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


baseAIbyowner=[];
for i=1:size(profitMatrix,2)
    IMt=profitMatrix(i,:)-baselineProfits';
    IMbyowner=[];
        for k=1:numOwners
            IMbyowner(k)=sum(IMt(ownership(k,:)));
        end
       baseAIbyowner(i,:)=IMbyowner; 
end


baseAI=[];
defendedAI=[];
for j=1:length(sigmas)
for dTar=1:119
for aTar=1:119
    baseTargets=targetListArray{aTar};
    actualTargets=baseTargets;
    defendedTargets=defendtargetListArray{dTar,j};
    for i=1:length(defendedTargets)
        actualTargets(actualTargets==defendedTargets(i))=[];
    end
    normalAI=baseAIbyowner(baseTargets,:);
    availableAI=sum(normalAI,1);
    baseAI(dTar,aTar,j)=sum(availableAI(availableAI>0));
    
    tdefendedAI=baseAIbyowner(actualTargets,:);
    tdefendedAI=sum(tdefendedAI,1);
    defendedAI(dTar,aTar,j)=sum(tdefendedAI(availableAI>0));

end
end
end

dAIplot=[];
for k=1:1:4
for i=1:119
    dAIplot(i,k)=defendedAI(ceil(i/k),i,1);
end
end
figure;
hold all;
base=squeeze(baseAI(1,:,1))';
plot(1:119,base-dAIplot(:,1),'-','LineWidth',2);
plot(1:119,base-dAIplot(:,2),'--','LineWidth',2);
plot(1:119,base-dAIplot(:,3),':','LineWidth',2);
plot(1:119,base-dAIplot(:,4),'-.','LineWidth',2);
legend('100% Def.','50%   Def.','33%   Def.','25%   Def.');
hold off;
xlabel('Leaf Link Attack Budget');
ylabel('Reduction in Attacker''s Incentive');
set(gca,'FontSize',18);
xlim([0 120]);

%Matched-defense reduction pct
max((base-dAIplot(:,1))./base*100)

%Pct of operating profits
mean(mean(mean(baseAI)))/sum(baselineProfits)

nTargets=35:20:119;
dAIplot=[];
for k=1:1:4
for i=1:5
    dAIplot(i,k)=min(defendedAI(:,nTargets(k),i));
end
end

figure;
hold all;
base=squeeze(baseAI(1,nTargets,1:5));
plot(sigmas(end:-1:1),base(1,:)'-dAIplot(:,3),'-','LineWidth',2);
%plot(sigmas(end:-1:1),base(2,:)'-dAIplot(:,2),'--','LineWidth',2);
%plot(sigmas(end:-1:1),base(3,:)'-dAIplot(:,3),':','LineWidth',2);
%plot(sigmas(end:-1:1),base(4,:)'-dAIplot(:,4),'-.','LineWidth',2);
hold off;
xlabel('\sigma');
ylabel('Reduction in Attacker''s Incentive');
set(gca,'FontSize',18);