# engine pump ON, system pressurised when N2 > 20-30%
# demand pumps 2, 3 are AC 2, 3.
# AUX pump is AC 1.
# demand pumps 1, 4 are air driven.

var sys = 'systems/hydraulic/';
var controls = 'controls/hydraulic/';
var ticks = 4;

var HDP = [
	props.globals.initNode(controls~'demand-pump[0]', 0, 'INT'),
	props.globals.initNode(controls~'demand-pump[1]', 0, 'INT'),
	props.globals.initNode(controls~'demand-pump[2]', 0, 'INT'),
	props.globals.initNode(controls~'demand-pump[3]', 0, 'INT'),
	  ];
var EDP = [
	props.globals.initNode(controls~'engine-pump[0]', 0, 'BOOL'),
	props.globals.initNode(controls~'engine-pump[1]', 0, 'BOOL'),
	props.globals.initNode(controls~'engine-pump[2]', 0, 'BOOL'),
	props.globals.initNode(controls~'engine-pump[3]', 0, 'BOOL'),
	  ];
var SYS_FAULT = [
	props.globals.initNode(sys~'system-fault[0]', 1, 'BOOL'),
	props.globals.initNode(sys~'system-fault[1]', 1, 'BOOL'),
	props.globals.initNode(sys~'system-fault[2]', 1, 'BOOL'),
	props.globals.initNode(sys~'system-fault[3]', 1, 'BOOL'),
	  ];
var HDP_PRESS = [
	props.globals.initNode(sys~'demand-pump-pressure-low[0]', 1, 'BOOL'),
	props.globals.initNode(sys~'demand-pump-pressure-low[1]', 1, 'BOOL'),
	props.globals.initNode(sys~'demand-pump-pressure-low[2]', 1, 'BOOL'),
	props.globals.initNode(sys~'demand-pump-pressure-low[3]', 1, 'BOOL'),
	  ];
var EDP_PRESS = [
	props.globals.initNode(sys~'engine-pump-pressure-low[0]', 1, 'BOOL'),
	props.globals.initNode(sys~'engine-pump-pressure-low[1]', 1, 'BOOL'),
	props.globals.initNode(sys~'engine-pump-pressure-low[2]', 1, 'BOOL'),
	props.globals.initNode(sys~'engine-pump-pressure-low[3]', 1, 'BOOL'),
	  ];

props.globals.initNode(sys~'pressure[0]', 0, 'INT');
props.globals.initNode(sys~'pressure[1]', 0, 'INT');
props.globals.initNode(sys~'pressure[2]', 0, 'INT');
props.globals.initNode(sys~'pressure[3]', 0, 'INT');

var Hyd = {
  pressure : 0,		# int
  temp : 20,		# int
  qty  : 100,		# int

  new : func(n)
  {
    return {
      parents : [Hyd],
      n : n,
    };
  },

  dem_sw : func(inc)
  {
    var p = HDP[me.n];
    var i = p.getValue();
    i += inc;
    if (i > 2) i = 2;
    if (me.n == 3) {		# HYD 4 has AUTO (-1)
      if (i < -1) i = -1;
    } else
      if (i < 0) i = 0;
    p.setValue(i);
    ticks = 0;
  },

  edp_sw : func
  {
    var p = EDP[me.n];
    #var i = p.getValue();
    #i = !i;
    p.setValue(!p.getValue());
    ticks = 0;
  },

#  system-fault[0]
#	system pressure < 1200,
#	qty < 0.35
#	T > 105
#  demand-pump-pressure-low[0] 
#	pump running and HDP press < 1400,
#	pump fault,
#	selector OFF
#  engine-pump-pressure-low[0]
#	EDP press < 1400

  update : func
  {
    var aux = 0;
    var edp_running = getprop('engines/engine['~me.n~']/running') and 
			EDP[me.n].getValue();
    var dem_running = getprop('systems/electrical/ac-bus['~me.n~']') and
			HDP[me.n].getValue() > 0;
			# XXX bleed ADP for hyd 1,4 ?

    if (me.n == 3) aux = HDP[me.n].getValue() == -1 ? 1 : 0;
    if (dem_running or edp_running or aux) {
      if (me.pressure < 2800) me.pressure += (3000 - me.pressure) / 3 + rand() * 200;
      if (me.temp < 50) me.temp += 1;
    } else {
      # decay
      if (me.pressure > 0) me.pressure -= 250 + rand() * 50;
      if (me.temp > 20) me.temp -= 1;
    }

    # entropy
    if (rand() > 0.8) {
      var i = rand() - 0.5;
      i = i > 0 ? 20 : -20;
      me.pressure += i;
    }

    # update lights
    var i = 0;
    i = me.pressure < 1200 or me.qty < 35 or me.temp > 105 ? 1 : 0;
    setprop(sys, 'system-fault['~me.n~']', i);
    i = dem_running ? 0 : 1;
    setprop(sys, 'demand-pump-pressure-low['~me.n~']', i);
    i = edp_running ? 0 : 1;
    setprop(sys, 'engine-pump-pressure-low['~me.n~']', i);

    # update props
    if (me.pressure < 0) me.pressure = 0;
    setprop(sys, 'pressure['~me.n~']', me.pressure);
  }
};

var resched_update = func
{
  if (ticks == 0) {
    for (var i = 0; i < 4; i += 1)
      hyd_sys[i].update();
    ticks = 3;			# update every 4 sec
  }
  ticks -= 1;
  settimer(resched_update, 2);
}

# init

var hyd_sys = [Hyd.new(0), Hyd.new(1), Hyd.new(2), Hyd.new(3)];

resched_update();
