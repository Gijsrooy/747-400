# Boeing 747-400 FMS
# Copyright (c) 2025 Josh Davidson (Octal450) and Gijs de Rooy

var Internal = {
	phase: 0, # 0: Preflight, 1: Takeoff, 2: Climb, 3: Cruise, 4: Descent, 5: Approach, 6: Rollout
	phaseNew: 0,
	phaseOut: props.globals.getNode("/systems/fms/internal/phase"),
};

var Value = { # Local store of commonly accessed values
	afsAlt: 0,
	altitude: 0,
	flapsLever: 0,
	gearLever: 0,
	wow: 0,
};

# Logic
var CORE = {
	init: func(t = 0) {
		me.resetPhase();
	},
	resetPhase: func() {
		Internal.phaseNew = 0;
		Internal.phase = 0;
		Internal.phaseOut.setValue(0);
	},
	loop: func() {
		Value.afsAlt = itaf.Internal.alt.getValue();
		Value.altitude = pts.Instrumentation.Altimeter.indicatedAltitudeFt.getValue();
		Value.flapsLever = systems.FCS.flapsInput.getValue();
		Value.gearLever = systems.GEAR.cmd.getBoolValue();
		Value.vertText = itaf.Text.vert.getValue();
		Value.wow = pts.Position.wow.getBoolValue();

		# Flight Phases
		if (Internal.phase == 0) { # Preflight
			if ((Value.vertText == "T/O CLB" and systems.FADEC.throttleCompareMax.getValue() >= 0.7) or !Value.wow) {
				Internal.phaseNew = 1; # Takeoff
			}
		} else if (Internal.phase == 1) { # Takeoff
			if (!Value.wow and Value.vertText == "ALT HLD") {
				Internal.phaseNew = 2; # Climb
			} else if (Value.wow and Value.vertText == "T/O CLB" and systems.FADEC.throttleCompareMax.getValue() < 0.7) { # Rejected T/O
				Internal.phaseNew = 0; # Preflight
			} else if (flightData.accelAlt > -2000) {
				if (Value.vertText != "T/O CLB" and Value.altitude >= flightData.accelAlt) {
					Internal.phaseNew = 2; # Climb
				}
			}
		} else if (Internal.phase == 2) { # Climb
			if (Value.flapsLever >= 25 and Value.gearLever) {
				Internal.phaseNew = 5; # Approach
			} else if (Value.wow) {
				Internal.phaseNew = 6; # Rollout
			} else if (RouteManager.cruiseAlt.getValue() > 0) {
				if (Value.vertText == "ALT HLD" and Value.afsAlt >= RouteManager.cruiseAlt.getValue()) {
					Internal.phaseNew = 3; # Cruise
				}
			}
		} else if (Internal.phase == 3) { # Cruise
			if (Value.flapsLever >= 25 and Value.gearLever) {
				Internal.phaseNew = 5; # Approach
			} else if (Value.wow) {
				Internal.phaseNew = 6; # Rollout
			} else if (RouteManager.cruiseAlt.getValue() > 0) {
				if (Value.afsAlt < RouteManager.cruiseAlt.getValue()) {
					Internal.phaseNew = 4; # Descent
				}
			}
		} else if (Internal.phase == 4) { # Descent
			if (Value.flapsLever > 0) {
				Internal.phaseNew = 5; # Approach
			} else if (Value.wow) {
				Internal.phaseNew = 6; # Rollout
			}
		} else if (Internal.phase == 5) { # Approach
			if (Value.flapsLever == 0) {
				Internal.phaseNew = 4; # Descent
			} else if (Value.wow and Value.vertText != "G/A CLB") {
				Internal.phaseNew = 6; # Rollout
			}
		} else if (Internal.phase == 6) { # Rollout
			if (!Value.wow or Value.vertText == "G/A CLB") {
				Internal.phaseNew = 5; # Approach
			}
		}

		if (Internal.phase != Internal.phaseNew) {
			Internal.phase = Internal.phaseNew;
			Internal.phaseOut.setValue(Internal.phaseNew);
		}
	},
};
