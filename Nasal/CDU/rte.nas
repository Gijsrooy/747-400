# Boeing 747-400 CDU
# Copyright (c) 2025 Josh Davidson (Octal450) and Gijs de Rooy

var Rte = {
	new: func(n) {
		var m = {parents: [Rte]};
		
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
			L1L: " ORIGIN",
			L1: "____",
			L2L: " RUNWAY",
			L2: "-----",
			L3L: "",
			L3: "",
			L4L: "",
			L4: "",
			L5L: "",
			L5: "",
			L6L: "------------",
			L6: "",
			
			LBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",

			pageNum: "1/2",
			
			RFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1L: "DEST",
			R1: "____",
			R2L: "FLT NO",
			R2: "",
			R3L: "",
			R3: "",
			R4L: "",
			R4: "",
			R5L: "",
			R5: "",
			R6L: "------------",
			R6: "ACTIVATE>",
			
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "    RTE 1",
			titleTranslate: -2,
		};
		
		m.group = "fmc";
		m.name = "rte";
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
		if (fms.flightData.airportFrom != "") {
			me.Display.L1 = fms.flightData.airportFrom;
			me.Display.L2L = " RUNWAY";
			if (fms.flightData.runwayFrom != "") {
				me.Display.L2 = "RW" ~ fms.flightData.runwayFrom;
			} else {
				me.Display.L2 = "-----";
			}
		} else {
			me.Display.L1 = "____";
			me.Display.L2 = "-----";
			me.Display.L2L = "";
		}
		if (fms.flightData.airportTo != "") {
			me.Display.R1 = fms.flightData.airportTo;
		} else {
			me.Display.R1 = "____";
		}
		if (fms.flightData.flightNumber != "") {
			me.Display.R2 = fms.flightData.flightNumber;
		} else {
			me.Display.R2 = "--------";
		}
		if (fms.RouteManager.active.getBoolValue()) {
			me.Display.title = "ACT RTE 1";
			me.Display.R6 = "PERF INIT>";
		} else {
			me.Display.title = "    RTE 1";
			me.Display.R6 = "ACTIVATE>";
		}
	},
	softKey: func(k) {
		me.scratchpad = unit[me.id].scratchpad;
		me.scratchpadState = unit[me.id].scratchpadState();
		
		 if (k == "l1") {
			if (me.scratchpadState == 0) {
				fms.EditFlightData.reset();
				unit[me.id].scratchpadClear();
			} elsif (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(4, 4, me.scratchpad)) {
					if (size(findAirportsByICAO(me.scratchpad)) == 1) {
						fms.EditFlightData.insertDeparture(me.scratchpad);
						unit[me.id].scratchpadClear();
					} else {
						unit[me.id].setMessage("NOT IN DATABASE");
					}
				} else {
					unit[me.id].setMessage("INVALID ENTRY");
				}
			}
		} elsif (k == "r1") {
			if (me.scratchpadState == 0) {
				fms.EditFlightData.reset();
				unit[me.id].scratchpadClear();
			} elsif (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(4, 4, me.scratchpad)) {
					if (size(findAirportsByICAO(me.scratchpad)) == 1) {
						fms.EditFlightData.insertDestination(me.scratchpad);
						unit[me.id].scratchpadClear();
					} else {
						unit[me.id].setMessage("NOT IN DATABASE");
					}
				} else {
					unit[me.id].setMessage("INVALID ENTRY");
				}
			}
		} elsif (k == "l2") {
			if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(1, 5, me.scratchpad)) {
					var info = airportinfo(fms.flightData.airportFrom);
					foreach(var rwy; keys(info.runways)){
						if (info.runways[rwy].id == me.scratchpad) {
							fms.EditFlightData.insertDepartureRwy(me.scratchpad);
							unit[me.id].scratchpadClear();
							return;
						}
					}
					unit[me.id].setMessage("NOT IN DATABASE");
				} else {
					unit[me.id].setMessage("INVALID ENTRY");
				}
			}
		}  elsif (k == "r2") {
			if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(1, 10, me.scratchpad)) {
					fms.flightData.flightNumber = me.scratchpad;
					unit[me.id].scratchpadClear();
				} else {
					unit[me.id].setMessage("INVALID ENTRY");
				}
			}
		} elsif (k == "r6") {
			if (fms.RouteManager.active.getBoolValue()) {
				unit[me.id].setPage("perfInit");
			} else {
				fms.EditFlightData.activateFlightplan();
			}
		}
	},
};

