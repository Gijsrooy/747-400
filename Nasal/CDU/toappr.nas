# Boeing 747-400 CDU
# Copyright (c) 2025 Josh Davidson (Octal450) and Gijs de Rooy
# Where needed + 0 is used to force a string to a number

var Takeoff = {
	new: func(n) {
		var m = {parents: [Takeoff]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.large, FONT.large, FONT.large, FONT.small, FONT.large, FONT.large],
			CLTranslate: [0, 0, 0, 4, 0, 0],
			CTranslate: [0, 0, 0, 4, 0, 0],
			C1L: "",
			C1: "",
			C2L: "",
			C2: "",
			C3L: "",
			C3: "CLB",
			C4L: "TRIM",
			C4: "",
			C5L: "",
			C5: "",
			C6L: "",
			C6: "",
			
			LFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1L: " FLAP/ACCEL HT",
			L1: "",
			L2L: " E/O ACCEL HT",
			L2: "",
			L3L: " THR REDUCTION",
			L3: "",
			L4L: " WIND/SLOPE",
			L4: "---",
			L5L: " RWY COND",
			L5: "",
			L6L: "------------",
			L6: "<INDEX",
			
			LBFont: [FONT.small, FONT.small, FONT.large, FONT.large, FONT.large, FONT.large],
			L1B: "       FT",
			L2B: "    FT",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "",
			
			RFont: [FONT.large, FONT.large, FONT.large, FONT.small, FONT.large, FONT.large],
			R1L: "V1",
			R1: "",
			R2L: "VR",
			R2: "",
			R3L: "REF V2",
			R3: "",
			R4L: "CG",
			R4: "",
			R5L: "POS SHIFT",
			R5: "",
			R6L: "------------",
			R6: "",
			
			RBFont: [FONT.small, FONT.small, FONT.small, FONT.large, FONT.large, FONT.large],
			R1B: "KT",
			R2B: "KT",
			R3B: "KT",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "TAKEOFF REF",
			titleTranslate: 0,
		};
		
		m.Value = {
			takeoffStabDeg: 0,
			tocg: "",
			toSlopeFmt: "",
			toWindFmt: "",
			v1Calc: 0,
			v2Calc: 0,
			vcl: 0,
			vfr: 0,
			vrCalc: 0,
			vsr: 0,
		};
		
		m.group = "fmc";
		m.name = "takeoff";
		m.scratchpad = "";
		m.scratchpadSplit = nil;
		m.scratchpadState = 0;
		
		return m;
	},
	reset: func() {
		me.setup();
	},
	setup: func() {
	},
	loop: func() {
		if (fms.flightData.accelAltSet) {
			if (fms.flightData.toFlaps > 0) {
				me.Display.L1 = sprintf("%2.0f/%d", fms.flightData.toFlaps, fms.flightData.accelAlt);
			} else {
				me.Display.L1 = "__" ~ sprintf("/%d", fms.flightData.accelAlt);
			}
			me.Display.L1B = sprintf("       FT");
		} else {
			if (fms.flightData.toFlaps > 0) {
				me.Display.L1 = sprintf("%2.0f/", fms.flightData.toFlaps);
			} else {
				me.Display.L1 = "__/";
			}
			me.Display.L1B = sprintf("   %dFT", fms.flightData.accelAlt);
		}
		
		me.Value.v1Calc = math.round(fms.Speeds.v1.getValue());
		if (fms.flightData.v1State > 0) {
			me.Display.R1L = "V1";
			me.Display.R1 = sprintf("%d  ", fms.flightData.v1);
			me.Display.R1B = "KT";
			me.Display.RFont[0] = FONT.large;
		} else if (fms.flightData.v1State == 0 and me.Value.v1Calc > 0) {
			me.Display.R1L = "REF V1";
			me.Display.R1 = sprintf("%d   ", me.Value.v1Calc);
			me.Display.R1B = "KT>";
			me.Display.RFont[0] = FONT.small;
		} else {
			me.Display.R1L = "V1";
			me.Display.R1 = "---";
			me.Display.R1B = "";
			me.Display.RFont[0] = FONT.small;
		}

		me.Display.L2 = sprintf("%d", fms.flightData.accelAltEo);
		if (fms.flightData.accelAltEoSet) {
			me.Display.LFont[1] = FONT.large;
		} else {
			me.Display.LFont[1] = FONT.small;
		}
		
		me.Value.vrCalc = math.round(fms.Speeds.vr.getValue());
		if (fms.flightData.vrState > 0) {
			me.Display.R2L = "VR";
			me.Display.R2 = sprintf("%d  ", fms.flightData.vr);
			me.Display.R2B = "KT";
			me.Display.RFont[1] = FONT.large;
		} else if (fms.flightData.vrState == 0 and me.Value.vrCalc > 0) {
			me.Display.R2L = "REF VR";
			me.Display.R2 = sprintf("%d   ", me.Value.vrCalc);
			me.Display.R2B = "KT>";
			me.Display.RFont[1] = FONT.small;
		} else {
			me.Display.R2L = "VR";
			me.Display.R2 = "---";
			me.Display.R2B = "";
			me.Display.RFont[1] = FONT.small;
		}
		
		me.Value.v2Calc = math.round(fms.Speeds.v2.getValue());
		if (fms.flightData.v2State > 0) {
			me.Display.R3L = "V2";
			me.Display.R3 = sprintf("%d  ", fms.flightData.v2);
			me.Display.R3B = "KT";
			me.Display.RFont[2] = FONT.large;
		} else if (fms.flightData.v2State == 0 and me.Value.v2Calc > 0) {
			me.Display.R3L = "REF V2";
			me.Display.R3 = sprintf("%d   ", me.Value.v2Calc);
			me.Display.R3B = "KT>";
			me.Display.RFont[2] = FONT.small;
		} else {
			me.Display.R3L = "V2";
			me.Display.R3 = "---";
			me.Display.R3B = "";
			me.Display.RFont[2] = FONT.small;
		}
		
		if (fms.flightData.tocg > 0) {
			me.Value.tocg = sprintf("%4.1f", fms.flightData.tocg);
		} else {
			me.Value.tocg = "--.-";
		}
		
		me.Value.takeoffStabDeg = fms.Internal.takeoffStabDeg.getValue();
		if (me.Value.takeoffStabDeg > 0) {
			me.Display.R4 = sprintf("+%2.1f", me.Value.takeoffStabDeg);
		} else {
			me.Display.R4 = "---";
		}
		
		if (fms.flightData.toSlope > -100 and fms.flightData.toWind > -100) {
			if (fms.flightData.toSlope < 0) {
				me.Value.toSlopeFmt = "D" ~ sprintf("%1.01f", abs(fms.flightData.toSlope));
			} else {
				me.Value.toSlopeFmt = "U" ~ sprintf("%1.01f", fms.flightData.toSlope);
			}
			
			if (fms.flightData.toWind < 0) {
				me.Value.toWindFmt = "T" ~ sprintf("%02d", abs(fms.flightData.toWind));
			} else {
				me.Value.toWindFmt = "H" ~ sprintf("%02d", fms.flightData.toWind);
			}

			me.Display.L4 = me.Value.toWindFmt ~ "/" ~ me.Value.toSlopeFmt;
			me.Display.LFont[3] = FONT.large;
		} else {
			me.Display.LFont[3] = FONT.small;
			me.Display.L4 = "H00/U0.0";
		}
				
		if (fms.flightData.climbThrustAlt > -2000) {
			me.Display.L3 = sprintf("%d", fms.flightData.climbThrustAlt);
			if (fms.flightData.climbThrustAltSet) {
				me.Display.LFont[2] = FONT.large;
			} else {
				me.Display.LFont[2] = FONT.small;
			}
		} else {
			me.Display.L3 = "----";
			me.Display.LFont[2] = FONT.small;
		}
	},
	softKey: func(k) {
		me.scratchpad = unit[me.id].scratchpad;
		me.scratchpadState = unit[me.id].scratchpadState();
		
		if (k == "l1") {
			if (me.scratchpadState == 2) {
				me.scratchpadSplit = split("/", me.scratchpad);
				if (size(me.scratchpadSplit) == 2) {
					if (unit[me.id].stringLengthInRange(2, 2, me.scratchpadSplit[0]) and unit[me.id].stringLengthInRange(3, 4, me.scratchpadSplit[1])) {
						if ((me.scratchpadSplit[0] == 10 or me.scratchpadSplit[0] == 20) and (me.scratchpadSplit[1] >= 400 and me.scratchpadSplit[1] <= 9999)) {
							fms.flightData.toFlaps = me.scratchpadSplit[0] + 0;
							fms.EditFlightData.resetVspeeds();
							fms.flightData.accelAlt = int(me.scratchpadSplit[1]);
							fms.flightData.accelAltSet = 1;
							unit[me.id].scratchpadClear();
						} else {
							unit[me.id].setMessage("INVALID ENTRY");
						}
					} elsif (me.scratchpadSplit[0] == "" and unit[me.id].stringLengthInRange(3, 4, me.scratchpadSplit[1]) and (me.scratchpadSplit[1] >= 400 and me.scratchpadSplit[1] <= 9999)) {
							fms.flightData.accelAlt = int(me.scratchpadSplit[1]);
							fms.flightData.accelAltSet = 1;
							unit[me.id].scratchpadClear();
					} else {
						unit[me.id].setMessage("INVALID ENTRY");
					}
				} else {
					if (unit[me.id].stringLengthInRange(2, 2, me.scratchpad) and me.scratchpad == 10 or me.scratchpad == 20) {
						fms.flightData.toFlaps = me.scratchpad + 0;
						fms.EditFlightData.resetVspeeds();
						unit[me.id].scratchpadClear();
					} elsif (unit[me.id].stringLengthInRange(3, 4, me.scratchpad) and me.scratchpad >= 400 and me.scratchpad <= 9999) {
						fms.flightData.accelAlt = int(me.scratchpad);
						fms.flightData.accelAltSet = 1;
						unit[me.id].scratchpadClear();
					} else {
						unit[me.id].setMessage("INVALID ENTRY");
					}
				}
			} elsif (unit[me.id].scratchpad == "DELETE") {
				fms.flightData.toFlaps = 0;
				fms.flightData.accelAlt = 1000;
				fms.flightData.accelAltSet = 0;
				fms.EditFlightData.resetVspeeds();
				unit[me.id].clearMessage(0);
			}
		} elsif (k == "r1") {
			if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(2, 3) and unit[me.id].stringIsInt() and me.scratchpad >= 100 and me.scratchpad <= 300) {
					fms.flightData.v1 = int(me.scratchpad);
					fms.flightData.v1State = 2;
					unit[me.id].scratchpadClear();
				} else {
					unit[me.id].setMessage("INVALID ENTRY");
				}
			} else if (me.scratchpadState == 1) {
				me.Value.v1Calc = math.round(fms.Speeds.v1.getValue());
				if (fms.flightData.v1State == 0 and me.Value.v1Calc > 0) {
					fms.flightData.v1 = me.Value.v1Calc;
					fms.flightData.v1State = 1;
				}
			} else {
				if (fms.flightData.v1State > 0) {
					fms.flightData.v1 = 0;
					fms.flightData.v1State = 0;
					unit[me.id].scratchpadClear();
				}
			}
		} else if (k == "l2") {
			if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(3, 4) and unit[me.id].stringIsInt() and me.scratchpad >= 400 and me.scratchpad <= 9999) {
					fms.flightData.accelAltEo = int(me.scratchpad);
					fms.flightData.accelAltEoSet = 1;
					unit[me.id].scratchpadClear();
				} else {
					unit[me.id].setMessage("INVALID ENTRY");
				}
			}
		} else if (k == "r2") {
			if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(2, 3) and unit[me.id].stringIsInt()) {
					if (me.scratchpad >= 100 and me.scratchpad <= 300) {
						fms.flightData.vr = int(me.scratchpad);
						fms.flightData.vrState = 2;
						unit[me.id].scratchpadClear();
					} else {
						unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					unit[me.id].setMessage("INVALID ENTRY");
				}
			} else if (me.scratchpadState == 1) {
				me.Value.vrCalc = math.round(fms.Speeds.vr.getValue());
				if (fms.flightData.vrState == 0 and me.Value.vrCalc > 0) {
					fms.flightData.vr = me.Value.vrCalc;
					fms.flightData.vrState = 1;
				}
			} else {
				if (fms.flightData.vrState > 0) {
					fms.flightData.vr = 0;
					fms.flightData.vrState = 0;
					unit[me.id].scratchpadClear();
				}
			}
		} else if (k == "r3") {
			if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(2, 3) and unit[me.id].stringIsInt()) {
					if (me.scratchpad >= 100 and me.scratchpad <= 300) {
						fms.flightData.v2 = int(me.scratchpad);
						fms.flightData.v2State = 2;
						unit[me.id].scratchpadClear();
					} else {
						unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					unit[me.id].setMessage("INVALID ENTRY");
				}
			} else if (me.scratchpadState == 1) {
				me.Value.v2Calc = math.round(fms.Speeds.v2.getValue());
				if (fms.flightData.v2State == 0 and me.Value.v2Calc > 0) {
					fms.flightData.v2 = me.Value.v2Calc;
					fms.flightData.v2State = 1;
				}
			} else {
				if (fms.flightData.v2State > 0) {
					fms.flightData.v2 = 0;
					fms.flightData.v2State = 0;
					unit[me.id].scratchpadClear();
				}
			}
		} else if (k == "l4") {
			if (me.scratchpadState == 2) {
				me.scratchpadSplit = split("/", me.scratchpad);
				if (size(me.scratchpadSplit) == 2) {
					if (unit[me.id].stringLengthInRange(2, 4, me.scratchpadSplit[0]) and unit[me.id].stringLengthInRange(2, 2, me.scratchpadSplit[1])) {
						# Check Wind
						if ((find("H", me.scratchpadSplit[0]) == 0 and find("T", me.scratchpadSplit[0]) == -1) or (find("T", me.scratchpadSplit[0]) == 0 and find("H", me.scratchpadSplit[0]) == -1)) {
							if (unit[me.id].stringContains("+", me.scratchpadSplit[0]) or unit[me.id].stringContains("-", me.scratchpadSplit[0])) {
								unit[me.id].setMessage("FORMAT ERROR");
								return;
							}
							
							me.scratchpadSplit[0] = string.replace(me.scratchpadSplit[0], "H", "");
							me.scratchpadSplit[0] = string.replace(me.scratchpadSplit[0], "T", "-");
						}
						
						if (!unit[me.id].stringIsInt(me.scratchpadSplit[0])) {
							unit[me.id].setMessage("INVALID ENTRY");
							return;
						}
						if (me.scratchpadSplit[0] < -99 or me.scratchpadSplit[0] > 99) {
							unit[me.id].setMessage("ENTRY OUT OF RANGE");
							return;
						}

						# Check Slope
						if ((find("U", me.scratchpadSplit[1]) == 0 and find("D", me.scratchpadSplit[1]) == -1) or (find("D", me.scratchpadSplit[1]) == 0 and find("U", me.scratchpadSplit[1]) == -1)) {
							if (unit[me.id].stringContains("+", me.scratchpadSplit[1]) or unit[me.id].stringContains("-", me.scratchpadSplit[1])) {
								unit[me.id].setMessage("INVALID ENTRY");
								return;
							}
							
							me.scratchpadSplit[1] = string.replace(me.scratchpadSplit[1], "U", "");
							me.scratchpadSplit[1] = string.replace(me.scratchpadSplit[1], "D", "-");
						}
						
						if (!unit[me.id].stringDecimalLengthInRange(0, 1, me.scratchpadSplit[1])) {
							unit[me.id].setMessage("INVALID ENTRY");
							return;
						}
						if (me.scratchpadSplit[1] < -2 or me.scratchpadSplit[1] > 2) {
							unit[me.id].setMessage("ENTRY OUT OF RANGE");
							return;
						}
						
						# Enter Data
						fms.flightData.toWind = int(me.scratchpadSplit[0]);
						fms.flightData.toSlope = me.scratchpadSplit[1] + 0;
						fms.EditFlightData.resetVspeeds();
						unit[me.id].scratchpadClear();
					} else {
						unit[me.id].setMessage("INVALID ENTRY");
					}
				} else {
					unit[me.id].setMessage("INVALID ENTRY");
				}
			}
		} else if (k == "l3") {
			if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(1, 5) and unit[me.id].stringIsInt()) {
					if (me.scratchpad >= fms.flightData.airportFromAlt + 1000) {
						fms.flightData.climbThrustAlt = int(me.scratchpad);
						fms.flightData.climbThrustAltSet = 1;
						unit[me.id].scratchpadClear();
					} else {
						unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					unit[me.id].setMessage("INVALID ENTRY");
				}
			} else if (me.scratchpadState == 0) {
				if (fms.flightData.climbThrustAltSet)  {
					fms.EditFlightData.insertToAlts(1);
					fms.flightData.climbThrustAltSet = 0;
					unit[me.id].scratchpadClear();
				}
			}
		} else if (k == "l6") {
			unit[me.id].setPage("initRef");
		}
	},
};

