
DSim=cnexp1_genscenario(zeros(500,1));
aList=DSim.getAgentsByName('dsim.MktPlayer');
nMktPlayers=length(aList);

numOwners=12;
nTargets=1:12;
nSeeds=1;
create_run(7,'cnexp1_attacks3_runner',nTargets,nSeeds);


clear all;
nTargets=1:12;
nSeeds=1;

parfor i=1:length(nTargets)
    run7_data{i}=cnexp1_attacks4_runner(i,1);
end

numOwners=12;
numTier=4;
numInTier=numOwners/numTier; %3
targetIdx=[];
for k=1:4
    targetIdx(k,:)=[(k-1)*numInTier+1:(k)*numInTier];
end

parfor k=1:4
    run8_data{k}=cnexp1_attacks4_runner(targetIdx(k,:),1);
end