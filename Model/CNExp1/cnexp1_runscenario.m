function  [clientProfits,DSim]=cnexp1_runscenario(attackList,runTime)
%ABMARKET Summary of this function goes here
%   Detailed explanation goes here

clear DSim;
DSim=cnexp1_genscenario(attackList);
rng('shuffle');

addLatencyScenarioParam=@(X) addLatencyScenario(X,attackList);

scenario=dsim.MktScenario();
scenario.addEvent(50,addLatencyScenarioParam);
scenario.addEvent(100,@addLoadScenario);
scenario.addEvent(200,@remLatencyScenario);
scenario.addEvent(250,@remLoadScenario);
DSim.addAgent(scenario);

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