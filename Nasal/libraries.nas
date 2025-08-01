# Boeing 747-400 Main Libraries
# Copyright (c) 2025 Josh Davidson (Octal450) and Gijs de Rooy

var systemsInit = func() {
	# Standard modules
	systems.FADEC.init();
	fms.CORE.init();
};

var fdmInit = setlistener("/sim/signals/fdm-initialized", func() {
	systemsInit();
	systemsLoop.start();
	removelistener(fdmInit);
	initDone = 1;
});

var systemsLoop = maketimer(0.1, func() {
	fms.CORE.loop();
	systems.FADEC.loop();
});
