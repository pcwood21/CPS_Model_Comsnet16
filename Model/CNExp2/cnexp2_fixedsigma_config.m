
DSim=cnexp1_genscenario(zeros(500,1));
aList=DSim.getAgentsByName('dsim.MktPlayer');
nMktPlayers=length(aList);

numOwners=12;
numAssets=120;

nTargets=floor(linspace(1,119,10));
owners=1:numOwners;
nSeeds=1:3;
create_run(12,'cnexp2_fixedsigma_runner',nTargets,owners,nSeeds);
