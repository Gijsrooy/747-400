# Boeing 747-400 CDU
# Copyright (c) 2025 Josh Davidson (Octal450) and Gijs de Rooy

var NavRadio = {
	new: func(n) {
		var m = {parents: [NavRadio]};
		
		m.id = n;
		
		m.Display = {
			CFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			CLTranslate: [0, -1, 0, 0, 0, -2],
			CTranslate: [0, -2, 0, 0, 0, 0],
			C1L: "",
			C1: "",
			C2L: "RADIAL",
			C2: "",
			C3L: "",
			C3: "",
			C4L: "",
			C4: "",
			C5L: "",
			C5: "",
			C6L: "PRESELECT",
			C6: "",
			
			LFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1L: " VOR L",
			L1: "",
			L2L: " CRS",
			L2: "---",
			L3L: " ADF L",
			L3: "",
			L4L: " ILS",
			L4: "",
			L5L: "",
			L5: "",
			L6L: "",
			L6: "------",
			
			LBFont: [FONT.small, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1B: "      M",
			L2B: "",
			L3B: "",
			L4B: "           M",
			L5B: "",
			L6B: "",

			pageNum: "",
			
			RFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1L: "VOR R",
			R1: "",
			R2L: "CRS",
			R2: "---",
			R3L: "ADF R",
			R3: "",
			R4L: "",
			R4: "",
			R5L: "",
			R5: "",
			R6L: "",
			R6: "------",
			
			RBFont: [FONT.small, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "M      ",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "NAV RADIO",
			titleTranslate: 0,
		};

		m.Value = {
			adfKhz: [0, 0],
			navRdl: [0, 0, 0],
			navCrs: [0, 0, 0], # Course 0 is forced to 360, so 0 = no course set
			navId: ["", "", ""],
			navMhz: [0, 0, 0],
		};
		
		m.group = "fmc";
		m.name = "navRadio";
		m.scratchpad = "";
		m.scratchpadSplit = nil;
		m.scratchpadSplitSize = 0;
		m.scratchpadState = 0;
		
		return m;
	},
	reset: func() {
		me.setup();
	},
	setup: func() {
	},
	loop: func() {
		me.Value.navId[0] = pts.Instrumentation.Nav.navId[0].getValue();
		me.Value.navMhz[0] = pts.Instrumentation.Nav.Frequencies.selectedMhz[0].getValue();
		if (me.Value.navMhz[0] > 0) {
			me.Display.L1 = sprintf("%3.2f %s", me.Value.navMhz[0], me.Value.navId[0]);
		}
		
		me.Value.navId[1] = pts.Instrumentation.Nav.navId[1].getValue();
		me.Value.navMhz[1] = pts.Instrumentation.Nav.Frequencies.selectedMhz[1].getValue();
		if (me.Value.navMhz[1] > 0) {
			me.Display.R1 = sprintf("%s %3.2f", me.Value.navId[1], me.Value.navMhz[1]);
		}

		me.Value.navRdl[0] = pts.Instrumentation.Nav.Radials.actualDeg[0].getValue();
		me.Value.navRdl[1] = pts.Instrumentation.Nav.Radials.actualDeg[1].getValue();
		me.Value.navCrs[0] = pts.Instrumentation.Nav.Radials.selectedDeg[0].getValue();
		me.Value.navCrs[1] = pts.Instrumentation.Nav.Radials.selectedDeg[1].getValue();
		me.Display.L2 = sprintf("%03d", me.Value.navCrs[0]);
		me.Display.C2 = sprintf("%03d  %03d", me.Value.navRdl[0], me.Value.navRdl[1]);
		me.Display.R2 = sprintf("%03d", me.Value.navCrs[1]);

		me.Value.adfKhz[0] = pts.Instrumentation.Adf.Frequencies.selectedKhz[0].getValue();
		if (me.Value.adfKhz[0] > 0) {
			me.Display.L3 = sprintf("%3.1f", me.Value.adfKhz[0]);
		}

		me.Value.adfKhz[1] = pts.Instrumentation.Adf.Frequencies.selectedKhz[1].getValue();
		if (me.Value.adfKhz[1] > 0) {
			me.Display.R3 = sprintf("%3.1f", me.Value.adfKhz[1]);
		}

		me.Value.navCrs[2] = pts.Instrumentation.Nav.Radials.selectedDeg[2].getValue();
		me.Value.navMhz[2] = pts.Instrumentation.Nav.Frequencies.selectedMhz[2].getValue();
		if (me.Value.navMhz[2] or 0 > 0) {
			me.Display.L4 = sprintf("%3.2f/%03dg", me.Value.navMhz[2], me.Value.navCrs[2]);
		}
	},
	softKey: func(k) {
		me.scratchpad = unit[me.id].scratchpad;
		me.scratchpadState = unit[me.id].scratchpadState();
		
		if (k == "l1") {
			if (me.scratchpadState == 2) {
				me.insertNav(0);
			}
		} elsif (k == "r1") {
			if (me.scratchpadState == 2) {
				me.insertNav(1);
			}
		} elsif (k == "l4") {
			if (me.scratchpadState == 2) {
				me.insertNav(2);
			}
		}
	},
	insertNav: func(n) {
		if (find("/", me.scratchpad) != -1) {
			me.scratchpadSplit = split("/", me.scratchpad);
		} else {
			me.scratchpadSplit = [me.scratchpad, ""];
		}
		
		if (unit[me.id].stringContains("-")) {
			unit[me.id].setMessage("INVALID ENTRY");
			return;
		}
		
		me.scratchpadSplitSize0 = size(me.scratchpadSplit[0]);
		me.scratchpadSplitSize1 = size(me.scratchpadSplit[1]);
		
		if (me.scratchpadSplitSize0 > 0) { # Frequency
			if (unit[me.id].stringLengthInRange(3, 6, me.scratchpadSplit[0]) and unit[me.id].stringDecimalLengthInRange(0, 2, me.scratchpadSplit[0])) {
				if (n == 2) { # ILS
					if (me.scratchpadSplit[0] < 108 or me.scratchpadSplit[0] > 111.95) {
						unit[me.id].setMessage("INVALID ENTRY");
						return;
					}
				} else { # VOR
					if (me.scratchpadSplit[0] < 108 or me.scratchpadSplit[0] > 117.95) {
						unit[me.id].setMessage("INVALID ENTRY");
						return;
					}
				}
			} else {
				unit[me.id].setMessage("INVALID ENTRY");
				return;
			}
		}
		
		if (me.scratchpadSplitSize1 > 0) { # Course
			if (unit[me.id].stringLengthInRange(1, 3, me.scratchpadSplit[1]) and unit[me.id].stringIsInt(me.scratchpadSplit[1])) {
				if (me.scratchpadSplit[1] == 0) { # Evaluate as integer so all forms of 0 work
					me.scratchpadSplit[1] = "360"; # Must be string
				}
				
				if (me.scratchpadSplit[1] < 1 or me.scratchpadSplit[1] > 360) {
					unit[me.id].setMessage("INVALID ENTRY");
					return;
				}
			} else {
				unit[me.id].setMessage("INVALID ENTRY");
				return;
			}
		}
		
		if (me.scratchpadSplitSize0 > 0) {
			pts.Instrumentation.Nav.Frequencies.selectedMhz[n].setValue(me.scratchpadSplit[0]);
		}
		if (me.scratchpadSplitSize1 > 0) {
			if (pts.Instrumentation.Nav.Frequencies.selectedMhz[n].getValue()) {
				pts.Instrumentation.Nav.Radials.selectedDeg[n].setValue(me.scratchpadSplit[1]);
			} else {
				unit[me.id].setMessage("INVALID ENTRY");
				return;
			}
		}
		unit[me.id].scratchpadClear();
	},
};
