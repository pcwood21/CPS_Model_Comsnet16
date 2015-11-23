function [output] = cnexp1_attacks5_runner(targetIdx,numTargets)

clear DSim;
DSim=cnexp1_genscenario(zeros(500,1));
aList=DSim.getAgentsByName('dsim.MktPlayer');
nMktPlayers=length(aList);

runTime=400;

load('targetListArray.mat');
targetList=zeros(nMktPlayers,1);
targetList(targetListArray{targetIdx})=1;
clear DSim;
rng('shuffle');

[profits, DSim]=cnexp1_runscenario(targetList,runTime);

output.profits=profits;
output.targetList=targetList;
output.DSim=DSim;
end