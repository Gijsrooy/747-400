# ==============================================================================
# Boeing 747-400 EICAS by Gijs de Rooy
# ==============================================================================

var canvas_lowerEICASPageFuel = {
	new: func(svg, name) {
		var obj = {parents: [canvas_lowerEICASPageFuel, B744SecondaryEICAS] };
		obj.group = obj.canvas.createGroup();
		obj.name = name;

		canvas.parsesvg(obj.group, svg, {"font-mapper": obj.font_mapper} );

		foreach(var key; obj.getKeys()) {
			obj[key] = obj.group.getElementById(key);
		};

		obj.update_items = [
			props.UpdateManager.FromHashValue("totalFuel", 100, func(val) {
				obj["text3840"].setText(sprintf("%3.01f", val * LB2KG / 1000));
			}),
			props.UpdateManager.FromHashValue("center", 100, func(val) {
				obj["center"].setText(sprintf("%3.01f", val * LB2KG / 1000));
			}),
			props.UpdateManager.FromHashList(["main1","main4"], 10, func(val) {
				obj["main1"].setText(sprintf("%3.01f", val.main1 * LB2KG / 1000));
				if (val.main1 < 2000 or (math.abs(val.main4 - val.main1)) > 3000) {
					obj["main1"].setColor(1,0.5,0);
				} else {
					obj["main1"].setColor(1,1,1);
				}
			}),
			props.UpdateManager.FromHashList(["main1","main1aft"], nil, func(val) {
				if (val.main1aft and val.main1 < 10 ) {
					obj["main1aft"].setColor(1,0.5,0);
				} elsif (val.main1aft) {
					obj["main1aft"].setColor(0,1,0);
				} else {
					obj["main1aft"].setColor(1,1,1);
				}
			}),
			props.UpdateManager.FromHashList(["main1","main1fwd"], 1, func(val) {
				if (val.main1fwd and val.main1 < 10 ) {
					obj["main1fwd"].setColor(1,0.5,0);
				} elsif (val.main1fwd) {
					obj["main1fwd"].setColor(0,1,0);
				} else {
					obj["main1fwd"].setColor(1,1,1);
				}
			}),
			props.UpdateManager.FromHashList(["main2","main3"], 10, func(val) {
				obj["main2"].setText(sprintf("%3.01f", val.main2 * LB2KG / 1000));
				if (val.main3 < 2000 or (math.abs(val.main2 - val.main3)) > 6000) {
					obj["main2"].setColor(1,0.5,0);
				} else {
					obj["main2"].setColor(1,1,1);
				}
			}),
			props.UpdateManager.FromHashList(["main2","main2aft"], 1, func(val) {
				if (val.main2aft and val.main2 < 10 ) {
					obj["main2aft"].setColor(1,0.5,0);
				} elsif (val.main2aft) {
					obj["main2aft"].setColor(0,1,0);
				} else {
					obj["main2aft"].setColor(1,1,1);
				}
			}),
			props.UpdateManager.FromHashList(["main2","main2fwd"], 1, func(val) {
				if (val.main2fwd and val.main2 < 10 ) {
					obj["main2fwd"].setColor(1,0.5,0);
				} elsif (val.main2fwd) {
					obj["main2fwd"].setColor(0,1,0);
				} else {
					obj["main2fwd"].setColor(1,1,1);
				}
			}),
			props.UpdateManager.FromHashList(["main2","ovrd2aft","jettisonrate"], 1, func(val) {
				if (val.ovrd2aft and val.main2 < 10 ) {
					obj["ovrd2aft"].setColor(1,0.5,0);
				} elsif (val.jettisonrate > 0) {
					obj["ovrd2aft"].setColor(1,0,1);
				} elsif (val.ovrd2aft) {
					obj["ovrd2aft"].setColor(0,1,0);
				} else {
					obj["ovrd2aft"].setColor(1,1,1);
				}
			}),
			props.UpdateManager.FromHashList(["main2","ovrd2fwd","jettisonrate"], 1, func(val) {
				if (val.ovrd2fwd and val.main2 < 10 ) {
					obj["ovrd2fwd"].setColor(1,0.5,0);
				} elsif (val.jettisonrate > 0) {
					obj["ovrd2fwd"].setColor(1,0,1);
				} elsif (val.ovrd2fwd) {
					obj["ovrd2fwd"].setColor(0,1,0);
				} else {
					obj["ovrd2fwd"].setColor(1,1,1);
				}
			}),
			props.UpdateManager.FromHashList(["main2","main3"], 10, func(val) {
				obj["main3"].setText(sprintf("%3.01f", val.main3 * LB2KG / 1000));
				if (val.main3 < 2000 or (math.abs(val.main3 - val.main2)) > 6000) {
					obj["main3"].setColor(1,0.5,0);
				} else {
					obj["main3"].setColor(1,1,1);
				}
			}),
			props.UpdateManager.FromHashList(["main3","main3aft"], 1, func(val) {
				if (val.main3aft and val.main3 < 10 ) {
					obj["main3aft"].setColor(1,0.5,0);
				} elsif (val.main3aft) {
					obj["main3aft"].setColor(0,1,0);
				} else {
					obj["main3aft"].setColor(1,1,1);
				}
			}),
			props.UpdateManager.FromHashList(["main3","main3fwd"], 1, func(val) {
				if (val.main3fwd and val.main3 < 10 ) {
					obj["main3fwd"].setColor(1,0.5,0);
				} elsif (val.main3fwd) {
					obj["main3fwd"].setColor(0,1,0);
				} else {
					obj["main3fwd"].setColor(1,1,1);
				}
			}),
			props.UpdateManager.FromHashList(["main3","ovrd3aft","jettisonrate"], 1, func(val) {
				if (val.ovrd3aft and val.main3 < 10 ) {
					obj["ovrd3aft"].setColor(1,0.5,0);
				} elsif (val.jettisonrate > 0) {
					obj["ovrd3aft"].setColor(1,0,1);
				} elsif (val.ovrd3aft) {
					obj["ovrd3aft"].setColor(0,1,0);
				} else {
					obj["ovrd3aft"].setColor(1,1,1);
				}
			}),
			props.UpdateManager.FromHashList(["main3","ovrd3fwd","jettisonrate"], 1, func(val) {
				if (val.ovrd3fwd and val.main3 < 10 ) {
					obj["ovrd3fwd"].setColor(1,0.5,0);
				} elsif (val.jettisonrate > 0) {
					obj["ovrd3fwd"].setColor(1,0,1);
				} elsif (val.ovrd3fwd) {
					obj["ovrd3fwd"].setColor(0,1,0);
				} else {
					obj["ovrd3fwd"].setColor(1,1,1);
				}
			}),
			props.UpdateManager.FromHashList(["main1","main4"], 10, func(val) {
				obj["main4"].setText(sprintf("%3.01f", val.main4 * LB2KG / 1000));
				if (val.main4 < 2000 or (math.abs(val.main1 - val.main4)) > 3000) {
					obj["main4"].setColor(1,0.5,0);
				} else {
					obj["main4"].setColor(1,1,1);
				}
			}),
			props.UpdateManager.FromHashList(["main4","main4aft"], 1, func(val) {
				if (val.main4aft and val.main4 < 10 ) {
					obj["main4aft"].setColor(1,0.5,0);
				} elsif (val.main4aft) {
					obj["main4aft"].setColor(0,1,0);
				} else {
					obj["main4aft"].setColor(1,1,1);
				}
			}),
			props.UpdateManager.FromHashList(["main4","main4fwd"], 1, func(val) {
				if (val.main4fwd and val.main4 < 10 ) {
					obj["main4fwd"].setColor(1,0.5,0);
				} elsif (val.main4fwd) {
					obj["main4fwd"].setColor(0,1,0);
				} else {
					obj["main4fwd"].setColor(1,1,1);
				}
			}),
			props.UpdateManager.FromHashValue("res2", 100, func(val) {
				obj["res2"].setText(sprintf("%3.01f", val * LB2KG / 1000));
			}),
			props.UpdateManager.FromHashValue("res3", 100, func(val) {
				obj["res3"].setText(sprintf("%3.01f", val * LB2KG / 1000));
			}),

			props.UpdateManager.FromHashValue("stab", 100, func(val) {
				obj["stab"].setText(sprintf("%3.01f", val * LB2KG / 1000));
			}),
			props.UpdateManager.FromHashList(["stab","stabextff","stabpump"], 1, func(val) {
				if (val.stabpump) {
					if (val.stab < 10 ) {
						obj["stabpumpl"].setColor(1,0.5,0);
						obj["stabpumpr"].setColor(1,0.5,0);
						obj["stabpumplines"].setColor(1,0.5,0);
					} elsif (val.stabextff != 0) {
						obj["stabpumpl"].setColor(0,1,0);
						obj["stabpumpr"].setColor(0,1,0);
						obj["stabpumplines"].setColor(0,1,0);
					} else {
						obj["stabpumpl"].setColor(0,1,1);
						obj["stabpumpr"].setColor(0,1,1);
					}
				} else {
					obj["stabpumpl"].setColor(1,1,1);
					obj["stabpumpr"].setColor(1,1,1);
				}
			}),

			props.UpdateManager.FromHashValue("xfeed1", 1, func(val) {
				obj["barxfeed1"].setVisible(val);
				obj["xfeed1"].setRotation(0.5 * math.pi * val);
			}),
			props.UpdateManager.FromHashValue("xfeed2", 1, func(val) {
				obj["barxfeed2"].setVisible(val);
				obj["xfeed2"].setRotation(0.5 * math.pi * val);
			}),
			props.UpdateManager.FromHashValue("xfeed3", 1, func(val) {
				obj["barxfeed3"].setVisible(val);
				obj["xfeed3"].setRotation(0.5 * math.pi * val);
			}),
			props.UpdateManager.FromHashValue("xfeed4", 1, func(val) {
				obj["barxfeed4"].setVisible(val);
				obj["xfeed4"].setRotation(0.5 * math.pi * val);
			}),
			props.UpdateManager.FromHashValue("eng1ff", 0.1, func(val) {
				obj["bareng1"].setVisible(val);
			}),
			props.UpdateManager.FromHashValue("eng2ff", 0.1, func(val) {
				obj["bareng2"].setVisible(val);
			}),
			props.UpdateManager.FromHashValue("eng3ff", 0.1, func(val) {
				obj["bareng3"].setVisible(val);
			}),
			props.UpdateManager.FromHashValue("eng4ff", 0.1, func(val) {
				obj["bareng4"].setVisible(val);
			}),
			props.UpdateManager.FromHashList(["jettisonrate","fueldumptime"], 1, func(val) {
				if (val.jettisonrate > 0) {
					obj["jettisonLines"].show();
					obj["jettison"].show();
					obj["stabpumpl"].setColor(1,0,1);
					obj["stabpumpr"].setColor(1,0,1);
					obj["stabpumplines"].setColor(1,0,1);
					obj["jettisonTime"].show();
					obj["jettisonTimeCount"].show();
					obj["jettisonTimeCount"].setText(sprintf("%2.0f", val.fueldumptime / 60));
					obj["stabline"].hide();
				} else {
					obj["jettisonLines"].hide();
					obj["jettison"].hide();
					obj["jettisonTime"].hide();
					obj["jettisonTimeCount"].hide();
					obj["stabline"].show();
				}
			}),
		];

		return obj;
	},
	getKeys: func() {
		return ["bareng1","bareng2","bareng3","bareng4","barxfeed1","barxfeed2","barxfeed3","barxfeed4","center",
		"main1","main1aft","main1fwd","main2","main2aft","main2fwd","main3","main3aft","main3fwd","main4","main4aft","main4fwd",
		"ovrd2aft","ovrd2fwd","ovrd3aft","ovrd3fwd","res2","res3","stab","text3840","xfeed1","xfeed2","xfeed3","xfeed4",
		"jettison","jettisonLines","jettisonTime","jettisonTimeCount","stabline","stabpumpl","stabpumpr","stabpumplines"];
	},
	update: func(notification) {
		me.updatePower();

		if (me.group.getVisible() == 0) {
			return;
		}

		foreach(var update_item; me.update_items) {
			update_item.update(notification);
		}
	},
	updatePower: func() {
		me.group.setVisible(getprop("/instrumentation/eicas/display") == "FUEL")
	}
};

