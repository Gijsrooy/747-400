# Boeing 747-400 CDU
# Copyright (c) 2025 Josh Davidson (Octal450) and Gijs de Rooy

var DepArr = {
	new: func(n) {
		var m = {parents: [DepArr]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			CLTranslate: [-1, 0, 0, 0, 0, 0],
			CTranslate: [0, 0, 0, 0, 0, 0],
			C1L: "RTE 1",
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
			L1: "<DEP",
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
			R2: "ARR>",
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
			
			title: "DEP/ARR INDEX",
			titleTranslate: 0,
		};
		
		m.group = "fmc";
		m.name = "depArr";
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
		me.Display.C1 = fms.flightData.airportFrom;
		me.Display.C2 = fms.flightData.airportTo;
	},
	softKey: func(k) {
		me.scratchpad = unit[me.id].scratchpad;
		me.scratchpadState = unit[me.id].scratchpadState();
		
		if (k == "l1") {
			unit[me.id].setPage("dep");
		} elsif (k == "r2") {
			unit[me.id].setPage("arr");
		}
	},
};

var Dep = {
	new: func(n) {
		var m = {parents: [Dep]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			CLTranslate: [-1, 0, 0, 0, 0, 0],
			CTranslate: [0, 0, 0, 0, 0, 0],
			C1L: "RTE 1",
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
			L1L: " SIDS",
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
			L6: "<INDEX",
			
			LBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",

			pageNum: "1/2",
			
			RFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1L: "RUNWAYS",
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
			R6: "ROUTE>",
			
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "     DEPARTURES",
			titleTranslate: -1,
		};
		
		m.group = "fmc";
		m.name = "dep";
		m.page = 1;
		m.numPages = 1;
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
			me.Display.title = sprintf("%4s", fms.flightData.airportFrom) ~ " DEPARTURES";
		} else {
			me.Display.L1 = "____";
		}

		var n_runways = 0;
		var n_sids = 0;
		var currIndex = (me.page - 1) * 5;

		if (fms.flightData.airportFrom != "") {
			if (fms.flightData.runwayFrom != "") {
				me.Display.R1B = "<SEL>      ";
				me.Display.R1 = fms.flightData.runwayFrom;
				me.Display.R2 = "";
				me.Display.R3 = "";
				me.Display.R4 = "";
				me.Display.R5 = "";
				n_runways = 1;
			} else {
				me.Display.R1B = "";

				var rwys = [];
				if (fms.flightData.sid != "") {
					rwys = flightplan().sid.runways;
				} else {
					rwys = keys(flightplan().departure.runways);
				}
				n_runways = size(rwys);

				if (n_runways > currIndex) {
					me.Display.R1 = rwys[currIndex];
				} else {
					me.Display.R1 = "";
				}
				if (n_runways > currIndex + 1) {
					me.Display.R2 = rwys[currIndex + 1];
				} else {
					me.Display.R2 = "";
				}
				if (n_runways > currIndex + 2) {
					me.Display.R3 = rwys[currIndex + 2];
				} else {
					me.Display.R3 = "";
				}
				if (n_runways > currIndex + 3) {
					me.Display.R4 = rwys[currIndex + 3];
				} else {
					me.Display.R4 = "";
				}
				if (n_runways > currIndex + 4) {
					me.Display.R5 = rwys[currIndex + 4];
				} else {
					me.Display.R5 = "";
				}
			}
			if (fms.flightData.sid != "") {
				me.Display.L1B = "      <SEL>";
				me.Display.L1 = fms.flightData.sid;
				me.Display.L2 = "";
				me.Display.L3 = "";
				me.Display.L4 = "";
				me.Display.L5 = "";
				n_sids = 1;
			} else {
				me.Display.L1B = "";

				var sids = [];
				if (fms.flightData.runwayFrom != "") {
					sids = flightplan().departure.sids(fms.flightData.runwayFrom);
				} else {
					sids = flightplan().departure.sids();
				}
				n_sids = size(sids);
				
				if (n_sids > currIndex) {
					me.Display.L1 = sids[currIndex];
				} else {
					me.Display.L1 = "";
				}
				if (n_sids > currIndex + 1) {
					me.Display.L2 = sids[currIndex + 1];
				} else {
					me.Display.L2 = "";
				}
				if (n_sids > currIndex + 2) {
					me.Display.L3 = sids[currIndex + 2];
				} else {
					me.Display.L3 = "";
				}
				if (n_sids > currIndex + 3) {
					me.Display.L4 = sids[currIndex + 3];
				} else {
					me.Display.L4 = "";
				}
				if (n_sids > currIndex + 4) {
					me.Display.L5 = sids[currIndex + 4];
				} else {
					me.Display.L5 = "";
				}
			}
		}

		me.numPages = math.floor(math.max(n_sids, n_runways) / 5) + 1;
		me.Display.pageNum = sprintf("%d/%d", me.page, me.numPages);

		if (me.page > me.numPages)
			me.page = me.numPages;
	},
	nextPage: func() {
		if (me.page < me.numPages)
			me.page += 1;
	},
	prevPage: func() {
		if (me.page > 1)
			me.page -= 1;
	},
	softKey: func(k) {
		me.scratchpad = unit[me.id].scratchpad;
		me.scratchpadState = unit[me.id].scratchpadState();
		
		 if (k == "l1") {
			fms.EditFlightData.insertSid(me.Display.L1);
		} elsif (k == "r1") {
			fms.EditFlightData.insertDepartureRwy(me.Display.R1);
		} elsif (k == "l2") {
			fms.EditFlightData.insertSid(me.Display.L2);
		} elsif (k == "r2") {
			fms.EditFlightData.insertDepartureRwy(me.Display.R2);
		} elsif (k == "l3") {
			fms.EditFlightData.insertSid(me.Display.L3);
		} elsif (k == "r3") {
			fms.EditFlightData.insertDepartureRwy(me.Display.R3);
		} elsif (k == "l4") {
			fms.EditFlightData.insertSid(me.Display.L4);
		} elsif (k == "r4") {
			fms.EditFlightData.insertDepartureRwy(me.Display.R4);
		} elsif (k == "l5") {
			fms.EditFlightData.insertSid(me.Display.L5);
		} elsif (k == "r5") {
			fms.EditFlightData.insertDepartureRwy(me.Display.R5);
		} elsif (k == "l6") {
			unit[me.id].setPage("depArr");
		} elsif (k == "r6") {
			unit[me.id].setPage("rte");
		}
	},
};

