# Boeing 747-400 CDU
# Copyright (c) 2025 Josh Davidson (Octal450) and Gijs de Rooy

var cdu1 = nil;
var cdu1Display = nil;
var cdu2 = nil;
var cdu2Display = nil;
var cdu3 = nil;
var cdu3Display = nil;

var Io = {
	msgLight: [props.globals.initNode("/instrumentation/cdu[0]/msg-light", 0, "BOOL"), props.globals.initNode("/instrumentation/cdu[1]/msg-light", 0, "BOOL"), props.globals.initNode("/instrumentation/cdu[2]/msg-light", 0, "BOOL")],
};

var Value = {
	CFont: [["", "", "", "", "", ""], ["", "", "", "", "", ""], ["", "", "", "", "", ""]],
	CTranslate: [[0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0]],
	CLTranslate: [[0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0]],
	LFont: [["", "", "", "", "", ""], ["", "", "", "", "", ""], ["", "", "", "", "", ""]],
	LBFont: [["", "", "", "", "", ""], ["", "", "", "", "", ""], ["", "", "", "", "", ""]],
	RFont: [["", "", "", "", "", ""], ["", "", "", "", "", ""], ["", "", "", "", "", ""]],
	RBFont: [["", "", "", "", "", ""], ["", "", "", "", "", ""], ["", "", "", "", "", ""]],
	title: ["", "", ""],
	titleTranslate: [0, 0, 0],
};

