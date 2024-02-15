# ==============================================================================
# Boeing 747-400 EICAS by Gijs de Rooy
# ==============================================================================

var canvas_lowerEICASPageElec = {
	new: func(svg, name) {
		var obj = {parents: [canvas_lowerEICASPageElec, B744SecondaryEICAS] };
		obj.group = obj.canvas.createGroup();
		obj.name = name;

		canvas.parsesvg(obj.group, svg, {"font-mapper": obj.font_mapper} );

		foreach(var key; obj.getKeys()) {
			obj[key] = obj.group.getElementById(key);
		};

		obj.update_items = [
			props.UpdateManager.FromHashValue("acBus1", nil, func(val) {
				if (val) {
					obj["bus1box"].setColor(0,1,0);
					obj["bus1text"].setColor(0,1,0);
				} else {
					obj["bus1box"].setColor(1,0.7,0);
					obj["bus1text"].setColor(1,0.7,0);
				}
			}),
			props.UpdateManager.FromHashValue("acBus2", nil, func(val) {
				if (val) {
					obj["bus2box"].setColor(0,1,0);
					obj["bus2text"].setColor(0,1,0);
				} else {
					obj["bus2box"].setColor(1,0.7,0);
					obj["bus2text"].setColor(1,0.7,0);
				}
			}),
			props.UpdateManager.FromHashValue("acBus3", nil, func(val) {
				if (val) {
					obj["bus3box"].setColor(0,1,0);
					obj["bus3text"].setColor(0,1,0);
				} else {
					obj["bus3box"].setColor(1,0.7,0);
					obj["bus3text"].setColor(1,0.7,0);
				}
			}),
			props.UpdateManager.FromHashValue("acBus4", nil, func(val) {
				if (val) {
					obj["bus4box"].setColor(0,1,0);
					obj["bus4text"].setColor(0,1,0);
				} else {
					obj["bus4box"].setColor(1,0.7,0);
					obj["bus4text"].setColor(1,0.7,0);
				}
			}),

			props.UpdateManager.FromHashValue("barApu1", nil, func(val) {
				obj["barapu1"].setVisible(val);
			}),
			props.UpdateManager.FromHashValue("barApu2", nil, func(val) {
				obj["barapu2"].setVisible(val);
			}),
			
			props.UpdateManager.FromHashValue("barBt1", nil, func(val) {
				obj["barbt1"].setVisible(val);
			}),
			props.UpdateManager.FromHashValue("barBt2", nil, func(val) {
				obj["barbt2"].setVisible(val);
			}),
			props.UpdateManager.FromHashValue("barBt3", nil, func(val) {
				obj["barbt3"].setVisible(val);
			}),
			props.UpdateManager.FromHashValue("barBt4", nil, func(val) {
				obj["barbt4"].setVisible(val);
			}),

			props.UpdateManager.FromHashValue("barExt1", nil, func(val) {
				obj["barext1"].setVisible(val);
			}),
			props.UpdateManager.FromHashValue("barExt2", nil, func(val) {
				obj["barext2"].setVisible(val);
			}),

			props.UpdateManager.FromHashValue("barGc1", nil, func(val) {
				obj["bargc1"].setVisible(val);
			}),
			props.UpdateManager.FromHashValue("barGc2", nil, func(val) {
				obj["bargc2"].setVisible(val);
			}),
			props.UpdateManager.FromHashValue("barGc3", nil, func(val) {
				obj["bargc3"].setVisible(val);
			}),
			props.UpdateManager.FromHashValue("barGc4", nil, func(val) {
				obj["bargc4"].setVisible(val);
			}),

			props.UpdateManager.FromHashValue("drive1", nil, func(val) {
				obj["drive1"].setVisible(val);
			}),
			props.UpdateManager.FromHashValue("drive2", nil, func(val) {
				obj["drive2"].setVisible(val);
			}),
			props.UpdateManager.FromHashValue("drive3", nil, func(val) {
				obj["drive3"].setVisible(val);
			}),
			props.UpdateManager.FromHashValue("drive4", nil, func(val) {
				obj["drive4"].setVisible(val);
			}),

			props.UpdateManager.FromHashValue("gc1", nil, func(val) {
				obj["gc1"].setVisible(val);
			}),
			props.UpdateManager.FromHashValue("gc2", nil, func(val) {
				obj["gc2"].setVisible(val);
			}),
			props.UpdateManager.FromHashValue("gc3", nil, func(val) {
				obj["gc3"].setVisible(val);
			}),
			props.UpdateManager.FromHashValue("gc4", nil, func(val) {
				obj["gc4"].setVisible(val);
			}),

			props.UpdateManager.FromHashValue("isln1", nil, func(val) {
				obj["isln1"].setVisible(val);
			}),
			props.UpdateManager.FromHashValue("isln2", nil, func(val) {
				obj["isln2"].setVisible(val);
			}),
			props.UpdateManager.FromHashValue("isln3", nil, func(val) {
				obj["isln3"].setVisible(val);
			}),
			props.UpdateManager.FromHashValue("isln4", nil, func(val) {
				obj["isln4"].setVisible(val);
			}),

			props.UpdateManager.FromHashValue("ssb", nil, func(val) {
				obj["ssb"].setTranslation(0, -50 * (1 - (val == "closed")));
			}),
			props.UpdateManager.FromHashValue("ssbBar", nil, func(val) {
				obj["ssbbar"].setVisible(val);
			}),

			props.UpdateManager.FromHashValue("utility1", nil, func(val) {
				if (val) {
					obj["utility1lines"].setColor(0,1,0);
					obj["utility1text"].setColor(0,1,0);
				} else {
					obj["utility1lines"].setColor(1,0.7,0);
					obj["utility1text"].setColor(1,0.7,0);
				}
			}),
			props.UpdateManager.FromHashValue("utility2", nil, func(val) {
				if (val) {
					obj["utility2lines"].setColor(0,1,0);
					obj["utility2text"].setColor(0,1,0);
				} else {
					obj["utility2lines"].setColor(1,0.7,0);
					obj["utility2text"].setColor(1,0.7,0);
				}
			}),
			props.UpdateManager.FromHashValue("utility3", nil, func(val) {
				if (val) {
					obj["utility3lines"].setColor(0,1,0);
					obj["utility3text"].setColor(0,1,0);
				} else {
					obj["utility3lines"].setColor(1,0.7,0);
					obj["utility3text"].setColor(1,0.7,0);
				}
			}),
			props.UpdateManager.FromHashValue("utility4", nil, func(val) {
				if (val) {
					obj["utility4lines"].setColor(0,1,0);
					obj["utility4text"].setColor(0,1,0);
				} else {
					obj["utility4lines"].setColor(1,0.7,0);
					obj["utility4text"].setColor(1,0.7,0);
				}
			}),
		];

		return obj;
	},
	getKeys: func() {
		return ["barapu1","barapu2","barbt1","barbt2","barbt3","barbt4","barext1","barext2","bargc1","bargc2","bargc3","bargc4",
		"bus1box","bus1text","bus2box","bus2text","bus3box","bus3text","bus4box","bus4text","drive1","drive2","drive3","drive4",
		"gc1","gc2","gc3","gc4","isln1","isln2","isln3","isln4","ssb","ssbbar","utility1text","utility1lines","utility2text","utility2lines","utility3text","utility3lines","utility4text","utility4lines"];
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
		me.group.setVisible(getprop("/instrumentation/eicas/display") == "ELEC")
	}
};

