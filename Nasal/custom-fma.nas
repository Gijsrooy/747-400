# IT Autoflight V4.1.0 Custom FMA File
# Make sure you enable custom-fma in the config
# Copyright (c) 2025 Josh Davidson (Octal450) and Gijs de Rooy

var Fma = {
	elapsedSec: props.globals.getNode("/sim/time/elapsed-sec"),
	Box: {
		show: [0, 0, 0, 0],
		elapsed: 0,
		time: [-10, -10, -10, -10],
	},
	loop: func() {
		me.Box.elapsed = me.elapsedSec.getValue();
		
		for (var i = 0; i < 4; i = i + 1) {
			if (me.Box.show[i] and me.Box.elapsed > me.Box.time[i] + 10) {
				me.Box.show[i] = 0;
			}
		}
	},
	showBox: func(window) { # 0 AFDS, 1 Speed, 2 Roll, 3 Pitch
		me.Box.show[window] = 1;
		me.Box.time[window] = me.elapsedSec.getValue();
		me.loop();
	},
	hideBox: func(window) {
		me.Box.show[window] = 0;
	 	me.Box.time[window] = -10;
	},
};

var UpdateFma = {
	thr: func() { # Called when speed/thrust modes change
		if (Text.thr.getValue() == "MACH" or Text.thr.getValue() == "SPEED") {
			Text.thr.setValue("SPD");
		} elsif (Text.thr.getValue() == "THR LIM") {
			Text.thr.setValue("THR REF");
			if (Output.vert.getValue() == 7) {
				atHoldLoop.start();
			}
		} elsif (Text.thr.getValue() == "RETARD") {
			Text.thr.setValue("IDLE");
		} elsif (Text.thr.getValue() == "CLAMP") {
			Text.thr.setValue("HOLD");
		}
	},
	arm: func() { # Called when armed modes change
		if (Output.lnavArm.getBoolValue()) {
			Text.latArm.setValue("LNAV");
		} elsif (Output.locArm.getBoolValue()) {
			Text.latArm.setValue("LOC");
		} elsif (Output.rolloutArm.getBoolValue()) {
			Text.latArm.setValue("ROLLOUT");
		} else {
			Text.latArm.setValue("");
		}
		if (Output.gsArm.getBoolValue()) {
			Text.vertArm.setValue("G/S");
		} elsif (Output.flareArm.getBoolValue()) {
			Text.vertArm.setValue("FLARE");
		} else {
			Text.vertArm.setValue("");
		}
	},
	lat: func() { # Called when lateral mode changes
		if (Text.lat.getValue() == "T/O") {
			Text.lat.setValue("TO/GA");
		} elsif (Text.lat.getValue() == "ROLL") {
			Text.lat.setValue("ATT");
		} elsif (Text.lat.getValue() == "HDG") {
			if (Output.hdgInHld.getBoolValue()) {
				Text.lat.setValue("HDG HOLD");
			} else {
				Text.lat.setValue("HDG SEL");
			}
		} elsif (Text.lat.getValue() == "LOC") {
			Input.hdg.setValue(getprop("/instrumentation/nav[" ~ Input.radioSel.getValue() ~ "]/radials/selected-deg"));
		} elsif (Text.lat.getValue() == "ALIGN") {
			Text.lat.setValue("LOC");
		}
	},
	vert: func() { # Called when vertical mode changes
		if (Text.vert.getValue() == "ALT CAP" or Text.vert.getValue() == "ALT HLD") {
			Text.vert.setValue("ALT");
		} elsif (Text.vert.getValue() == "T/O CLB" or Text.vert.getValue() == "G/A CLB") {
			Text.vert.setValue("TO/GA");
		} elsif (Text.vert.getValue() == "SPD CLB" or Text.vert.getValue() == "SPD DES") {
			Text.vert.setValue("FLCH SPD");
		} elsif (Text.vert.getValue() == "FPA") {
			Text.vert.setValue("VNAV PTH");
		} elsif (Text.vert.getValue() == "ROLLOUT") {
			Text.vert.setValue("");
		}
	},
};

var ATHold = {
	loop: func(t = 0) {
		if (Velocities.indicatedAirspeedKt.getValue() > 65) {
			if (Output.vert.getValue() == 7) {
				if (Input.athrServoClamp.getBoolValue() == 0) {
					Input.athrServoClamp.setBoolValue(1);
				}
			} else {
				Input.athrServoClamp.setBoolValue(0);
				atHoldLoop.stop();
			}
		}
	}
};

var atHoldLoop = maketimer(0.1, ATHold, ATHold.loop);