# ==============================================================================
# Boeing 747-400 EICAS by Gijs de Rooy
# ==============================================================================

var canvas_lowerEICASPageStat = {
	new: func(svg, name) {
		var obj = {parents: [canvas_lowerEICASPageStat, B744SecondaryEICAS] };
		obj.group = obj.canvas.createGroup();
		obj.name = name;

		canvas.parsesvg(obj.group, svg, {"font-mapper": obj.font_mapper} );

		foreach(var key; obj.getKeys()) {
			obj[key] = obj.group.getElementById(key);
		};

		obj.update_items = [
			props.UpdateManager.FromHashValue("aileronPosLeftOut", 0.025, func(val) {
				obj["aileronPosLeftOut"].setTranslation(0, -100 * val);
			}),
			props.UpdateManager.FromHashValue("aileronPosLeftIn", 0.025, func(val) {
				obj["aileronPosLeftIn"].setTranslation(0, -100 * val);
			}),
			props.UpdateManager.FromHashValue("aileronPosRightIn", 0.025, func(val) {
				obj["aileronPosRightIn"].setTranslation(0, -100 * val);
			}),
			props.UpdateManager.FromHashValue("aileronPosRightOut", 0.025, func(val) {
				obj["aileronPosRightOut"].setTranslation(0, -100 * val);
			}),
			
			props.UpdateManager.FromHashValue("apuegt", 0.1, func(val) {
				obj["apuegt"].setText(sprintf("%3.0f", (val - 32) / 1.8));
			}),
			props.UpdateManager.FromHashValue("apun1", 0.1, func(val) {
				obj["apun1"].setText(sprintf("%3.01f", val));
			}),
			props.UpdateManager.FromHashValue("apun2", 0.1, func(val) {
				obj["apun2"].setText(sprintf("%2.01f", val));
			}),

			props.UpdateManager.FromHashValue("apuBattVdc", 1, func(val) {
				obj["apuBattVdc"].setText(sprintf("%2.0f", val));
			}),
			props.UpdateManager.FromHashValue("mainBattVdc", 1, func(val) {
				obj["mainBattVdc"].setText(sprintf("%2.0f", val));
			}),

			props.UpdateManager.FromHashValue("hyd1pr", 1, func(val) {
				obj["hyd1pr"].setText(sprintf("%4.0f", val));
			}),
			props.UpdateManager.FromHashValue("hyd2pr", 1, func(val) {
				obj["hyd2pr"].setText(sprintf("%4.0f", val));
			}),
			props.UpdateManager.FromHashValue("hyd3pr", 1, func(val) {
				obj["hyd3pr"].setText(sprintf("%4.0f", val));
			}),
			props.UpdateManager.FromHashValue("hyd4pr", 1, func(val) {
				obj["hyd4pr"].setText(sprintf("%4.0f", val));
			}),

			props.UpdateManager.FromHashValue("elevatorPos", 0.025, func(val) {
				obj["elevPosLeft"].setTranslation(0, -100 * val);
				obj["elevPosRight"].setTranslation(0, -100 * val);
			}),
			props.UpdateManager.FromHashValue("rudderPos", 0.025, func(val) {
				obj["rudPosLow"].setTranslation(-140 * val, 0);
				obj["rudPosUpp"].setTranslation(-140 * val, 0);
			}),
			props.UpdateManager.FromHashValue("splPosLeft", 1, func(val) {
				obj["splPosLeft"].setTranslation(0, -2.22 * val);
			}),
			props.UpdateManager.FromHashValue("splPosRight", 1, func(val) {
				obj["splPosRight"].setTranslation(0, -2.22 * val);
			}),
		];

		return obj;
	},

	getKeys: func() {
		return ["aileronPosLeftIn","aileronPosLeftOut","aileronPosRightIn","aileronPosRightOut","apuBattVdc","apun1","apun2","apuegt",
		"elevPosLeft","elevPosRight","hyd1pr","hyd2pr","hyd3pr","hyd4pr","mainBattVdc","rudPosLow","rudPosUpp","splPosLeft","splPosRight"];
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
		me.group.setVisible(getprop("/instrumentation/eicas/display") == "STAT")
	}
};

var input = {
	aileronPosLeftOut: "/fdm/jsbsim/fcs/aileron[0]/pos-norm",
	aileronPosLeftIn: "/fdm/jsbsim/fcs/aileron[1]/pos-norm",
	aileronPosRightIn: "/fdm/jsbsim/fcs/aileron[2]/pos-norm",
	aileronPosRightOut: "/fdm/jsbsim/fcs/aileron[3]/pos-norm",
	apuegt: "/engines/engine[4]/egt-degf",
	apun1: "/engines/engine[4]/n1",
	apun2: "/engines/engine[4]/n2",
	hyd1pr: "/systems/hydraulic/pressure[0]",
	hyd2pr: "/systems/hydraulic/pressure[1]",
	hyd3pr: "/systems/hydraulic/pressure[2]",
	hyd4pr: "/systems/hydraulic/pressure[3]",
	apuBattVdc: "/systems/electrical/suppliers/apu-battery",
	mainBattVdc: "/systems/electrical/suppliers/battery",
	rudderPos: "/fdm/jsbsim/fcs/rudder-pos-norm",
	elevatorPos: "/fdm/jsbsim/fcs/elevator[0]/pos-norm",
	splPosLeft: "/fdm/jsbsim/fcs/spoiler[0]/pos-deg",
	splPosRight: "/fdm/jsbsim/fcs/spoiler[11]/pos-deg",
};

emexec.ExecModule.register("B744 secondary EICAS", input, canvas_lowerEICASPageStat.new("Aircraft/747-400/Models/Cockpit/Instruments/EICAS/stat.svg", "stat"));