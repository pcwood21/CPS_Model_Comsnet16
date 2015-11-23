
DSim=cnexp1_genscenario(zeros(500,1));
aList=DSim.getAgentsByName('dsim.MktPlayer');
nMktPlayers=length(aList);

numOwners=12;
targetIdxList=1:numOwners;
create_run(10,'cnexp1_attacks6_runner',targetIdxList,[1]);
