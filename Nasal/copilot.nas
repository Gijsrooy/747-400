setlistener("/sim/signals/fdm-initialized", func {
    copilot.init();
});

# Copilot announcements
var copilot = {
	init : func { 
        me.UPDATE_INTERVAL = 1; 
        me.loopid = 0; 
		# Initialize state variables.
		me.V1announced = 0;
		me.VRannounced = 0;
		me.V2announced = 0;
		me.cogannounced = 0;
        me.reset(); 
        print("Copilot aboard"); 
    }, 
	update : func {
        var airspeed = getprop("velocities/airspeed-kt");
		var V1 = getprop("/instrumentation/fmc/vspeeds/V1");
		var V2 = getprop("/instrumentation/fmc/vspeeds/V2");
		var VR = getprop("/instrumentation/fmc/vspeeds/VR");
		
        if ((airspeed != nil) and (V1 != nil) and (airspeed > V1) and (me.V1announced == 0)) {
            me.announce("V1!");
			me.V1announced = 1;
        } elsif ((airspeed != nil) and (VR != nil) and (airspeed > VR) and (me.VRannounced == 0)) {
            me.announce("VR!");
			me.VRannounced = 1;
        } elsif ((airspeed != nil) and (V2 != nil) and (airspeed > V2) and (me.V2announced == 0)) {
            me.announce("V2!");
			me.V2announced = 1;
        }
		if (getprop("/fdm/jsbsim/aero/outside-cog-envelope") == 1 and !me.cogannounced) {
			me.announce("Warning: the center of gravity lies outside the flight envelope!");
			me.cogannounced = 1;
		}
    },
	announce : func(msg) {
        setprop("/sim/messages/copilot", msg);
    },
    reset : func {
        me.loopid += 1;
        me._loop_(me.loopid);
    },
    _loop_ : func(id) {
        id == me.loopid or return;
        me.update();
        settimer(func { me._loop_(id); }, me.UPDATE_INTERVAL);
    }
};