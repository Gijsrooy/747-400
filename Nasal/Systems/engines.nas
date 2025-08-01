# Boeing 747-400 Engines
# Copyright (c) 2025 Josh Davidson (Octal450) and Gijs de Rooy

var ENGINES = {
	Controls: {
		throttle: [props.globals.getNode("/controls/engines/engine[0]/throttle"), props.globals.getNode("/controls/engines/engine[1]/throttle"), props.globals.getNode("/controls/engines/engine[2]/throttle"), props.globals.getNode("/controls/engines/engine[3]/throttle")],
	},
};

var toggleRevThrust = func() {
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and FADEC.throttleCompareMax.getValue() <= 0.05) {
		if (FADEC.reverseEngage[0].getBoolValue() or FADEC.reverseEngage[1].getBoolValue() or FADEC.reverseEngage[2].getBoolValue() or FADEC.reverseEngage[3].getBoolValue()) {
			ENGINES.Controls.throttle[0].setValue(0);
			ENGINES.Controls.throttle[1].setValue(0);
			ENGINES.Controls.throttle[2].setValue(0);
			ENGINES.Controls.throttle[3].setValue(0);
			FADEC.reverseEngage[0].setBoolValue(0);
			FADEC.reverseEngage[1].setBoolValue(0);
			FADEC.reverseEngage[2].setBoolValue(0);
			FADEC.reverseEngage[3].setBoolValue(0);
		} else {
			FADEC.reverseEngage[0].setBoolValue(1);
			FADEC.reverseEngage[1].setBoolValue(1);
			FADEC.reverseEngage[2].setBoolValue(1);
			FADEC.reverseEngage[3].setBoolValue(1);
		}
	} else {
		ENGINES.Controls.throttle[0].setValue(0);
		ENGINES.Controls.throttle[1].setValue(0);
		ENGINES.Controls.throttle[2].setValue(0);
		ENGINES.Controls.throttle[3].setValue(0);
		FADEC.reverseEngage[0].setBoolValue(0);
		FADEC.reverseEngage[1].setBoolValue(0);
		FADEC.reverseEngage[2].setBoolValue(0);
		FADEC.reverseEngage[3].setBoolValue(0);
	}
};
