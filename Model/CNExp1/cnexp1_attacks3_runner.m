function [output] = cnexp1_attacks3_runner(numTargets,seed)

clear DSim;
DSim=cnexp1_genscenario(zeros(500,1));
aList=DSim.getAgentsByName('dsim.MktPlayer');
nMktPlayers=length(aList);

runTime=400;

targetList=zeros(nMktPlayers,1);

rng(seed);
ownership=cnexp2_owenership_model(12,120);

targetIdx=randperm(size(ownership,1),numTargets);
targetList(ownership(targetIdx,:))=1;


[profits,DSim]=cnexp1_runscenario(targetList,runTime);

output.profits=profits;
output.targetList=targetList;
output.DSim=DSim;
end