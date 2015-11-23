
DSim=cnexp1_genscenario(zeros(500,1));
aList=DSim.getAgentsByName('dsim.MktPlayer');
nMktPlayers=length(aList);

nTargets=floor(linspace(1,118,30));
nSeeds=1:40;
create_run(3,'cnexp1_attacks2_runner',nTargets,nSeeds);