var input = {
	acBus1: "/systems/electrical/ac-bus[0]",
	acBus2: "/systems/electrical/ac-bus[1]",
	acBus3: "/systems/electrical/ac-bus[2]",
	acBus4: "/systems/electrical/ac-bus[3]",
	barApu1: "/systems/electrical/eicas/flowbar.apu[0]",
	barApu2: "/systems/electrical/eicas/flowbar.apu[1]",
	barBt1: "/systems/electrical/eicas/flowbar.bt[0]",
	barBt2: "/systems/electrical/eicas/flowbar.bt[1]",
	barBt3: "/systems/electrical/eicas/flowbar.bt[2]",
	barBt4: "/systems/electrical/eicas/flowbar.bt[3]",
	barGc1: "/systems/electrical/eicas/flowbar.gc[0]",
	barGc2: "/systems/electrical/eicas/flowbar.gc[1]",
	barGc3: "/systems/electrical/eicas/flowbar.gc[2]",
	barGc4: "/systems/electrical/eicas/flowbar.gc[3]",
	barExt1: "/systems/electrical/eicas/flowbar.ext[0]",
	barExt2: "/systems/electrical/eicas/flowbar.ext[1]",
	drive1: "/systems/electrical/generator-drive[0]",
	drive2: "/systems/electrical/generator-drive[1]",
	drive3: "/systems/electrical/generator-drive[2]",
	drive4: "/systems/electrical/generator-drive[3]",
	gc1: "/systems/electrical/generator-off[0]",
	gc2: "/systems/electrical/generator-off[1]",
	gc3: "/systems/electrical/generator-off[2]",
	gc4: "/systems/electrical/generator-off[3]",
	isln1: "/systems/electrical/bus-isolation[0]",
	isln2: "/systems/electrical/bus-isolation[1]",
	isln3: "/systems/electrical/bus-isolation[2]",
	isln4: "/systems/electrical/bus-isolation[3]",
	ssb: "/systems/electrical/eicas/ssb",
	ssbBar: "/systems/electrical/eicas/flowbar.ssb",
	utility1: "/systems/electrical/eicas/utility[0]",
	utility2: "/systems/electrical/eicas/utility[1]",
	utility3: "/systems/electrical/eicas/utility[2]",
	utility4: "/systems/electrical/eicas/utility[3]",
};

emexec.ExecModule.register("B744 secondary EICAS", input, canvas_lowerEICASPageElec.new("Aircraft/747-400/Models/Cockpit/Instruments/EICAS/elec.svg", "elec"));