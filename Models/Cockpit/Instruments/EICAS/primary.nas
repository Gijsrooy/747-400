# ==============================================================================
# Boeing 747-400 EICAS by Gijs de Rooy
# ==============================================================================

var thrustRefModeText = ["TO","TO 1","TO 2","D-TO","D-TO 1","D-TO 2","CLB","CLB 1","CLB 2","CON","CRZ","GA"];

var B744PrimaryEICAS = {
	new: func(svg, name) {
		var obj = { parents: [B744PrimaryEICAS] };
		obj.canvas = canvas.new({
			"name": "primaryEICAS",
			"size": [1024, 1024],
			"view": [1024, 1024],
			"mipmapping": 1
		});
		obj.canvas.addPlacement({"node": "Upper-EICAS-Screen"});

		obj.font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};

		obj.group = obj.canvas.createGroup();
		obj.name = name;

		canvas.parsesvg(obj.group, svg, {"font-mapper": obj.font_mapper} );

		foreach(var key; obj.getKeys()) {
			obj[key] = obj.group.getElementById(key);
		};

		for(var n = 1; n<=4; n+=1){
			var c = obj["eng"~n~"n1bar"].getCenter();
			obj["eng"~n~"n1bar"].createTransform().setTranslation(-c[0], -c[1]);
			obj["eng"~n~"n1bar_scale"] = obj["eng"~n~"n1bar"].createTransform();
			obj["eng"~n~"n1bar"].createTransform().setTranslation(c[0], c[1]);
			c = obj["eng"~n~"egtBar"].getCenter();
			obj["eng"~n~"egtBar"].createTransform().setTranslation(-c[0], -c[1]);
			obj["eng"~n~"egtBar_scale"] = obj["eng"~n~"egtBar"].createTransform();
			obj["eng"~n~"egtBar"].createTransform().setTranslation(c[0], c[1]);
		}
		c = obj["flapsBar"].getCenter();
		obj["flapsBar"].createTransform().setTranslation(-c[0], -c[1]);
		obj["flapsBar_scale"] = obj["flapsBar"].createTransform();
		obj["flapsBar"].createTransform().setTranslation(c[0], c[1]);

		var timerFlaps = maketimer(10.0, func { 
			obj["flapsText"].hide();
			obj["flapsLine"].hide();
			obj["flapsL"].hide();
			obj["flapsBar"].hide();
			obj["flapsBox"].hide(); 
		});
		setlistener("/fdm/jsbsim/fcs/flap-pos-norm", func() {
			if (getprop("/fdm/jsbsim/fcs/flap-pos-norm") == 0) {
				timerFlaps.singleShot = 1;
				timerFlaps.start(); # start the timer (with 1 second inverval)
			} else {
				timerFlaps.stop();
			}
		});
		timerFlaps.stop();

		var timerGear = maketimer(10.0, func { 
			obj["gear"].hide();
			obj["gearL"].hide();
			obj["gearBox"].hide();
			obj["gearBoxTrans"].hide(); 
		});
		setlistener("gear/gear/position-norm", func() {
			if (getprop("gear/gear/position-norm") == 0) {
				timerGear.singleShot = 1;
				timerGear.start(); # start the timer (with 1 second inverval)
			} else {
				timerGear.stop();
			}
		});

		obj.update_items = [
			props.UpdateManager.FromHashValue("eng1egt", 1, func(val) {
				obj.eicasEGT(val, 1);
			}),
			props.UpdateManager.FromHashValue("eng2egt", 1, func(val) {
				obj.eicasEGT(val, 2);
			}),
			props.UpdateManager.FromHashValue("eng3egt", 1, func(val) {
				obj.eicasEGT(val, 3);
			}),
			props.UpdateManager.FromHashValue("eng4egt", 1, func(val) {
				obj.eicasEGT(val, 4);
			}),

			props.UpdateManager.FromHashList(["eng1n1", "eng1throttle", "eng1n1max", "eng1rev"], nil, func(val) {
				obj.eicasN1(val.eng1n1, val.eng1throttle, val.eng1n1max, val.eng1rev, 1);
			}),
			props.UpdateManager.FromHashList(["eng2n1", "eng2throttle", "eng2n1max", "eng2rev"], nil, func(val) {
				obj.eicasN1(val.eng2n1, val.eng2throttle, val.eng2n1max, val.eng2rev, 2);
			}),
			props.UpdateManager.FromHashList(["eng3n1", "eng3throttle", "eng3n1max", "eng3rev"], nil, func(val) {
				obj.eicasN1(val.eng3n1, val.eng3throttle, val.eng3n1max, val.eng3rev, 3);
			}),
			props.UpdateManager.FromHashList(["eng4n1", "eng4throttle", "eng4n1max", "eng4rev"], nil, func(val) {
				obj.eicasN1(val.eng4n1, val.eng4throttle, val.eng4n1max, val.eng4rev, 4);
			}),

			props.UpdateManager.FromHashValue("eng1nai", nil, func(val) {
				obj["eng1nai"].setVisible(val);
			}),
			props.UpdateManager.FromHashValue("eng2nai", nil, func(val) {
				obj["eng2nai"].setVisible(val);
			}),
			props.UpdateManager.FromHashValue("eng3nai", nil, func(val) {
				obj["eng3nai"].setVisible(val);
			}),
			props.UpdateManager.FromHashValue("eng4nai", nil, func(val) {
				obj["eng4nai"].setVisible(val);
			}),

			props.UpdateManager.FromHashValue("msgWarning", nil, func(val) {
				obj["msgWarning"].setText(val);
			}),
			props.UpdateManager.FromHashValue("msgCaution", nil, func(val) {
				obj["msgCaution"].setText(val);
			}),
			props.UpdateManager.FromHashValue("msgAdvisory", nil, func(val) {
				obj["msgAdvisory"].setText(val);
			}),
			props.UpdateManager.FromHashValue("msgMemo", nil, func(val) {
				obj["msgMemo"].setText(val);
			}),

			props.UpdateManager.FromHashValue("assTemp", 1, func(val) {
				if ((val or -999) > -90) {
					obj["assTemp"].setText(sprintf("%+02.0fc", val));
					obj["assTemp"].show();
				} else {
					obj["assTemp"].hide();
				}
			}),

			props.UpdateManager.FromHashValue("thrustMode", 1, func(val) {
				if (val > -1) {
					obj["thrustRefMode"].setText(thrustRefModeText[val]);
				} else {
					obj["thrustRefMode"].setText("");
				}
			}),

			props.UpdateManager.FromHashValue("wai", nil, func(val) {
				obj["wai"].setVisible(val);
			}),

			props.UpdateManager.FromHashValue("fuelTemp", 1, func(val) {
				obj["fuelTemp"].setText(sprintf("%+02.0fc",val));
				if (val < -37) {
					obj["fuelTemp"].setColor(1, 0.5, 0);
				} else {
					obj["fuelTemp"].setColor(1, 1, 1);
				}
			}),

			props.UpdateManager.FromHashValue("tat", 1, func(val) {
				obj["tat"].setText(sprintf("%+02.0fc", val));
			}),

			props.UpdateManager.FromHashValue("fuelTotal", 100, func(val) {
				obj["fuelTotal"].setText(sprintf("%03.01f", val * LB2KG / 1000));
			}),

			props.UpdateManager.FromHashValue("fuelJettison", 1, func(val) {
				obj["fuelTemp"].setVisible(val == 0);
				obj["fuelTempL"].setVisible(val == 0);
				obj["fuelToRemain"].setVisible(val > 0);
				obj["fuelToRemainL"].setVisible(val > 0);
			}),

			props.UpdateManager.FromHashValue("fuelToRemain", 100, func(val) {
				obj["fuelToRemain"].setText(sprintf("%03.01f",val * LB2KG / 1000));
			}),

			props.UpdateManager.FromHashList(["flapsCmd","flapsPos"], 0.05, func(val) {
				if (val.flapsPos != 0 or val.flapsCmd != 0) {
					obj["flapsBar"].show();
					obj["flapsBar_scale"].setScale(1, val.flapsPos / 30);
					obj["flapsBox"].show();
					obj["flapsL"].show();
					obj["flapsLine"].setTranslation(0, 5.233 * val.flapsCmd);
					obj["flapsLine"].show();
					obj["flapsText"].setText(sprintf("%2.0f", val.flapsCmd));
					obj["flapsText"].setTranslation(0, 5.233 * val.flapsCmd);
					obj["flapsText"].show();
				}
				if (abs(val.flapsCmd - val.flapsPos) > 0.1) {
					obj["flapsLine"].setColor(1, 0, 1);
					obj["flapsText"].setColor(1, 0, 1);
				} else {
					obj["flapsLine"].setColor(0, 1, 0);
					obj["flapsText"].setColor(0, 1, 0);
				}
			}),

			props.UpdateManager.FromHashList(["gear0pos","gear1pos","gear2pos","gear3pos","gear4pos","gear0stuck","gear1stuck","gear2stuck","gear3stuck","gear4stuck"], 0.02, func(val) {
				if (val.gear0stuck or val.gear1stuck or val.gear2stuck or val.gear3stuck or val.gear4stuck) {
					obj["gear"].hide();
					obj["gearBox"].hide();
					obj["gearBoxTrans"].hide();
					obj["gearL"].show();

					var gearPos = [val.gear0pos, val.gear1pos, val.gear2pos, val.gear3pos, val.gear4pos];

					for(var g = 0; g <= 4; g += 1) {
						obj["gear"~g].show();
						obj["gear"~g~"box"].show();
						if(gearPos[g] == 1) {
							obj["gear"~g].setColor(0,1,0);
							obj["gear"~g].setText("DN");
							obj["gear"~g~"box"].setColor(0,1,0);
						} else {
							obj["gear"~g].setColor(1,1,1);
							if (gearPos[g] == 0) {
								obj["gear"~g].setText("UP");
								obj["gear"~g~"box"].setColor(1,1,1);
							} else {
								obj["gear"~g].setText("");
							}
						}
						obj["gear"~g~"boxTrans"].setVisible(gearPos[g] != 1 and gearPos[g] != 0);
					}
				} else {
					for(var g = 0; g <= 4; g+=1){
						obj["gear"~g].hide();
						obj["gear"~g~"box"].hide();
						obj["gear"~g~"boxTrans"].hide();
					}

					if (val.gear0pos < 0.02 and val.gear1pos < 0.02 and val.gear2pos < 0.02 and val.gear3pos < 0.02 and val.gear4pos < 0.02) {
						obj["gear"].setText("UP");
						obj["gear"].setColor(1,1,1);
						obj["gearBox"].setColor(1,1,1);
						obj["gearBoxTrans"].hide();
					} elsif (val.gear0pos > 0.98 and val.gear1pos > 0.98 and val.gear2pos > 0.98 and val.gear3pos > 0.98 and val.gear4pos > 0.98) {
						obj["gear"].setText("DOWN");
						obj["gear"].setColor(0,1,0);
						obj["gearBox"].setColor(0,1,0);
						obj["gear"].show();
						obj["gearBox"].show();
						obj["gearBoxTrans"].hide();
					}  else {
						obj["gear"].hide();
						obj["gearBox"].hide();
						obj["gearBoxTrans"].show();
					}
				}
			}),

		];

		obj.update = func(notification) {
			foreach(var update_item; obj.update_items) {
				update_item.update(notification);
			}
		};

		obj.eicasEGT = func(val, n) {
			var egtDegC = (val - 32) / 1.8;

			obj["eng"~n~"egt"].setText(sprintf("%3.0f", egtDegC));
			obj["eng"~n~"egtBar_scale"].setScale(1, egtDegC / 960);

			if (egtDegC >= 960) {
				obj["eng"~n~"egt"].setColor(1, 0, 0);
				obj["eng"~n~"egtBar"].setColor(1, 0, 0);
			} elsif (egtDegC >= 925) {
				obj["eng"~n~"egt"].setColor(1, 0.5, 0);
				obj["eng"~n~"egtBar"].setColor(1, 0.5, 0);
			} else {
				obj["eng"~n~"egt"].setColor(1, 1, 1);
				obj["eng"~n~"egtBar"].setColor(1, 1, 1);
			}
		};

		obj.eicasN1 = func(n1, n1cmd, n1max, rev, n) {
			obj["eng"~n~"n1"].setText(sprintf("%3.01f", n1));
			obj["eng"~n~"n1bar_scale"].setScale(1, n1 / 117.5);
			if(n1 >= 117.5) {
				obj["eng"~n~"n1"].setColor(1, 0, 0);
				obj["eng"~n~"n1bar"].setColor(1, 0, 0);
			} else {
				obj["eng"~n~"n1"].setColor(1, 1, 1);
				obj["eng"~n~"n1bar"].setColor(1, 1, 1);
			}

			if (rev > 0) {
				obj["eng"~n~"n1ref"].setText("REV");
				if (rev != 1) {
					obj["eng"~n~"n1ref"].setColor(1, 0.5, 0);
				} else {
					obj["eng"~n~"n1ref"].setColor(0, 1.0, 0);
				}
				obj["eng"~n~"n1cmdLine"].hide();
			} else {
				obj["eng"~n~"n1cmdLine"].show();
				obj["eng"~n~"n1cmdLine"].setTranslation(0, -173.2 * n1cmd * n1max - 46.8);
				obj["eng"~n~"n1ref"].setText(sprintf("%3.01f", 92.5 * n1cmd * n1max + 25.0));
				obj["eng"~n~"n1ref"].setColor(0, 1.0, 0);
			}

			obj["eng"~n~"n1maxLine"].setTranslation(0, -173.2 * n1max - 46.8);
		};

		return obj;
	},

	getKeys: func() {
		return ["assTemp", "thrustRefMode",
		"eng1egt","eng2egt","eng3egt","eng4egt",
		"eng1egtBar","eng2egtBar","eng3egtBar","eng4egtBar",
		"eng1n1","eng2n1","eng3n1","eng4n1",
		"eng1n1bar","eng2n1bar","eng3n1bar","eng4n1bar",
		"eng1n1cmdLine", "eng2n1cmdLine", "eng3n1cmdLine", "eng4n1cmdLine",
		"eng1n1maxLine", "eng2n1maxLine", "eng3n1maxLine", "eng4n1maxLine",
		"eng1n1ref","eng2n1ref","eng3n1ref","eng4n1ref",
		"eng1nai","eng2nai","eng3nai","eng4nai",
		"flapsBar","flapsBox","flapsL","flapsLine","flapsText",
		"fuelTemp","fuelTempL","fuelTotal","fuelToRemain","fuelToRemainL",
		"gear","gearBox","gearBoxTrans","gearL",
		"gear0","gear0box", "gear0boxTrans",
		"gear1","gear1box", "gear1boxTrans",
		"gear2","gear2box", "gear2boxTrans",
		"gear3","gear3box", "gear3boxTrans",
		"gear4","gear4box", "gear4boxTrans",
		"msgAdvisory","msgCaution","msgMemo","msgWarning",
		"tat","wai"];
	},

	update: func(notification) {
		obj.update(notification);
	}
};

