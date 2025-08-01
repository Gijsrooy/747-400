# Boeing 747-400 FADEC
# Copyright (c) 2025 Josh Davidson (Octal450) and Gijs de Rooy

var FADEC = {
	pitchMode: "",
	reverseEngage: [props.globals.getNode("/systems/fadec/reverse-1/engage"), props.globals.getNode("/systems/fadec/reverse-2/engage"), props.globals.getNode("/systems/fadec/reverse-3/engage"), props.globals.getNode("/systems/fadec/reverse-4/engage")],
	throttleCompareMax: props.globals.getNode("/systems/fadec/throttle-compare-max"),
	Limit: {
	activeMode: props.globals.getNode("/systems/fadec/limit/active-mode"),
		activeModeInt: props.globals.getNode("/systems/fadec/limit/active-mode-int"), # 0 T/O, 1 G/A, 2 CON (MCT), 3 CLB, 4 CRZ
		auto: props.globals.getNode("/systems/fadec/limit/auto"),
	},
	Controls: {
		altn1: props.globals.getNode("/controls/fadec/altn-1"),
		altn2: props.globals.getNode("/controls/fadec/altn-2"),
		altn3: props.globals.getNode("/controls/fadec/altn-3"),
		altn4: props.globals.getNode("/controls/fadec/altn-4"),
	},
	init: func() {
		me.reverseEngage[0].setBoolValue(0);
		me.reverseEngage[1].setBoolValue(0);
		me.reverseEngage[2].setBoolValue(0);
		me.reverseEngage[3].setBoolValue(0);
		me.Controls.altn1.setBoolValue(0);
		me.Controls.altn2.setBoolValue(0);
		me.Controls.altn3.setBoolValue(0);
		me.Controls.altn4.setBoolValue(0);
		me.Limit.activeModeInt.setValue(0);
		me.Limit.activeMode.setValue("T/O");
		me.Limit.auto.setBoolValue(1);
	},
	loop: func() {
		me.pitchMode = itaf.Text.vert.getValue();

		if (me.Limit.auto.getBoolValue()) {
			if (me.pitchMode == "G/A CLB") {
				me.setMode(1); # G/A
			} else if (me.pitchMode == "T/O CLB") {
				me.setMode(0); # T/O
			} else if (me.pitchMode == "SPD CLB" or fms.Internal.phase < 3) {
				me.setMode(3); # CLB
			} else {
				me.setMode(4); # CRZ
			}
		}
	},
	setMode: func(m) {
		if (m == 0) {
			me.Limit.activeModeInt.setValue(0);
			me.Limit.activeMode.setValue("T/O");
		} else if (m == 1) {
			me.Limit.activeModeInt.setValue(1);
			me.Limit.activeMode.setValue("G/A");
		} else if (m == 2) {
			me.Limit.activeModeInt.setValue(2);
			me.Limit.activeMode.setValue("CON");
		} else if (m == 3) {
			me.Limit.activeModeInt.setValue(3);
			me.Limit.activeMode.setValue("CLB");
		} else if (m == 4) {
			me.Limit.activeModeInt.setValue(4);
			me.Limit.activeMode.setValue("CRZ");
		}
	},
};
