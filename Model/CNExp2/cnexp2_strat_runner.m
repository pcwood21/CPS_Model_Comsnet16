function [output] = cnexp2_strat_runner(targetIdx,sigma,seed)

clear DSim;
DSim=cnexp1_genscenario(zeros(500,1));
aList=DSim.getAgentsByName('dsim.MktPlayer');
nMktPlayers=length(aList);

runTime=400;

targetList=zeros(nMktPlayers,1);

rng(seed);
targetList(targetIdx)=1;


profits=cnexp2_runscenario(targetList,sigma,ownerId,runTime);

output.profits=profits;
output.targetList=targetList;
end