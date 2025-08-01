# Boeing 747-400 Property Tree Setup
# Copyright (c) 2025 Josh Davidson (Octal450) and Gijs de Rooy
# Nodes organized like property tree, except when lots of identical (example: Gear wow), where vectors are used to make it easier
# Anything that says Temp is set by another file to avoid multiple getValue calls
# Usage Example: pts.Class.SubClass.node.getValue()

var Gear = {
	wow: [props.globals.getNode("/gear/gear[0]/wow"), props.globals.getNode("/gear/gear[1]/wow"), props.globals.getNode("/gear/gear[2]/wow"), props.globals.getNode("/gear/gear[3]/wow"), props.globals.getNode("/gear/gear[4]/wow"), props.globals.getNode("/gear/gear[5]/wow")],
};

var Instrumentation = {
	Altimeter: {
		indicatedAltitudeFt: props.globals.getNode("/instrumentation/altimeter/indicated-altitude-ft"),
	},
};

var Position = {
	wow: props.globals.getNode("/position/wow"),
};
