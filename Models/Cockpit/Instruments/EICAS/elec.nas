# ==============================================================================
# Boeing 747-400 EICAS by Gijs de Rooy
# ==============================================================================

var canvas_elec = {
	new: func(canvas_group)
	{
		var m = { parents: [canvas_elec] };
		
		var eicas = canvas_group;
		
		var font_mapper = func(family, weight)
		{
			if( family == "Liberation Sans" and weight == "normal" )
				return "LiberationFonts/LiberationSans-Regular.ttf";
		};
		
		canvas.parsesvg(eicas, "Aircraft/747-400/Models/Cockpit/Instruments/EICAS/elec.svg", {'font-mapper': font_mapper});
		
		var svg_keys = ["barapu1","barapu2","barbt1","barbt2","barbt3","barbt4","barext1","barext2","bargc1","bargc2","bargc3","bargc4","bus1box","bus1text","bus2box","bus2text","bus3border","bus3box","bus3text","bus4box","bus4text","drive1","drive2","drive3","drive4","gc1","gc2","gc3","gc4","isln1","isln2","isln3","isln4","ssb","ssbbar","utility1lines","utility1text","utility2lines","utility2text","utility3lines","utility3text","utility4lines","utility4text"];
		foreach(var key; svg_keys) {
			m[key] = eicas.getElementById(key);
		}
		
		return m;
	},
	update: func()
	{		
		for (var i=0; i < 2; i = i+1) {
			j = i+1;
			me["barapu"~j].setBool("visible", getprop("/systems/electrical/eicas/flowbar.apu["~i~"]"));
			me["barext"~j].setBool("visible", getprop("/systems/electrical/eicas/flowbar.ext["~i~"]"));
		}

		for (var i=0; i < 4; i = i+1) {
			j = i+1;
			if (getprop("/systems/electrical/eicas/utility["~i~"]")) {
				#me["utility"~j~"text"].setColor(0,1,0);
				me["utility"~j~"lines"].setColor(0,1,0);
			} else {
				#me["utility"~j~"text"].setColor(1,0.706,0);
				me["utility"~j~"lines"].setColor(1,0.706,0);
			}
			if (getprop("/systems/electrical/ac-bus["~i~"]")) {
				me["bus"~j~"text"].setColor(0,1,0);
				me["bus"~j~"box"].setColor(0,1,0);
			} else {
				me["bus"~j~"text"].setColor(1,0.706,0);
				me["bus"~j~"box"].setColor(1,0.706,0);
			}
			me["barbt"~j].setBool("visible", getprop("/systems/electrical/eicas/flowbar.bt["~i~"]"));
			me["bargc"~j].setBool("visible", getprop("/systems/electrical/eicas/flowbar.gc["~i~"]"));
			me["drive"~j].setBool("visible", getprop("/systems/electrical/generator-drive["~i~"]"));
			me["gc"~j].setBool("visible", getprop("/systems/electrical/generator-off["~i~"]"));
			me["isln"~j].setBool("visible", getprop("/systems/electrical/bus-isolation["~i~"]"));
		}
		
		me["ssbbar"].setBool("visible",getprop("/systems/electrical/eicas/flowbar.ssb"));
		me["ssb"].setTranslation(0,-50*(1-(getprop("/systems/electrical/eicas/ssb") == "closed")));

		settimer(func me.update(), 0.5);
	}
};