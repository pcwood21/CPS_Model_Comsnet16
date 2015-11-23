
DSim=cnexp1_genscenario(zeros(500,1));
aList=DSim.getAgentsByName('dsim.MktPlayer');
nMktPlayers=length(aList);

nTargets=1:12;
nSeeds=1:20;
create_run(6,'cnexp1_attacks3_runner',nTargets,nSeeds);
