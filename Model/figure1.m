clear all;

load('run9.mat');
load('run10.mat');
load('run11.mat');
load('AIRandom.mat');
load('targetListArray.mat');
load('targetListArrayMid.mat');
load('baselineProfits.mat');

targets=1:119;
numOwners=12;
numAssets=120;

[ownership,toptier]=cnexp2_owenership_model(numOwners,numAssets);

AI_leaf=zeros(length(targets),1);

for i=1:length(targets)
    profits=run9_data{i,1}.profits-baselineProfits;
    aiByOwner=[];
    for k=1:numOwners
        aiByOwner(k)=sum(profits(ownership(k,:)));
    end
    AI_leaf(i)=sum(aiByOwner(aiByOwner>0));
end

midtargets=1:11;
AI_mid=zeros(length(midtargets),1);
for i=1:length(midtargets)
    profits=run10_data{i,1}.profits-baselineProfits;
    aiByOwner=[];
    for k=1:numOwners
        aiByOwner(k)=sum(profits(ownership(k,:)));
    end
    AI_mid(i)=sum(aiByOwner(aiByOwner>0));
end

AI_top=zeros(3,1);
for i=1:length(AI_top)
    profits=run11_data{i}.profits-baselineProfits;
    aiByOwner=[];
    for k=1:numOwners
        aiByOwner(k)=sum(profits(ownership(k,:)));
    end
    AI_top(i)=sum(aiByOwner(aiByOwner>0));
end

figure;
subplot(1,3,1);
hold all;
plot(targets,AI_leaf,'-','LineWidth',2);
plot(AIbyowner_targets,AIbyowner_avg,'--','LineWidth',2);
hold off;
xlabel('Leaf Link Attack Budget');
ylabel('Attacker''s Incentive');
set(gca,'FontSize',18);
legend('Optimized','Random');
xlim([0 120]);
ylim([0 2.5e5]);

%figure;
subplot(1,3,2);
hold all;
plot(midtargets,AI_mid,'-','LineWidth',2);
plot(AIbyowner_mid_targets,AIbyowner_mid_avg,'--','LineWidth',2);
hold off;
xlabel('Mid Link Attack Budget');
legend('Optimized','Random');
%ylabel('Attacker''s Incentive');
set(gca,'FontSize',18);
xlim([0 12]);
ylim([0 2.5e5]);


%figure;
subplot(1,3,3);
plot(1:3,AI_top,'-','LineWidth',2);
xlabel('Top Link Attack Budget');
%ylabel('Attacker''s Incentive');
set(gca,'FontSize',18);
xlim([1 3]);
ylim([0 2.5e5]);
