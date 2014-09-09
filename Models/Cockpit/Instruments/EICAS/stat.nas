# ==============================================================================
# Boeing 747-400 EICAS by Gijs de Rooy
# ==============================================================================

var stat_canvas = {};

var aileronPosLeftIn = {};
var aileronPosLeftOut = {};
var aileronPosRightIn = {};
var aileronPosRightOut = {};
var rudPosLow = {};
var rudPosUpp = {};
var elevPosLeft = {};
var elevPosRight = {};
var apun1 = {};
var apun2 = {};
var apuegt = {};
var hyd1pr = {};
var hyd2pr = {};
var hyd3pr = {};
var hyd4pr = {};
var apuBattVdc = {};
var mainBattVdc = {};

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
		
		aileronPosLeftIn = eicas.getElementById("aileronPosLeftIn");
		aileronPosLeftOut = eicas.getElementById("aileronPosLeftOut");
		aileronPosRightIn = eicas.getElementById("aileronPosRightIn");
		aileronPosRightOut = eicas.getElementById("aileronPosRightOut");
		rudPosLow = eicas.getElementById("rudPosLow");
		rudPosUpp = eicas.getElementById("rudPosUpp");
		elevPosLeft = eicas.getElementById("elevPosLeft");
		elevPosRight = eicas.getElementById("elevPosRight");
		apun1 = eicas.getElementById("apun1");
		apun2 = eicas.getElementById("apun2");
		apuegt = eicas.getElementById("apuegt");
		hyd1pr = eicas.getElementById("hyd1pr");
		hyd2pr = eicas.getElementById("hyd2pr");
		hyd3pr = eicas.getElementById("hyd3pr");
		hyd4pr = eicas.getElementById("hyd4pr");
		mainBattVdc = eicas.getElementById("mainBattVdc");
		apuBattVdc = eicas.getElementById("apuBattVdc");
		
		return m;
	},
	update: func()
	{
		aileronPosLeftOut.setTranslation(0,-115*getprop("fdm/jsbsim/fcs/left-outboard-aileron-pos-norm"));
		aileronPosLeftIn.setTranslation(0,-115*getprop("fdm/jsbsim/fcs/left-inboard-aileron-pos-norm"));
		aileronPosRightOut.setTranslation(0,-115*getprop("fdm/jsbsim/fcs/right-outboard-aileron-pos-norm"));
		aileronPosRightIn.setTranslation(0,-115*getprop("fdm/jsbsim/fcs/right-inboard-aileron-pos-norm"));
		rudPosLow.setTranslation(-222.5*getprop("fdm/jsbsim/fcs/rudder-pos-norm"),0);
		rudPosUpp.setTranslation(-222.5*getprop("fdm/jsbsim/fcs/rudder-pos-norm"),0);
		elevPosLeft.setTranslation(0,-115*getprop("fdm/jsbsim/fcs/outboard-elevator-pos-norm"));
		elevPosRight.setTranslation(0,-115*getprop("fdm/jsbsim/fcs/outboard-elevator-pos-norm"));
		apun1.setText(sprintf("%3.01f",getprop("engines/engine[4]/n1")));
		apun2.setText(sprintf("%2.01f",getprop("engines/engine[4]/n2")));
		apuegt.setText(sprintf("%3.0f",(getprop("engines/engine[4]/egt-degf")-32)/1.8));
		hyd1pr.setText(sprintf("%4.0f",getprop("systems/hydraulic/pressure")));
		hyd2pr.setText(sprintf("%4.0f",getprop("systems/hydraulic/pressure[1]")));
		hyd3pr.setText(sprintf("%4.0f",getprop("systems/hydraulic/pressure[2]")));
		hyd4pr.setText(sprintf("%4.0f",getprop("systems/hydraulic/pressure[3]")));
		mainBattVdc.setText(sprintf("%2.0f",getprop("systems/electrical/suppliers/battery")));
		apuBattVdc.setText(sprintf("%2.0f",getprop("systems/electrical/suppliers/apu-battery")));
		
		settimer(func me.update(), 0.05);
	}
};