var canvasBase = {
	updateCdu1: 0,
	updateCdu2: 0,
	updateCdu3: 0,
	init: func(canvasGroup, file) {
		var font_mapper = func(family, weight) {
			return cdu.FONT.large;
		};
		
		canvas.parsesvg(canvasGroup, file, {"font-mapper": font_mapper});
		
		var svgKeys = me.getKeys();
		foreach(var key; svgKeys) {
			me[key] = canvasGroup.getElementById(key);
			if (find("_L", key) != -1 or key == "PageNum") me[key].setFont(cdu.FONT.small);
			
			var clip_el = canvasGroup.getElementById(key ~ "_clip");
			if (clip_el != nil) {
				clip_el.setVisible(0);
				var tranRect = clip_el.getTransformedBounds();
				
				var clip_rect = sprintf("rect(%d, %d, %d, %d)", 
					tranRect[1], # 0 ys
					tranRect[2], # 1 xe
					tranRect[3], # 2 ye
					tranRect[0] # 3 xs
				);
				
				# Coordinates are top, right, bottom, left (ys, xe, ye, xs) ref: l621 of simgear/canvas/CanvasElement.cxx
				me[key].set("clip", clip_rect);
				me[key].set("clip-frame", canvas.Element.PARENT);
			}
		}
		
		me.page = canvasGroup;
		
		return me;
	},
	getKeys: func() {
		return ["Clr", "C1", "C1_L", "C2", "C2_L", "C3", "C3_L", "C4", "C4_L", "C5", "C5_L", "C6", "C6_L", "L1", "L1_B", "L1_L", "L2", "L2_B", "L2_L", "L3", "L3_B", "L3_L", "L4", "L4_B", "L4_L", "L5", "L5_B", "L5_L", "L6", "L6_B", "L6_L", "PageNum",
		"R1", "R1_B", "R1_L", "R2", "R2_B", "R2_L", "R3", "R3_B", "R3_L", "R4", "R4_B", "R4_L", "R5", "R5_B", "R5_L", "R6", "R6_B", "R6_L", "Scratchpad", "Title"];
	},
	setup: func() {
		# Hide the pages by default
		# cdu1.page.hide();
		# cdu2.page.hide();
		# cdu3.page.hide();
	},
	hideCdu: func(n) {
		if (n == 0) {
			me.updateCdu1 = 0;
			cdu1.page.hide();
		}
		if (n == 1) {
			me.updateCdu2 = 0;
			cdu2.page.hide();
		}
		if (n == 2) {
			me.updateCdu3 = 0;
			cdu3.page.hide();
		}
	},
	update: func() {
		if (cdu.unit[0].powerSource.getValue() >= 112) {
			if (!cdu.unit[0].Blink.active) {
				# if (!me.updateCdu1) {
					me.updateCdu1 = 1;
					cdu1.update();
					cdu1.page.show();
				# }
			}
		} else {
			if (me.updateCdu1) {
				me.updateCdu1 = 0;
				cdu1.page.hide();
			}
		}
		if (cdu.unit[1].powerSource.getValue() >= 112) {
			if (!cdu.unit[1].Blink.active) {
				# if (!me.updateCdu2) {
					me.updateCdu2 = 1;
					cdu2.update();
					cdu2.page.show();
				# }
			}
		} else {
			if (me.updateCdu2) {
				me.updateCdu2 = 0;
				cdu2.page.hide();
			}
		}
		if (cdu.unit[2].powerSource.getValue() >= 112) {
			if (!cdu.unit[2].Blink.active) {
				# if (!me.updateCdu3) {
					me.updateCdu3 = 1;
					cdu3.update();
					cdu3.page.show();
				# }
			}
		} else {
			if (me.updateCdu3) {
				me.updateCdu3 = 0;
				cdu3.page.hide();
			}
		}
	},
	updateBase: func(n) {
		if (cdu.unit[n].message.size() > 0 or pts.Controls.Switches.annunTest.getBoolValue()) {
			Io.msgLight[n].setBoolValue(1);
		} else {
			Io.msgLight[n].setBoolValue(0);
		}
		
		if (cdu.unit[n].clear) {
			me["Clr"].show();
		} else {
			me["Clr"].hide();
		}
		me["Scratchpad"].setText(cdu.unit[n].scratchpad);
		
		Value.title[n] = cdu.unit[n].page.Display.title;
		if (math.mod(size(Value.title[n]), 2) != 0) { # Preserve alignment if odd num of characters
			Value.title[n] = " " ~ Value.title[n];
		}
		me["Title"].setText(Value.title[n]);
		
		me["C1"].setText(cdu.unit[n].page.Display.C1);
		me["C1_L"].setText(cdu.unit[n].page.Display.C1L);
		me["C2"].setText(cdu.unit[n].page.Display.C2);
		me["C2_L"].setText(cdu.unit[n].page.Display.C2L);
		me["C3"].setText(cdu.unit[n].page.Display.C3);
		me["C3_L"].setText(cdu.unit[n].page.Display.C3L);
		me["C4"].setText(cdu.unit[n].page.Display.C4);
		me["C4_L"].setText(cdu.unit[n].page.Display.C4L);
		me["C5"].setText(cdu.unit[n].page.Display.C5);
		me["C5_L"].setText(cdu.unit[n].page.Display.C5L);
		me["C6"].setText(cdu.unit[n].page.Display.C6);
		me["C6_L"].setText(cdu.unit[n].page.Display.C6L);
		
		me["L1"].setText(cdu.unit[n].page.Display.L1);
		me["L1_L"].setText(cdu.unit[n].page.Display.L1L);
		me["L2"].setText(cdu.unit[n].page.Display.L2);
		me["L2_L"].setText(cdu.unit[n].page.Display.L2L);
		me["L3"].setText(cdu.unit[n].page.Display.L3);
		me["L3_L"].setText(cdu.unit[n].page.Display.L3L);
		me["L4"].setText(cdu.unit[n].page.Display.L4);
		me["L4_L"].setText(cdu.unit[n].page.Display.L4L);
		me["L5"].setText(cdu.unit[n].page.Display.L5);
		me["L5_L"].setText(cdu.unit[n].page.Display.L5L);
		me["L6"].setText(cdu.unit[n].page.Display.L6);
		me["L6_L"].setText(cdu.unit[n].page.Display.L6L);
		
		me["L1_B"].setText(cdu.unit[n].page.Display.L1B);
		me["L2_B"].setText(cdu.unit[n].page.Display.L2B);
		me["L3_B"].setText(cdu.unit[n].page.Display.L3B);
		me["L4_B"].setText(cdu.unit[n].page.Display.L4B);
		me["L5_B"].setText(cdu.unit[n].page.Display.L5B);
		me["L6_B"].setText(cdu.unit[n].page.Display.L6B);
		
		me["PageNum"].setText(cdu.unit[n].page.Display.pageNum);
		
		me["R1"].setText(cdu.unit[n].page.Display.R1);
		me["R1_L"].setText(cdu.unit[n].page.Display.R1L);
		me["R2"].setText(cdu.unit[n].page.Display.R2);
		me["R2_L"].setText(cdu.unit[n].page.Display.R2L);
		me["R3"].setText(cdu.unit[n].page.Display.R3);
		me["R3_L"].setText(cdu.unit[n].page.Display.R3L);
		me["R4"].setText(cdu.unit[n].page.Display.R4);
		me["R4_L"].setText(cdu.unit[n].page.Display.R4L);
		me["R5"].setText(cdu.unit[n].page.Display.R5);
		me["R5_L"].setText(cdu.unit[n].page.Display.R5L);
		me["R6"].setText(cdu.unit[n].page.Display.R6);
		me["R6_L"].setText(cdu.unit[n].page.Display.R6L);
		
		me["R1_B"].setText(cdu.unit[n].page.Display.R1B);
		me["R2_B"].setText(cdu.unit[n].page.Display.R2B);
		me["R3_B"].setText(cdu.unit[n].page.Display.R3B);
		me["R4_B"].setText(cdu.unit[n].page.Display.R4B);
		me["R5_B"].setText(cdu.unit[n].page.Display.R5B);
		me["R6_B"].setText(cdu.unit[n].page.Display.R6B);
		
		me.updateFontSize(n);
		me.updateTranslation(n);
	},
	updateFontSize: func(n) {
		if (Value.CFont[n][0] != cdu.unit[n].page.Display.CFont[0]) {
			Value.CFont[n][0] = cdu.unit[n].page.Display.CFont[0];
			me["C1"].setFont(cdu.unit[n].page.Display.CFont[0]);
		}
		if (Value.CFont[n][1] != cdu.unit[n].page.Display.CFont[1]) {
			Value.CFont[n][1] = cdu.unit[n].page.Display.CFont[1];
			me["C2"].setFont(cdu.unit[n].page.Display.CFont[1]);
		}
		if (Value.CFont[n][2] != cdu.unit[n].page.Display.CFont[2]) {
			Value.CFont[n][2] = cdu.unit[n].page.Display.CFont[2];
			me["C3"].setFont(cdu.unit[n].page.Display.CFont[2]);
		}
		if (Value.CFont[n][3] != cdu.unit[n].page.Display.CFont[3]) {
			Value.CFont[n][3] = cdu.unit[n].page.Display.CFont[3];
			me["C4"].setFont(cdu.unit[n].page.Display.CFont[3]);
		}
		if (Value.CFont[n][4] != cdu.unit[n].page.Display.CFont[4]) {
			Value.CFont[n][4] = cdu.unit[n].page.Display.CFont[4];
			me["C5"].setFont(cdu.unit[n].page.Display.CFont[4]);
		}
		if (Value.CFont[n][5] != cdu.unit[n].page.Display.CFont[5]) {
			Value.CFont[n][5] = cdu.unit[n].page.Display.CFont[5];
			me["C6"].setFont(cdu.unit[n].page.Display.CFont[5]);
		}
		
		if (Value.LFont[n][0] != cdu.unit[n].page.Display.LFont[0]) {
			Value.LFont[n][0] = cdu.unit[n].page.Display.LFont[0];
			me["L1"].setFont(cdu.unit[n].page.Display.LFont[0]);
		}
		if (Value.LFont[n][1] != cdu.unit[n].page.Display.LFont[1]) {
			Value.LFont[n][1] = cdu.unit[n].page.Display.LFont[1];
			me["L2"].setFont(cdu.unit[n].page.Display.LFont[1]);
		}
		if (Value.LFont[n][2] != cdu.unit[n].page.Display.LFont[2]) {
			Value.LFont[n][2] = cdu.unit[n].page.Display.LFont[2];
			me["L3"].setFont(cdu.unit[n].page.Display.LFont[2]);
		}
		if (Value.LFont[n][3] != cdu.unit[n].page.Display.LFont[3]) {
			Value.LFont[n][3] = cdu.unit[n].page.Display.LFont[3];
			me["L4"].setFont(cdu.unit[n].page.Display.LFont[3]);
		}
		if (Value.LFont[n][4] != cdu.unit[n].page.Display.LFont[4]) {
			Value.LFont[n][4] = cdu.unit[n].page.Display.LFont[4];
			me["L5"].setFont(cdu.unit[n].page.Display.LFont[4]);
		}
		if (Value.LFont[n][5] != cdu.unit[n].page.Display.LFont[5]) {
			Value.LFont[n][5] = cdu.unit[n].page.Display.LFont[5];
			me["L6"].setFont(cdu.unit[n].page.Display.LFont[5]);
		}
		
		if (Value.LBFont[n][0] != cdu.unit[n].page.Display.LBFont[0]) {
			Value.LBFont[n][0] = cdu.unit[n].page.Display.LBFont[0];
			me["L1_B"].setFont(cdu.unit[n].page.Display.LBFont[0]);
		}
		if (Value.LBFont[n][1] != cdu.unit[n].page.Display.LBFont[1]) {
			Value.LBFont[n][1] = cdu.unit[n].page.Display.LBFont[1];
			me["L2_B"].setFont(cdu.unit[n].page.Display.LBFont[1]);
		}
		if (Value.LBFont[n][2] != cdu.unit[n].page.Display.LBFont[2]) {
			Value.LBFont[n][2] = cdu.unit[n].page.Display.LBFont[2];
			me["L3_B"].setFont(cdu.unit[n].page.Display.LBFont[2]);
		}
		if (Value.LBFont[n][3] != cdu.unit[n].page.Display.LBFont[3]) {
			Value.LBFont[n][3] = cdu.unit[n].page.Display.LBFont[3];
			me["L4_B"].setFont(cdu.unit[n].page.Display.LBFont[3]);
		}
		if (Value.LBFont[n][4] != cdu.unit[n].page.Display.LBFont[4]) {
			Value.LBFont[n][4] = cdu.unit[n].page.Display.LBFont[4];
			me["L5_B"].setFont(cdu.unit[n].page.Display.LBFont[4]);
		}
		if (Value.LBFont[n][5] != cdu.unit[n].page.Display.LBFont[5]) {
			Value.LBFont[n][5] = cdu.unit[n].page.Display.LBFont[5];
			me["L6_B"].setFont(cdu.unit[n].page.Display.LBFont[5]);
		}
		
		if (Value.RFont[n][0] != cdu.unit[n].page.Display.RFont[0]) {
			Value.RFont[n][0] = cdu.unit[n].page.Display.RFont[0];
			me["R1"].setFont(cdu.unit[n].page.Display.RFont[0]);
		}
		if (Value.RFont[n][1] != cdu.unit[n].page.Display.RFont[1]) {
			Value.RFont[n][1] = cdu.unit[n].page.Display.RFont[1];
			me["R2"].setFont(cdu.unit[n].page.Display.RFont[1]);
		}
		if (Value.RFont[n][2] != cdu.unit[n].page.Display.RFont[2]) {
			Value.RFont[n][2] = cdu.unit[n].page.Display.RFont[2];
			me["R3"].setFont(cdu.unit[n].page.Display.RFont[2]);
		}
		if (Value.RFont[n][3] != cdu.unit[n].page.Display.RFont[3]) {
			Value.RFont[n][3] = cdu.unit[n].page.Display.RFont[3];
			me["R4"].setFont(cdu.unit[n].page.Display.RFont[3]);
		}
		if (Value.RFont[n][4] != cdu.unit[n].page.Display.RFont[4]) {
			Value.RFont[n][4] = cdu.unit[n].page.Display.RFont[4];
			me["R5"].setFont(cdu.unit[n].page.Display.RFont[4]);
		}
		if (Value.RFont[n][5] != cdu.unit[n].page.Display.RFont[5]) {
			Value.RFont[n][5] = cdu.unit[n].page.Display.RFont[5];
			me["R6"].setFont(cdu.unit[n].page.Display.RFont[5]);
		}
		
		if (Value.RBFont[n][0] != cdu.unit[n].page.Display.RBFont[0]) {
			Value.RBFont[n][0] = cdu.unit[n].page.Display.RBFont[0];
			me["R1_B"].setFont(cdu.unit[n].page.Display.RBFont[0]);
		}
		if (Value.RBFont[n][1] != cdu.unit[n].page.Display.RBFont[1]) {
			Value.RBFont[n][1] = cdu.unit[n].page.Display.RBFont[1];
			me["R2_B"].setFont(cdu.unit[n].page.Display.RBFont[1]);
		}
		if (Value.RBFont[n][2] != cdu.unit[n].page.Display.RBFont[2]) {
			Value.RBFont[n][2] = cdu.unit[n].page.Display.RBFont[2];
			me["R3_B"].setFont(cdu.unit[n].page.Display.RBFont[2]);
		}
		if (Value.RBFont[n][3] != cdu.unit[n].page.Display.RBFont[3]) {
			Value.RBFont[n][3] = cdu.unit[n].page.Display.RBFont[3];
			me["R4_B"].setFont(cdu.unit[n].page.Display.RBFont[3]);
		}
		if (Value.RBFont[n][4] != cdu.unit[n].page.Display.RBFont[4]) {
			Value.RBFont[n][4] = cdu.unit[n].page.Display.RBFont[4];
			me["R5_B"].setFont(cdu.unit[n].page.Display.RBFont[4]);
		}
		if (Value.RBFont[n][5] != cdu.unit[n].page.Display.RBFont[5]) {
			Value.RBFont[n][5] = cdu.unit[n].page.Display.RBFont[5];
			me["R6_B"].setFont(cdu.unit[n].page.Display.RBFont[5]);
		}
	},
	updateTranslation: func(n) {
		if (Value.titleTranslate[n] != cdu.unit[n].page.Display.titleTranslate) {
			Value.titleTranslate[n] = cdu.unit[n].page.Display.titleTranslate;
			me["Title"].setTranslation(cdu.unit[n].page.Display.titleTranslate * 38.77, 0);
		}
		
		if (Value.CTranslate[n][0] != cdu.unit[n].page.Display.CTranslate[0]) {
			Value.CTranslate[n][0] = cdu.unit[n].page.Display.CTranslate[0];
			me["C1"].setTranslation(cdu.unit[n].page.Display.CTranslate[0] * 38.77, 0);
		}
		if (Value.CTranslate[n][1] != cdu.unit[n].page.Display.CTranslate[1]) {
			Value.CTranslate[n][1] = cdu.unit[n].page.Display.CTranslate[1];
			me["C2"].setTranslation(cdu.unit[n].page.Display.CTranslate[1] * 38.77, 0);
		}
		if (Value.CTranslate[n][2] != cdu.unit[n].page.Display.CTranslate[2]) {
			Value.CTranslate[n][2] = cdu.unit[n].page.Display.CTranslate[2];
			me["C3"].setTranslation(cdu.unit[n].page.Display.CTranslate[2] * 38.77, 0);
		}
		if (Value.CTranslate[n][3] != cdu.unit[n].page.Display.CTranslate[3]) {
			Value.CTranslate[n][3] = cdu.unit[n].page.Display.CTranslate[3];
			me["C4"].setTranslation(cdu.unit[n].page.Display.CTranslate[3] * 38.77, 0);
		}
		if (Value.CTranslate[n][4] != cdu.unit[n].page.Display.CTranslate[4]) {
			Value.CTranslate[n][4] = cdu.unit[n].page.Display.CTranslate[4];
			me["C5"].setTranslation(cdu.unit[n].page.Display.CTranslate[4] * 38.77, 0);
		}
		if (Value.CTranslate[n][5] != cdu.unit[n].page.Display.CTranslate[5]) {
			Value.CTranslate[n][5] = cdu.unit[n].page.Display.CTranslate[5];
			me["C6"].setTranslation(cdu.unit[n].page.Display.CTranslate[5] * 38.77, 0);
		}
		
		if (Value.CLTranslate[n][0] != cdu.unit[n].page.Display.CLTranslate[0]) {
			Value.CLTranslate[n][0] = cdu.unit[n].page.Display.CLTranslate[0];
			me["C1_L"].setTranslation(cdu.unit[n].page.Display.CLTranslate[0] * 38.77, 0);
		}
		if (Value.CLTranslate[n][1] != cdu.unit[n].page.Display.CLTranslate[1]) {
			Value.CLTranslate[n][1] = cdu.unit[n].page.Display.CLTranslate[1];
			me["C2_L"].setTranslation(cdu.unit[n].page.Display.CLTranslate[1] * 38.77, 0);
		}
		if (Value.CLTranslate[n][2] != cdu.unit[n].page.Display.CLTranslate[2]) {
			Value.CLTranslate[n][2] = cdu.unit[n].page.Display.CLTranslate[2];
			me["C3_L"].setTranslation(cdu.unit[n].page.Display.CLTranslate[2] * 38.77, 0);
		}
		if (Value.CLTranslate[n][3] != cdu.unit[n].page.Display.CLTranslate[3]) {
			Value.CLTranslate[n][3] = cdu.unit[n].page.Display.CLTranslate[3];
			me["C4_L"].setTranslation(cdu.unit[n].page.Display.CLTranslate[3] * 38.77, 0);
		}
		if (Value.CLTranslate[n][4] != cdu.unit[n].page.Display.CLTranslate[4]) {
			Value.CLTranslate[n][4] = cdu.unit[n].page.Display.CLTranslate[4];
			me["C5_L"].setTranslation(cdu.unit[n].page.Display.CLTranslate[4] * 38.77, 0);
		}
		if (Value.CLTranslate[n][5] != cdu.unit[n].page.Display.CLTranslate[5]) {
			Value.CLTranslate[n][5] = cdu.unit[n].page.Display.CLTranslate[5];
			me["C6_L"].setTranslation(cdu.unit[n].page.Display.CLTranslate[5] * 38.77, 0);
		}
	},
};

