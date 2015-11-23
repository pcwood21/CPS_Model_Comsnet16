
DSim=cnexp1_genscenario(zeros(500,1));
aList=DSim.getAgentsByName('dsim.MktPlayer');
nMktPlayers=length(aList);

numOwners=12;
numAssets=120;

targets=1:119;
sigmas=0.1:0.1:0.5;
seeds=1;
create_run(13,'cnexp2_strat_runner',targets,sigmas,seeds);


targets=120
run13_addendum={};
parfor i=1:length(sigmas)
   run13_addendum{i}=cnexp2_strat_runner(targets,sigmas(i),seeds);
end
