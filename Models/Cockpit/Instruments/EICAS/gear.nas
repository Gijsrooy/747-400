# ==============================================================================
# Boeing 747-400 EICAS by Gijs de Rooy
# ==============================================================================

var canvas_lowerEICASPageGear = {
	new: func(svg, name) {
		var obj = {parents: [canvas_lowerEICASPageGear, B744SecondaryEICAS] };
		obj.group = obj.canvas.createGroup();
		obj.name = name;

		canvas.parsesvg(obj.group, svg, {"font-mapper": obj.font_mapper} );

		foreach(var key; obj.getKeys()) {
			obj[key] = obj.group.getElementById(key);
		};

		obj.update_items = [
			props.UpdateManager.FromHashValue("gear1btms", 0.1, func(val) {
				obj.btms(val, 1);
			}),
			props.UpdateManager.FromHashValue("gear2btms", 0.1, func(val) {
				obj.btms(val, 2);
			}),
			props.UpdateManager.FromHashValue("gear3btms", 0.1, func(val) {
				obj.btms(val, 3);
			}),
			props.UpdateManager.FromHashValue("gear4btms", 0.1, func(val) {
				obj.btms(val, 4);
			}),

			props.UpdateManager.FromHashValue("gear0pos", 0.1, func(val) {
				obj["gear0closed"].setVisible(val < 0.1);
			}),
			props.UpdateManager.FromHashValue("gear1pos", 0.1, func(val) {
				obj["gear1closed"].setVisible(val < 0.1);
			}),
			props.UpdateManager.FromHashValue("gear2pos", 0.1, func(val) {
				obj["gear2closed"].setVisible(val < 0.1);
			}),
			props.UpdateManager.FromHashValue("gear3pos", 0.1, func(val) {
				obj["gear3closed"].setVisible(val < 0.1);
			}),
			props.UpdateManager.FromHashValue("gear4pos", 0.1, func(val) {
				obj["gear4closed"].setVisible(val < 0.1);
			}),
		];

		obj.btms = func(btms, n) {
			obj["gear"~n~"btms1"].setText(sprintf("%1.0f", btms));
			obj["gear"~n~"btms2"].setText(sprintf("%1.0f", btms));
			obj["gear"~n~"btms3"].setText(sprintf("%1.0f", btms));
			obj["gear"~n~"btms4"].setText(sprintf("%1.0f", btms));

			if (btms >= 5) {
				obj["gear"~n~"btms1"].setColor(1, 0.5, 0);
				obj["gear"~n~"btms2"].setColor(1, 0.5, 0);
				obj["gear"~n~"btms3"].setColor(1, 0.5, 0);
				obj["gear"~n~"btms4"].setColor(1, 0.5, 0);
			} else {
				obj["gear"~n~"btms1"].setColor(1, 1, 1);
				obj["gear"~n~"btms2"].setColor(1, 1, 1);
				obj["gear"~n~"btms3"].setColor(1, 1, 1);
				obj["gear"~n~"btms4"].setColor(1, 1, 1);
			}
		};

		return obj;
	},

	getKeys: func() {
		return ["gear1btms1","gear1btms2","gear1btms3","gear1btms4",
		"gear2btms1","gear2btms2","gear2btms3","gear2btms4",
		"gear3btms1","gear3btms2","gear3btms3","gear3btms4",
		"gear4btms1","gear4btms2","gear4btms3","gear4btms4",
		"gear0closed","gear1closed","gear2closed","gear3closed","gear4closed"];
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
		me.group.setVisible(getprop("/instrumentation/eicas/display") == "GEAR")
	}
};

var input = {
	gear1btms: "/gear/gear[1]/btms",
	gear2btms: "/gear/gear[2]/btms",
	gear3btms: "/gear/gear[3]/btms",
	gear4btms: "/gear/gear[4]/btms",
	gear0pos: "/gear/gear[0]/position-norm",
	gear1pos: "/gear/gear[1]/position-norm",
	gear2pos: "/gear/gear[2]/position-norm",
	gear3pos: "/gear/gear[3]/position-norm",
	gear4pos: "/gear/gear[4]/position-norm",
};

emexec.ExecModule.register("B744 secondary EICAS", input, canvas_lowerEICASPageGear.new("Aircraft/747-400/Models/Cockpit/Instruments/EICAS/gear.svg", "gear"));