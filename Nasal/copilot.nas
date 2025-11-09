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
    }, 
	update : func {
        var airspeed = pts.Instrumentation.AirspeedIndicator.indicatedSpeedKt.getValue();
		var V1 = fms.flightData.v1;
		var V2 = fms.flightData.v2;
		var VR = fms.flightData.vr;
		
        if ((airspeed != 0) and (V1 != 0) and (airspeed > V1) and (me.V1announced == 0)) {
            me.announce("V1!");
			me.V1announced = 1;
        } elsif ((airspeed != 0) and (VR != 0) and (airspeed > VR) and (me.VRannounced == 0)) {
            me.announce("VR!");
			me.VRannounced = 1;
        } elsif ((airspeed != 0) and (V2 != 0) and (airspeed > V2) and (me.V2announced == 0)) {
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