var Arr = {
	new: func(n) {
		var m = {parents: [Arr]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			CLTranslate: [-1, 0, 0, 0, 0, 0],
			CTranslate: [0, 0, 0, 0, 0, 0],
			C1L: "RTE 1",
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
			L1L: " STARS",
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
			L6: "<INDEX",
			
			LBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",

			pageNum: "1/2",
			
			RFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1L: "APPROACHES",
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
			R6: "ROUTE>",
			
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "     ARRIVALS",
			titleTranslate: -1,
		};
		
		m.group = "fmc";
		m.name = "arr";
		m.page = 1;
		m.numPages = 1;
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
		if (fms.flightData.airportTo != "") {
			me.Display.title = sprintf("%4s", fms.flightData.airportTo) ~ " ARRIVALS";
		} else {
			me.Display.L1 = "____";
		}

		var n_approaches = 0;
		var n_stars = 0;
		var currIndex = (me.page - 1) * 5;

		if (fms.flightData.airportTo != "") {
			if (fms.flightData.approach != "") {
				me.Display.R1B = "<SEL>      ";
				me.Display.R1 = fms.flightData.approach;
				me.Display.R2 = "";
				me.Display.R3 = "";
				me.Display.R4 = "";
				me.Display.R5 = "";
				n_approaches = 1;
			} else {
				me.Display.R1B = "";

				var approaches = flightplan().destination.getApproachList();
				n_approaches = size(approaches);

				if (n_approaches > currIndex) {
					me.Display.R1 = approaches[currIndex];
				} else {
					me.Display.R1 = "";
				}
				if (n_approaches > currIndex + 1) {
					me.Display.R2 = approaches[currIndex + 1];
				} else {
					me.Display.R2 = "";
				}
				if (n_approaches > currIndex + 2) {
					me.Display.R3 = approaches[currIndex + 2];
				} else {
					me.Display.R3 = "";
				}
				if (n_approaches > currIndex + 3) {
					me.Display.R4 = approaches[currIndex + 3];
				} else {
					me.Display.R4 = "";
				}
				if (n_approaches > currIndex + 4) {
					me.Display.R5 = approaches[currIndex + 4];
				} else {
					me.Display.R5 = "";
				}
			}
			if (fms.flightData.star != "") {
				me.Display.L1B = "      <SEL>";
				me.Display.L1 = fms.flightData.star;
				me.Display.L2 = "";
				me.Display.L3 = "";
				me.Display.L4 = "";
				me.Display.L5 = "";
				n_stars = 1;
			} else {
				me.Display.L1B = "";

				var stars = flightplan().destination.stars();
				n_stars = size(stars);
				
				if (n_stars > currIndex) {
					me.Display.L1 = stars[currIndex];
				} else {
					me.Display.L1 = "";
				}
				if (n_stars > currIndex + 1) {
					me.Display.L2 = stars[currIndex + 1];
				} else {
					me.Display.L2 = "";
				}
				if (n_stars > currIndex + 2) {
					me.Display.L3 = stars[currIndex + 2];
				} else {
					me.Display.L3 = "";
				}
				if (n_stars > currIndex + 3) {
					me.Display.L4 = stars[currIndex + 3];
				} else {
					me.Display.L4 = "";
				}
				if (n_stars > currIndex + 4) {
					me.Display.L5 = stars[currIndex + 4];
				} else {
					me.Display.L5 = "";
				}
			}
		}

		me.numPages = math.floor(math.max(n_stars, n_approaches) / 5) + 1;
		me.Display.pageNum = sprintf("%d/%d", me.page, me.numPages);

		if (me.page > me.numPages)
			me.page = me.numPages;
	},
	nextPage: func() {
		if (me.page < me.numPages)
			me.page += 1;
	},
	prevPage: func() {
		if (me.page > 1)
			me.page -= 1;
	},
	softKey: func(k) {
		me.scratchpad = unit[me.id].scratchpad;
		me.scratchpadState = unit[me.id].scratchpadState();
		
		 if (k == "l1") {
			fms.EditFlightData.insertStar(me.Display.L1);
		} elsif (k == "r1") {
			fms.EditFlightData.insertApproach(me.Display.R1);
		} elsif (k == "l2") {
			fms.EditFlightData.insertStar(me.Display.L2);
		} elsif (k == "r2") {
			fms.EditFlightData.insertApproach(me.Display.R2);
		} elsif (k == "l3") {
			fms.EditFlightData.insertStar(me.Display.L3);
		} elsif (k == "r3") {
			fms.EditFlightData.insertApproach(me.Display.R3);
		} elsif (k == "l4") {
			fms.EditFlightData.insertStar(me.Display.L4);
		} elsif (k == "r4") {
			fms.EditFlightData.insertApproach(me.Display.R4);
		} elsif (k == "l5") {
			fms.EditFlightData.insertStar(me.Display.L5);
		} elsif (k == "r5") {
			fms.EditFlightData.insertApproach(me.Display.R5);
		} elsif (k == "l6") {
			unit[me.id].setPage("depArr");
		} elsif (k == "r6") {
			unit[me.id].setPage("rte");
		}
	},
};
