# Boeing 747-400 Property Tree Setup
# Copyright (c) 2025 Josh Davidson (Octal450) and Gijs de Rooy
# Nodes organized like property tree, except when lots of identical (example: Gear wow), where vectors are used to make it easier
# Anything that says Temp is set by another file to avoid multiple getValue calls
# Usage Example: pts.Class.SubClass.node.getValue()

var Consumables = {
	Fuel: {
		totalFuelLbs: props.globals.getNode("/consumables/fuel/total-fuel-lbs"),
	},
};

var Controls = {
	Switches: {
		annunTest: props.globals.getNode("/controls/switches/annun-test"),
	},
};

var Fdm = {
	JSBSim: {
		Atmosphere: {
			oatC: props.globals.getNode("/fdm/jsbsim/atmosphere/temperature-degc"),
		},
		Inertia: {
			weightLbs: props.globals.getNode("/fdm/jsbsim/inertia/weight-lbs"),
			zfwLbs: props.globals.getNode("/fdm/jsbsim/inertia/zfw-lbs"),
		},
		Propulsion: {
			fuelUsed: [props.globals.getNode("/fdm/jsbsim/propulsion/engine[0]/fuel-used-lbs"), props.globals.getNode("/fdm/jsbsim/propulsion/engine[1]/fuel-used-lbs"), props.globals.getNode("/fdm/jsbsim/propulsion/engine[2]/fuel-used-lbs"), props.globals.getNode("/fdm/jsbsim/propulsion/engine[3]/fuel-used-lbs")],
		}
	},
};

var Gear = {
	wow: [props.globals.getNode("/gear/gear[0]/wow"), props.globals.getNode("/gear/gear[1]/wow"), props.globals.getNode("/gear/gear[2]/wow"), props.globals.getNode("/gear/gear[3]/wow"), props.globals.getNode("/gear/gear[4]/wow"), props.globals.getNode("/gear/gear[5]/wow")],
};

var Instrumentation = {
	Adf: {
		Frequencies: {
			selectedKhz: [props.globals.getNode("/instrumentation/adf[0]/frequencies/selected-khz"), props.globals.getNode("/instrumentation/adf[1]/frequencies/selected-khz")],
		},
	},
	AirspeedIndicator: {
		indicatedSpeedKt: props.globals.getNode("/instrumentation/airspeed-indicator/indicated-speed-kt"),
		trueSpeedKt: props.globals.getNode("/instrumentation/airspeed-indicator/true-speed-kt"),
	},
	Altimeter: {
		indicatedAltitudeFt: props.globals.getNode("/instrumentation/altimeter/indicated-altitude-ft"),
	},
	Efis: {
		hdgTrkSelected: [props.globals.initNode("/instrumentation/efis[0]/hdg-trk-selected", 0, "BOOL"), props.globals.initNode("/instrumentation/efis[1]/hdg-trk-selected", 0, "BOOL")],
		Inputs: {
			arpt: [props.globals.initNode("/instrumentation/efis[0]/inputs/arpt", 0, "BOOL"), props.globals.initNode("/instrumentation/efis[1]/inputs/arpt", 0, "BOOL")],
			data: [props.globals.initNode("/instrumentation/efis[0]/inputs/data", 0, "BOOL"), props.globals.initNode("/instrumentation/efis[1]/inputs/data", 0, "BOOL")],
			planWptIndex: [props.globals.initNode("/instrumentation/efis[0]/inputs/plan-wpt-index", 0, "BOOL"), props.globals.initNode("/instrumentation/efis[1]/inputs/plan-wpt-index", 0, "BOOL")],
			lhVorAdf: [props.globals.initNode("/instrumentation/efis[0]/inputs/lh-vor-adf", 0, "INT"), props.globals.initNode("/instrumentation/efis[1]/inputs/lh-vor-adf", 0, "INT")],
			ndCentered: [props.globals.initNode("/instrumentation/efis[0]/inputs/nd-centered", 0, "BOOL"), props.globals.initNode("/instrumentation/efis[1]/inputs/nd-centered", 0, "BOOL")],
			rangeNm: [props.globals.initNode("/instrumentation/efis[0]/inputs/range-nm", 10, "INT"), props.globals.initNode("/instrumentation/efis[1]/inputs/range-nm", 10, "INT")],
			rhVorAdf: [props.globals.initNode("/instrumentation/efis[0]/inputs/rh-vor-adf", 0, "INT"), props.globals.initNode("/instrumentation/efis[1]/inputs/rh-vor-adf", 0, "INT")],
			sta: [props.globals.initNode("/instrumentation/efis[0]/inputs/sta", 0, "BOOL"), props.globals.initNode("/instrumentation/efis[1]/inputs/sta", 0, "BOOL")],
			tfc: [props.globals.initNode("/instrumentation/efis[0]/inputs/tfc", 0, "BOOL"), props.globals.initNode("/instrumentation/efis[1]/inputs/tfc", 0, "BOOL")],
			wpt: [props.globals.initNode("/instrumentation/efis[0]/inputs/wpt", 0, "BOOL"), props.globals.initNode("/instrumentation/efis[1]/inputs/wpt", 0, "BOOL")],
		},
		Mfd: {
			mode: [props.globals.getNode("/instrumentation/efis[0]/mfd/display-mode"), props.globals.getNode("/instrumentation/efis[1]/mfd/display-mode")],
		}
	},
	Nav: {
		Frequencies: {
			selectedMhz: [props.globals.getNode("/instrumentation/nav[0]/frequencies/selected-mhz"), props.globals.getNode("/instrumentation/nav[1]/frequencies/selected-mhz"), props.globals.getNode("/instrumentation/nav[2]/frequencies/selected-mhz")],
		},
		navId: [props.globals.getNode("/instrumentation/nav[0]/nav-id"), props.globals.getNode("/instrumentation/nav[1]/nav-id"), props.globals.getNode("/instrumentation/nav[2]/nav-id")],
		Radials: {
			actualDeg: [props.globals.getNode("/instrumentation/nav[0]/radials/actual-deg"), props.globals.getNode("/instrumentation/nav[1]/radials/actual-deg"), props.globals.getNode("/instrumentation/nav[2]/radials/actual-deg")],
			selectedDeg: [props.globals.getNode("/instrumentation/nav[0]/radials/selected-deg"), props.globals.getNode("/instrumentation/nav[1]/radials/selected-deg"), props.globals.getNode("/instrumentation/nav[2]/radials/selected-deg")],
		},
	},
};

var Position = {
	node: props.globals.getNode("/position"),
	wow: props.globals.getNode("/position/wow"),
};

var Sim = {
	Time: {
		elapsedSec: props.globals.getNode("/sim/time/elapsed-sec"),
		utcHr: props.globals.getNode("/sim/time/utc/hour"),
		utcMin: props.globals.getNode("/sim/time/utc/minute"),
	},
}