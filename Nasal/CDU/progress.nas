# Boeing 747-400 CDU
# Copyright (c) 2025 Josh Davidson (Octal450) and Gijs de Rooy

var Progress = {
	new: func(n) {
		var m = {parents: [Progress]};
		
		m.id = n;
		
		m.Display = {		
			CFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			CLTranslate: [0, 0, 0, 0, 0, 0],
			CTranslate: [0, 0, 0, 0, 0, 0],
			C1L: "ALT   ATA",
			C1: "",
			C2L: "DTG   ETA",
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
			L1L: " LAST",
			L1: "",
			L2L: " TO",
			L2: "",
			L3L: " NEXT",
			L3: "",
			L4L: " DEST",
			L4: "",
			L5L: " MCP SPD",
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

			pageNum: "1/3",
			
			RFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1L: "FUEL",
			R1: "",
			R2L: "",
			R2: "---",
			R3L: "",
			R3: "",
			R4L: "",
			R4: "",
			R5L: "",
			R5: "",
			R6L: "",
			R6: "",
			
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: fms.flightData.flightNumber ~ " PROGRESS",
			titleTranslate: 0,
		};
		
		m.group = "fmc";
		m.name = "progress";
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
		var fp = flightplan();
		if (fp.current - 1 > 0) {
			var last = fp.getWP(fp.current - 1);
			me.Display.L1 = last.id;
		}
		if (fp.current < fp.getPlanSize()) {
			var to = fp.getWP(fp.current);
			me.Display.L2 = to.id;
			me.Display.C2 = sprintf("%d ", to.distance_along_route);
		}
		if (fp.current + 1 < fp.getPlanSize()) {
			var next = fp.getWP(fp.current + 1);
			me.Display.L3 = next.id;
			me.Display.C3 = sprintf("%d ", next.distance_along_route);
		}
		me.Display.L4 = fms.flightData.airportTo;
		me.Display.L5 = sprintf("%d", itaf.Input.kts.getValue());
	},
	nextPage: func() {
		unit[me.id].setPage("progress2");
	},
	prevPage: func() {
	},
	softKey: func(k) {
		me.scratchpad = unit[me.id].scratchpad;
		me.scratchpadState = unit[me.id].scratchpadState();
	},
};


var Progress2 = {
	new: func(n) {
		var m = {parents: [Progress2]};
		
		m.id = n;
		
		m.Display = {		
			CFont: [FONT.large, FONT.large, FONT.small, FONT.large, FONT.small, FONT.large],
			CLTranslate: [0, 0, -2, 0, 0, 0],
			CTranslate: [0, 0, -2, 0, -2, 0],
			C1L: "WIND",
			C1: "",
			C2L: "",
			C2: "",
			C3L: "FUEL USED",
			C3: "",
			C4L: "",
			C4: "",
			C5L: "",
			C5: "FUEL QTY",
			C6L: "",
			C6: "",
			
			LFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.small, FONT.large],
			L1L: "H/WIND",
			L1: "",
			L2L: "",
			L2: "",
			L3L: " TAS",
			L3: "",
			L4L: "   1     2",
			L4: "",
			L5L: "",
			L5: "",
			L6L: " TOTALIZER",
			L6: "",
			
			LBFont: [FONT.large, FONT.large, FONT.small, FONT.large, FONT.large, FONT.large],
			L1B: "",
			L2B: "",
			L3B: "   KT",
			L4B: "",
			L5B: "",
			L6B: "",

			pageNum: "2/3",
			
			RFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.small, FONT.large],
			R1L: "X/WIND",
			R1: "",
			R2L: "",
			R2: "",
			R3L: "SAT",
			R3: "",
			R4L: "3     4 ",
			R4: "",
			R5L: "",
			R5: "",
			R6L: "CALCULATED",
			R6: "",
			
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: fms.flightData.flightNumber ~ " PROGRESS",
			titleTranslate: 0,
		};
		
		m.group = "fmc";
		m.name = "progress2";
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
		var fuelUsed = [pts.Fdm.JSBSim.Propulsion.fuelUsed[0].getValue() * LB2KG / 1000, pts.Fdm.JSBSim.Propulsion.fuelUsed[1].getValue() * LB2KG / 1000, pts.Fdm.JSBSim.Propulsion.fuelUsed[2].getValue() * LB2KG / 1000, pts.Fdm.JSBSim.Propulsion.fuelUsed[3].getValue() * LB2KG / 1000];
		me.Display.L3 = sprintf("%3d", math.min(100, pts.Instrumentation.AirspeedIndicator.trueSpeedKt.getValue()));
		me.Display.C3 = sprintf("TOT %5.1f", fuelUsed[0] + fuelUsed[1] + fuelUsed[2] + fuelUsed[3]);
		me.Display.R3 = sprintf("%2dgC", pts.Fdm.JSBSim.Atmosphere.oatC.getValue());
		me.Display.L4 = sprintf("%5.1f %5.1f", fuelUsed[0], fuelUsed[1]);
		me.Display.R4 = sprintf("%5.1f %5.1f", fuelUsed[2], fuelUsed[3]);
		me.Display.L6 = sprintf("%5.1f", pts.Consumables.Fuel.totalFuelLbs.getValue() * LB2KG / 1000);
	},
	nextPage: func() {
		unit[me.id].setPage("progress3");
	},
	prevPage: func() {
		unit[me.id].setPage("progress");
	},
	softKey: func(k) {
		me.scratchpad = unit[me.id].scratchpad;
		me.scratchpadState = unit[me.id].scratchpadState();
	},
};