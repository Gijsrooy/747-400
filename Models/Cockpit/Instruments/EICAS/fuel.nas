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
				obj["totalFuel"].setText(sprintf("%3.01f", val / 1000));
			}),
			props.UpdateManager.FromHashValue("center", 100, func(val) {
				obj["centertext"].setText(sprintf("%3.01f", val / 1000));
			}),
			props.UpdateManager.FromHashValue("main1", 100, func(val) {
				obj["main1text"].setText(sprintf("%3.01f", val / 1000));
			}),
			props.UpdateManager.FromHashValue("main2", 100, func(val) {
				obj["main2text"].setText(sprintf("%3.01f", val / 1000));
			}),
			props.UpdateManager.FromHashValue("main3", 100, func(val) {
				obj["main3text"].setText(sprintf("%3.01f", val / 1000));
			}),
			props.UpdateManager.FromHashValue("main4", 100, func(val) {
				obj["main4text"].setText(sprintf("%3.01f", val / 1000));
			}),
			props.UpdateManager.FromHashValue("stab", 100, func(val) {
				obj["stabtext"].setText(sprintf("%3.01f", val / 1000));
			}),
			props.UpdateManager.FromHashValue("res2", 100, func(val) {
				obj["res2text"].setText(sprintf("%3.01f", val / 1000));
			}),
			props.UpdateManager.FromHashValue("res3", 100, func(val) {
				obj["res3text"].setText(sprintf("%3.01f", val / 1000));
			}),
			props.UpdateManager.FromHashList(["centerleft","centerleftpress","centerright","centerrightpress","jettisonrate","flow12","flow24","flow32"], 1, func(val) {
				if (val.centerleftpress) {
					obj["centerleft"].setColor(1,1,0);
				} elsif (val.centerleft) {
					if (val.jettisonrate > 0) {
						obj["centerleft"].setColor(1,0,1);
					} else {
						obj["centerleft"].setColor(0,1,0);
					}
				} else {
					obj["centerleft"].setColor(1,1,1);
				}
				if (val.centerrightpress) {
					obj["centerright"].setColor(1,1,0);
				} elsif (val.centerright) {
					if (val.jettisonrate > 0) {
						obj["centerright"].setColor(1,0,1);
					} else {
						obj["centerright"].setColor(0,1,0);
					}
				} else {
					obj["centerright"].setColor(1,1,1);
				}
				obj["centerleftflow"].setVisible(val.centerleft and (val.flow12 or val.flow24));
				obj["centerleftpump"].setVisible(val.centerleft);
				obj["centerrightflow"].setVisible(val.centerright and (val.flow13 or val.flow32));
				obj["centerrightpump"].setVisible(val.centerright);
			}),
			props.UpdateManager.FromHashList(["main1aft","main1aftpress","main1fwd","main1fwdpress","flow1"], 1, func(val) {
				obj.mainPump("main1aft", val.main1aft, val.main1aftpress, val.flow1);
				obj.mainPump("main1fwd", val.main1fwd, val.main1fwdpress, val.flow1);
			}),
			props.UpdateManager.FromHashList(["main2aft","main2aftpress","main2fwd","main2fwdpress","flow6"], 1, func(val) {
				obj.mainPump("main2aft", val.main2aft, val.main2aftpress, val.flow6);
				obj.mainPump("main2fwd", val.main2fwd, val.main2fwdpress, val.flow6);
			}),
			props.UpdateManager.FromHashList(["main3aft","main3aftpress","main3fwd","main3fwdpress","flow14"], 1, func(val) {
				obj.mainPump("main3aft", val.main3aft, val.main3aftpress, val.flow14);
				obj.mainPump("main3fwd", val.main3fwd, val.main3fwdpress, val.flow14);
			}),
			props.UpdateManager.FromHashList(["main4aft","main4aftpress","main4fwd","main4fwdpress","flow19"], 1, func(val) {
				obj.mainPump("main4aft", val.main4aft, val.main4aftpress, val.flow19);
				obj.mainPump("main4fwd", val.main4fwd, val.main4fwdpress, val.flow19);
			}),
			props.UpdateManager.FromHashList(["ovrd2aft","ovrd2aftarm","ovrd2fwdpress","ovrd2fwd","ovrd2fwdarm","ovrd2fwdpress","jettisonrate","flow4","flow29"], 1, func(val) {
				obj.ovrdPump("ovrd2aft", val.ovrd2aft, val.ovrd2aftarm, val.ovrd2aftpress, val.flow4 or val.flow29, val.jettisonrate);
				obj.ovrdPump("ovrd2fwd", val.ovrd2fwd, val.ovrd2fwdarm, val.ovrd2fwdpress, val.flow4 or val.flow29, val.jettisonrate);
			}),
			props.UpdateManager.FromHashList(["ovrd3aft","ovrd3aftarm","ovrd3aftpress","ovrd3fwd","ovrd3fwdarm","ovrd3fwdpress","jettisonrate","flow17","flow37"], 1, func(val) {
				obj.ovrdPump("ovrd3aft", val.ovrd3aft, val.ovrd3aftarm, val.ovrd3aftpress, val.flow17 or val.flow37, val.jettisonrate);
				obj.ovrdPump("ovrd3fwd", val.ovrd3fwd, val.ovrd3fwdarm, val.ovrd3fwdpress, val.flow17 or val.flow37, val.jettisonrate);
			}),
			props.UpdateManager.FromHashList(["main1imbalance","main2imbalance","main1low","main2low","main3low","main4low"], 1, func(val) {
				obj.mainTank(1, val.main1imbalance, val.main1low);
				obj.mainTank(2, val.main2imbalance, val.main2low);
				obj.mainTank(3, val.main2imbalance, val.main3low);
				obj.mainTank(4, val.main1imbalance, val.main4low);
			}),
			props.UpdateManager.FromHashValue("res2ext", 1, func(val) {
				obj["res2arrow"].setVisible(val < 0);
				obj["res2flow"].setVisible(val < 0);
			}),
			props.UpdateManager.FromHashValue("res3ext", 1, func(val) {
				obj["res3arrow"].setVisible(val < 0);
				obj["res3flow"].setVisible(val < 0);
			}),
			props.UpdateManager.FromHashList(["stabext","stabpumpleft","stabpumpleftarm","stabpumpleftpress","stabpumpright","stabpumprightarm","stabpumprightpress","flow7to0","jettisonrate"], 1, func(val) {
				obj.stabPump("l", val.stabpumpleft, val.stabpumpleftarm, val.stabpumpleftpress, val.flow7to0, val.jettisonrate);
				obj.stabPump("r", val.stabpumpright, val.stabpumprightarm, val.stabpumprightpress, val.flow7to0, val.jettisonrate);
				obj["stabarrow"].setVisible(val.flow7to0);
				obj["stabline"].setVisible(val.flow7to0);
			}),
			props.UpdateManager.FromHashList(["flow1","flow2","flow3","flow4","flow5","flow6","flow7","flow8","flow10",
				"flow12","flow13","flow14","flow15","flow16","flow17","flow18","flow19",
				"flow20","flow21","flow24","flow25","flow27","flow29",
				"flow32","flow33","flow35","flow37","flow38a","flow38b","flow39",
				"flow1to2","flow4to3"], 1, func(val) {
				obj["flow1"].setVisible(val.flow1);
				obj["flow2"].setVisible(val.flow2);
				obj["flow3"].setVisible(val.flow3);
				obj["flow4"].setVisible(val.flow4);
				obj["flow5"].setVisible(val.flow5);
				obj["flow6"].setVisible(val.flow6);
				obj["flow7"].setVisible(val.flow7);
				obj["flow8"].setVisible(val.flow8);
				obj["flow10"].setVisible(val.flow10);
				obj["flow12"].setVisible(val.flow12);
				obj["flow13"].setVisible(val.flow13);
				obj["flow14"].setVisible(val.flow14);
				obj["flow15"].setVisible(val.flow15);
				obj["flow16"].setVisible(val.flow16);
				obj["flow17"].setVisible(val.flow17);
				obj["flow18"].setVisible(val.flow18);
				obj["flow19"].setVisible(val.flow19);
				obj["flow20"].setVisible(val.flow20);
				obj["flow21"].setVisible(val.flow21);
				obj["flow24"].setVisible(val.flow24);
				obj["flow25"].setVisible(val.flow25);
				obj["flow27"].setVisible(val.flow27);
				obj["flow29"].setVisible(val.flow29);
				obj["flow32"].setVisible(val.flow32);
				obj["flow33"].setVisible(val.flow33);
				obj["flow35"].setVisible(val.flow35);
				obj["flow37"].setVisible(val.flow37);
				obj["flow38a"].setVisible(val.flow38a);
				obj["flow38b"].setVisible(val.flow38b);
				obj["flow39"].setVisible(val.flow39);
				obj["flow40"].setVisible(val.flow27);
				obj["flow41"].setVisible(val.flow35);
				obj["main1arrow"].setVisible(val.flow1to2);
				obj["main1flow"].setVisible(val.flow1to2);
				obj["main4arrow"].setVisible(val.flow4to3);
				obj["main4flow"].setVisible(val.flow4to3);
			}),
			props.UpdateManager.FromHashList(["xfeed1","xfeed1transit","xfeed2","xfeed2transit","xfeed3","xfeed3transit","xfeed4","xfeed4transit"], 1, func(val) {
				obj.xfeed(1, val.xfeed1, val.xfeed1transit);
				obj.xfeed(2, val.xfeed2, val.xfeed2transit);
				obj.xfeed(3, val.xfeed3, val.xfeed3transit);
				obj.xfeed(4, val.xfeed4, val.xfeed4transit);
			}),
			props.UpdateManager.FromHashList(["eng1lowpress","eng2lowpress","eng3lowpress","eng4lowpress"], 1, func(val) {
				obj.engine(1, val.eng1lowpress, "flow1", "flow2");
				obj.engine(2, val.eng2lowpress, "flow6", "flow7");
				obj.engine(3, val.eng3lowpress, "flow14", "flow15");
				obj.engine(4, val.eng4lowpress, "flow19", "flow20");
			}),
			props.UpdateManager.FromHashList(["jettisonrate","fueldumptime","fuelJettison"], 1, func(val) {
				obj["jettison"].setVisible(val.fuelJettison > 0);
				if (val.jettisonrate > 0) {
					obj["jettisonTimeCount"].setText(sprintf("%2.0f", val.fueldumptime / 60));
				}
			}),
		];

		obj.engine = func(n, press, flow1, flow2) {
			obj["eng"~n].setColor(1,1,1-press);
			obj[flow1].setColor(press,1,0);
			obj[flow2].setColor(press,1,0);
		};

		obj.mainTank = func(n, imbalance, low) {	
			if (imbalance or low) {
				obj["main"~n].setColor(1,1,0);
			} else {
				obj["main"~n].setColor(1,1,1);
			}
		};

		obj.mainPump = func(n, pump, press, flow) {
			if (press) {
				obj[n].setColor(1,1,0);
			} elsif (pump) {
				obj[n].setColor(0,1,0);
			} else {
				obj[n].setColor(1,1,1);
			}
			obj[n~"pump"].setVisible(pump);
			obj[n~"flow"].setVisible(pump and flow);
		};

		obj.ovrdPump = func(n, pump, arm, press, flow, jettisonrate) {
			if (press) {
				obj[n].setColor(1,1,0);
			} elsif (arm and !pump) {
				obj[n].setColor(0,1,1);
			} elsif (pump) {
				if (jettisonrate > 0) {
					obj[n].setColor(1,0,1);
				} else {
					obj[n].setColor(0,1,0);
				}
			} else {
				obj[n].setColor(1,1,1);
			}
			obj[n~"flow"].setVisible(pump and flow);
			obj[n~"pump"].setVisible(arm);
		};

		obj.stabPump = func(n, pump, arm, press, flow, jettisonrate) {
			if (pump and press) {
				obj["stab"~n].setColor(1,1,0);
			} elsif (arm and !pump) {
				obj["stab"~n].setColor(0,1,1);
			} elsif (pump) {
				if (jettisonrate > 0) {
					obj["stab"~n].setColor(1,0,1);
				} else {
					obj["stab"~n].setColor(0,1,0);
				}
			} else {
				obj["stab"~n].setColor(1,1,1);
			}
			obj["stab"~n~"flow"].setVisible(pump and flow);
			obj["stab"~n~"pump"].setVisible(arm);
		};

		obj.xfeed = func(n, open, transit) {
			obj["xfeed"~n].setRotation(0.5 * math.pi * (open != 0));
			obj["xfeed"~n].setColor(1,1,1-transit);
		};

		return obj;
	},
	getKeys: func() {
		return [
		"centertext","centerleft","centerleftflow","centerleftpump","centerright","centerrightflow","centerrightpump",
		"eng1","eng2","eng3","eng4",
		"main1","main1text","main1aft","main1aftpump","main1aftflow","main1fwd","main1fwdpump","main1fwdflow",
		"main2","main2text","main2aft","main2aftpump","main2aftflow","main2fwd","main2fwdpump","main2fwdflow",
		"main3","main3low","main3text","main3aft","main3aftpump","main3aftflow","main3fwd","main3fwdpump","main3fwdflow","flow14",
		"main4","main4low","main4text","main4aft","main4aftpump","main4aftflow","main4fwd","main4fwdpump","main4fwdflow","flow19",
		"ovrd2aft","ovrd2aftflow","ovrd2aftpump","ovrd2fwd","ovrd2fwdflow","ovrd2fwdpump",
		"ovrd3aft","ovrd3aftflow","ovrd3aftpump","ovrd3fwd","ovrd3fwdflow","ovrd3fwdpump",
		"flow1","flow2","flow3","flow4","flow5","flow6","flow7","flow8","flow10",
		"flow12","flow13","flow14","flow15","flow16","flow17","flow18","flow19",
		"flow20","flow21","flow24","flow25","flow27","flow29",
		"flow32","flow33","flow35","flow37","flow38a","flow38b","flow39",
		"flow40","flow41",
		"res2","res2text","res2arrow","res2flow",
		"res3","res3text","res3arrow","res3flow",
		"main1arrow","main1flow",
		"main4arrow","main4flow",
		"stab","stabtext","stabarrow","stabline","stabl","stablflow","stablpump","stabr","stabrflow","stabrpump",
		"totalFuel","xfeed1","xfeed2","xfeed3","xfeed4",
		"jettison","jettisonTimeCount"];
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
	eng1lowpress: "/fdm/jsbsim/propulsion/engine[0]/low-fuel-pressure",
	eng2lowpress: "/fdm/jsbsim/propulsion/engine[1]/low-fuel-pressure",
	eng3lowpress: "/fdm/jsbsim/propulsion/engine[2]/low-fuel-pressure",
	eng4lowpress: "/fdm/jsbsim/propulsion/engine[3]/low-fuel-pressure",
	totalFuel: "/consumables/fuel/total-fuel-kg",
	center: "/fdm/jsbsim/propulsion/tank[0]/contents-kg",
	centerext: "/fdm/jsbsim/propulsion/tank[0]/external-flow-rate-pps",
	centerleft: "/controls/fuel/tank[0]/override-pump[0]",
	centerleftpress: "/fdm/jsbsim/propulsion/tank[0]/override-pump[0]/low-pressure",
	centerright: "/controls/fuel/tank[0]/override-pump[1]",
	centerrightpress: "/fdm/jsbsim/propulsion/tank[0]/override-pump[1]/low-pressure",
	main1: "/fdm/jsbsim/propulsion/tank[1]/contents-kg",
	main1ext: "/fdm/jsbsim/propulsion/tank[1]/external-flow-rate-pps",
	main1imbalance: "/fdm/jsbsim/propulsion/tank[1]/imbalance",
	main1low: "/fdm/jsbsim/propulsion/tank[1]/low-quantity",
	main1aft: "/controls/fuel/tank[1]/pump[1]",
	main1aftpress: "/controls/fuel/tank[1]/pump[1]/low-pressure",
	main1fwd: "/controls/fuel/tank[1]/pump[0]",
	main1fwdpress: "/controls/fuel/tank[1]/pump[0]/low-pressure",
	main2: "/fdm/jsbsim/propulsion/tank[2]/contents-kg",
	main2ext: "/fdm/jsbsim/propulsion/tank[2]/external-flow-rate-pps",
	main2imbalance: "/fdm/jsbsim/propulsion/tank[2]/imbalance",
	main2low: "/fdm/jsbsim/propulsion/tank[2]/low-quantity",
	main2aft: "/controls/fuel/tank[2]/pump[1]",
	main2aftpress: "/controls/fuel/tank[2]/pump[1]/low-pressure",
	main2fwd: "/controls/fuel/tank[2]/pump[0]",
	main2fwdpress: "/controls/fuel/tank[2]/pump[0]/low-pressure",
	ovrd2aft: "/fdm/jsbsim/propulsion/tank[2]/override-pump[1]/psi",
	ovrd2aftarm: "/controls/fuel/tank[2]/override-pump[1]",
	ovrd2aftpress: "/fdm/jsbsim/propulsion/tank[2]/override-pump[1]/low-pressure",
	ovrd2fwd: "/fdm/jsbsim/propulsion/tank[2]/override-pump[0]/psi",
	ovrd2fwdarm: "/controls/fuel/tank[2]/override-pump[0]",
	ovrd2fwdpress: "/fdm/jsbsim/propulsion/tank[2]/override-pump[0]/low-pressure",
	main3: "/fdm/jsbsim/propulsion/tank[3]/contents-kg",
	main3aft: "/controls/fuel/tank[3]/pump[1]",
	main3aftpress: "/controls/fuel/tank[3]/pump[1]/low-pressure",
	main3fwd: "/controls/fuel/tank[3]/pump[0]",
	main3fwdpress: "/controls/fuel/tank[3]/pump[0]/low-pressure",
	main3ext: "/fdm/jsbsim/propulsion/tank[3]/external-flow-rate-pps",
	main3low: "/fdm/jsbsim/propulsion/tank[3]/low-quantity",
	ovrd3aft: "/fdm/jsbsim/propulsion/tank[3]/override-pump[1]/psi",
	ovrd3aftarm: "/controls/fuel/tank[3]/override-pump[1]",
	ovrd3aftpress: "/fdm/jsbsim/propulsion/tank[3]/override-pump[1]/low-pressure",
	ovrd3fwd: "/fdm/jsbsim/propulsion/tank[3]/override-pump[0]/psi",
	ovrd3fwdarm: "/controls/fuel/tank[3]/override-pump[0]",
	ovrd3fwdpress: "/fdm/jsbsim/propulsion/tank[3]/override-pump[0]/low-pressure",
	main4: "/fdm/jsbsim/propulsion/tank[4]/contents-kg",
	main4aft: "/controls/fuel/tank[4]/pump[1]",
	main4aftpress: "/controls/fuel/tank[4]/pump[1]/low-pressure",
	main4fwd: "/controls/fuel/tank[4]/pump[0]",
	main4fwdpress: "/controls/fuel/tank[4]/pump[0]/low-pressure",
	main4ext: "/fdm/jsbsim/propulsion/tank[4]/external-flow-rate-pps",
	main4low: "/fdm/jsbsim/propulsion/tank[4]/low-quantity",
	res2: "/fdm/jsbsim/propulsion/tank[5]/contents-kg",
	res2ext: "/fdm/jsbsim/propulsion/tank[5]/external-flow-rate-pps",
	res3: "/fdm/jsbsim/propulsion/tank[6]/contents-kg",
	res3ext: "/fdm/jsbsim/propulsion/tank[6]/external-flow-rate-pps",
	stab: "/fdm/jsbsim/propulsion/tank[7]/contents-kg",
	stabpumpleft: "/fdm/jsbsim/propulsion/tank[7]/pump[0]",
	stabpumpleftarm: "/controls/fuel/tank[7]/pump[0]",
	stabpumpleftpress: "/fdm/jsbsim/propulsion/tank[7]/pump[0]/low-pressure",
	stabpumpright: "/fdm/jsbsim/propulsion/tank[7]/pump[1]",
	stabpumprightarm: "/controls/fuel/tank[7]/pump[1]",
	stabpumprightpress: "/fdm/jsbsim/propulsion/tank[7]/pump[1]/low-pressure",
	stabext: "/fdm/jsbsim/propulsion/tank[7]/external-flow-rate-pps",
	xfeed1: "/fdm/jsbsim/propulsion/tank[1]/x-feed",
	xfeed3: "/fdm/jsbsim/propulsion/tank[3]/x-feed",
	xfeed2: "/fdm/jsbsim/propulsion/tank[2]/x-feed",
	xfeed4: "/fdm/jsbsim/propulsion/tank[4]/x-feed",
	xfeed1transit: "/fdm/jsbsim/propulsion/tank[1]/x-feed/transit",
	xfeed2transit: "/fdm/jsbsim/propulsion/tank[2]/x-feed/transit",
	xfeed3transit: "/fdm/jsbsim/propulsion/tank[3]/x-feed/transit",
	xfeed4transit: "/fdm/jsbsim/propulsion/tank[4]/x-feed/transit",
	jettisonrate: "/fdm/jsbsim/propulsion/fuel-dump-rate-pps",
	fueldumptime: "/fdm/jsbsim/propulsion/fuel-dump-time-sec",
	fuelJettison: "/controls/fuel/jettison/selector",
	flow1: "/instrumentation/eicas/fuel/flow[1]",
	flow2: "/instrumentation/eicas/fuel/flow[2]",
	flow3: "/instrumentation/eicas/fuel/flow[3]",
	flow4: "/instrumentation/eicas/fuel/flow[4]",
	flow5: "/instrumentation/eicas/fuel/flow[5]",
	flow6: "/instrumentation/eicas/fuel/flow[6]",
	flow7: "/instrumentation/eicas/fuel/flow[7]",
	flow8: "/instrumentation/eicas/fuel/flow[8]",
	flow10: "/instrumentation/eicas/fuel/flow[10]",
	flow12: "/instrumentation/eicas/fuel/flow[12]",
	flow13: "/instrumentation/eicas/fuel/flow[13]",
	flow14: "/instrumentation/eicas/fuel/flow[14]",
	flow15: "/instrumentation/eicas/fuel/flow[15]",
	flow16: "/instrumentation/eicas/fuel/flow[16]",
	flow17: "/instrumentation/eicas/fuel/flow[17]",
	flow18: "/instrumentation/eicas/fuel/flow[18]",
	flow19: "/instrumentation/eicas/fuel/flow[19]",
	flow20: "/instrumentation/eicas/fuel/flow[20]",
	flow21: "/instrumentation/eicas/fuel/flow[21]",
	flow24: "/instrumentation/eicas/fuel/flow[24]",
	flow25: "/instrumentation/eicas/fuel/flow[25]",
	flow27: "/instrumentation/eicas/fuel/flow[27]",
	flow29: "/instrumentation/eicas/fuel/flow[29]",
	flow32: "/instrumentation/eicas/fuel/flow[32]",
	flow33: "/instrumentation/eicas/fuel/flow[33]",
	flow35: "/instrumentation/eicas/fuel/flow[35]",
	flow37: "/instrumentation/eicas/fuel/flow[37]",
	flow38a: "/instrumentation/eicas/fuel/flow[380]",
	flow38b: "/instrumentation/eicas/fuel/flow[381]",
	flow39: "/instrumentation/eicas/fuel/flow[39]",
	flow7to0: "/fdm/jsbsim/propulsion/tank[7]/external-flow-rate/tank[0]",
	flow1to2: "/fdm/jsbsim/propulsion/tank[1]/external-flow/tank[2]",
	flow4to3: "/fdm/jsbsim/propulsion/tank[4]/external-flow/tank[3]",
};

emexec.ExecModule.register("B744 secondary EICAS", input, canvas_lowerEICASPageFuel.new("Aircraft/747-400/Models/Cockpit/Instruments/EICAS/fuel.svg", "fuel"));