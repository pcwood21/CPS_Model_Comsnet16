
DSim=cnexp1_genscenario(zeros(500,1));
aList=DSim.getAgentsByName('dsim.MktPlayer');
nMktPlayers=length(aList);

numOwners=12;
numAssets=120;

sigmaval=linspace(0,0.5,10);
owners=1:numOwners;
nSeeds=1:20;
create_run(5,'cnexp2_fixedtargets_runner',sigmaval,owners,nSeeds);