var Rte2 = {
	new: func(n) {
		var m = {parents: [Rte2]};
		
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
			L1L: " VIA",
			L1: "-----",
			L2L: "",
			L2: "",
			L3L: "",
			L3: "",
			L4L: "",
			L4: "",
			L5L: "",
			L5: "",
			L6L: "------------",
			L6: "",
			
			LBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",

			pageNum: "2/2",
			
			RFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1L: "TO",
			R1: "-----",
			R2L: "",
			R2: "",
			R3L: "",
			R3: "",
			R4L: "",
			R4: "",
			R5L: "",
			R5: "",
			R6L: "------------",
			R6: "",
			
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "    RTE 1",
			titleTranslate: -2,
		};
		
		m.group = "fmc";
		m.name = "rte2";
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
		if (fms.RouteManager.active.getBoolValue()) {
			me.Display.title = "ACT RTE 1";
			me.Display.R6 = "";
		} else {
			me.Display.title = "    RTE 1";
			me.Display.R6 = "PERF INIT>";
		}
		
		var fp = flightplan();
		var n_legs = fp.getPlanSize();

		if (fp.sid) {
			me.Display.L1 = fp.sid.id;
		} else {
			me.Display.L1 = "-----";
		}
		if (n_legs >= 2) {
			me.Display.R1 = fp.sid.route(fp.departure.runway)[-1].id;
		} else {
			me.Display.R1 = "-----";
		}
		if (n_legs >= 3) {
			me.Display.L2 = fp.getWP(2).id;
		} else {
			me.Display.L2 = "-----";
		}
	},
	softKey: func(k) {
		me.scratchpad = unit[me.id].scratchpad;
		me.scratchpadState = unit[me.id].scratchpadState();
		
		 if (k == "l1") {
			if (pts.Position.wow) {
				if (me.scratchpadState == 0) {
					fms.EditFlightData.reset();
					unit[me.id].scratchpadClear();
				} elsif (me.scratchpadState == 2) {
					if (unit[me.id].stringLengthInRange(4, 4, me.scratchpad)) {
						if (size(findAirportsByICAO(me.scratchpad)) == 1) {
							fms.EditFlightData.insertDeparture(me.scratchpad);
							unit[me.id].scratchpadClear();
						} else {
							unit[me.id].setMessage("NOT IN DATABASE");
						}
					} else {
						unit[me.id].setMessage("INVALID ENTRY");
					}
				}
			}
		} elsif (k == "r1") {
			if (me.scratchpadState == 0) {
				fms.EditFlightData.reset();
				unit[me.id].scratchpadClear();
			} elsif (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(4, 4, me.scratchpad)) {
					if (size(findAirportsByICAO(me.scratchpad)) == 1) {
						fms.EditFlightData.insertDestination(me.scratchpad);
						unit[me.id].scratchpadClear();
					} else {
						unit[me.id].setMessage("NOT IN DATABASE");
					}
				} else {
					unit[me.id].setMessage("INVALID ENTRY");
				}
			}
		} elsif (k == "l2") {
			if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(1, 5, me.scratchpad)) {
					var info = airportinfo(fms.flightData.airportFrom);
					foreach(var rwy; keys(info.runways)){
						if (info.runways[rwy].id == me.scratchpad) {
							fms.EditFlightData.insertDepartureRwy(me.scratchpad);
							unit[me.id].scratchpadClear();
							return;
						}
					}
					unit[me.id].setMessage("NOT IN DATABASE");
				} else {
					unit[me.id].setMessage("INVALID ENTRY");
				}
			}
		}  elsif (k == "r2") {
			if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(1, 10, me.scratchpad)) {
					fms.flightData.flightNumber = me.scratchpad;
					unit[me.id].scratchpadClear();
				} else {
					unit[me.id].setMessage("INVALID ENTRY");
				}
			}
		} elsif (k == "r6") {
			if (fms.RouteManager.active.getBoolValue()) {
				unit[me.id].setPage("perfinit");
			} else {
				fms.EditFlightData.activateFlightplan();
			}
		}
	},
};

