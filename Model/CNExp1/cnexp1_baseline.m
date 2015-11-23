
runTime=400;
attackList=zeros(500,1);
[clientProfits,DSim]=cnexp1_runscenario(attackList,runTime);
aList=DSim.getAgentsByName('dsim.MktLogger');
logger=aList{1};
figure;
pH=logger.priceHist(2:end);
rH=logger.residualHist(2:end);
tH=logger.timeHist(2:end);
[ax,h1,h2]=plotyy(tH,pH,tH,rH);
ylabel(ax(2),'Residual Power');
ylabel(ax(1),'Market Price (\lambda)');
xlabel('Time (s)');
legend([h1;h2],'Price','Power');
set(gca,'FontSize',18);
set(ax(2),'FontSize',18);

aList=DSim.getAgentsByName('dsim.MktPlayer');
genIdx=zeros(length(aList),1);
conIdx=zeros(length(aList),1);
for i=1:length(aList)
    agent=aList{i};
    if agent.PrMin==0
        %Agent is Consumer
        conIdx(i)=1;
    else
        %Agent is a Generator
        genIdx(i)=1;
    end
end

genProfits=clientProfits(genIdx==1);
genProfits=genProfits*length(genProfits);
conProfits=clientProfits(conIdx==1);
conProfits=conProfits*length(conProfits);
grp=[zeros(1,length(genProfits)),ones(1,length(conProfits))];

figure;
bh=boxplot([genProfits' conProfits'],grp,'labels',{'Generators','Consumers'});
set(gca,'FontSize',18);
set(bh(:,:),'linewidth',2);
ylabel('Normalized Profits');
%ylim([0.5 1.5]);

figure;
bh=bar(sort(clientProfits)/3600);%,'labels',{'Market Player Profits'});
set(gca,'FontSize',18);
set(bh(:,:),'linewidth',2);
ylabel('Profit ($)');
xlim([0 length(clientProfits)]);
xlabel('Market Players');
ylim([0 max(clientProfits)/3600]);
%set(bh,'XTick',[])


%Individual Profit
profitHist=logger.test_profitHist(2:end);
powerHist=logger.test_powerHist(2:end);
timeHist=logger.timeHist(2:end);


clear DSim;
attackList=zeros(500,1);
attackList(1)=1;
[clientProfits,DSim]=cnexp1_runscenario(attackList,runTime);

aList=DSim.getAgentsByName('dsim.MktLogger');
logger=aList{1};
newprofitHist=logger.test_profitHist(2:end);
newpowerHist=logger.test_powerHist(2:end);


clear DSim;
attackList=zeros(500,1);
attackList(21:50)=1;
[clientProfits,DSim]=cnexp1_runscenario(attackList,runTime);

aList=DSim.getAgentsByName('dsim.MktLogger');
logger=aList{1};
otherprofitHist=logger.test_profitHist(2:end);
otherpowerHist=logger.test_powerHist(2:end);


figure;
[ax,h1,h2]=plotyy(timeHist,[profitHist' newprofitHist'],timeHist,[abs(powerHist)' abs(newpowerHist)']);
ylabel(ax(2),'Power (W)');
ylabel(ax(1),'Profit ($)');
%set(h1,'LineStyle','-','LineWidth',2)
%set(h2,'LineStyle','--','LineWidth',2)
xlabel('Time (s)');
%legend([h1;h2],'Profit','Power');
set(gca,'FontSize',18);
set(ax(2),'FontSize',18);

figure;
hold all;
plot(timeHist,profitHist,'LineWidth',2);
plot(timeHist,newprofitHist,'--','LineWidth',2);
plot(timeHist,otherprofitHist,':','LineWidth',2);
legend('No Attack','Self Attacked','Others Attacked');
xlabel('Time (s)');
ylabel('Profit ($)');
set(gca,'FontSize',18);

figure;
hold all;
plot(timeHist,abs(powerHist),'LineWidth',2);
plot(timeHist,abs(newpowerHist),'--','LineWidth',2);
plot(timeHist,abs(otherpowerHist),':','LineWidth',2);
legend('No Attack','Self Attacked','Others Attacked');
xlabel('Time (s)');
ylabel('Power (W)');

baseProfits=sum(profitHist);
target1Profits=sum(newprofitHist);
target2Profits=sum(otherprofitHist);
IM=[target1Profits-baseProfits target2Profits-baseProfits]/400
