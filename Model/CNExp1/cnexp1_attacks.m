

%Single Attack Impact Matrix

DSim=cnexp1_genscenario(zeros(500,1));
aList=DSim.getAgentsByName('dsim.MktPlayer');
nMktPlayers=length(aList);

runTime=300;
baselineProfits=cnexp1_runscenario(zeros(nMktPlayers,1),runTime);

nTargets=nMktPlayers;

IM=zeros(nTargets,nMktPlayers);
parfor i=1:length(nTargets)
    targetList=zeros(nTargets,1);
    targetList(i)=1;
    profits=cnexp1_runscenario(targetList,runTime);
    IM(i,:)=profits;
end
