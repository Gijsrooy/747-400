# Boeing 747-400 FMS
# Copyright (c) 2025 Josh Davidson (Octal450) and Gijs de Rooy
# Where needed + 0 is used to force a string to a number

# Properties and Data
var FlightData = {
	new: func() {
		var m = {parents: [FlightData]};

		m.accelAlt = 1000;
		m.accelAltSet = 0;
		m.accelAltEo = 400;
		m.accelAltEoSet = 0;
		m.airportAltn = "";
		m.airportFrom = "";
		m.airportTo = "";
		m.canCalcVspeeds = 0;
		m.climbThrustAlt = -2000;
		m.climbThrustAltSet = 0;
		m.costIndex = -1;
		m.cruiseAlt = 0;
		m.cruiseAltAll = [0, 0, 0, 0, 0, 0];
		m.cruisecg = 20;
		m.cruiseFl = 0;
		m.cruiseFlAll = [0, 0, 0, 0, 0, 0];
		m.cruiseTemp = nil;
		m.flexActive = 0;
		m.flexTemp = 0;
		m.flightNumber = "";
		m.gwLbs = 0;
		m.landFlaps = 25;
		m.runwayFrom = "";
		m.sid = "";
		m.star = "";
		m.tocg = 0;
		m.toFlaps = 0;
		m.togwLbs = 0;
		m.toPacks = 0;
		m.toSlope = -100; 
		m.toWind = -100;
		m.ufobLbs = 0;
		m.v1 = 0;
		m.v1State = 0;
		m.v2 = 0;
		m.v2State = 0;
		m.vapp = 0;
		m.vappOvrd = 0;
		m.vr = 0;
		m.vrState = 0;
		m.zfwLbs = 0;

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

var FlightDataOut = {
	canCalcVspeeds: props.globals.getNode("/systems/fms/flight-data/can-calc-vspeeds"),
	costIndex: props.globals.getNode("/systems/fms/flight-data/cost-index"),
	cruisecg: props.globals.getNode("/systems/fms/flight-data/cruisecg"),
	cruiseFl: props.globals.getNode("/systems/fms/flight-data/cruise-fl"),
	flexActive: props.globals.getNode("/systems/fms/flight-data/flex-active"),
	flexTemp: props.globals.getNode("/systems/fms/flight-data/flex-temp"),
	gwKg: props.globals.getNode("/systems/fms/flight-data/gw-kg"),
	gwLbs: props.globals.getNode("/systems/fms/flight-data/gw-lbs"),
	landFlaps: props.globals.getNode("/systems/fms/flight-data/land-flaps"),
	tocg: props.globals.getNode("/systems/fms/flight-data/tocg"),
	toFlaps: props.globals.getNode("/systems/fms/flight-data/to-flaps"),
	toPacks: props.globals.getNode("/systems/fms/flight-data/to-packs"),
	toSlope: props.globals.getNode("/systems/fms/flight-data/to-slope"),
	toWind: props.globals.getNode("/systems/fms/flight-data/to-wind"),
	togw: props.globals.getNode("/systems/fms/flight-data/togw-lbs"),
	v1: props.globals.getNode("/systems/fms/flight-data/v1"),
	v2: props.globals.getNode("/systems/fms/flight-data/v2"),
	vr: props.globals.getNode("/systems/fms/flight-data/vr"),
	zfwLbs: props.globals.getNode("/systems/fms/flight-data/zfw-lbs"),
};

var RouteManager = {
	active: props.globals.getNode("/autopilot/route-manager/active"),
	alternateAirport: props.globals.getNode("/autopilot/route-manager/alternate/airport"),
	approach: props.globals.getNode("/autopilot/route-manager/destination/approach"),
	cruiseAlt: props.globals.getNode("/autopilot/route-manager/cruise/altitude-ft"),
	currentWp: props.globals.getNode("/autopilot/route-manager/current-wp"),
	departureAirport: props.globals.getNode("/autopilot/route-manager/departure/airport"),
	departureRunway: props.globals.getNode("/autopilot/route-manager/departure/runway"),
	destinationAirport: props.globals.getNode("/autopilot/route-manager/destination/airport"),
	destinationRunway: props.globals.getNode("/autopilot/route-manager/destination/runway"),
	distanceRemainingNm: props.globals.getNode("/autopilot/route-manager/distance-remaining-nm"),
	sid: props.globals.getNode("/autopilot/route-manager/departure/sid"),
	star: props.globals.getNode("/autopilot/route-manager/destination/star"),
	num: props.globals.getNode("/autopilot/route-manager/route/num"),
};

var EditFlightData = {
	loop: func() {
		flightData.ufobLbs = math.round(pts.Consumables.Fuel.totalFuelLbs.getValue(), 100) / 1000;
		flightData.gwLbs = math.round(pts.Fdm.JSBSim.Inertia.weightLbs.getValue(), 100) / 1000;
		flightData.zfwLbs = math.round(pts.Fdm.JSBSim.Inertia.zfwLbs.getValue(), 100) / 1000;

		# Write out values for JSBSim to use
		me.writeOut();

		# After write out
		# Enable/Disable V speeds Calc
		if (flightData.runwayFrom != "") {
			flightData.canCalcVspeeds = 1;
		} else {
			flightData.canCalcVspeeds = 0;
			me.resetVspeeds();
		}
	},
	reset: func() {
		# Reset Route Manager
		flightplan().cleanPlan(); # Clear List function in Route Manager
		RouteManager.alternateAirport.setValue("");
		RouteManager.cruiseAlt.setValue(0);
		RouteManager.departureAirport.setValue("");
		RouteManager.destinationAirport.setValue("");
		
		# Clear FlightData
		flightData.reset();
		me.writeOut();
	},
	writeOut: func() { # Write out relevant parts of the FlightData object to property tree as required so that JSBSim can access it
		FlightDataOut.canCalcVspeeds.setBoolValue(flightData.canCalcVspeeds);
		FlightDataOut.costIndex.setValue(flightData.costIndex);
		FlightDataOut.cruisecg.setValue(flightData.cruisecg);
		FlightDataOut.cruiseFl.setValue(flightData.cruiseFl);
		FlightDataOut.flexActive.setBoolValue(flightData.flexActive);
		FlightDataOut.flexTemp.setValue(flightData.flexTemp);
		FlightDataOut.gwLbs.setValue(flightData.gwLbs);
		FlightDataOut.landFlaps.setValue(flightData.landFlaps);
		FlightDataOut.tocg.setValue(flightData.tocg);
		FlightDataOut.toFlaps.setValue(flightData.toFlaps);
		FlightDataOut.toPacks.setValue(flightData.toPacks);
		FlightDataOut.toSlope.setValue(flightData.toSlope);
		FlightDataOut.toWind.setValue(flightData.toWind);
		FlightDataOut.togw.setValue(flightData.togwLbs);
		FlightDataOut.v1.setValue(flightData.v1);
		FlightDataOut.v2.setValue(flightData.v2);
		FlightDataOut.vr.setValue(flightData.vr);
		FlightDataOut.zfwLbs.setValue(flightData.zfwLbs);
	},
	activateFlightplan: func() {		
		if (!RouteManager.active.getBoolValue()) {
			fgcommand("activate-flightplan", props.Node.new({"activate": 1}));
		}
		if (RouteManager.currentWp.getValue() == -1) { # This fixes a weird issue where the Route Manager sets it to -1
			RouteManager.currentWp.setValue(1);
		}
	},
	insertAlternate: func(arpt) { # Assumes validation is already done
		flightData.airportAltn = arpt;
		RouteManager.alternateAirport.setValue(arpt);
		if (RouteManager.currentWp.getValue() == -1) { # This fixes a weird issue where the Route Manager sets it to -1
			RouteManager.currentWp.setValue(0);
		}
	},
	insertApproach: func(app) { # Assumes validation is already done
		flightData.approach = app;
		RouteManager.approach.setValue(app);
	},
	insertCruiseFl: func(s1, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0) {
		flightData.cruiseAlt = s1 * 100;
		flightData.cruiseAltAll = [s1 * 100, s2 * 100, s3 * 100, s4 * 100, s5 * 100, s6 * 100];
		flightData.cruiseFl = int(s1);
		flightData.cruiseFlAll = [int(s1), int(s2), int(s3), int(s4), int(s5), int(s6)];
		RouteManager.cruiseAlt.setValue(s1 * 100);
		
		if (s1 == 0) {
			flightData.cruiseTemp = nil;
		} else if (s1 * 100 < 36090) {
			flightData.cruiseTemp = math.round(15 - (math.round(s1 / 10) * 1.98));
		} else {
			flightData.cruiseTemp = -56; # Rounded
		}
	},
	insertDeparture: func(arpt) { # Assumes validation is already done
		flightplan().cleanPlan();
		flightData.airportFrom = arpt;
		flightData.runwayFrom = "";
		flightData.sid = "";
		me.resetVspeeds();
		RouteManager.departureAirport.setValue(arpt);
	},
	insertDepartureRwy: func(rwy) { # Assumes validation is already done
		flightData.runwayFrom = rwy;
		flightData.sid = "";
		RouteManager.departureRunway.setValue(rwy);
		me.resetVspeeds();
	},
	insertDestination: func(arpt) { # Assumes validation is already done
		flightData.approach = "";
		flightData.airportTo = arpt;
		flightData.star = "";
		me.resetVspeeds();
		RouteManager.destinationAirport.setValue(arpt);
	},
	insertDestinationRwy: func(rwy) { # Assumes validation is already done
		RouteManager.destinationRunway.setValue(rwy);
		me.resetVspeeds();
	},
	insertSid: func(sid) { # Assumes validation is already done
		flightData.sid = sid;
		RouteManager.sid.setValue(sid);
	},
	insertStar: func(star) { # Assumes validation is already done
		flightData.star = star;
		RouteManager.star.setValue(star);
	},
	resetVspeeds: func(t = 0) {
		if (Internal.phase > 0) return;
		
		if (flightData.v1State == 1 and (t == 0 or t == 1)) {
			flightData.v1 = 0;
			flightData.v1State = 0;
		}
		if (flightData.vrState == 1 and (t == 0 or t == 2)) {
			flightData.vr = 0;
			flightData.vrState = 0;
		}
		if (flightData.v2State == 1 and (t == 0 or t == 3)) {
			flightData.v2 = 0;
			flightData.v2State = 0;
		}
	},
};