# Boeing 747-400 CDU
# Copyright (c) 2025 Josh Davidson (Octal450) and Gijs de Rooy

var unit = [nil, nil, nil];

var CDU = {
	new: func(n, t, ps) {
		var m = {parents: [CDU]};
		
		m.Blink = {
			active: 0,
			time: -10,
		};
		
		m.clear = 0;
		m.clearKeyPressed = 0;
		m.elapsedSec = 0;
		m.id = n;
		m.lastFmcPage = "none";
		m.message = std.Vector.new();
		
		m.PageList = {
			approach: Approach.new(n),
			arr: Arr.new(n),
			dep: Dep.new(n),
			depArr: DepArr.new(n),
			efisControl: EfisControl.new(n, t),
			efisOptions: EfisOptions.new(n, t),
			ident: Ident.new(n),
			init: Init.new(n),
			initRef: InitRef.new(n),
			menu: Menu.new(n, t),
			navRadio: NavRadio.new(n),
			perfInit: PerfInit.new(n),
			progress: Progress.new(n),
			progress2: Progress2.new(n),
			rte: Rte.new(n),
			rte2: Rte2.new(n),
			rteLegs: RteLegs.new(n),
			takeoff: Takeoff.new(n),
			thrustLim: ThrustLim.new(n),
		};
		
		m.page = m.PageList.menu;
		m.powerSource = ps;
		m.scratchpad = "";
		m.scratchpadDecimal = nil;
		m.scratchpadOld = "";
		m.scratchpadSize = 0;
		m.type = t; # 0 = Standard, 1 = Standby
		
		return m;
	},
	reset: func() {
		me.blinkScreen();
		me.clear = 0;
		me.clearKeyPressed = 0;
		me.lastFmcPage = "none";
		me.message.clear();
		me.page = me.PageList.menu;
		
		me.PageList.dep.reset();
		me.PageList.efisControl.reset();
		me.PageList.efisOptions.reset();
		me.PageList.ident.reset();
		me.PageList.init.reset();
		me.PageList.initRef.reset();
		me.PageList.navRadio.reset();
		me.PageList.rte.reset();
		me.PageList.rte2.reset();
		me.PageList.rteLegs.reset();
		me.PageList.takeoff.reset();
		me.PageList.thrustLim.reset();
		
		me.scratchpad = "";
		me.scratchpadDecimal = nil;
		me.scratchpadOld = "";
		me.scratchpadSize = 0;
	},
	loop: func() {
		me.elapsedSec = pts.Sim.Time.elapsedSec.getValue();

		if (me.powerSource.getValue() < 112) {
			if (me.page != me.PageList.menu) {
				me.page = me.PageList.menu;
			}
			fms.Internal.request[me.id] = 1;
		}
		
		if (me.Blink.active) {
			if (me.Blink.time < me.elapsedSec) {
				me.Blink.active = 0;
			}
		}
		me.page.loop();
	},
	alphaNumKey: func(k) {
		if (me.powerSource.getValue() < 112) {
			return;
		}
		
		me.clear = 0;
		if (me.message.size() > 0) {
			me.clearMessage(1);
		}
		if (size(me.scratchpad) < 23) {
			me.scratchpad = me.scratchpad ~ k;
		}
	},
	blinkScreen: func() {
		me.Blink.active = 1;
		canvas_cdu.canvasBase.hideCdu(me.id);
		me.Blink.time = me.elapsedSec + 0.4;
	},
	clearKey: func(pressed) {
		if (me.message.size() > 0 and me.clearKeyPressed == 0) { # Clear message
			me.clear = 0;
			me.clearMessage(0);
		} else {
			if (pressed) {
				me.clearKeyPressed = me.elapsedSec;
			} elsif (me.clearKeyPressed != 0) {
				var duration = me.elapsedSec - me.clearKeyPressed;
				if (duration >= 1) { # Clear entire scratchpad
					me.clear = 0;
					me.scratchpad = "";
				} elsif (size(me.scratchpad) > 0) { # Clear last character
					me.clear = 0;
					me.scratchpad = left(me.scratchpad, size(me.scratchpad) - 1);
				}
				me.clearKeyPressed = 0;
			}
		}
	},
	clearMessage: func(a) {
		me.clear = 0;
		
		if (a == 2) { # Clear all and set scratchpad to stored value
			me.message.clear();
			if (size(me.scratchpadOld) > 0) {
				me.scratchpad = me.scratchpadOld;
			} else {
				me.scratchpad = "";
			}
		} else if (a == 1) { # Clear all and blank scratchpad
			me.message.clear();
			me.scratchpad = "";
			me.scratchpadOld = "";
		} else { # Clear single message
			if (me.message.size() > 1) {
				me.message.pop(0);
				me.scratchpad = me.message.vector[0];
			} else if (me.message.size() > 0) {
				me.message.pop(0);
				if (size(me.scratchpadOld) > 0) {
					me.scratchpad = me.scratchpadOld;
				} else {
					me.scratchpad = "";
				}
			}
		}
	},
	deleteKey: func() {
		if (me.scratchpad == "") {
			me.setMessage("DELETE");
		}
	},
	depArrKey: func() {
		if (me.powerSource.getValue() < 112) {
			return;
		}

		if (!me.Blink.active) {
			me.pageKey("depArr");
		} else {
			me.setMessage("BUTTON PUSH IGNORED");
		}
	},
	initRefKey: func() {
		if (me.powerSource.getValue() < 112) {
			return;
		}

		if (!me.Blink.active) {
			if (pts.Position.wow) {
				if (fms.flightData.costIndex != -1 and fms.flightData.cruiseAlt > 0) {
					me.pageKey("takeoff");
				} else {
					me.pageKey("perfInit");
				}
			} else {
				me.pageKey("thrustLim");
			}
		} else {
			me.setMessage("BUTTON PUSH IGNORED");
		}
	},
	nextPageKey: func() {
		if (me.powerSource.getValue() < 112) {
			return;
		}
		
		if (contains(me.page, "numPages")) {
			if (!me.Blink.active) {
				me.blinkScreen();
				me.page.nextPage();
			} else {
				me.setMessage("BUTTON PUSH IGNORED");
			}
		}
	},
	pageKey: func(p) {
		if (me.powerSource.getValue() < 112) {
			return;
		}
		
		if (!me.Blink.active) {
			if (p == "menu" or !fms.Internal.request[me.id]) {
				me.setPage(p);
			} else {
				me.blinkScreen();
				me.setMessage("NOT ALLOWED");
			}
		} else {
			me.setMessage("BUTTON PUSH IGNORED");
		}
	},
	prevPageKey: func() {
		if (me.powerSource.getValue() < 112) {
			return;
		}
		
		if (contains(me.page, "numPages")) {
			if (!me.Blink.active) {
				me.blinkScreen();
				me.page.prevPage();
			} else {
				me.setMessage("BUTTON PUSH IGNORED");
			}
		}
	},
	removeMessage: func(m) {
		me.clear = 0;
		
		if (me.message.contains(m)) {
			if (me.message.size() > 1) {
				me.message.pop(me.message.index(m));
				me.scratchpad = me.message.vector[0];
			} else if (me.message.size() > 0) {
				me.message.pop(me.message.index(m));
				if (size(me.scratchpadOld) > 0) {
					me.scratchpad = me.scratchpadOld;
				} else {
					me.scratchpad = "";
				}
			}
		}
	},
	scratchpadClear: func() {
		me.clearMessage(1); # Also clears scratchpad and clear
	},
	scratchpadSet: func(t) {
		me.clearMessage(1);
		me.scratchpad = t;
	},
	scratchpadState: func() {
		if (me.clear) { # CLR character
			return 0;
		} else if (size(me.scratchpad) > 0 and me.message.size() == 0) { # Entry
			return 2;
		} else { # Empty or Message
			return 1;
		}
	},
	setMessage: func(m) {
		me.clear = 0;
		
		if (me.message.size() > 0) {
			if (me.message.vector[0] != m) { # Don't duplicate top message
				me.removeMessage(m); # Remove duplicate if it exists
				me.message.insert(0, m);
				me.scratchpad = m;
			}
		} else {
			me.message.insert(0, m);
			me.scratchpadOld = me.scratchpad;
			me.scratchpad = m;
		}
	},
	setPage: func(p) {
		if (p == "perf") { # PERF page logic
			if (fms.Internal.phase <= 2) {
				p = "perfClb";
			} else if (fms.Internal.phase == 3) {
				p = "perfCrz";
			} else {
				p = "perfDes";
			}
		}
		
		if (!contains(me.PageList, p)) { # Fallback logic
			p = "fallback";
		}
		
		if (me.PageList[p].group == "fmc") { # Standby CDU special logic
			if (me.type) {
				me.blinkScreen();
				me.setMessage("NOT ALLOWED");
				return;
			}
		}
		
		if (me.page.group == "fmc") { # Store last FMC group page
			me.lastFmcPage = me.page.name;
		}
		
		me.blinkScreen();
		me.page = me.PageList[p]; # Set page
		me.page.setup();
		
		# Update everything now to make sure it all transitions at once
		me.page.loop(); 
		canvas_cdu.updateCdu(me.id);
	},
	softKey: func(k) {
		if (me.powerSource.getValue() < 112) {
			return;
		}
		
		if (!me.Blink.active) {
			me.blinkScreen();
			me.page.softKey(k);
		} else {
			me.setMessage("BUTTON PUSH IGNORED");
		}
	},
	# String checking functions - if no test string is provided, they will check the scratchpad
	stringContains: func(c, test = nil) { # Checks if the test contains the string provided
		if (test == nil) {
			test = me.scratchpad;
		}
		
		if (find(c, test) != -1) {
			return 1;
		} else {
			return 0;
		}
	},
	stringDecimalLengthInRange: func(min, max, test = nil) { # Checks if the test is a decimal number with place length in the range provided
		if (test == nil) {
			test = me.scratchpad;
		}
		
		if (int(test) != nil) {
			if (find(".", test) != -1) {
				if (max == 0) {
					return 0;
				} else {
					me.scratchpadDecimal = split(".", test);
					if (size(me.scratchpadDecimal[1]) >= min and size(me.scratchpadDecimal[1]) <= max) {
						return 1;
					} else {
						return 0;
					}
				}
			} else {
				if (min == 0) {
					return 1;
				} else {
					return 0;
				}
			}
		} else {
			return 0;
		}
	},
	stringIsInt: func(test = nil) { # Checks if the test is an integer number
		if (test == nil) {
			test = me.scratchpad;
		}
		
		if (int(test) != nil) {
			if (test - int(test) != 0) {
				return 0;
			} else {
				return 1;
			}
		} else {
			return 0;
		}
	},
	stringIsNumber: func(test = nil) { # Checks if the test is a number, integer or decimal
		if (test == nil) {
			test = me.scratchpad;
		}
		
		if (int(test) != nil) {
			return 1;
		} else {
			return 0;
		}
	},
	stringLengthInRange: func(min, max, test = nil) { # Checks if the test string length is in the range provided
		if (test == nil) {
			test = me.scratchpad;
		}
		
		me.scratchpadSize = size(sprintf("%s", string.replace(test, "-", ""))); # Always string, and negatives don't affect
		
		if (me.scratchpadSize >= min and me.scratchpadSize <= max) {
			return 1;
		} else {
			return 0;
		}
	},
};

