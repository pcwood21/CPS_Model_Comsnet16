
DSim=cnexp1_genscenario(zeros(500,1));
aList=DSim.getAgentsByName('dsim.MktPlayer');
nMktPlayers=length(aList);

targetIdxList=1:nMktPlayers;
create_run(1,'cnexp1_attacks1_runner',targetIdxList,[1]);