var input = {
	assTemp: "/instrumentation/fmc/inputs/assumed-temp-deg-c",
	eng1egt: "/engines/engine[0]/egt-degf",
	eng2egt: "/engines/engine[1]/egt-degf",
	eng3egt: "/engines/engine[2]/egt-degf",
	eng4egt: "/engines/engine[3]/egt-degf",
	eng1n1: "/engines/engine[0]/n1",
	eng2n1: "/engines/engine[1]/n1",
	eng3n1: "/engines/engine[2]/n1",
	eng4n1: "/engines/engine[3]/n1",
	eng1throttle: "/controls/engines/engine[0]/throttle",
	eng2throttle: "/controls/engines/engine[1]/throttle",
	eng3throttle: "/controls/engines/engine[2]/throttle",
	eng4throttle: "/controls/engines/engine[3]/throttle",
	eng1n1max: "/fdm/jsbsim/eec/throttle-max-cmd-norm[0]",
	eng2n1max: "/fdm/jsbsim/eec/throttle-max-cmd-norm[0]",
	eng3n1max: "/fdm/jsbsim/eec/throttle-max-cmd-norm[0]",
	eng4n1max: "/fdm/jsbsim/eec/throttle-max-cmd-norm[0]",
	eng1nai: "/controls/anti-ice/engine[0]/inlet-heat",
	eng2nai: "/controls/anti-ice/engine[1]/inlet-heat",
	eng3nai: "/controls/anti-ice/engine[2]/inlet-heat",
	eng4nai: "/controls/anti-ice/engine[3]/inlet-heat",
	eng1rev: "/engines/engine[0]/reverser-pos-norm",
	eng2rev: "/engines/engine[1]/reverser-pos-norm",
	eng3rev: "/engines/engine[2]/reverser-pos-norm",
	eng4rev: "/engines/engine[3]/reverser-pos-norm",
	flapsCmd: "/fdm/jsbsim/fcs/flaps/cmd-detent-deg",
	flapsPos: "/fdm/jsbsim/fcs/flaps/pos-deg",
	fuelJettison: "/controls/fuel/jettison/selector",
	fuelTemp: "/consumables/fuel/tank[1]/temperature_degC",
	fuelToRemain: "/controls/fuel/jettison/fuel-to-remain-lbs",
	fuelTotal: "/fdm/jsbsim/propulsion/total-fuel-lbs",
	gear0pos: "/gear/gear[0]/position-norm",
	gear1pos: "/gear/gear[1]/position-norm",
	gear2pos: "/gear/gear[2]/position-norm",
	gear3pos: "/gear/gear[3]/position-norm",
	gear4pos: "/gear/gear[4]/position-norm",
	gear0stuck: "/controls/failures/gear[0]/stuck",
	gear1stuck: "/controls/failures/gear[1]/stuck",
	gear2stuck: "/controls/failures/gear[2]/stuck",
	gear3stuck: "/controls/failures/gear[3]/stuck",
	gear4stuck: "/controls/failures/gear[4]/stuck",
	gearDown: "/controls/gear/gear-down",
	msgWarning: "/instrumentation/eicas/msg/warning",
	msgCaution: "/instrumentation/eicas/msg/caution",
	msgAdvisory: "/instrumentation/eicas/msg/advisory",
	msgMemo: "/instrumentation/eicas/msg/memo",
	tat: "/environment/temperature-degc",
	thrustMode: "/fdm/jsbsim/eec/reference-thrust-mode",
	wai: "/controls/anti-ice/wing-heat",
};

var primaryEICAS = B744PrimaryEICAS.new("Aircraft/747-400/Models/Cockpit/Instruments/EICAS/primary.svg", "primary");
emexec.ExecModule.register("B744 primary EICAS", input, primaryEICAS);

var showPrimaryEICAS = func() {
	var dlg = canvas.Window.new([600, 600], "dialog")
        .set("resize", 1)
 		.lockAspectRatio()
 		.setTitle("Primary EICAS")
	    .setCanvas(primaryEICAS.canvas);
}