var input = {
	eng1ff: "/fdm/jsbsim/propulsion/engine[0]/fuel-flow-rate-pps",
	eng2ff: "/fdm/jsbsim/propulsion/engine[1]/fuel-flow-rate-pps",
	eng3ff: "/fdm/jsbsim/propulsion/engine[2]/fuel-flow-rate-pps",
	eng4ff: "/fdm/jsbsim/propulsion/engine[3]/fuel-flow-rate-pps",
	totalFuel: "/fdm/jsbsim/propulsion/total-fuel-lbs",
	center: "/consumables/fuel/tank[0]/level-lbs",
	main1: "/consumables/fuel/tank[1]/level-lbs",
	main1aft: "/controls/fuel/tank[1]/pump-aft",
	main1fwd: "/controls/fuel/tank[1]/pump-fwd",
	main2: "/consumables/fuel/tank[2]/level-lbs",
	main2aft: "/controls/fuel/tank[2]/pump-aft",
	main2fwd: "/controls/fuel/tank[2]/pump-fwd",
	ovrd2aft: "/controls/fuel/tank[2]/ovrd-aft",
	ovrd2fwd: "/controls/fuel/tank[2]/ovrd-fwd",
	main3: "/consumables/fuel/tank[3]/level-lbs",
	main3aft: "/controls/fuel/tank[3]/pump-aft",
	main3fwd: "/controls/fuel/tank[3]/pump-fwd",
	ovrd3aft: "/controls/fuel/tank[3]/ovrd-aft",
	ovrd3fwd: "/controls/fuel/tank[3]/ovrd-fwd",
	main4: "/consumables/fuel/tank[4]/level-lbs",
	main4aft: "/controls/fuel/tank[4]/pump-aft",
	main4fwd: "/controls/fuel/tank[4]/pump-fwd",
	res2: "/consumables/fuel/tank[5]/level-lbs",
	res3: "/consumables/fuel/tank[6]/level-lbs",
	stab: "/consumables/fuel/tank[7]/level-lbs",
	stabpump: "/controls/fuel/tank[7]/pump",
	stabextff: "/fdm/jsbsim/propulsion/tank[7]/external-flow-rate-pps",
	xfeed1: "/controls/fuel/tank[1]/x-feed",
	xfeed2: "/controls/fuel/tank[2]/x-feed",
	xfeed3: "/controls/fuel/tank[3]/x-feed",
	xfeed4: "/controls/fuel/tank[4]/x-feed",
	jettisonrate: "/fdm/jsbsim/propulsion/fuel-dump-rate-pps",
	fueldumptime: "/fdm/jsbsim/propulsion/fuel-dump-time-sec",
};

emexec.ExecModule.register("B744 secondary EICAS", input, canvas_lowerEICASPageFuel.new("Aircraft/747-400/Models/Cockpit/Instruments/EICAS/fuel.svg", "fuel"));