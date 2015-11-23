
DSim=cnexp1_genscenario(zeros(500,1));
aList=DSim.getAgentsByName('dsim.MktPlayer');
nMktPlayers=length(aList);

targetIdxList=1:nMktPlayers;
create_run(9,'cnexp1_attacks5_runner',targetIdxList,[1]);
