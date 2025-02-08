# ==============================================================================
# Boeing 747-400 pfd by Gijs de Rooy
# ==============================================================================

var roundToNearest = func(n, m) {
	var x = int(n/m)*m;
	if((math.mod(n,m)) > (m/2))
			x = x + m;
	return x;
}

var pfd_canvas = nil;
var pfd_display = nil;

var B744PFD = {
	new: func(svg, name) {
		var obj = { parents: [B744PFD] };
		obj.canvas = canvas.new({
			"name": "PFD",
			"size": [1024, 1024],
			"view": [1024, 1024],
			"mipmapping": 1
		});
		obj.canvas.addPlacement({"node": "pfdScreen"});

		obj.font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};

		obj.group = obj.canvas.createGroup();
		obj.name = name;

		canvas.parsesvg(obj.group, svg, {"font-mapper": obj.font_mapper} );

		foreach(var key; obj.getKeys()) {
			obj[key] = obj.group.getElementById(key);
		};

		obj.h_trans = obj["horizon"].createTransform();
		obj.h_rot = obj["horizon"].createTransform();
		
		var c1 = obj["spdTrend"].getCenter();
		obj["spdTrend"].createTransform().setTranslation(-c1[0], -c1[1]);
		obj["spdTrend_scale"] = obj["spdTrend"].createTransform();
		obj["spdTrend"].createTransform().setTranslation(c1[0], c1[1]);
		var c2 = obj["risingRwyPtr"].getCenter();
		obj["risingRwyPtr"].createTransform().setTranslation(-c2[0], -c2[1]);
		obj["risingRwyPtr_scale"] = obj["risingRwyPtr"].createTransform();
		obj["risingRwyPtr"].createTransform().setTranslation(c2[0], c2[1]);
		
		obj["horizon"].set("clip", "rect(241.8, 694.7, 733.5, 211.1)");
		obj["minSpdInd"].set("clip", "rect(156, 1024, 829, 0)");
		obj["maxSpdInd"].set("clip", "rect(156, 1024, 829, 0)");
		obj["spdTape"].set("clip", "rect(156, 1024, 829, 0)");
		obj["altTape"].set("clip", "rect(156, 1024, 829, 0)");
		obj["cmdSpd"].set("clip", "rect(156, 1024, 829, 0)");
		obj["selAltPtr"].set("clip", "rect(156, 1024, 829, 0)");
		obj["vsiNeedle"].set("clip", "rect(287, 1024, 739, 930)");
		obj["compass"].set("clip", "rect(700, 1024, 990, 0)");
		obj["curAlt3"].set("clip", "rect(463, 1024, 531, 0)");
		obj["curSpdTen"].set("clip", "rect(455, 1024, 541, 0)");

		obj.update_items = [
			
			props.UpdateManager.FromHashValue("pitch", 0.025, func(val) {
				obj.h_trans.setTranslation(0, val * 10.5); #10 deg = 105px
			}),
			props.UpdateManager.FromHashValue("roll", 0.025, func(val) {
				obj.h_rot.setRotation(-val * D2R, obj["horizon"].getCenter());
				obj["bankPointer"].setRotation(-val * D2R);
			}),
			props.UpdateManager.FromHashList(["hdg","ias","selHdg","track"], 0.1, func(val) {
				obj["compass"].setRotation(-val.hdg * D2R);
				obj["selHdgPtr"].setRotation((val.selHdg - val.hdg) * D2R);
				if (val.ias > 10) {
					obj["trackIndicator"].setRotation((val.track - val.hdg) * D2R);
				} else {
					obj["trackIndicator"].setRotation(0);
				}
			}),

			props.UpdateManager.FromHashList(["passiveMode","roll","targetRoll"], 0.1, func(val) {
				if (val.passiveMode == 1) {
					if (val.targetRoll != nil) {
						var fdRoll = (val.roll - val.targetRoll) * 10.5;
						if (fdRoll > 200)
							fdRoll = 200;
						elsif (fdRoll < -200)
							fdRoll = -200;
						obj["fdX"].setTranslation(-fdRoll, 0);
					}
					obj["fdX"].show();
					#obj["fdY"].show();
				} else {
					obj["fdX"].hide();
					obj["fdY"].hide();
				}
			}),
			
			# 121 kts = 675 px -> 5.584
			# 806 ft = 675 px -> 0.837
			
			props.UpdateManager.FromHashList(["apSpd","ias"], 0.1, func(val) {
				if (val.ias < 30) val.ias = 30;
				var cmdSpd = val.apSpd - val.ias;
				if (cmdSpd > 60)
					cmdSpd = 60;
				elsif(cmdSpd < -60)
					cmdSpd = -60;
				obj["cmdSpd"].setTranslation(0, -cmdSpd * 5.584);
			}),

			props.UpdateManager.FromHashValue("mach", 0.001, func(val) {
				if (val >= 0.40) {
					obj["machText"].setText(sprintf("%.3f", val));
					obj["machText"].show();
				} else {
					obj["machText"].hide();
				}
			}),

			props.UpdateManager.FromHashValue("apAlt", 1, func(val) {
				obj["altText1"].setText(sprintf("%2.0f", math.floor(val / 1000)));
				obj["altText2"].setText(sprintf("%03.0f", math.mod(val, 1000)));
				obj["mcpAltMtr"].setText(sprintf("%5.0f", val * FT2M));
			}),

			props.UpdateManager.FromHashValue("alt", 1, func(val) {
				var altAbs = abs(val);
				obj["curAlt1"].setText(sprintf("%2.0f", math.floor(altAbs / 1000)));
				obj["curAlt2"].setText(sprintf("%1.0f", math.mod(math.floor(altAbs / 100), 10)));
				obj["curAlt3"].setTranslation(0, (math.mod(altAbs, 100) / 20) * 35);
				obj["curAltMtrTxt"].setText(sprintf("%4.0f", val * FT2M));
			}),

			props.UpdateManager.FromHashList(["alt","apAlt","targetVs","vSpd"], 1, func(val) {
				var curAltDiff = val.alt - val.apAlt;
				if (abs(curAltDiff) > 300 and abs(curAltDiff) < 900) {
					obj["curAltBox"].setStrokeLineWidth(5);
					if ((val.alt > val.apAlt and val.vSpd > 1) or (val.alt < val.apAlt and val.vSpd < 1)) {
						obj["curAltBox"].setColor(1, 0.5, 0);
						obj["selAltBox"].hide();
					} else {
						obj["curAltBox"].setColor(1, 1, 1);
						obj["selAltBox"].show();
					}
				} else {
					obj["curAltBox"].setStrokeLineWidth(3);
					obj["curAltBox"].setColor(1, 1, 1);
					obj["selAltBox"].hide();
				}
				if (curAltDiff > 403)
					curAltDiff = 403;
				elsif (curAltDiff < -403)
					curAltDiff = -403;
				obj["selAltPtr"].setTranslation(0, curAltDiff * 0.837);

				if (val.alt < 10000 and val.alt > 0)
					obj["tenThousand"].show();
				else
					obj["tenThousand"].hide();
				if (val.vSpd != nil) {
					var vertSpd = val.vSpd * 60;
					if (abs(vertSpd) > 400) {
						var vsiText = sprintf("%4.0f", roundToNearest(abs(vertSpd), 50));
						if (abs(vertSpd) > 9999) vsiText = "9999";
						obj["vertSpd"].setTranslation(0, -540 * (vertSpd > 0));
						obj["vertSpd"].setText(vsiText);
						obj["vertSpd"].show();
					} else {
						obj["vertSpd"].hide();
					}
					obj["vsPointer"].setTranslation(0, -val.targetVs);
				}
			}),

			props.UpdateManager.FromHashValue("ias", 0.1, func(val) {
				obj["curSpd"].setText(sprintf("%2.0f", math.floor(val / 10)));
				obj["curSpdTen"].setTranslation(0, math.mod(val, 10) * 45);
			}),

			props.UpdateManager.FromHashList(["markerInner","markerMiddle","markerOuter"], nil, func(val) {
				if (val.markerOuter) {
					obj["markerBeacon"].show();
					obj["markerBeaconText"].setText("OM");
				} elsif (val.markerMiddle) {
					obj["markerBeacon"].show();
					obj["markerBeaconText"].setText("MM");
				} elsif (val.markerInner) {
					obj["markerBeacon"].show();
					obj["markerBeaconText"].setText("IM");
				} else {
					obj["markerBeacon"].hide();
				}
			}),

			props.UpdateManager.FromHashList(["agl","navSigQ","navNeedle"], nil, func(val) {
				if(val.navSigQ > 0.95) {
					var deflection = val.navNeedle; # 1 dot = 1 degree, full needle deflection is 10 deg
					if (deflection > 0.3)
						deflection = 0.3;
					if (deflection < -0.3)
						deflection = -0.3;
						
					obj["locPtr"].show();
					
					var radioAlt = val.agl - 24;
					if (radioAlt < 2500) {
						obj["risingRwy"].show();
						obj["risingRwyPtr"].show();
						if (radioAlt< 200) {
							if(abs(deflection) < 0.1)
								obj["risingRwy"].setTranslation(deflection * 500, -(200 - radioAlt) * 0.682);
							else
								obj["risingRwy"].setTranslation(deflection * 250, -(200 - radioAlt) * 0.682);
							obj["risingRwyPtr_scale"].setScale(1, ((200 - radioAlt) * 0.682) / 11);
						} else {
							obj["risingRwy"].setTranslation(deflection * 150, 0);
							obj["risingRwyPtr_scale"].setScale(1, 1);
						}
					} else {
						obj["risingRwy"].hide();
						obj["risingRwyPtr"].hide();
					}
					
					if(abs(deflection) < 0.233) # 2 1/3 dot
						obj["locPtr"].setColorFill(1, 0, 1, 1);
					else
						obj["locPtr"].setColorFill(1, 0, 1, 0);
					if(abs(deflection) < 0.1) {
						obj["locPtr"].setTranslation(deflection * 500, 0);
						obj["risingRwyPtr"].setTranslation(deflection * 500, 0);
						obj["locScaleExp"].show();
						obj["locScale"].hide();
					} else {
						obj["locPtr"].setTranslation(deflection * 250, 0);
						obj["risingRwyPtr"].setTranslation(deflection * 250, 0);
						obj["locScaleExp"].hide();
						obj["locScale"].show();
					}
				} else {
					obj["locPtr"].hide();
					obj["locScaleExp"].hide();
					obj["locScale"].hide();
					obj["risingRwy"].hide();
					obj["risingRwyPtr"].hide();
				}
			}),

			props.UpdateManager.FromHashList(["gsInRange","gsNeedle"], nil, func(val) {
				if(val.gsInRange) {
					obj["gsPtr"].show();
					obj["gsScale"].show();
					obj["gsPtr"].setTranslation(0, -val.gsNeedle * 140);
				} else {
					obj["gsPtr"].hide();
					obj["gsScale"].hide();
				}
			}),

			props.UpdateManager.FromHashValue("agl", 1, func(val) {
				var radioAlt = val - 24;
				if (radioAlt < 2500) {
					if (radioAlt > 500)
						obj["radioAltInd"].setText(sprintf("%4.0f", roundToNearest(radioAlt, 20)));
					elsif (radioAlt > 100)
						obj["radioAltInd"].setText(sprintf("%4.0f", roundToNearest(radioAlt, 10)));
					else
						obj["radioAltInd"].setText(sprintf("%4.0f", roundToNearest(radioAlt, 2)));
					obj["radioAltInd"].show();
				} else {
					obj["radioAltInd"].hide();
				}
			}),

			props.UpdateManager.FromHashValue("spdTrend", 0.01, func(val) {
				if (abs(val > 0.1))
					obj["spdTrend_scale"].setScale(1, val);
				else
					obj["spdTrend_scale"].setScale(1, 0);
			}),

			props.UpdateManager.FromHashValue("ias", 0.1, func(val) {
				obj["spdTape"].setTranslation(0, val * 5.584);
			}),
			props.UpdateManager.FromHashValue("alt", 1, func(val) {
				obj["altTape"].setTranslation(0, val * 0.837);
			}),

			props.UpdateManager.FromHashValue("vsiDeg", 1, func(val) {
				obj["vsiNeedle"].setRotation(val * D2R);
			}),

			props.UpdateManager.FromHashList(["passiveMode","altLock","hdgLock","spdLock"], nil, func(val) {
				if (val.passiveMode == 1)
					obj["afdsMode"].setText("FD");
				elsif (val.altLock != "" or val.hdgLock != "" or val.spdLock != "")
					obj["afdsMode"].setText("CMD");
				else
					obj["afdsMode"].setText("");

				if (val.spdLock == "speed-with-throttle")
					obj["atMode"].setText("SPD");
				elsif (val.spdLock ==  "speed-with-pitch-trim")
					obj["atMode"].setText("THR");
				else
					obj["atMode"].setText("");

				if (val.hdgLock == "wing-leveler")
					obj["rollMode"].setText("HDG HOLD");
				elsif (val.hdgLock ==  "dg-heading-hold")
					obj["rollMode"].setText("HDG SEL");
				elsif (val.hdgLock ==  "nav1-hold")
					obj["rollMode"].setText("LNAV");
				else
					obj["rollMode"].setText("");

				obj["vsPointer"].hide();
				if (val.altLock == "vertical-speed-hold") {
					obj["pitchMode"].setText("V/S");
					obj["vsPointer"].show();
				} elsif (val.altLock ==  "altitude-hold")
					obj["pitchMode"].setText("ALT");
				elsif (val.altLock ==  "gs1-hold")
					obj["pitchMode"].setText("G/S");
				elsif (val.altLock ==  "speed-with-pitch-trim")
					obj["pitchMode"].setText("FLCH SPD");
				else
					obj["pitchMode"].setText("");
			}),

			props.UpdateManager.FromHashValue("navId", nil, func(val) {
				obj["ilsId"].setText(val);
			}),

			props.UpdateManager.FromHashList(["v1","v2","vr","wow"], 1, func(val) {
				if (val.v1 or 0 > 0) {
					if (val.wow) {
						obj["v1"].show();
						obj["v1"].setTranslation(0, -val.v1 * 5.584);
						obj["vr"].show();
						obj["vr"].setTranslation(0, -val.vr * 5.584);
					} else {
						obj["v1"].hide();
						obj["vr"].hide();
					}
					obj["v2"].setTranslation(0, -val.v2 * 5.584);
				} else {
					obj["v1"].hide();
					obj["vr"].hide();
				}
			}),

			props.UpdateManager.FromHashValue("flaps0", 1, func(val) {
				obj["flaps0"].setTranslation(0, -val * 5.584);
			}),
			props.UpdateManager.FromHashValue("flaps1", 1, func(val) {
				obj["flaps1"].setTranslation(0, -val * 5.584);
			}),
			props.UpdateManager.FromHashValue("flaps5", 1, func(val) {
				obj["flaps5"].setTranslation(0, -val * 5.584);
			}),
			props.UpdateManager.FromHashValue("flaps10", 1, func(val) {
				obj["flaps10"].setTranslation(0, -val * 5.584);
			}),
			props.UpdateManager.FromHashValue("flaps20", 1, func(val) {
				obj["flaps20"].setTranslation(0, -val * 5.584);
			}),

			props.UpdateManager.FromHashList(["flaps","flaps25","flaps30","phase"], 1, func(val) {
				if (val.phase == "APPROACH") {
					if (val.flaps == 1)
						var vref = val.flaps30;
					else
						var vref = val.flaps25;
					obj["vref"].show();
					obj["vref"].setTranslation(0, -vref * 5.584);
				} else {
					obj["vref"].hide();
				}
			}),

			props.UpdateManager.FromHashList(["alt","flaps"], nil, func(val) {
				obj["flaps0"].hide();
				obj["flaps1"].hide();
				obj["flaps5"].hide();
				obj["flaps10"].hide();
				obj["flaps20"].hide();
				if (val.alt < 20000) {
					if (val.flaps == 0.033) {
						obj["flaps0"].show(); obj["flaps1"].show();
					} elsif (val.flaps == 0.167) {
						obj["flaps1"].show(); obj["flaps5"].show();
					} elsif (val.flaps == 0.333) {
						obj["flaps5"].show(); obj["flaps10"].show();
					} elsif (val.flaps == 0.667) {
						obj["flaps10"].show(); obj["flaps20"].show();
					}
				}
			}),

			props.UpdateManager.FromHashValue("iasMin", 1, func(val) {
				obj["minSpdInd"].setTranslation(0, -val * 5.584);
			}),
			props.UpdateManager.FromHashValue("iasMax", 1, func(val) {
				obj["maxSpdInd"].setTranslation(0, -val * 5.584);
			}),

			props.UpdateManager.FromHashValue("destElev", 1, func(val) {
				if (val != nil) {
					obj["touchdown"].setTranslation(0, -val * 0.9);
					obj["touchdown"].show();
				} else {
					obj["touchdown"].hide();
				}
			}),

			props.UpdateManager.FromHashList(["ias","wow"], 1, func(val) {
				if(val.wow or (val.ias <= 35)) {
					obj["minSpdInd"].hide();
					obj["maxSpdInd"].hide();
				} else {
					obj["minSpdInd"].show();
					obj["maxSpdInd"].show();
				}
			}),

			props.UpdateManager.FromHashValue("altInhg", 0.01, func(val) {
				obj["baroSet"].setText(sprintf("%2.2f", val));
			}),
			props.UpdateManager.FromHashValue("ilsCourse", 1, func(val) {
				obj["ilsCourse"].setText(sprintf("CRS %3.0f", val));
			}),
			props.UpdateManager.FromHashValue("dh", 1, func(val) {
				obj["dhText"].setText(sprintf("DH%3.0f", val));
				obj["minimums"].setTranslation(0, -val * 0.9);
			}),
			props.UpdateManager.FromHashValue("selHdg", 1, func(val) {
				obj["selHdgText"].setText(sprintf("%3.0f", val));
			}),
			props.UpdateManager.FromHashValue("apSpd", 1, func(val) {
				obj["speedText"].setText(sprintf("%3.0f", val));
			}),
			
			props.UpdateManager.FromHashValue("navDist", 1, func(val) {
				if (val > 0) {
					obj["dmeDist"].setText(sprintf("DME %2.01f", val * 0.000539));
					obj["dmeDist"].show();
				} else {
					obj["dmeDist"].hide();
				}
			}),

			props.UpdateManager.FromHashValue("gpwsWarning", 1, func(val) {
				obj["egpwsPitch"].setVisible(val);
			}),
		];

		obj.update = func(notification) {
			foreach(var update_item; obj.update_items) {
				update_item.update(notification);
			}
		};

		return obj;
	},

	getKeys: func() {
		return ["afdsMode","altTape","altText1","altText2","atMode","bankPointer","baroSet","cmdSpd","compass",
		"curAlt1","curAlt2","curAlt3","curAltBox","curAltMtrTxt","curSpd","curSpdTen",
		"dhText","dmeDist","egpwsPitch","fdX","fdY","flaps0","flaps1","flaps10","flaps20","flaps5",
		"gpwsAlert","gsPtr","gsScale","horizon","ilsCourse","ilsId","locPtr","locScale","locScaleExp","machText","markerBeacon","markerBeaconText",
		"maxSpdInd","mcpAltMtr","minimums","minSpdInd","pitchMode","radioAltInd","risingRwy","risingRwyPtr","rollMode","selAltBox","selAltPtr","selHdgPtr","selHdgText",
		"spdTape","spdTrend","speedText","tenThousand","touchdown","trackIndicator","v1","v2","vertSpd","vr","vref","vsiNeedle","vsPointer"];
	},

	update: func(notification) {
		obj.update(notification);
	}
};

