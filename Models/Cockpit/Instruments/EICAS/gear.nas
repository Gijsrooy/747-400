# ==============================================================================
# Boeing 747-400 EICAS by Gijs de Rooy
# ==============================================================================

var canvas_gear = {
	new: func(canvas_group)
	{
		var m = { parents: [canvas_gear] };
		var eicas = canvas_group;
		var font_mapper = func(family, weight)
		{
			if( family == "Liberation Sans" and weight == "normal" )
				return "LiberationFonts/LiberationSans-Regular.ttf";
		};
		
		canvas.parsesvg(eicas, "Aircraft/747-400/Models/Cockpit/Instruments/EICAS/gear.svg", {'font-mapper': font_mapper});
		
		var svg_keys = ["gear1btms1","gear1btms2","gear1btms3","gear1btms4","gear2btms1","gear2btms2","gear2btms3","gear2btms4","gear3btms1","gear3btms2","gear3btms3","gear3btms4","gear4btms1","gear4btms2","gear4btms3","gear4btms4","gear0closed","gear1closed","gear2closed","gear3closed","gear4closed"];
		foreach(var key; svg_keys) {
			m[key] = eicas.getElementById(key);
		}
		
		return m;
	},
	update: func()
	{
		for (var i=1; i <= 4; i = i+1) {
			var btms = getprop("gear/gear["~i~"]/btms");
			if (btms >= 5) {
				me["gear"~i~"btms1"].setColor(1,0.5,0);
				me["gear"~i~"btms2"].setColor(1,0.5,0);
				me["gear"~i~"btms3"].setColor(1,0.5,0);
				me["gear"~i~"btms4"].setColor(1,0.5,0);
			} else {
				me["gear"~i~"btms1"].setColor(1,1,1);
				me["gear"~i~"btms2"].setColor(1,1,1);
				me["gear"~i~"btms3"].setColor(1,1,1);
				me["gear"~i~"btms4"].setColor(1,1,1);
			}
			me["gear"~i~"btms1"].setText(sprintf("%1.0f",btms));
			me["gear"~i~"btms2"].setText(sprintf("%1.0f",btms));
			me["gear"~i~"btms3"].setText(sprintf("%1.0f",btms));
			me["gear"~i~"btms4"].setText(sprintf("%1.0f",btms));
		}
		for (var i=0; i <= 4; i = i+1)
			me["gear"~i~"closed"].setVisible(getprop("gear/gear["~i~"]/position-norm") == 0);
		
		settimer(func me.update(), 1);
	}
};