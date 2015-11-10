# ==============================================================================
# Boeing 747-400 EICAS by Gijs de Rooy
# ==============================================================================

var canvas_doors = {
	new: func(canvas_group)
	{
		var m = { parents: [canvas_doors] };
		var eicas = canvas_group;
		var font_mapper = func(family, weight)
		{
			if( family == "Liberation Sans" and weight == "normal" )
				return "LiberationFonts/LiberationSans-Regular.ttf";
		};
		
		canvas.parsesvg(eicas, "Aircraft/747-400/Models/Cockpit/Instruments/EICAS/doors.svg", {'font-mapper': font_mapper});
		
		return m;
	},
	update: func()
	{
		
		settimer(func me.update(), 0);
	}
};