var BASE = {
	setup: func() {
		unit[0] = CDU.new(0, 0, systems.ELECTRICAL.Bus.ac1);
		unit[1] = CDU.new(1, 0, systems.ELECTRICAL.Bus.ac1);
		unit[2] = CDU.new(2, 1, systems.ELECTRICAL.Bus.ac1);
	},
	loop: func() {
		unit[0].loop();
		unit[1].loop();
		unit[2].loop();
	},
	reset: func() {
		fms.CORE.resetRadio();
		for (var i = 0; i < 3; i = i + 1) {
			unit[i].reset();
		}
	},
	removeGlobalMessage: func(m) {
		for (var i = 0; i < 3; i = i + 1) {
			unit[i].removeMessage(m);
		}
	},
	setGlobalMessage: func(m, t = 0) {
		for (var i = 0; i < 3; i = i + 1) {
			if (t or !unit[i].type) unit[i].setMessage(m);
		}
	},
};

var FONT = { # Letter separation in Canvas: 38.77
	large: "BoeingCDULarge.ttf",
	small: "BoeingCDUSmall.ttf",
};

var FORMAT = {
	Position: {
		degrees: [nil, nil],
		dms: nil,
		minutes: [nil, nil],
		sign: [nil, nil],
		formatNode: func(node) {
			me.dms = node.getChild("latitude-deg").getValue();
			me.degrees[0] = int(me.dms);
			me.minutes[0] = sprintf("%.1f",abs((me.dms - me.degrees[0]) * 60));
			me.sign[0] = me.degrees[0] >= 0 ? "N" : "S";
			me.dms = node.getChild("longitude-deg").getValue();
			me.degrees[1] = int(me.dms);
			me.minutes[1] = sprintf("%.1f",abs((me.dms - me.degrees[1]) * 60));
			me.sign[1] = me.degrees[1] >= 0 ? "E" : "W";
			return sprintf("%s%02dg%04.1f/%s%03dg%04.1f", me.sign[0], abs(me.degrees[0]), me.minutes[0], me.sign[1], abs(me.degrees[1]), me.minutes[1]);
		},
	},
};