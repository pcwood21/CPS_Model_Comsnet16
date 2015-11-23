function [output] = cnexp1_attacks7_runner(targetIdx,numTargets)

numOwners=12;
numAssets=120;
[ ownership, toptier ] = cnexp2_owenership_model( numOwners,numAssets );

clear DSim;
DSim=cnexp1_genscenario(zeros(500,1));
aList=DSim.getAgentsByName('dsim.MktPlayer');
nMktPlayers=length(aList);

runTime=400;

load('targetListArrayTop.mat');
ownerTargets=targetListArrayTop{targetIdx};

targetList=zeros(nMktPlayers,1);
targetList(ownership(toptier(ownerTargets),:))=1;
clear DSim;
rng('shuffle');

[profits, DSim]=cnexp1_runscenario(targetList,runTime);

output.profits=profits;
output.targetList=targetList;
output.DSim=DSim;
end

%{

run11_data={};
parfor i=1:3
    run11_data{i}=cnexp1_attacks7_runner(i,-1);
end
