# ==============================================================================
# Boeing 747-400 EICAS by Gijs de Rooy
# ==============================================================================

var fuel_canvas = {};
var text3840 = {};
var stab = {};
var main1 = {};
var main2 = {};
var main3 = {};
var main4 = {};
var res2 = {};
var res3 = {};
var center = {};
var main1aft = {};
var main1fwd = {};
var main2aft = {};
var main2fwd = {};
var main3aft = {};
var main3fwd = {};
var main4aft = {};
var main4fwd = {};
var ovrd2aft = {};
var ovrd2fwd = {};
var ovrd3aft = {};
var ovrd3fwd = {};
var stabpumpl = {};
var stabpumpr = {};
var res2arrow = {};
var res3arrow = {};
var bar0pump1 = {};
var bar0pump2 = {};
var bareng1 = {};
var bareng2 = {};
var bareng3 = {};
var bareng4 = {};
var bar1pump = {};
var bar2pump = {};
var bar3pump = {};
var bar4pump = {};
var barxfeed1 = {};
var barxfeed2 = {};
var barxfeed3 = {};
var barxfeed4 = {};
var stabarrow = {};
var stabpumplines = {};
var stabline = {};
var xfeed1 = {};
var xfeed2 = {};
var xfeed3 = {};
var xfeed4 = {};
var jettisonLines = {};
var jettison = {};
var jettisonTime = {};
var jettisonTimeCount = {};
var canvas_group = {};

