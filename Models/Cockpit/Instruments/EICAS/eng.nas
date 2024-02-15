# ==============================================================================
# Boeing 747-400 EICAS by Gijs de Rooy
# ==============================================================================

var canvas_lowerEICASPageEng = {
	new: func(svg, name) {
		var obj = {parents: [canvas_lowerEICASPageEng, B744SecondaryEICAS] };
		obj.group = obj.canvas.createGroup();
		obj.name = name;

		canvas.parsesvg(obj.group, svg, {"font-mapper": obj.font_mapper} );

		foreach(var key; obj.getKeys()) {
			obj[key] = obj.group.getElementById(key);
		};

		for (var i=1; i <= 4; i = i+1) {
			var c = obj["eng"~i~"n2bar"].getCenter();
			obj["eng"~i~"n2bar"].createTransform().setTranslation(-c[0], -c[1]);
			obj["eng"~i~"n2bar_scale"] = obj["eng"~i~"n2bar"].createTransform();
			obj["eng"~i~"n2bar"].createTransform().setTranslation(c[0], c[1]);
		}

		obj.update_items = [
			props.UpdateManager.FromHashValue("ff1", 0.1, func(val) {
				obj["eng1ff"].setText(sprintf("%2.01f", val * LB2KG / 1000));
			}),
			props.UpdateManager.FromHashValue("ff2", 0.1, func(val) {
				obj["eng2ff"].setText(sprintf("%2.01f", val * LB2KG / 1000));
			}),
			props.UpdateManager.FromHashValue("ff3", 0.1, func(val) {
				obj["eng3ff"].setText(sprintf("%2.01f", val * LB2KG / 1000));
			}),
			props.UpdateManager.FromHashValue("ff4", 0.1, func(val) {
				obj["eng4ff"].setText(sprintf("%2.01f", val * LB2KG / 1000));
			}),
			props.UpdateManager.FromHashValue("n21", 0.1, func(val) {
				obj["eng1n2"].setText(sprintf("%3.01f", val));
				obj["eng1n2bar_scale"].setScale(1, val / 112.5);
				if(val >= 112.5) {
					obj["eng1n2"].setColor(1,0,0);
					obj["eng1n2bar"].setColor(1,0,0);
				} else {
					obj["eng1n2"].setColor(1,1,1);
					obj["eng1n2bar"].setColor(1,1,1);
				}
			}),
			props.UpdateManager.FromHashValue("n22", 0.1, func(val) {
				obj["eng2n2"].setText(sprintf("%3.01f", val));
				obj["eng2n2bar_scale"].setScale(1, val / 112.5);
				if(val >= 112.5) {
					obj["eng2n2"].setColor(1,0,0);
					obj["eng2n2bar"].setColor(1,0,0);
				} else {
					obj["eng2n2"].setColor(1,1,1);
					obj["eng2n2bar"].setColor(1,1,1);
				}
			}),
			props.UpdateManager.FromHashValue("n23", 0.1, func(val) {
				obj["eng3n2"].setText(sprintf("%3.01f", val));
				obj["eng3n2bar_scale"].setScale(1, val / 112.5);
				if(val >= 112.5) {
					obj["eng3n2"].setColor(1,0,0);
					obj["eng3n2bar"].setColor(1,0,0);
				} else {
					obj["eng3n2"].setColor(1,1,1);
					obj["eng3n2bar"].setColor(1,1,1);
				}
			}),
			props.UpdateManager.FromHashValue("n24", 0.1, func(val) {
				obj["eng4n2"].setText(sprintf("%3.01f", val));
				obj["eng4n2bar_scale"].setScale(1, val / 112.5);
				if(val >= 112.5) {
					obj["eng4n2"].setColor(1,0,0);
					obj["eng4n2bar"].setColor(1,0,0);
				} else {
					obj["eng4n2"].setColor(1,1,1);
					obj["eng4n2bar"].setColor(1,1,1);
				}
			}),
			props.UpdateManager.FromHashValue("oilp1", 1, func(val) {
				obj["eng1oilp"].setText(sprintf("%2.0f", val));
			}),
			props.UpdateManager.FromHashValue("oilp2", 1, func(val) {
				obj["eng2oilp"].setText(sprintf("%2.0f", val));
			}),
			props.UpdateManager.FromHashValue("oilp3", 1, func(val) {
				obj["eng3oilp"].setText(sprintf("%2.0f", val));
			}),
			props.UpdateManager.FromHashValue("oilp4", 1, func(val) {
				obj["eng4oilp"].setText(sprintf("%2.0f", val));
			}),
		];

		obj.page = obj.group;

		return obj;
	},

	getKeys: func() {
		return ["eng1ff","eng1n2","eng1oilp","eng1n2bar","eng2ff","eng2n2","eng2oilp","eng2n2bar","eng3ff","eng3n2","eng3oilp","eng3n2bar","eng4ff","eng4n2","eng4oilp","eng4n2bar"];
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
		me.group.setVisible(getprop("/instrumentation/eicas/display") == "ENG")
	}
};

var input = {
	ff1: "/engines/engine[0]/fuel-flow_pph",
	ff2: "/engines/engine[1]/fuel-flow_pph",
	ff3: "/engines/engine[2]/fuel-flow_pph",
	ff4: "/engines/engine[3]/fuel-flow_pph",
	n21: "/engines/engine[0]/n2",
	n22: "/engines/engine[1]/n2",
	n23: "/engines/engine[2]/n2",
	n24: "/engines/engine[3]/n2",
	oilp1: "/engines/engine[0]/oil-pressure-psi",
	oilp2: "/engines/engine[1]/oil-pressure-psi",
	oilp3: "/engines/engine[2]/oil-pressure-psi",
	oilp4: "/engines/engine[3]/oil-pressure-psi",
};

emexec.ExecModule.register("B744 secondary EICAS", input, canvas_lowerEICASPageEng.new("Aircraft/747-400/Models/Cockpit/Instruments/EICAS/eng.svg", "eng"));