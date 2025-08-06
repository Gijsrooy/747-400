# Boeing 747-400 CDU
# Copyright (c) 2025 Josh Davidson (Octal450) and Gijs de Rooy

var InitRef = {
	new: func(n) {
		var m = {parents: [InitRef]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			CLTranslate: [0, 0, 0, 0, 0, 0],
			CTranslate: [-2, 0, 0, 0, 0, 0],
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
			L1: "<IDENT",
			L2L: "",
			L2: "<POS",
			L3L: "",
			L3: "<PERF",
			L4L: "",
			L4: "<THRUST LIM",
			L5L: "",
			L5: "<TAKEOFF",
			L6L: "",
			L6: "<APPROACH",
			
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
			R6L: "",
			R6: "",
			
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "INIT/REF INDEX",
			titleTranslate: -1,
		};
			
		m.group = "fmc";
		m.name = "initRef";
		
		return m;
	},
	setup: func() {
	},
	loop: func() {
	},
	softKey: func(k) {
		me.scratchpadState = unit[me.id].scratchpadState();
		
		if (k == "l1") {
			unit[me.id].setPage("ident");
		} elsif (k == "l2") {
			unit[me.id].setPage("init");
		} elsif (k == "l3") {
			unit[me.id].setPage("perfInit");
		} elsif (k == "l4") {
			unit[me.id].setPage("thrustLim");
		} elsif (k == "l5") {
			unit[me.id].setPage("takeoff");
		} elsif (k == "l6") {
			unit[me.id].setPage("approach");
		}
	},
};

var Init = {
	new: func(n) {
		var m = {parents: [Init]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			CLTranslate: [0, 0, 0, 0, 0, 0],
			CTranslate: [-4, 0, 0, -4, 0, 0],
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
			L4L: " UTC (GPS)",
			L4: "",
			L5L: "",
			L5: "",
			L6L: "------------",
			L6: "<INDEX",
			
			LBFont: [FONT.large, FONT.large, FONT.large, FONT.small, FONT.large, FONT.large],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "    Z",
			L5B: "",
			L6B: "",
			
			pageNum: "1/3",
			
			RFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1L: "LAST POS",
			R1: "",
			R2L: "",
			R2: "",
			R3L: "",
			R3: "",
			R4L: "GPS POS",
			R4: "",
			R5L: "",
			R5: "",
			R6L: "------------",
			R6: "ROUTE>",
			
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "POS INIT",
			titleTranslate: 0,
		};
		
		m.Value = {
			utc: "0000",
			positionSplit: ["", ""],
		};
		
		m.group = "fmc";
		m.name = "init";
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
		me.Value.positionSplit = split("/", FORMAT.Position.formatNode(pts.Position.node));
		me.Display.C1 = me.Value.positionSplit[0];
		me.Display.R1 = me.Value.positionSplit[1];
		me.Display.C4 = me.Value.positionSplit[0];
		me.Display.R4 = me.Value.positionSplit[1];
	},
	loop: func() {
		me.Value.utc = sprintf("%02d%02d", pts.Sim.Time.utcHr.getValue(), pts.Sim.Time.utcMin.getValue());
		me.Display.L4 = me.Value.utc;
	},
	softKey: func(k) {
		me.scratchpad = unit[me.id].scratchpad;
		me.scratchpadState = unit[me.id].scratchpadState();
		
		if (k == "l6") {
			unit[me.id].setPage("initRef");
		} else if (k == "r6") {
			unit[me.id].setPage("rte");
		}
	},
};

