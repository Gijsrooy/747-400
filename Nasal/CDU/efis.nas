# Boeing 747-400 CDU
# Copyright (c) 2025 Josh Davidson (Octal450) and Gijs de Rooy

var EfisControl = {
	new: func(n, t) {
		var m = {parents: [EfisControl]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			CLTranslate: [0, 0, 0, 0, 0, 0],
			CTranslate: [0, 0, 0, 0, 0, 0],
			C1L: "",
			C1: "",
			C2L: "",
			C2: "",
			C3L: "",
			C3: "",
			C4L: "",
			C4: "",
			C5L: "",
			C5: "",
			C6L: "",
			C6: "",
			
			LFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1L: "",
			L1: "",
			L2L: "",
			L2: "",
			L3L: "",
			L3: "",
			L4L: "",
			L4: "",
			L5L: "",
			L5: "",
			L6L: "",
			L6: "",
			
			LBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "",
			
			RFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1L: "MODE",
			R1: "",
			R2L: "",
			R2: "",
			R3L: "",
			R3: "",
			R4L: "",
			R4: "",
			R5L: "",
			R5: "",
			R6L: "-----------",
			R6: "OPTIONS>",
			
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "EFIS CONTROL",
			titleTranslate: -1,
		};
			
		m.group = "fmc";
		m.name = "efisControl";
		m.type = t;
		
		return m;
	},
	setup: func() {
	},
	loop: func() {
		if (me.type == 0) {
			me.Display.R1 = (pts.Instrumentation.Efis.Mfd.mode[me.id].getValue() == "MAP" ? "<SEL>" : "") ~ "  MAP>";
			me.Display.R2 = (pts.Instrumentation.Efis.Mfd.mode[me.id].getValue() == "PLAN" ? "<SEL>" : "") ~ " PLAN>";
			me.Display.R3 = (pts.Instrumentation.Efis.Mfd.mode[me.id].getValue() == "APP" ? "<SEL>" : "") ~ "  APP>";
			me.Display.R4 = (pts.Instrumentation.Efis.Mfd.mode[me.id].getValue() == "VOR" ? "<SEL>" : "") ~ "  VOR>";
			me.Display.R5 = (pts.Instrumentation.Efis.Inputs.ndCentered[me.id].getBoolValue() ? "<SEL>" : "") ~ "  CTR>";
			me.Display.L6L = sprintf("%dNM", pts.Instrumentation.Efis.Inputs.rangeNm[me.id].getValue() / 2);
		}
	},
	softKey: func(k) {
		me.scratchpadState = unit[me.id].scratchpadState();
		
		if (k == "r1") {
			pts.Instrumentation.Efis.Mfd.mode[me.id].setValue("MAP");
		} elsif (k == "r2") {
			pts.Instrumentation.Efis.Mfd.mode[me.id].setValue("PLAN");
		} elsif (k == "r3") {
			pts.Instrumentation.Efis.Mfd.mode[me.id].setValue("APP");
		} elsif (k == "r4") {
			pts.Instrumentation.Efis.Mfd.mode[me.id].setValue("VOR");
		} elsif (k == "r5") {
			pts.Instrumentation.Efis.Inputs.ndCentered[me.id].toggleBoolValue();
		} elsif (k == "r6") {
			unit[me.id].setPage("efisOptions");
		}
	},
};

var EfisOptions = {
	new: func(n, t) {
		var m = {parents: [EfisOptions]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			CLTranslate: [0, 0, 0, 0, 0, 0],
			CTranslate: [0, 0, 0, 0, 0, 0],
			C1L: "",
			C1: "",
			C2L: "",
			C2: "",
			C3L: "",
			C3: "",
			C4L: "",
			C4: "",
			C5L: "",
			C5: "",
			C6L: "",
			C6: "",
			
			LFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1L: "",
			L1: "",
			L2L: "",
			L2: "",
			L3L: "",
			L3: "",
			L4L: "",
			L4: "",
			L5L: "",
			L5: "",
			L6L: "",
			L6: "",
			
			LBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "",
			
			RFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1L: "",
			R1: "",
			R2L: "",
			R2: "",
			R3L: "",
			R3: "",
			R4L: "",
			R4: "",
			R5L: "",
			R5: "",
			R6L: "-----------",
			R6: "CONTROL>",
			
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "EFIS OPTIONS",
			titleTranslate: -1,
		};
			
		m.group = "fmc";
		m.name = "efisOptions";
		m.type = t;
		
		return m;
	},
	setup: func() {
	},
	loop: func() {
		if (me.type == 0) {
			me.Display.R1 = (pts.Instrumentation.Efis.Inputs.wpt[me.id].getBoolValue() ? "<SEL>" : "") ~ "  WPT>";
			me.Display.R2 = (pts.Instrumentation.Efis.Inputs.sta[me.id].getBoolValue() ? "<SEL>" : "") ~ "  STA>";
			me.Display.R3 = (pts.Instrumentation.Efis.Inputs.arpt[me.id].getBoolValue() ? "<SEL>" : "") ~ " ARPT>";
			me.Display.R4 = (pts.Instrumentation.Efis.Inputs.data[me.id].getBoolValue() ? "<SEL>" : "") ~ " DATA>";
			me.Display.L5 = "<TFC  " ~ (pts.Instrumentation.Efis.Inputs.tfc[me.id].getBoolValue() ? "<SEL>" : "");
		}
	},
	softKey: func(k) {
		me.scratchpadState = unit[me.id].scratchpadState();
		
		if (k == "r1") {
			pts.Instrumentation.Efis.Inputs.wpt[me.id].toggleBoolValue();
		} elsif (k == "r2") {
			pts.Instrumentation.Efis.Inputs.sta[me.id].toggleBoolValue();
		} elsif (k == "r3") {
			pts.Instrumentation.Efis.Inputs.arpt[me.id].toggleBoolValue();
		} elsif (k == "r4") {
			pts.Instrumentation.Efis.Inputs.data[me.id].toggleBoolValue();
		} elsif (k == "l5") {
			pts.Instrumentation.Efis.Inputs.tfc[me.id].toggleBoolValue();
		} elsif (k == "r6") {
			unit[me.id].setPage("efisControl");
		}
	},
};
