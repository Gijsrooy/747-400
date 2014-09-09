# ==============================================================================
# Boeing 747-400 EICAS by Gijs de Rooy
# ==============================================================================

var eng_canvas = {};

var eng1ff = {};
var eng2ff = {};
var eng3ff = {};
var eng4ff = {};
var eng1n2 = {};
var eng2n2 = {};
var eng3n2 = {};
var eng4n2 = {};
var eng1oilp = {};
var eng2oilp = {};
var eng3oilp = {};
var eng4oilp = {};
var eng1n2bar = {};
var eng2n2bar = {};
var eng3n2bar = {};
var eng4n2bar = {};
var eng1n2bar_scale = {};
var eng2n2bar_scale = {};
var eng3n2bar_scale = {};
var eng4n2bar_scale = {};

var canvas_eng = {
	new: func(canvas_group)
	{
		var m = { parents: [canvas_eng] };
		
		var eicasE = canvas_group;
		
		var font_mapper = func(family, weight)
		{
			if( family == "Liberation Sans" and weight == "normal" )
				return "LiberationFonts/LiberationSans-Regular.ttf";
		};
		
		canvas.parsesvg(eicasE, "Aircraft/747-400/Models/Cockpit/Instruments/EICAS/eng.svg", {'font-mapper': font_mapper});
		
		eng1ff = eicasE.getElementById("eng1ff");
		eng2ff = eicasE.getElementById("eng2ff");
		eng3ff = eicasE.getElementById("eng3ff");
		eng4ff = eicasE.getElementById("eng4ff");
		eng1n2 = eicasE.getElementById("eng1n2");
		eng2n2 = eicasE.getElementById("eng2n2");
		eng3n2 = eicasE.getElementById("eng3n2");
		eng4n2 = eicasE.getElementById("eng4n2");
		eng1oilp = eicasE.getElementById("eng1oilp");
		eng2oilp = eicasE.getElementById("eng2oilp");
		eng3oilp = eicasE.getElementById("eng3oilp");
		eng4oilp = eicasE.getElementById("eng4oilp");
		eng1n2bar = eicasE.getElementById("eng1n2bar").updateCenter();
		eng2n2bar = eicasE.getElementById("eng2n2bar").updateCenter();
		eng3n2bar = eicasE.getElementById("eng3n2bar").updateCenter();
		eng4n2bar = eicasE.getElementById("eng4n2bar").updateCenter();
		
		var c1 = eng1n2bar.getCenter();
		eng1n2bar.createTransform().setTranslation(-c1[0], -c1[1]);
		eng1n2bar_scale = eng1n2bar.createTransform();
		eng1n2bar.createTransform().setTranslation(c1[0], c1[1]);
		var c2 = eng2n2bar.getCenter();
		eng2n2bar.createTransform().setTranslation(-c2[0], -c2[1]);
		eng2n2bar_scale = eng2n2bar.createTransform();
		eng2n2bar.createTransform().setTranslation(c2[0], c2[1]);
		var c3 = eng3n2bar.getCenter();
		eng3n2bar.createTransform().setTranslation(-c3[0], -c3[1]);
		eng3n2bar_scale = eng3n2bar.createTransform();
		eng3n2bar.createTransform().setTranslation(c3[0], c3[1]);
		var c4 = eng4n2bar.getCenter();
		eng4n2bar.createTransform().setTranslation(-c4[0], -c4[1]);
		eng4n2bar_scale = eng4n2bar.createTransform();
		eng4n2bar.createTransform().setTranslation(c4[0], c4[1]);
		
		return m;
	},
	update: func()
	{	
		eng1n2.setText(sprintf("%3.01f",getprop("engines/engine[0]/n2")));
		if (getprop("engines/engine[0]/n2") != nil){
			eng1n2bar_scale.setScale(1, getprop("engines/engine[0]/n2")/112.5);
			if(getprop("engines/engine[0]/n2") >= 112.5) {
				eng1n2.setColor(1,0,0);
				eng1n2bar.setColor(1,0,0);
			} else {
				eng1n2.setColor(1,1,1);
				eng1n2bar.setColor(1,1,1);
			}
		}
		
		eng2n2.setText(sprintf("%3.01f",getprop("engines/engine[1]/n2")));
		if (getprop("engines/engine[1]/n2") != nil){
			eng2n2bar_scale.setScale(1, getprop("engines/engine[1]/n2")/112.5);
			if(getprop("engines/engine[1]/n2") >= 112.5) {
				eng2n2.setColor(1,0,0);
				eng2n2bar.setColor(1,0,0);
			} else {
				eng2n2.setColor(1,1,1);
				eng2n2bar.setColor(1,1,1);
			}
		}
		
		eng3n2.setText(sprintf("%3.01f",getprop("engines/engine[2]/n2")));
		if (getprop("engines/engine[2]/n2") != nil){
			eng3n2bar_scale.setScale(1, getprop("engines/engine[2]/n2")/112.5);
			if(getprop("engines/engine[2]/n2") >= 112.5) {
				eng3n2.setColor(1,0,0);
				eng3n2bar.setColor(1,0,0);
			} else {
				eng3n2.setColor(1,1,1);
				eng3n2bar.setColor(1,1,1);
			}
		}
		
		eng4n2.setText(sprintf("%3.01f",getprop("engines/engine[3]/n2")));
		if (getprop("engines/engine[3]/n2") != nil){
			eng4n2bar_scale.setScale(1, getprop("engines/engine[3]/n2")/112.5);
			if(getprop("engines/engine[3]/n2") >= 112.5) {
				eng4n2.setColor(1,0,0);
				eng4n2bar.setColor(1,0,0);
			} else {
				eng4n2.setColor(1,1,1);
				eng4n2bar.setColor(1,1,1);
			}
		}
		
		if (getprop("engines/engine/fuel-flow_pph") != nil) {
			eng1ff.setText(sprintf("%2.01f",getprop("engines/engine/fuel-flow_pph")*LB2KG/1000));
			eng2ff.setText(sprintf("%2.01f",getprop("engines/engine[1]/fuel-flow_pph")*LB2KG/1000));
			eng3ff.setText(sprintf("%2.01f",getprop("engines/engine[2]/fuel-flow_pph")*LB2KG/1000));
			eng4ff.setText(sprintf("%2.01f",getprop("engines/engine[3]/fuel-flow_pph")*LB2KG/1000));
		}
		eng1oilp.setText(sprintf("%2.0f",getprop("engines/engine/oil-pressure-psi")));
		eng2oilp.setText(sprintf("%2.0f",getprop("engines/engine[1]/oil-pressure-psi")));
		eng3oilp.setText(sprintf("%2.0f",getprop("engines/engine[2]/oil-pressure-psi")));
		eng4oilp.setText(sprintf("%2.0f",getprop("engines/engine[3]/oil-pressure-psi")));

		settimer(func me.update(), 0);
	}
};