var Approach = {
	new: func(n) {
		var m = {parents: [Approach]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			CLTranslate: [2, 0, 0, 0, 0, 0],
			CTranslate: [3, 3, 0, 0, 0, 0],
			C1L: "FLAPS",
			C1: "25g",
			C2L: "",
			C2: "30g",
			C3L: "",
			C3: "",
			C4L: "",
			C4: "",
			C5L: "",
			C5: "",
			C6L: "",
			C6: "",
			
			LFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1L: " GROSS WT",
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
			
			pageNum: "",
			
			RFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1L: "VREF",
			R1: "",
			R2L: "",
			R2: "",
			R3L: "",
			R3: "",
			R4L: "FLAP/SPEED",
			R4: "",
			R5L: "",
			R5: "",
			R6L: "------------",
			R6: "THRUST LIM>",
			
			RBFont: [FONT.small, FONT.small, FONT.large, FONT.small, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "APPROACH REF",
			titleTranslate: 1,
		};
		
		m.Value = {
			vref: 0,
			vref25: 0,
			vref30: 0,
		};
		
		m.group = "fmc";
		m.name = "approach";
		m.scratchpad = "";
		m.scratchpadState = 0;
		
		return m;
	},
	setup: func() {
	},
	loop: func() {
		me.Value.vref = fms.Speeds.vref.getValue();
		me.Value.vref25 = fms.Speeds.vref25.getValue();
		me.Value.vref30 = fms.Speeds.vref30.getValue();

		if (me.Value.vref25 > 0) {
			me.Display.R1 = sprintf("%d  ", me.Value.vref25);
			me.Display.R1B = "KT";
		} else {
			me.Display.R1 = "---";
		}

		if (me.Value.vref30 > 0) {
			me.Display.R2 = sprintf("%d  ", me.Value.vref30);
			me.Display.R2B = "KT";
		} else {
			me.Display.R2 = "---";
		}

		me.Display.L4L = fms.flightData.airportTo ~ fms.RouteManager.destinationRunway.getValue();
		if (fms.flightData.airportTo != "" and fms.RouteManager.destinationRunway.getValue() != "") {
			var lengthM = airportinfo(fms.flightData.airportTo).runway(fms.RouteManager.destinationRunway.getValue()).length;
			me.Display.L4 = sprintf("%dFT%dM", lengthM * M2FT, lengthM);
		} else {
			me.Display.L4 = "";
		}
		
		if (me.Value.vref > 0) {
			me.Display.R4 = sprintf("%dg/%d  ", fms.flightData.landFlaps, me.Value.vref);
			me.Display.R4B = "KT";
		} else {
			me.Display.R4 = sprintf("%dg", fms.flightData.landFlaps) ~ "/---";
		}
	},
	softKey: func(k) {
		me.scratchpad = unit[me.id].scratchpad;
		me.scratchpadState = unit[me.id].scratchpadState();

		if (k == "r1") {
			if (me.scratchpadState == 1) {
				unit[me.id].scratchpad = "25/" ~ int(me.Value.vref25);
			}
		} else if (k == "r2") {
			if (me.scratchpadState == 1) {
				unit[me.id].scratchpad = "30/" ~ int(me.Value.vref30);
			}
		} else if (k == "r4") {
			if (me.scratchpadState == 2) {
				me.scratchpadSplit = split("/", me.scratchpad);
				if (size(me.scratchpadSplit) == 2) {
					fms.flightData.landFlaps = int(me.scratchpadSplit[0]);
					unit[me.id].scratchpadClear();
				}
			}
		} else if (k == "l6") {
			unit[me.id].setPage("initRef");
		} else if (k == "r6") {
			unit[me.id].setPage("thrustLim");
		}
	},
};
