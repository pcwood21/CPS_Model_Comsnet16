function [output] = cnexp1_attacks6_runner(targetIdx,numTargets)

numOwners=12;
numAssets=120;
[ ownership, toptier ] = cnexp2_owenership_model( numOwners,numAssets );

clear DSim;
DSim=cnexp1_genscenario(zeros(500,1));
aList=DSim.getAgentsByName('dsim.MktPlayer');
nMktPlayers=length(aList);

runTime=400;

load('targetListArrayMid.mat');
ownerTargets=targetListArrayMid{targetIdx};

targetList=zeros(nMktPlayers,1);
targetList(ownership(ownerTargets,:))=1;
clear DSim;
rng('shuffle');

[profits, DSim]=cnexp1_runscenario(targetList,runTime);

output.profits=profits;
output.targetList=targetList;
output.DSim=DSim;
end