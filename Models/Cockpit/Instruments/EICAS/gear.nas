# ==============================================================================
# Boeing 747-400 EICAS by Gijs de Rooy
# ==============================================================================

var gear_canvas = {};

var gear1btms1 = {};
var gear1btms2 = {};
var gear1btms3 = {};
var gear1btms4 = {};
var gear2btms1 = {};
var gear2btms2 = {};
var gear2btms3 = {};
var gear2btms4 = {};
var gear3btms1 = {};
var gear3btms2 = {};
var gear3btms3 = {};
var gear3btms4 = {};
var gear4btms1 = {};
var gear4btms2 = {};
var gear4btms3 = {};
var gear4btms4 = {};
var gear0closed = {};
var gear1closed = {};
var gear2closed = {};
var gear3closed = {};
var gear4closed = {};

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
		
		gear1btms1 = eicas.getElementById("gear1btms1");
		gear1btms2 = eicas.getElementById("gear1btms2");
		gear1btms3 = eicas.getElementById("gear1btms3");
		gear1btms4 = eicas.getElementById("gear1btms4");
		gear2btms1 = eicas.getElementById("gear2btms1");
		gear2btms2 = eicas.getElementById("gear2btms2");
		gear2btms3 = eicas.getElementById("gear2btms3");
		gear2btms4 = eicas.getElementById("gear2btms4");
		gear3btms1 = eicas.getElementById("gear3btms1");
		gear3btms2 = eicas.getElementById("gear3btms2");
		gear3btms3 = eicas.getElementById("gear3btms3");
		gear3btms4 = eicas.getElementById("gear3btms4");
		gear4btms1 = eicas.getElementById("gear4btms1");
		gear4btms2 = eicas.getElementById("gear4btms2");
		gear4btms3 = eicas.getElementById("gear4btms3");
		gear4btms4 = eicas.getElementById("gear4btms4");
		gear0closed = eicas.getElementById("gear0closed");
		gear1closed = eicas.getElementById("gear1closed");
		gear2closed = eicas.getElementById("gear2closed");
		gear3closed = eicas.getElementById("gear3closed");
		gear4closed = eicas.getElementById("gear4closed");
		
		return m;
	},
	update: func()
	{
		if (getprop("gear/gear[1]/btms") >= 5) {
			gear1btms1.setColor(1,0.5,0);
			gear1btms2.setColor(1,0.5,0);
			gear1btms3.setColor(1,0.5,0);
			gear1btms4.setColor(1,0.5,0);
		} else {
			gear1btms1.setColor(1,1,1);
			gear1btms2.setColor(1,1,1);
			gear1btms3.setColor(1,1,1);
			gear1btms4.setColor(1,1,1);
		}
		gear1btms1.setText(sprintf("%1.0f",getprop("gear/gear[1]/btms")));
		gear1btms2.setText(sprintf("%1.0f",getprop("gear/gear[1]/btms")));
		gear1btms3.setText(sprintf("%1.0f",getprop("gear/gear[1]/btms")));
		gear1btms4.setText(sprintf("%1.0f",getprop("gear/gear[1]/btms")));
		if (getprop("gear/gear[2]/btms") >= 5) {
			gear2btms1.setColor(1,0.5,0);
			gear2btms2.setColor(1,0.5,0);
			gear2btms3.setColor(1,0.5,0);
			gear2btms4.setColor(1,0.5,0);
		} else {
			gear2btms1.setColor(1,1,1);
			gear2btms2.setColor(1,1,1);
			gear2btms3.setColor(1,1,1);
			gear2btms4.setColor(1,1,1);
		}
		gear2btms1.setText(sprintf("%1.0f",getprop("gear/gear[2]/btms")));
		gear2btms2.setText(sprintf("%1.0f",getprop("gear/gear[2]/btms")));
		gear2btms3.setText(sprintf("%1.0f",getprop("gear/gear[2]/btms")));
		gear2btms4.setText(sprintf("%1.0f",getprop("gear/gear[2]/btms")));
		if (getprop("gear/gear[3]/btms") >= 5) {
			gear3btms1.setColor(1,0.5,0);
			gear3btms2.setColor(1,0.5,0);
			gear3btms3.setColor(1,0.5,0);
			gear3btms4.setColor(1,0.5,0);
		} else {
			gear3btms1.setColor(1,1,1);
			gear3btms2.setColor(1,1,1);
			gear3btms3.setColor(1,1,1);
			gear3btms4.setColor(1,1,1);
		}
		gear3btms1.setText(sprintf("%1.0f",getprop("gear/gear[3]/btms")));
		gear3btms2.setText(sprintf("%1.0f",getprop("gear/gear[3]/btms")));
		gear3btms3.setText(sprintf("%1.0f",getprop("gear/gear[3]/btms")));
		gear3btms4.setText(sprintf("%1.0f",getprop("gear/gear[3]/btms")));
		if (getprop("gear/gear[4]/btms") >= 5) {
			gear4btms1.setColor(1,0.5,0);
			gear4btms2.setColor(1,0.5,0);
			gear4btms3.setColor(1,0.5,0);
			gear4btms4.setColor(1,0.5,0);
		} else {
			gear4btms1.setColor(1,1,1);
			gear4btms2.setColor(1,1,1);
			gear4btms3.setColor(1,1,1);
			gear4btms4.setColor(1,1,1);
		}
		gear4btms1.setText(sprintf("%1.0f",getprop("gear/gear[4]/btms")));
		gear4btms2.setText(sprintf("%1.0f",getprop("gear/gear[4]/btms")));
		gear4btms3.setText(sprintf("%1.0f",getprop("gear/gear[4]/btms")));
		gear4btms4.setText(sprintf("%1.0f",getprop("gear/gear[4]/btms")));
		
		if(getprop("gear/gear/position-norm") == 0)
			gear0closed.show();
		else 
			gear0closed.hide();
		if(getprop("gear/gear[1]/position-norm") == 0)
			gear1closed.show();
		else 
			gear1closed.hide();
		if(getprop("gear/gear[2]/position-norm") == 0)
			gear2closed.show();
		else 
			gear2closed.hide();
		if(getprop("gear/gear[3]/position-norm") == 0)
			gear3closed.show();
		else 
			gear3closed.hide();
		if(getprop("gear/gear[4]/position-norm") == 0)
			gear4closed.show();
		else 
			gear4closed.hide();
		
		settimer(func me.update(), 0);
	}
};