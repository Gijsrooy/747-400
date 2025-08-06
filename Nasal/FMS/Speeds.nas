# Boeing 747-400 FMS
# Copyright (c) 2025 Josh Davidson (Octal450) and Gijs de Rooy

# Properties and Data
var Speeds = {
	v1: props.globals.getNode("/systems/fms/speeds/v1"),
	v2: props.globals.getNode("/systems/fms/speeds/v2"),
	vapp: props.globals.getNode("/systems/fms/speeds/vapp"),
	vr: props.globals.getNode("/systems/fms/speeds/vr"),
	vref: props.globals.getNode("/systems/fms/speeds/vref"),
	vref25: props.globals.getNode("/systems/fms/speeds/vref-25"),
	vref30: props.globals.getNode("/systems/fms/speeds/vref-30"),
};