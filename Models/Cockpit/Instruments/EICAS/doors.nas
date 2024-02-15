# ==============================================================================
# Boeing 747-400 EICAS by Gijs de Rooy
# ==============================================================================

var canvas_lowerEICASPageDoors = {
	new: func(svg, name) {
		var obj = {parents: [canvas_lowerEICASPageDoors, B744SecondaryEICAS] };
		obj.group = obj.canvas.createGroup();
		obj.name = name;

		canvas.parsesvg(obj.group, svg, {"font-mapper": obj.font_mapper} );

		foreach(var key; obj.getKeys()) {
			obj[key] = obj.group.getElementById(key);
		}

		obj.update_items = [];

		return obj;
	},

	getKeys: func() {
		return [];
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
		me.group.setVisible(getprop("/instrumentation/eicas/display") == "DRS")
	}
};

var input = {};

emexec.ExecModule.register("B744 secondary EICAS", input, canvas_lowerEICASPageDoors.new("Aircraft/747-400/Models/Cockpit/Instruments/EICAS/doors.svg", "doors"));