var PerfInit = {
	new: func(n) {
		var m = {parents: [PerfInit]};
		
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
			
			LFont: [FONT.small, FONT.large, FONT.small, FONT.small, FONT.large, FONT.large],
			L1L: " GR WT DUAL",
			L1: "",
			L2L: " FUEL",
			L2: "",
			L3L: " ZFW",
			L3: "",
			L4L: "",
			L4: "",
			L5L: " COST INDEX",
			L5: "",
			L6L: "------------",
			L6: "<INDEX",
			
			LBFont: [FONT.large, FONT.small, FONT.large, FONT.large, FONT.large, FONT.large],
			L1B: "",
			L2B: "      SENSED",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "",
			
			RFont: [FONT.large, FONT.large, FONT.large, FONT.small, FONT.large, FONT.large],
			R1L: "CRZ ALT",
			R1: "",
			R2L: "",
			R2: "",
			R3L: "",
			R3: "",
			R4L: "CRZ CG",
			R4: "---.-",
			R5L: "STEP SIZE",
			R5: "ICAO",
			R6L: "------------",
			R6: "THRUST LIM>",
			
			RBFont: [FONT.small, FONT.large, FONT.small, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "PERF INIT",
			titleTranslate: 0,
		};
		
		m.group = "fmc";
		m.name = "perfInit";
		m.scratchpad = "";
		m.scratchpadState = 0;
		
		return m;
	},
	setup: func() {
	},
	loop: func() {
		if (fms.flightData.gwLbs > 0) {
			me.Display.L1 = sprintf("%3.1f", fms.flightData.gwLbs * LB2KG);
		}

		if (fms.flightData.cruiseAlt > 0) {
			me.Display.R1 = sprintf("%5d", fms.flightData.cruiseAlt);
		} else {
			me.Display.R1 = "_____";
		}

		if (fms.flightData.ufobLbs > 0) {
			me.Display.L2 = sprintf("%3.1f", fms.flightData.ufobLbs * LB2KG);
		}

		if (fms.flightData.zfwLbs > 0) {
			me.Display.L3 = sprintf("%3.1f", fms.flightData.zfwLbs * LB2KG);
		}

		me.Display.R4 = sprintf("%4.1f%%", fms.flightData.cruisecg);
		me.Display.RFont[3] = fms.flightData.cruisecg == 20.0 ? FONT.small : FONT.large;

		if (fms.flightData.costIndex > -1) {
			me.Display.L5 = sprintf("%5d", fms.flightData.costIndex);
		} else {
			me.Display.L5 = "____";
		}
	},
	softKey: func(k) {
		me.scratchpad = unit[me.id].scratchpad;
		me.scratchpadState = unit[me.id].scratchpadState();
		
		if (k == "r1") {
			if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(3, 5, me.scratchpad) and me.scratchpad >= -1005 and me.scratchpad <= 45100) {
					fms.EditFlightData.insertCruiseFl(me.scratchpad / 100);
					unit[me.id].scratchpadClear();
				} else {
					unit[me.id].setMessage("INVALID ENTRY");
				}
			}
		} elsif (k == "r4") {
			if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(1, 4, me.scratchpad) and me.scratchpad >= 8.5 and me.scratchpad <= 33.0) {
					fms.flightData.cruisecg = me.scratchpad;
					unit[me.id].scratchpadClear();
				} else {
					unit[me.id].setMessage("INVALID ENTRY");
				}
			}
		} elsif (k == "l5") {
			if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(1, 4, me.scratchpad) and me.scratchpad >= 0 and me.scratchpad <= 9999) {
					fms.flightData.costIndex = int(me.scratchpad);
					unit[me.id].scratchpadClear();
				} else {
					unit[me.id].setMessage("INVALID ENTRY");
				}
			}
		} elsif (k == "l6") {
			unit[me.id].setPage("initRef");
		} else if (k == "r6") {
			unit[me.id].setPage("thrustLim");
		}
	},
};