var canvas_fuel = {
	new: func(canvas_group)
	{
		var m = { parents: [canvas_fuel] };
		var eicas = canvas_group;
		var font_mapper = func(family, weight)
		{
			if( family == "Liberation Sans" and weight == "normal" )
				return "LiberationFonts/LiberationSans-Regular.ttf";
		};
		
		canvas.parsesvg(eicas, "Aircraft/747-400/Models/Cockpit/Instruments/EICAS/fuel.svg", {'font-mapper': font_mapper});
		
		text3840 = eicas.getElementById("text3840");
		stab = eicas.getElementById("stab");
		main1 = eicas.getElementById("main1");
		main2 = eicas.getElementById("main2");
		main3 = eicas.getElementById("main3");
		main4 = eicas.getElementById("main4");
		res2 = eicas.getElementById("res2");
		res3 = eicas.getElementById("res3");
		center = eicas.getElementById("center");
		main1aft = eicas.getElementById("main1aft");
		main1fwd = eicas.getElementById("main1fwd");
		main2aft = eicas.getElementById("main2aft");
		main2fwd = eicas.getElementById("main2fwd");
		main3aft = eicas.getElementById("main3aft");
		main3fwd = eicas.getElementById("main3fwd");
		main4aft = eicas.getElementById("main4aft");
		main4fwd = eicas.getElementById("main4fwd");
		ovrd2aft = eicas.getElementById("ovrd2aft");
		ovrd2fwd = eicas.getElementById("ovrd2fwd");
		ovrd3aft = eicas.getElementById("ovrd3aft");
		ovrd3fwd = eicas.getElementById("ovrd3fwd");
		stabpumpl = eicas.getElementById("stabpumpl");
		stabpumpr = eicas.getElementById("stabpumpr");
		res2arrow = eicas.getElementById("res2arrow");
		res3arrow = eicas.getElementById("res3arrow");
		bar0pump1 = eicas.getElementById("bar0pump1");
		bar0pump2 = eicas.getElementById("bar0pump2");
		bareng1 = eicas.getElementById("bareng1");
		bareng2 = eicas.getElementById("bareng2");
		bareng3 = eicas.getElementById("bareng3");
		bareng4 = eicas.getElementById("bareng4");
		bar1pump = eicas.getElementById("bar1pump");
		bar2pump = eicas.getElementById("bar2pump");
		bar3pump = eicas.getElementById("bar3pump");
		bar4pump = eicas.getElementById("bar4pump");
		barxfeed1 = eicas.getElementById("barxfeed1");
		barxfeed2 = eicas.getElementById("barxfeed2");
		barxfeed3 = eicas.getElementById("barxfeed3");
		barxfeed4 = eicas.getElementById("barxfeed4");
		stabarrow = eicas.getElementById("stabarrow");
		stabpumplines = eicas.getElementById("stabpumplines");
		stabline = eicas.getElementById("stabline");
		xfeed1 = eicas.getElementById("xfeed1").updateCenter();
		xfeed2 = eicas.getElementById("xfeed2").updateCenter();
		xfeed3 = eicas.getElementById("xfeed3").updateCenter();
		xfeed4 = eicas.getElementById("xfeed4").updateCenter();
		jettisonLines = eicas.getElementById("jettisonLines");
		jettison = eicas.getElementById("jettison");
		jettisonTime = eicas.getElementById("jettisonTime");
		jettisonTimeCount = eicas.getElementById("jettisonTimeCount");
		
		return m;
	},
	update: func()
	{
		if (getprop("/controls/fuel/tank[1]/pump-aft") and getprop("/consumables/fuel/tank[1]/level-lbs") < 10 ) {
			main1aft.setColor(1,0.5,0);
		} elsif (getprop("/controls/fuel/tank[1]/pump-aft")) {
			main1aft.setColor(0,1,0);
		} else {
			main1aft.setColor(1,1,1);
		}
		if (getprop("/controls/fuel/tank[1]/pump-fwd") and getprop("/consumables/fuel/tank[1]/level-lbs") < 10 ) {
			main1fwd.setColor(1,0.5,0);
		} elsif (getprop("/controls/fuel/tank[1]/pump-fwd")) {
			main1fwd.setColor(0,1,0);
		} else {
			main1fwd.setColor(1,1,1);
		}
		if (getprop("/controls/fuel/tank[2]/pump-aft") and getprop("/consumables/fuel/tank[2]/level-lbs") < 10 ) {
			main2aft.setColor(1,0.5,0);
		} elsif (getprop("/controls/fuel/tank[2]/pump-aft")) {
			main2aft.setColor(0,1,0);
		} else {
			main2aft.setColor(1,1,1);
		}
		if (getprop("/controls/fuel/tank[2]/pump-fwd") and getprop("/consumables/fuel/tank[2]/level-lbs") < 10 ) {
			main2fwd.setColor(1,0.5,0);
		} elsif (getprop("/controls/fuel/tank[2]/pump-fwd")) {
			main2fwd.setColor(0,1,0);
		} else {
			main2fwd.setColor(1,1,1);
		}
		if (getprop("/controls/fuel/tank[3]/pump-aft") and getprop("/consumables/fuel/tank[3]/level-lbs") < 10 ) {
			main3aft.setColor(1,0.5,0);
		} elsif (getprop("/controls/fuel/tank[3]/pump-aft")) {
			main3aft.setColor(0,1,0);
		} else {
			main3aft.setColor(1,1,1);
		}
		if (getprop("/controls/fuel/tank[3]/pump-fwd") and getprop("/consumables/fuel/tank[3]/level-lbs") < 10 ) {
			main3fwd.setColor(1,0.5,0);
		} elsif (getprop("/controls/fuel/tank[3]/pump-fwd")) {
			main3fwd.setColor(0,1,0);
		} else {
			main3fwd.setColor(1,1,1);
		}
		if (getprop("/controls/fuel/tank[4]/pump-aft") and getprop("/consumables/fuel/tank[4]/level-lbs") < 10 ) {
			main4aft.setColor(1,0.5,0);
		} elsif (getprop("/controls/fuel/tank[4]/pump-aft")) {
			main4aft.setColor(0,1,0);
		} else {
			main4aft.setColor(1,1,1);
		}
		if (getprop("/controls/fuel/tank[4]/pump-fwd") and getprop("/consumables/fuel/tank[4]/level-lbs") < 10 ) {
			main4fwd.setColor(1,0.5,0);
		} elsif (getprop("/controls/fuel/tank[4]/pump-fwd")) {
			main4fwd.setColor(0,1,0);
		} else {
			main4fwd.setColor(1,1,1);
		}
		
		if (getprop("/controls/fuel/tank[2]/ovrd-aft") and getprop("/consumables/fuel/tank[2]/level-lbs") < 10 ) {
			ovrd2aft.setColor(1,0,0.5);
		} elsif (getprop("/controls/fuel/tank[2]/ovrd-aft")) {
			ovrd2aft.setColor(0,1,1);
		} else {
			ovrd2aft.setColor(1,1,1);
		}
		if (getprop("/controls/fuel/tank[2]/ovrd-fwd") and getprop("/consumables/fuel/tank[2]/level-lbs") < 10 ) {
			ovrd2fwd.setColor(1,0,0.5);
		} elsif (getprop("/controls/fuel/tank[2]/ovrd-fwd")) {
			ovrd2fwd.setColor(0,1,1);
		} else {
			ovrd2fwd.setColor(1,1,1);
		}
		if (getprop("/controls/fuel/tank[3]/ovrd-aft") and getprop("/consumables/fuel/tank[3]/level-lbs") < 10 ) {
			ovrd3aft.setColor(1,0,0.5);
		} elsif (getprop("/controls/fuel/tank[3]/ovrd-aft")) {
			ovrd3aft.setColor(0,1,1);
		} else {
			ovrd3aft.setColor(1,1,1);
		}
		if (getprop("/controls/fuel/tank[3]/ovrd-fwd") and getprop("/consumables/fuel/tank[3]/level-lbs") < 10 ) {
			ovrd3fwd.setColor(1,0,0.5);
		} elsif (getprop("/controls/fuel/tank[3]/ovrd-fwd")) {
			ovrd3fwd.setColor(0,1,1);
		} else {
			ovrd3fwd.setColor(1,1,1);
		}
		
		
		if (getprop("/controls/fuel/tank[7]/pump") and getprop("/consumables/fuel/tank[7]/level-lbs") < 10 ) {
			stabpumpl.setColor(1,0.5,0);
			stabpumpr.setColor(1,0.5,0);
			stabpumplines.setColor(1,0.5,0);
		} elsif (getprop("/controls/fuel/tank[7]/pump") and getprop("/fdm/jsbsim/propulsion/tank[7]/external-flow-rate-pps") != 0) {
			stabpumpl.setColor(0,1,0);
			stabpumpr.setColor(0,1,0);
			stabpumplines.setColor(0,1,0);
		} elsif (getprop("/controls/fuel/tank[7]/pump")) {
			stabpumpl.setColor(0,1,1);
			stabpumpr.setColor(0,1,1);
		} else {
			stabpumpl.setColor(1,1,1);
			stabpumpr.setColor(1,1,1);
		}
		
		bar0pump1.setBool("visible", getprop("/fdm/jsbsim/propulsion/tank[0]/external-flow-rate-pps"));
		bar0pump2.setBool("visible", getprop("/fdm/jsbsim/propulsion/tank[0]/external-flow-rate-pps"));
		res2arrow.setBool("visible", getprop("/fdm/jsbsim/propulsion/tank[5]/external-flow-rate-pps"));
		res3arrow.setBool("visible", getprop("/fdm/jsbsim/propulsion/tank[6]/external-flow-rate-pps"));
		stabarrow.setBool("visible", getprop("/fdm/jsbsim/propulsion/tank[7]/external-flow-rate/tank[0]"));
		if (getprop("/fdm/jsbsim/propulsion/jettison-flow-rates") != 0) 
			stabline.hide();
		else 
			stabline.show();

		bareng1.setBool("visible", getprop("/fdm/jsbsim/propulsion/engine[0]/fuel-flow-rate-pps"));
		bareng2.setBool("visible", getprop("/fdm/jsbsim/propulsion/engine[1]/fuel-flow-rate-pps"));
		bareng3.setBool("visible", getprop("/fdm/jsbsim/propulsion/engine[2]/fuel-flow-rate-pps"));
		bareng4.setBool("visible", getprop("/fdm/jsbsim/propulsion/engine[3]/fuel-flow-rate-pps"));
		barxfeed1.setBool("visible", getprop("/controls/fuel/tank[1]/x-feed"));
		barxfeed2.setBool("visible", getprop("/controls/fuel/tank[2]/x-feed"));
		barxfeed3.setBool("visible", getprop("/controls/fuel/tank[3]/x-feed"));
		barxfeed4.setBool("visible", getprop("/controls/fuel/tank[4]/x-feed"));
		xfeed1.setRotation(0.5 * math.pi * getprop("/controls/fuel/tank[1]/x-feed"));
		xfeed2.setRotation(0.5 * math.pi * getprop("/controls/fuel/tank[2]/x-feed"));
		xfeed3.setRotation(0.5 * math.pi * getprop("/controls/fuel/tank[3]/x-feed"));
		xfeed4.setRotation(0.5 * math.pi * getprop("/controls/fuel/tank[4]/x-feed"));
		if (getprop("/fdm/jsbsim/propulsion/jettison-flow-rates") > 0) {
			jettisonLines.show();
			jettison.show();
			ovrd2aft.setColor(1,0,1);
			ovrd2fwd.setColor(1,0,1);
			ovrd3aft.setColor(1,0,1);
			ovrd3fwd.setColor(1,0,1);
			stabpumpl.setColor(1,0,1);
			stabpumpr.setColor(1,0,1);
			stabpumplines.setColor(1,0,1);
			jettisonTime.show();
			jettisonTimeCount.show();
			jettisonTimeCount.setText(sprintf("%2.0f",getprop("/fdm/jsbsim/propulsion/fuel-dump-time-sec")/60));
		} else {
			jettisonLines.hide();
			jettison.hide();
			jettisonTime.hide();
			jettisonTimeCount.hide();
		}
		
		if (getprop("/fdm/jsbsim/propulsion/tank[1]/external-flow-rate-pps") or (getprop("/fdm/jsbsim/propulsion/engine[0]/fuel-flow-rate-pps") > 0 and (getprop("/controls/fuel/tank[1]/pump-aft") or getprop("/controls/fuel/tank[1]/pump-fwd")))) {
			bar1pump.show();
		} else {
			bar1pump.hide();
		}
		if (getprop("/fdm/jsbsim/propulsion/tank[2]/external-flow-rate-pps") or (getprop("/fdm/jsbsim/propulsion/engine[1]/fuel-flow-rate-pps") > 0 and (getprop("/controls/fuel/tank[2]/pump-aft") or getprop("/controls/fuel/tank[2]/pump-fwd")))) {
			bar2pump.show();
		} else {
			bar2pump.hide();
		}
		if (getprop("/fdm/jsbsim/propulsion/tank[3]/external-flow-rate-pps") or (getprop("/fdm/jsbsim/propulsion/engine[2]/fuel-flow-rate-pps") > 0 and (getprop("/controls/fuel/tank[3]/pump-aft") or getprop("/controls/fuel/tank[3]/pump-fwd")))) {
			bar3pump.show();
		} else {
			bar3pump.hide();
		}
		if (getprop("/fdm/jsbsim/propulsion/tank[4]/external-flow-rate-pps") or (getprop("/fdm/jsbsim/propulsion/engine[3]/fuel-flow-rate-pps") > 0 and (getprop("/controls/fuel/tank[4]/pump-aft") or getprop("/controls/fuel/tank[4]/pump-fwd")))) {
			bar4pump.show();
		} else {
			bar4pump.hide();
		}
		
		if (getprop("/consumables/fuel/tank[1]/level-lbs") < 2000 or (math.abs((getprop("/consumables/fuel/tank[1]/level-lbs")-getprop("/consumables/fuel/tank[4]/level-lbs"))) > 3000)) {
			main1.setColor(0,1,1);
		} else {
			main1.setColor(1,1,1);
		}
		if (getprop("/consumables/fuel/tank[2]/level-lbs") < 2000 or (math.abs((getprop("/consumables/fuel/tank[2]/level-lbs")-getprop("/consumables/fuel/tank[3]/level-lbs"))) > 6000)) {
			main2.setColor(0,1,1);
		} else {
			main2.setColor(1,1,1);
		}
		if (getprop("/consumables/fuel/tank[3]/level-lbs") < 2000 or (math.abs((getprop("/consumables/fuel/tank[2]/level-lbs")-getprop("/consumables/fuel/tank[3]/level-lbs"))) > 6000)) {
			main3.setColor(0,1,1);
		} else {
			main3.setColor(1,1,1);
		}
		if (getprop("/consumables/fuel/tank[4]/level-lbs") < 2000 or (math.abs((getprop("/consumables/fuel/tank[1]/level-lbs")-getprop("/consumables/fuel/tank[4]/level-lbs"))) > 3000)) {
			main4.setColor(0,1,1);
		} else {
			main4.setColor(1,1,1);
		}
		
		text3840.setText(sprintf("%3.01f",getprop("/fdm/jsbsim/propulsion/total-fuel-lbs")*LB2KG/1000));
		center.setText(sprintf("%3.01f",getprop("/consumables/fuel/tank[0]/level-lbs")*LB2KG/1000));
		main1.setText(sprintf("%3.01f",getprop("/consumables/fuel/tank[1]/level-lbs")*LB2KG/1000));
		main2.setText(sprintf("%3.01f",getprop("/consumables/fuel/tank[2]/level-lbs")*LB2KG/1000));
		main3.setText(sprintf("%3.01f",getprop("/consumables/fuel/tank[3]/level-lbs")*LB2KG/1000));
		main4.setText(sprintf("%3.01f",getprop("/consumables/fuel/tank[4]/level-lbs")*LB2KG/1000));
		res2.setText(sprintf("%3.01f",getprop("/consumables/fuel/tank[5]/level-lbs")*LB2KG/1000));
		res3.setText(sprintf("%3.01f",getprop("/consumables/fuel/tank[6]/level-lbs")*LB2KG/1000));
		stab.setText(sprintf("%3.01f",getprop("/consumables/fuel/tank[7]/level-lbs")*LB2KG/1000));

		settimer(func me.update(), 0);
	}
};