var RteLegs = {
	new: func(n) {
		var m = {parents: [RteLegs]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			CLTranslate: [0, 0, 0, 0, 0, 0],
			CTranslate: [-1, -1, -1, -1, -1, 0],
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
			L6L: "------------",
			L6: "",
			
			LBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",

			pageNum: "1/2",
			
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
			R6L: "------------",
			R6: "",
			
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "    RTE 1 LEGS",
			titleTranslate: -2,
		};

		m.group = "fmc";
		m.name = "rtelegs";
		m.scratchpad = "";
		m.scratchpadSplit = nil;
		m.scratchpadSplitSize = 0;
		m.scratchpadState = 0;
		m.page = 1;
		m.numPages = 1;
		
		return m;
	},
	reset: func() {
		me.setup();
	},
	setup: func() {
	},
	loop: func() {
		if (fms.RouteManager.active.getBoolValue()) {
			me.Display.title = "ACT RTE 1 LEGS";
			me.Display.R6 = "";
		} else {
			me.Display.title = "    RTE 1 LEGS";
			me.Display.R6 = "ACTIVATE>";
		}
		
		var fp = flightplan();
		var n_legs = fp.getPlanSize();

		me.numPages = math.floor((n_legs - fp.current) / 5) + 1;
		me.Display.pageNum = sprintf("%d/%d", me.page, me.numPages);

		if (me.page > me.numPages)
			me.page = me.numPages;

		var currIndex = (me.page - 1) * 5 + fp.current;

		if (n_legs > currIndex) {
			me.Display.L1 = fp.getWP(currIndex).id;
			if (me.page > 1) {
				me.Display.L1L = sprintf(" %03dg", fp.getWP(currIndex).leg_bearing);
				me.Display.C1L = sprintf("%3dNM", fp.getWP(currIndex).leg_distance);
			}
			me.Display.C1 = me.ctrLine(currIndex);
			me.Display.R1 = me.legLine(currIndex);
		} else {
			me.Display.L1L = "";
			me.Display.L1 = "";
			me.Display.C1L = "";
			me.Display.C1 = "";
			me.Display.R1 = "";
		}
		if (n_legs > currIndex + 1) {
			me.Display.L2L = sprintf(" %03dg", fp.getWP(currIndex + 1).leg_bearing);
			me.Display.L2 = fp.getWP(currIndex + 1).id;
			me.Display.C2L = sprintf("%3dNM", fp.getWP(currIndex + 1).leg_distance);
			me.Display.C2 = me.ctrLine(currIndex + 1);
			me.Display.R2 = me.legLine(currIndex + 1);
		} else {
			me.Display.L2L = "";
			me.Display.L2 = "";
			me.Display.C2L = "";
			me.Display.C2 = "";
			me.Display.R2 = "";
		}
		if (n_legs > currIndex + 2) {
			me.Display.L3L = sprintf(" %03dg", fp.getWP(currIndex + 2).leg_bearing);
			me.Display.L3 = fp.getWP(currIndex + 2).id;
			me.Display.C3L = sprintf("%3dNM", fp.getWP(currIndex + 2).leg_distance);
			me.Display.C3 = me.ctrLine(currIndex + 2);
			me.Display.R3 = me.legLine(currIndex + 2);
		} else {
			me.Display.L3L = "";
			me.Display.L3 = "";
			me.Display.C3L = "";
			me.Display.C3 = "";
			me.Display.R3 = "";
		}
		if (n_legs > currIndex + 3) {
			me.Display.L4L = sprintf(" %03dg", fp.getWP(currIndex + 3).leg_bearing);
			me.Display.L4 = fp.getWP(currIndex + 3).id;
			me.Display.C4L = sprintf("%3dNM", fp.getWP(currIndex + 3).leg_distance);
			me.Display.C4 = me.ctrLine(currIndex + 3);
			me.Display.R4 = me.legLine(currIndex + 3);
		} else {
			me.Display.L4L = "";
			me.Display.L4 = "";
			me.Display.C4L = "";
			me.Display.C4 = "";
			me.Display.R4 = "";
		}
		if (n_legs > currIndex + 4) {
			me.Display.L5L = sprintf(" %03dg", fp.getWP(currIndex + 4).leg_bearing);
			me.Display.L5 = fp.getWP(currIndex + 4).id;
			me.Display.C5L = sprintf("%3dNM", fp.getWP(currIndex + 4).leg_distance);
			me.Display.C5 = me.ctrLine(currIndex + 4);
			me.Display.R5 = me.legLine(currIndex + 4);
		} else {
			me.Display.L5L = "";
			me.Display.L5 = "";
			me.Display.C5L = "";
			me.Display.C5 = "";
			me.Display.R5 = "";
		}
	},
	ctrLine: func(line) {
		var text = "";
		if (pts.Instrumentation.Efis.Inputs.planWptIndex[0].getValue() == line and pts.Instrumentation.Efis.Mfd.mode[0].getValue() == "PLAN") {
			text = "<CTR>";
		}
		return text;
	},
	legLine: func(line) {
		var wp = flightplan().getWP(line);
		var alt_cstr_type = wp.alt_cstr_type == "above" ? "A" : (wp.alt_cstr_type == "below" ? "B" : " ");
		var text = "";
		if (wp.alt_cstr > 0 and wp.speed_cstr > 0) {
			text = sprintf("%3d/%5d%s", wp.speed_cstr, wp.alt_cstr, alt_cstr_type);
		} elsif (wp.alt_cstr > 0) {
			text = sprintf("---/%5d%s", wp.alt_cstr, alt_cstr_type);
		} elsif (wp.speed_cstr > 0) {
			text = sprintf("%3d/------", wp.speed_cstr);
		} else {
			text = "---/------";
		}
		return text;
	},
	nextPage: func() {
		if (me.page < me.numPages)
			me.page += 1;
		else
			me.page = 1;
	},
	prevPage: func() {
		if (me.page > 1)
			me.page -= 1;
		else
			me.page = me.numPages;
	},
	softKey: func(k) {
		me.scratchpad = unit[me.id].scratchpad;
		me.scratchpadState = unit[me.id].scratchpadState();
		
		if (k == "l2") {
			me.directTo(me.Display.L2);
		} elsif (k == "l3") {
			me.directTo(me.Display.L3);
		} elsif  (k == "l4") {
			me.directTo(me.Display.L4);
		} elsif  (k == "l5") {
			me.directTo(me.Display.L5);
		} elsif (k == "r6") {
			if (fms.RouteManager.active.getBoolValue()) {
				unit[me.id].setPage("perfInit");
			} else {
				fms.EditFlightData.activateFlightplan();
			}
		}
	},
	directTo: func(id) {
		for (var i = 1; i < flightplan().getPlanSize(); i += 1) {
			if (flightplan().getWP(i).id == id) {
				for (var j = 1; j < i; j += 1) {
					flightplan().deleteWP(1);
				}
			}
		}
	},
};