###########################################
##                                       ##
## AUTOBRAKING SYSTEM for BOEING 747-400 ##
## 21 Mai 2009              Gijs de Rooy ##
##                                       ##
###########################################

var autobrake = func {

        if (getprop("/gear/gear/wow") == 1 and getprop("/controls/engines/engine/throttle") == 0 and getprop("/controls/engines/engine[1]/throttle") == 0 and getprop("/controls/engines/engine[2]/throttle") == 0 and getprop("/controls/engines/engine[3]/throttle") == 0) {				  
	  # brakes enable after touchdown of nose wheel
	
        if (getprop("/controls/gear/autobrakes") == 0) {
          # autobrakes are off, so do nothing here
          setprop("/controls/gear/brake-left", 0);
          setprop("/controls/gear/brake-right", 0);
        }

        elsif (getprop("/controls/gear/autobrakes") == 1) {
          # autobrakes set to level 1
          setprop("/controls/gear/brake-left", 0.2);
          setprop("/controls/gear/brake-right", 0.2);
        }

        elsif (getprop("/controls/gear/autobrakes") == 2) {
          # autobrakes set to level 2
          setprop("/controls/gear/brake-left", 0.4);
          setprop("/controls/gear/brake-right", 0.4);
        }

        elsif (getprop("/controls/gear/autobrakes") == 3) {
          # autobrakes set to level 3
          setprop("/controls/gear/brake-left", 0.6);
          setprop("/controls/gear/brake-right", 0.6);
        }

        elsif (getprop("/controls/gear/autobrakes") == 4) {
          # autobrakes set to level MAX
          setprop("/controls/gear/brake-left", 0.8);
          setprop("/controls/gear/brake-right", 0.8);
        }

        elsif (getprop("/controls/gear/autobrakes") == 5) {
          # autobrakes set to level MAX
          setprop("/controls/gear/brake-left", 1.0);
          setprop("/controls/gear/brake-right", 1.0);
        }

        elsif (getprop("/controls/gear/autobrakes") == 6) {
          # autobrakes set to level RTO
	if (getprop("/velocities/groundspeed-kt") > 85 and getprop("/controls/engines/engine/throttle") == 0) {
          setprop("/controls/gear/brake-parking", 1.0);
        }
	}

	}

	settimer(autobrake, 0.1);
}

_setlistener("/sim/signals/fdm-initialized", autobrake); 