# ==============================================================================
# Boeing 747-400 EICAS by Gijs de Rooy
# ==============================================================================

var canvas_stat = {
	new: func(canvas_group)
	{
		var m = { parents: [canvas_stat] };
		var eicas = canvas_group;
		var font_mapper = func(family, weight)
		{
			if( family == "Liberation Sans" and weight == "normal" )
				return "LiberationFonts/LiberationSans-Regular.ttf";
		};
		
		canvas.parsesvg(eicas, "Aircraft/747-400/Models/Cockpit/Instruments/EICAS/stat.svg", {'font-mapper': font_mapper});
		
		var svg_keys = ["aileronPosLeftIn","aileronPosLeftOut","aileronPosRightIn","aileronPosRightOut","apuBattVdc","apun1","apun2","apuegt","elevPosLeft","elevPosRight","hyd1pr","hyd2pr","hyd3pr","hyd4pr","mainBattVdc","rudPosLow","rudPosUpp","splPosLeft","splPosRight"];
		foreach(var key; svg_keys) {
			m[key] = eicas.getElementById(key);
		}
		
		return m;
	},
	update: func()
	{
		me["aileronPosLeftOut"].setTranslation(0,-100*getprop("fdm/jsbsim/fcs/aileron[0]/pos-norm"));
		me["aileronPosLeftIn"].setTranslation(0,-100*getprop("fdm/jsbsim/fcs/aileron[1]/pos-norm"));
		me["aileronPosRightIn"].setTranslation(0,-100*getprop("fdm/jsbsim/fcs/aileron[2]/pos-norm"));
		me["aileronPosRightOut"].setTranslation(0,-100*getprop("fdm/jsbsim/fcs/aileron[3]/pos-norm"));
		me["rudPosLow"].setTranslation(-140*getprop("fdm/jsbsim/fcs/rudder-pos-norm"),0);
		me["rudPosUpp"].setTranslation(-140*getprop("fdm/jsbsim/fcs/rudder-pos-norm"),0);
		me["elevPosLeft"].setTranslation(0,-100*getprop("fdm/jsbsim/fcs/elevator[0]/pos-norm"));
		me["elevPosRight"].setTranslation(0,-100*getprop("fdm/jsbsim/fcs/elevator[0]/pos-norm"));
		me["splPosLeft"].setTranslation(0,-2.22*getprop("fdm/jsbsim/fcs/spoiler[0]/pos-deg"));
		me["splPosRight"].setTranslation(0,-2.22*getprop("fdm/jsbsim/fcs/spoiler[11]/pos-deg"));
		me["apun1"].setText(sprintf("%3.01f",getprop("engines/engine[4]/n1")));
		me["apun2"].setText(sprintf("%2.01f",getprop("engines/engine[4]/n2")));
		me["apuegt"].setText(sprintf("%3.0f",(getprop("engines/engine[4]/egt-degf")-32)/1.8));
		me["hyd1pr"].setText(sprintf("%4.0f",getprop("systems/hydraulic/pressure")));
		me["hyd2pr"].setText(sprintf("%4.0f",getprop("systems/hydraulic/pressure[1]")));
		me["hyd3pr"].setText(sprintf("%4.0f",getprop("systems/hydraulic/pressure[2]")));
		me["hyd4pr"].setText(sprintf("%4.0f",getprop("systems/hydraulic/pressure[3]")));
		me["mainBattVdc"].setText(sprintf("%2.0f",getprop("systems/electrical/suppliers/battery")));
		me["apuBattVdc"].setText(sprintf("%2.0f",getprop("systems/electrical/suppliers/apu-battery")));
		
		settimer(func me.update(), 0.1);
	}
};