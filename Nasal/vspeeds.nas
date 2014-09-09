var V1announced = 0;
var V2announced = 0;
var VRannounced = 0;
var V1 = "";
var V2 = "";
var VR = "";
var Vref = "";
var Vref1 = "";
var Vref5 = "";
var Vref10 = "";
var Vref20 = "";
var Vref30 = "";
var Vmax = "";

var vspeeds = func {
	WT = getprop("/fdm/jsbsim/inertia/weight-lbs")*0.00045359237;
	toflaps = getprop("/instrumentation/fmc/to-flap");
	flaps = getprop("/controls/flight/flaps");
	if (toflaps == 10) {
		V1 = (0.3*(WT-200))+100;
		VR = (0.3*(WT-200))+115;
		V2 = (0.3*(WT-200))+135;
	}
	if (toflaps == 20) {
		V1 = (0.3*(WT-200))+95;
		VR = (0.3*(WT-200))+110;
		V2 = (0.3*(WT-200))+130;
	}
	Vref25 = (0.3*(WT-200))+132;
	Vref30 = (0.285*(WT-200))+127;
	if (flaps == 0.833)
		Vref = Vref25;
	if (flaps == 1) 
		Vref = Vref30;
	if(Vref != "")
		Vref = math.ceil(Vref/20)*20;
	Vref30 = math.ceil(Vref30/20)*20;

	Vref1 = Vref30 + 80;
	Vref5 = Vref30 + 60;
	Vref10 = Vref30 + 40;
	Vref20 = Vref30 + 20;
	
	Vmax = 365; # Vmo (Mach 0.92)
	if (getprop("/controls/gear/gear-down"))
		Vmax = 320;
	if (flaps == 0.033)
		Vmax = 280;
	elsif (flaps == 0.167)
		Vmax = 260;
	elsif (flaps == 0.333)
		Vmax = 240;
	elsif (flaps == 0.667)
		Vmax = 230;
	elsif (flaps == 0.833)
		Vmax = 205;
	elsif (flaps == 1)
		Vmax = 180;
	
	setprop("/instrumentation/fmc/vspeeds/V1",int(V1));
	setprop("/instrumentation/fmc/vspeeds/VR",int(VR));
	setprop("/instrumentation/fmc/vspeeds/Vref",Vref);
	setprop("/instrumentation/fmc/vspeeds/Vref1",Vref1);
	setprop("/instrumentation/fmc/vspeeds/Vref5",Vref5);
	setprop("/instrumentation/fmc/vspeeds/Vref10",Vref10);
	setprop("/instrumentation/fmc/vspeeds/Vref20",Vref20);
	setprop("/instrumentation/fmc/vspeeds/Vref30",Vref30);
	setprop("/instrumentation/fmc/vspeeds/Vmax",Vmax);
	setprop("/instrumentation/fmc/vspeeds/V2",int(V2));
	setprop("/instrumentation/fmc/cg",getprop("/fdm/jsbsim/aero/CoG-mac-pct"));
	setprop("/instrumentation/fmc/stab-trim-units",getprop("/fdm/jsbsim/aero/stab-trim-units"));
	settimer(vspeeds, 1);
}

_setlistener("/sim/signals/fdm-initialized", vspeeds);
