# Boeing 747-400 Main Libraries
# Copyright (c) 2025 Josh Davidson (Octal450) and Gijs de Rooy

var systemsInit = func() {
	# Standard modules
	systems.FADEC.init();
	fms.CORE.init();

	# Object orientated modules
	cdu.BASE.setup();
};

var fdmInit = setlistener("/sim/signals/fdm-initialized", func() {
	systemsInit();
	systemsLoop.start();
	canvas_cdu.setup();
	removelistener(fdmInit);
	initDone = 1;
});

var systemsLoop = maketimer(0.1, func() {
	fms.CORE.loop();
	cdu.BASE.loop();
	systems.FADEC.loop();
});
