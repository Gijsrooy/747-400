# Boeing 747-400 FMS
# Copyright (c) 2025 Josh Davidson (Octal450) and Gijs de Rooy
# Where needed + 0 is used to force a string to a number

# Properties and Data
var FlightData = {
	new: func() {
		var m = {parents: [FlightData]};

		# TODO: Placeholder until this is accessible in the CDU
		m.accelAlt = getprop("/it-autoflight/settings/accel-ft");

		return m; 
	},
	reset: func() {
		var blankData = flightData.new();
		foreach(var key; keys(me)) {
			me[key] = blankData[key];
		}
	},
};

var flightData = FlightData.new();

var RouteManager = {
	cruiseAlt: props.globals.getNode("/autopilot/route-manager/cruise/altitude-ft"),
};