var canvasCdu1 = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasCdu1, canvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	update: func() {
		me.updateBase(0);
	},
};

var canvasCdu2 = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasCdu2, canvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	update: func() {
		me.updateBase(1);
	},
};

var canvasCdu3 = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasCdu3, canvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	update: func() {
		me.updateBase(2);
	},
};

var setup = func() {
	cdu1Display = canvas.new({
		"name": "CDU1",
		"size": [512, 432],
		"view": [1024, 864],
		"mipmapping": 1
	});
	cdu2Display = canvas.new({
		"name": "CDU2",
		"size": [512, 432],
		"view": [1024, 864],
		"mipmapping": 1
	});
	cdu3Display = canvas.new({
		"name": "CDU3",
		"size": [512, 432],
		"view": [1024, 864],
		"mipmapping": 1
	});
	
	cdu1Display.addPlacement({"node": "cdu1.screen"});
	cdu2Display.addPlacement({"node": "cdu2.screen"});
	cdu3Display.addPlacement({"node": "cdu3.screen"});
	
	var cdu1Group = cdu1Display.createGroup();
	var cdu2Group = cdu2Display.createGroup();
	var cdu3Group = cdu3Display.createGroup();
	
	cdu1 = canvasCdu1.new(cdu1Group, "Aircraft/747-400/Models/Cockpit/Instruments/CDU/CDU.svg");
	cdu2 = canvasCdu2.new(cdu2Group, "Aircraft/747-400/Models/Cockpit/Instruments/CDU/CDU.svg");
	cdu3 = canvasCdu3.new(cdu3Group, "Aircraft/747-400/Models/Cockpit/Instruments/CDU/CDU.svg");
	
	canvasBase.setup();
	
	cdu1.update();
	cdu2.update();
	cdu3.update();
	
	update.start();
}

var updateCdu = func(n) {
	if (n == 0) {
		cdu1.update();
	} else if (n == 1) {
		cdu2.update();
	} else if (n == 2) {
		cdu3.update();
	}
}

var update = maketimer(0.1, func() { # 10FPS
	canvasBase.update();
});
