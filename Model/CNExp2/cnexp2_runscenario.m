function  [clientProfits,DSim]=cnexp2_runscenario(attackList,sigma,ownerId,runTime)
%ABMARKET Summary of this function goes here
%   Detailed explanation goes here

clear DSim;
DSim=cnexp1_genscenario(attackList);
numOwners=12;
numAssets=120;
ownerList=cnexp2_owenership_model( numOwners,numAssets );
rng('shuffle');

addLatencyScenarioParam=@(X) addLatencyScenario(X,attackList);

scenario=dsim.MktScenario();
scenario.addEvent(50,addLatencyScenarioParam);
scenario.addEvent(100,@addLoadScenario);
scenario.addEvent(200,@remLatencyScenario);
scenario.addEvent(250,@remLoadScenario);
DSim.addAgent(scenario);

aList=DSim.getAgentsByName('dsim.MktPlayer');
for i=1:length(aList)
%     if any(i==ownerList(ownerId,:))
%         continue;
%     end
    agent=aList{i};
    newPmin=agent.Pmin*(1+sigma*randn());
    if newPmin < 0 && agent.Pmin > 0
        newPmin=0;
    elseif newPmin > 0 && agent.Pmin < 0
        newPmin=0;
    end
    newPmax=agent.Pmax*(1+sigma*randn());
    if newPmax < 0 && agent.Pmax > 0
        newPmax=0;
    elseif newPmax > 0 && agent.Pmax < 0
        newPmax=0;
    end
    newPrmin=agent.PrMin*(1+sigma*randn());
    if newPrmin < 0
        newPrmin=0;
    end
    newPrmax=agent.PrMax*(1+sigma*randn());
    if newPrmax < 0
        newPrmax=0;
    end
    if newPrmax<newPrmin
        newPrmax=newPrmin+0.01;
    end
    agent.Pmin=newPmin;
    agent.Pmax=newPmax;
    agent.PrMin=newPrmin;
    agent.PrMax=newPrmax;
end

    

DSim.run(runTime);

aList=DSim.getAgentsByName('dsim.MktLogger');
logger=aList{1};
clientProfits=logger.profitList;

%{
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
%}


end

function addLatencyScenario(DSim,clientList)

ISO=DSim.getAgentsByName('dsim.ISO');
ISO=ISO{1};
aList=DSim.getAgentsByName('dsim.MktPlayer');
targetAgents=aList(clientList==1);
targetComms=[];
targetAID=[];
for i=1:length(targetAgents)
    agent=targetAgents{i};
    targetAID(end+1)=agent.id;
    targetComms(end+1)=agent.commAgentId;
end

aList=DSim.getAgentsByName('dsim.Comm');
for i=1:length(aList)
    agent=aList{i};
    if any(agent.id==targetComms) || (~isempty(agent.availDestAgent) && any(agent.availDestAgent==targetAID))
        agent.Bandwidth=1e9;
        agent.Latency=1e9;
    end
end

end

function addLoadScenario(DSim)

aList=DSim.getAgentsByName('dsim.MktPlayer');
for i=1:length(aList)
    agent=aList{i};
    if agent.Pmax>0
        agent.APmax=0.5;
        agent.APmin=0.1;
    end
end

end

function remLoadScenario(DSim)

aList=DSim.getAgentsByName('dsim.MktPlayer');
for i=1:length(aList)
    agent=aList{i};
    if agent.Pmax>0
        agent.APmax=0;
        agent.APmin=0;
    end
end

end

function remLatencyScenario(DSim)

aList=DSim.getAgentsByName('dsim.Comm');
for i=1:length(aList)
    agent=aList{i};
    agent.Bandwidth=1e9;
    agent.Latency=0;
end

end