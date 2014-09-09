# ==============================================================================
# Boeing 747-400 EICAS by Gijs de Rooy
# ==============================================================================

var elec_canvas = {};
var bus3 = {};
var bus1text = {};
var bus2text = {};
var bus3text = {};
var bus4text = {};
var bus1box = {};
var bus2box = {};
var bus3box = {};
var bus4box = {};
var barapu1 = {};
var barapu2 = {};
var barext1 = {};
var barext2 = {};
var barbt1 = {};
var barbt2 = {};
var barbt3 = {};
var barbt4 = {};
var bargc1 = {};
var bargc2 = {};
var bargc3 = {};
var bargc4 = {};
var boxgc1 = {};
var boxgc2 = {};
var boxgc3 = {};
var boxgc4 = {};
var drive1text = {};
var drive2text = {};
var drive3text = {};
var drive4text = {};
var gc1lines = {};
var gc1text = {};
var gc2text = {};
var gc3text = {};
var gc4text = {};
var isln1text = {};
var isln2text = {};
var isln3text = {};
var isln4text = {};
var utility1text = {};
var utility1lines = {};
var utility2text = {};
var utility2lines = {};
var utility3text = {};
var utility3lines = {};
var utility4text = {};
var utility4lines = {};
var ssb = {};
var dialog = {};

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
		
		bus3 = eicas.getElementById("bus3border");
		bus1text = eicas.getElementById("bus1text");
		bus2text = eicas.getElementById("bus2text");
		bus3text = eicas.getElementById("bus3text");
		bus4text = eicas.getElementById("bus4text");
		bus1box = eicas.getElementById("bus1box");
		bus2box = eicas.getElementById("bus2box");
		bus3box = eicas.getElementById("bus3box");
		bus4box = eicas.getElementById("bus4box");
		barapu1 = eicas.getElementById("barapu1");
		barapu2 = eicas.getElementById("barapu2");
		barext1 = eicas.getElementById("barext1");
		barext2 = eicas.getElementById("barext2");
		barbt1 = eicas.getElementById("barbt1");
		barbt2 = eicas.getElementById("barbt2");
		barbt3 = eicas.getElementById("barbt3");
		barbt4 = eicas.getElementById("barbt4");
		bargc1 = eicas.getElementById("bargc1");
		bargc2 = eicas.getElementById("bargc2");
		bargc3 = eicas.getElementById("bargc3");
		bargc4 = eicas.getElementById("bargc4");
		boxgc1 = eicas.getElementById("boxgc1");
		boxgc2 = eicas.getElementById("boxgc2");
		boxgc3 = eicas.getElementById("boxgc3");
		boxgc4 = eicas.getElementById("boxgc4");
		drive1text = eicas.getElementById("drive1text");
		drive2text = eicas.getElementById("drive2text");
		drive3text = eicas.getElementById("drive3text");
		drive4text = eicas.getElementById("drive4text");
		gc1lines = eicas.getElementById("gc1lines");
		gc1text = eicas.getElementById("gc1text");
		gc2text = eicas.getElementById("gc2text");
		gc3text = eicas.getElementById("gc3text");
		gc4text = eicas.getElementById("gc4text");
		isln1text = eicas.getElementById("isln1text");
		isln2text = eicas.getElementById("isln2text");
		isln3text = eicas.getElementById("isln3text");
		isln4text = eicas.getElementById("isln4text");
		utility1text = eicas.getElementById("utility1text");
		utility1lines = eicas.getElementById("utility1lines");
		utility2text = eicas.getElementById("utility2text");
		utility2lines = eicas.getElementById("utility2lines");
		utility3text = eicas.getElementById("utility3text");
		utility3lines = eicas.getElementById("utility3lines");
		utility4text = eicas.getElementById("utility4text");
		utility4lines = eicas.getElementById("utility4lines");
		ssb = eicas.getElementById("ssb");
		
		return m;
	},
	update: func()
	{
		if (getprop("/systems/electrical/eicas/ssb") == "closed") {
			ssb.show();
		} else {
			ssb.hide();
		}
		barapu1.setBool("visible", getprop("/systems/electrical/eicas/flowbar.apu[0]"));
		barapu2.setBool("visible", getprop("/systems/electrical/eicas/flowbar.apu[1]"));
		barext1.setBool("visible", getprop("/systems/electrical/eicas/flowbar.ext[0]"));
		barext2.setBool("visible", getprop("/systems/electrical/eicas/flowbar.ext[1]"));
		barbt1.setBool("visible", getprop("/systems/electrical/eicas/flowbar.bt[0]"));
		barbt2.setBool("visible", getprop("/systems/electrical/eicas/flowbar.bt[1]"));
		barbt3.setBool("visible", getprop("/systems/electrical/eicas/flowbar.bt[2]"));
		barbt4.setBool("visible", getprop("/systems/electrical/eicas/flowbar.bt[3]"));
		bargc1.setBool("visible", getprop("/systems/electrical/eicas/flowbar.gc[0]"));
		bargc2.setBool("visible", getprop("/systems/electrical/eicas/flowbar.gc[1]"));
		bargc3.setBool("visible", getprop("/systems/electrical/eicas/flowbar.gc[2]"));
		bargc4.setBool("visible", getprop("/systems/electrical/eicas/flowbar.gc[3]"));
		drive1text.setBool("visible", getprop("/systems/electrical/generator-drive[0]"));
		drive2text.setBool("visible", getprop("/systems/electrical/generator-drive[1]"));
		drive3text.setBool("visible", getprop("/systems/electrical/generator-drive[2]"));
		drive4text.setBool("visible", getprop("/systems/electrical/generator-drive[3]"));
		gc1lines.setBool("visible", !getprop("/systems/electrical/generator-off[0]"));
		gc1text.setBool("visible", getprop("/systems/electrical/generator-off[0]"));
		gc2text.setBool("visible", getprop("/systems/electrical/generator-off[1]"));
		gc3text.setBool("visible", getprop("/systems/electrical/generator-off[2]"));
		gc4text.setBool("visible", getprop("/systems/electrical/generator-off[3]"));
		isln1text.setBool("visible", getprop("/systems/electrical/bus-isolation[0]"));
		isln2text.setBool("visible", getprop("/systems/electrical/bus-isolation[1]"));
		isln3text.setBool("visible", getprop("/systems/electrical/bus-isolation[2]"));
		isln4text.setBool("visible", getprop("/systems/electrical/bus-isolation[3]"));

		if (getprop("/systems/electrical/eicas/utility[0]")) {
			utility1text.setColorFill(0,1,0);
			utility1lines.setColor(0,1,0);
		} else {
			utility1text.setColorFill(1,0.706,0);
			utility1lines.setColor(1,0.706,0);
		}
		if (getprop("/systems/electrical/eicas/utility[1]")) {
			utility2text.setColorFill(0,1,0);
			utility2lines.setColor(0,1,0);
		} else {
			utility2text.setColorFill(1,0.706,0);
			utility2lines.setColor(1,0.706,0);
		}
		if (getprop("/systems/electrical/eicas/utility[2]")) {
			utility3text.setColorFill(0,1,0);
			utility3lines.setColor(0,1,0);
		} else {
			utility3text.setColorFill(1,0.706,0);
			utility3lines.setColor(1,0.706,0);
		}
		if (getprop("/systems/electrical/eicas/utility[3]")) {
			utility4text.setColorFill(0,1,0);
			utility4lines.setColor(0,1,0);
		} else {
			utility4text.setColorFill(1,0.706,0);
			utility4lines.setColor(1,0.706,0);
		}
		if (getprop("/systems/electrical/ac-bus[0]")) {
			bus1text.setColor(0,1,0);
			bus1box.setColor(0,1,0);
		} else {
			bus1text.setColor(1,0.706,0);
			bus1box.setColor(1,0.706,0);
		}
		if (getprop("/systems/electrical/ac-bus[1]")) {
			bus2text.setColor(0,1,0);
			bus2box.setColor(0,1,0);
		} else {
			bus2text.setColor(1,0.706,0);
			bus2box.setColor(1,0.706,0);
		}
		if (getprop("/systems/electrical/ac-bus[2]")) {
			bus3text.setColor(0,1,0);
			bus3box.setColor(0,1,0);
		} else {
			bus3text.setColor(1,0.706,0);
			bus3box.setColor(1,0.706,0);
		}
		if (getprop("/systems/electrical/ac-bus[3]")) {
			bus4text.setColor(0,1,0);
			bus4box.setColor(0,1,0);
		} else {
			bus4text.setColor(1,0.706,0);
			bus4box.setColor(1,0.706,0);
		}
		if (getprop("/systems/electrical/eicas/flowbar.gc[0]")) {
			boxgc1.setColor(1,1,1);
		} else {
			boxgc1.setColor(1,0.706,0);
		}
		if (getprop("/systems/electrical/eicas/flowbar.gc[1]")) {
			boxgc2.setColor(1,1,1);
		} else {
			boxgc2.setColor(1,0.706,0);
		}
		if (getprop("/systems/electrical/eicas/flowbar.gc[2]")) {
			boxgc3.setColor(1,1,1);
		} else {
			boxgc3.setColor(1,0.706,0);
		}
		if (getprop("/systems/electrical/eicas/flowbar.gc[3]")) {
			boxgc4.setColor(1,1,1);
		} else {
			boxgc4.setColor(1,0.706,0);
		}

		settimer(func me.update(), 0);
	}
};