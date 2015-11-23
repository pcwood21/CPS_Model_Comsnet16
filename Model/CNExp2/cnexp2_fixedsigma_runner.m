function [output] = cnexp2_fixedsigma_runner(targetIdx,ownerId,seed)

clear DSim;
DSim=cnexp1_genscenario(zeros(500,1));
aList=DSim.getAgentsByName('dsim.MktPlayer');
nMktPlayers=length(aList);

runTime=400;

targetList=zeros(nMktPlayers,1);

rng(seed);
%targetIdx=randperm(length(targetList),numTargets);
targetList(targetIdx)=1;

sigma=0.1;

profits=cnexp2_runscenario(targetList,sigma,ownerId,runTime);

output.profits=profits;
output.targetList=targetList;
end