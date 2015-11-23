function [output] = cnexp1_attacks2_runner(numTargets,seed)

clear DSim;
DSim=cnexp1_genscenario(zeros(500,1));
aList=DSim.getAgentsByName('dsim.MktPlayer');
nMktPlayers=length(aList);

runTime=400;

targetList=zeros(nMktPlayers,1);

rng(seed);
targetIdx=randperm(length(targetList),numTargets);
targetList(targetIdx)=1;


profits=cnexp1_runscenario(targetList,runTime);

output.profits=profits;
output.targetList=targetList;
end