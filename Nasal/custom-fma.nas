# IT Autoflight V4.1.0 Custom FMA File
# Make sure you enable custom-fma in the config
# Copyright (c) 2025 Josh Davidson (Octal450) and Gijs de Rooy

var Fma = {
	elapsedSec: props.globals.getNode("/sim/time/elapsed-sec"),
	at: props.globals.initNode("/instrumentation/pfd/fma/at-mode", "", "STRING"),
	pitch: props.globals.initNode("/instrumentation/pfd/fma/pitch-mode", "", "STRING"),
	pitchArm: props.globals.initNode("/instrumentation/pfd/fma/pitch-mode-armed", "", "STRING"),
	roll: props.globals.initNode("/instrumentation/pfd/fma/roll-mode", "", "STRING"),
	rollArm: props.globals.initNode("/instrumentation/pfd/fma/roll-mode-armed", "", "STRING"),
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
	latText: "",
	vertText: "",
	thr: func() { # Called when speed/thrust modes change
		if (Text.thr.getValue() == "MACH" or Text.thr.getValue() == "SPEED") {
			Fma.at.setValue("SPD");
		} elsif (Text.thr.getValue() == "THR LIM") {
			Fma.at.setValue("THR REF");
			if (Output.vert.getValue() == 7) {
				atHoldLoop.start();
			}
		} elsif (Text.thr.getValue() == "IDLE" or Text.thr.getValue() == "RETARD") {
			Fma.at.setValue("IDLE");
		} elsif (Text.thr.getValue() == "CLAMP") {
			Fma.at.setValue("HOLD");
		}
	},
	arm: func() { # Called when armed modes change
		if (Output.lnavArm.getBoolValue()) {
			Fma.rollArm.setValue("LNAV");
		} elsif (Output.locArm.getBoolValue()) {
			Fma.rollArm.setValue("LOC");
		} elsif (Output.rolloutArm.getBoolValue()) {
			Fma.rollArm.setValue("ROLLOUT");
		} else {
			Fma.rollArm.setValue("");
		}

		if (Output.gsArm.getBoolValue()) {
			Fma.pitchArm.setValue("G/S");
		} elsif (Output.flareArm.getBoolValue()) {
			Fma.pitchArm.setValue("FLARE");
		} else {
			Fma.pitchArm.setValue("");
		}
	},
	lat: func() { # Called when lateral mode changes
		me.latText = Text.lat.getValue();

		if (me.latText == "T/O") {
			Fma.roll.setValue("TO/GA");
		} elsif (me.latText == "LNAV") {
			Fma.roll.setValue("LNAV");
		} elsif (me.latText == "ROLL") {
			Fma.roll.setValue("ATT");
		} elsif (me.latText == "HDG") {
			if (Output.hdgInHld.getBoolValue()) {
				Fma.roll.setValue("HDG HOLD");
			} else {
				Fma.roll.setValue("HDG SEL");
			}
		} elsif (me.latText == "LOC") {
			Fma.roll.setValue("LOC");
			Input.hdg.setValue(getprop("/instrumentation/nav[" ~ Input.radioSel.getValue() ~ "]/radials/selected-deg"));
		} elsif (me.latText == "ALIGN") {
			Fma.roll.setValue("LOC");
		} else {
			Fma.roll.setValue("");
		}
	},
	vert: func() { # Called when vertical mode changes
		me.vertText = Text.vert.getValue();

		if (me.vertText == "ALT CAP" or me.vertText == "ALT HLD") {
			Fma.pitch.setValue("ALT");
		} elsif (me.vertText == "T/O CLB" or me.vertText == "G/A CLB") {
			Fma.pitch.setValue("TO/GA");
		} elsif (me.vertText == "SPD CLB" or me.vertText == "SPD DES") {
			Fma.pitch.setValue("FLCH SPD");
		} elsif (me.vertText == "FPA") {
			Fma.pitch.setValue("VNAV PTH");
		} elsif (me.vertText == "ROLLOUT") {
			Fma.pitch.setValue("");
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