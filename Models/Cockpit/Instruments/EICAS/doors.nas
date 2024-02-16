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

		obj["aftCargo"].hide();
		obj["bulkCargo"].hide();
		obj["ctrElec"].hide();
		obj["mainElec"].hide();

		obj.update_items = [
			props.UpdateManager.FromHashValue("cargo1", nil, func(val) {
			   	obj["fwdCargo"].setVisible(val > 0.1);
			}),
			props.UpdateManager.FromHashValue("entry1L", nil, func(val) {
			   	obj["entry1L"].setVisible(val > 0.1);
			}),
			props.UpdateManager.FromHashValue("entry1R", nil, func(val) {
			   	obj["entry1R"].setVisible(val > 0.1);
			}),
			props.UpdateManager.FromHashValue("entry2L", nil, func(val) {
			   	obj["entry2L"].setVisible(val > 0.1);
			}),
			props.UpdateManager.FromHashValue("entry2R", nil, func(val) {
			   	obj["entry2R"].setVisible(val > 0.1);
			}),
			props.UpdateManager.FromHashValue("entry3L", nil, func(val) {
			   	obj["entry3L"].setVisible(val > 0.1);
			}),
			props.UpdateManager.FromHashValue("entry3R", nil, func(val) {
			   	obj["entry3R"].setVisible(val > 0.1);
			}),
			props.UpdateManager.FromHashValue("entry4L", nil, func(val) {
			   	obj["entry4L"].setVisible(val > 0.1);
			}),
			props.UpdateManager.FromHashValue("entry4R", nil, func(val) {
			   	obj["entry4R"].setVisible(val > 0.1);
			}),
			props.UpdateManager.FromHashValue("entry5L", nil, func(val) {
			   	obj["entry5L"].setVisible(val > 0.1);
			}),
			props.UpdateManager.FromHashValue("entry5R", nil, func(val) {
			   	obj["entry5R"].setVisible(val > 0.1);
			}),
			props.UpdateManager.FromHashValue("upperL", nil, func(val) {
			   	obj["upperL"].setVisible(val > 0.1);
			}),
			props.UpdateManager.FromHashValue("upperR", nil, func(val) {
			   	obj["upperR"].setVisible(val > 0.1);
			}),
		];

		return obj;
	},

	getKeys: func() {
		return ["aftCargo","bulkCargo","fwdCargo","ctrElec","mainElec","upperL","upperR","entry1L","entry1R","entry2L","entry2R","entry3L","entry3R","entry4L","entry4R","entry5L","entry5R"];
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

var input = {
	cargo1: "/controls/doors/cargo1/position-norm",
	entry1L: "/controls/doors/entry1left/position-norm",
	entry1R: "/controls/doors/entry1right/position-norm",
	entry2L: "/controls/doors/entry2left/position-norm",
	entry2R: "/controls/doors/entry2right/position-norm",
	entry3L: "/controls/doors/entry3left/position-norm",
	entry3R: "/controls/doors/entry3right/position-norm",
	entry4L: "/controls/doors/entry4left/position-norm",
	entry4R: "/controls/doors/entry4right/position-norm",
	entry5L: "/controls/doors/entry5left/position-norm",
	entry5R: "/controls/doors/entry5right/position-norm",
	upperL: "/controls/doors/upperdeckleft/position-norm",
	upperR: "/controls/doors/upperdeckright/position-norm",
};

emexec.ExecModule.register("B744 secondary EICAS", input, canvas_lowerEICASPageDoors.new("Aircraft/747-400/Models/Cockpit/Instruments/EICAS/doors.svg", "doors"));