var ThrustLim = {
	new: func(n) {
		var m = {parents: [ThrustLim]};
		
		m.id = n;
		
		m.Display = {
			arrow: 1,
			
			CFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			CLTranslate: [-2, 0, 0, 0, 0, 0],
			CTranslate: [-2, 0, 0, 0, 0, 0],
			C1L: "OAT",
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
			L1L: " SEL",
			L1: "",
			L2L: "",
			L2: "<TO   <SEL>",
			L3L: "",
			L3: "",
			L4L: "",
			L4: "",
			L5L: "",
			L5: "",
			L6L: "------------",
			L6: "<INDEX",
			
			LBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "",
			
			RFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1L: "TO N1",
			R1: "",
			R2L: "",
			R2: "<ARM>   CLB>",
			R3L: "",
			R3: "",
			R4L: "",
			R4: "",
			R5L: "",
			R5: "",
			R6L: "------------",
			R6: "TAKEOFF>",
			
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "THRUST LIM",
			titleTranslate: 0,
		};
		
		m.group = "fmc";
		m.name = "thrustLim";
		m.scratchpad = "";
		m.scratchpadState = 0;

		return m;
	},
	setup: func() {
		if (fms.Internal.phase > 1) {
			me.Display.L1L = " SEL";
			me.Display.C1L = "OAT";
			me.Display.L2 = "<TO   <SEL>";
			me.Display.R2 = "<SEL>   CLB>";
			me.Display.L3 = "";
			me.Display.L4 = "";
			me.Display.R6 = "TAKEOFF>";
		} else {
			me.Display.L1L = "";
			me.Display.L1 = "";
			me.Display.C1L = "";
			me.Display.C1 = "";
			me.Display.L2 = "<GA";
			me.Display.L3 = "<CON";
			me.Display.L4 = "<CRZ";
			me.Display.R6 = "APPROACH>";
		}
	},
	loop: func() {
		if (fms.Internal.phase <= 1) {	
			me.Display.L1L = " SEL";
			me.Display.C1L = "OAT";
			me.Display.C1 = sprintf("%dgC", pts.Fdm.JSBSim.Atmosphere.oatC.getValue());
			me.Display.L1 = fms.flightData.flexTemp > 0 ? sprintf("%dg", fms.flightData.flexTemp) : "--";
			me.Display.R1L = (fms.flightData.flexActive ? "D-" : "") ~ systems.FADEC.Limit.activeMode.getValue() ~ " N1";
			me.Display.R1 = sprintf("%3.1f%%", systems.FADEC.Limit.active.getValue());
			me.Display.L2 = systems.FADEC.Limit.activeModeInt.getValue() == 0 ? "<TO   <SEL>" : "<TO";
			me.Display.R2 = systems.FADEC.Limit.activeModeInt.getValue() == 3 ? "<SEL>  CLB>" : "<ARM>  CLB>";
			me.Display.L3 = "";
			me.Display.L4 = "";
			me.Display.R6 = "TAKEOFF>";
		} else {
			me.Display.L1L = "";
			me.Display.L1 = "";
			me.Display.C1L = "";
			me.Display.C1 = "";
			me.Display.R1L = systems.FADEC.Limit.activeMode.getValue() ~ " N1";
			me.Display.R1 = sprintf("%3.1f%%", systems.FADEC.Limit.active.getValue());
			me.Display.R2 = systems.FADEC.Limit.activeModeInt.getValue() == 3 ? "<SEL>  CLB>" : "CLB>";
			me.Display.L2 = systems.FADEC.Limit.activeModeInt.getValue() == 1 ? "<GA   <SEL>" : "<GA";
			me.Display.L3 = systems.FADEC.Limit.activeModeInt.getValue() == 2 ? "<CON  <SEL>" : "<CON";
			me.Display.L4 = systems.FADEC.Limit.activeModeInt.getValue() == 4 ? "<CRZ  <SEL>" : "<CRZ";
			me.Display.R6 = "APPROACH>";
		}
	},
	softKey: func(k) {
		me.scratchpad = unit[me.id].scratchpad;
		me.scratchpadState = unit[me.id].scratchpadState();
		
		if (fms.Internal.phase <= 1) { # on ground
			if (k == "l1") {
				if (me.scratchpadState == 2) {
					if (unit[me.id].stringLengthInRange(1, 2) and unit[me.id].stringIsInt()) {
						if (me.scratchpad >= math.round(pts.Fdm.JSBSim.Atmosphere.oatC.getValue()) and me.scratchpad <= 99) {
							if (systems.FADEC.Limit.activeModeInt.getValue() != 0 and !systems.FADEC.Limit.auto.getBoolValue()) {
								systems.FADEC.setMode(0);
							}
							
							fms.flightData.flexActive = 1;
							if (me.scratchpad > 63) me.scratchpad = 63;
							fms.flightData.flexTemp = int(me.scratchpad);
							fms.EditFlightData.resetVspeeds();
							unit[me.id].scratchpadClear();
						} else {
							unit[me.id].setMessage("INVALID ENTRY");
						}
					} else {
						unit[me.id].setMessage("INVALID ENTRY");
					}
				} else if (me.scratchpadState == 0) {
					fms.flightData.flexActive = 0;
					fms.flightData.flexTemp = 0;
					fms.EditFlightData.resetVspeeds();
					unit[me.id].scratchpadClear();
				}
			} elsif (k == "l6") {
				unit[me.id].setPage("initRef");
			} elsif (k == "r6") {
				unit[me.id].setPage("takeoff");
			}
		} else { # in flight
			if (k == "l2") {
				systems.FADEC.Limit.auto.setBoolValue(0);
				systems.FADEC.setMode(1);
			} elsif (k == "r2") {
				systems.FADEC.Limit.auto.setBoolValue(0);
				systems.FADEC.setMode(3);
			} elsif (k == "l3") {
				systems.FADEC.Limit.auto.setBoolValue(0);
				systems.FADEC.setMode(2);
			} elsif (k == "l4") {
				systems.FADEC.Limit.auto.setBoolValue(0);
				systems.FADEC.setMode(4);
			} elsif (k == "l6") {
				unit[me.id].setPage("initRef");
			} elsif (k == "r6") {
				unit[me.id].setPage("approach");
			}
		}
	},
};