var input = {
	agl: "/position/altitude-agl-ft",
	alt: "/instrumentation/altimeter/indicated-altitude-ft",
	altInhg: "/instrumentation/altimeter/setting-inhg",
	altLock: "/autopilot/locks/altitude",
	apAlt: "/autopilot/settings/target-altitude-ft",
	apSpd: "/autopilot/settings/target-speed-kt",
	destElev: "/autopilot/route-manager/destination/field-elevation-ft",
	dh: "/instrumentation/mk-viii/inputs/arinc429/decision-height",
	flaps: "/controls/flight/flaps",
	flaps0: "/systems/fms/speeds/flaps-0",
	flaps1: "/systems/fms/speeds/flaps-1",
	flaps5: "/systems/fms/speeds/flaps-5",
	flaps10: "/systems/fms/speeds/flaps-10",
	flaps20: "/systems/fms/speeds/flaps-20",
	flaps25: "/systems/fms/speeds/flaps-25",
	flaps30: "/systems/fms/speeds/flaps-30",
	gpwsWarning: "/instrumentation/mk-viii/outputs/discretes/gpws-warning",
	gsInRange: "/instrumentation/nav/gs-in-range",
	gsNeedle: "/instrumentation/nav/gs-needle-deflection-norm",
	hdg: "/orientation/heading-magnetic-deg",	
	hdgLock: "/autopilot/locks/heading",
	ias: "/instrumentation/airspeed-indicator/indicated-speed-kt",
	iasMax: "/systems/fms/speeds/vmax",
	iasMin: "/systems/fms/speeds/vmin",
	ilsCourse: "/instrumentation/nav/radials/selected-deg",
	mach: "/velocities/mach",
	markerInner: "/instrumentation/marker-beacon/inner",
	markerMiddle: "/instrumentation/marker-beacon/middle",
	markerOuter: "/instrumentation/marker-beacon/outer",
	navDist: "/instrumentation/nav/nav-distance",
	navId: "/instrumentation/nav/nav-id",
	navNeedle: "/instrumentation/nav/heading-needle-deflection-norm",
	navSigQ: "/instrumentation/nav/signal-quality-norm",
	passiveMode: "/autopilot/locks/passive-mode",
	phase: "/instrumentation/fmc/phase-name",
	pitch: "/orientation/pitch-deg",
	roll: "/orientation/roll-deg",
	selHdg: "/autopilot/settings/heading-bug-deg",
	spdLock: "/autopilot/locks/speed",
	spdTrend: "/instrumentation/pfd/speed-trend-up",
	targetRoll: "/autopilot/internal/target-roll-deg",
	targetVs: "instrumentation/pfd/target-vs",
	track: "/orientation/track-magnetic-deg",
	v1: "/instrumentation/fmc/vspeeds/V1",
	v2: "/instrumentation/fmc/vspeeds/V2",
	vr: "/instrumentation/fmc/vspeeds/VR",
	vsiDeg: "/instrumentation/pfd/vsi-needle-deg",
	vSpd: "/velocities/vertical-speed-fps",
	wow: "/gear/gear/wow",
};

var pfd = B744PFD.new("Aircraft/747-400/Models/Cockpit/Instruments/PFD/PFD.svg", "PFD");
emexec.ExecModule.register("B744 PFD", input, pfd);

var showPFD = func() {
	var dlg = canvas.Window.new([600, 600], "dialog")
        .set("resize", 1)
 		.lockAspectRatio()
 		.setTitle("PFD")
	    .setCanvas(pfd.canvas);
}