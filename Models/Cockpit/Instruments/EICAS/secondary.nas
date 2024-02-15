var B744SecondaryEICAS = {
	init: func() {
		me.canvas = canvas.new({
			"name": "lowerEICAS",
			"size": [1024, 1024],
			"view": [1024, 1024],
			"mipmapping": 1
		});
		me.canvas.addPlacement({"node": "Lower-EICAS-Screen"});
		
		me.font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};
	},
};

B744SecondaryEICAS.init();

var showSecondaryEICAS = func {
	var dlg = canvas.Window.new([600, 600], "dialog")
        .set("resize", 1)
 		.lockAspectRatio()
 		.setTitle("Secondary EICAS")
	    .setCanvas(B744SecondaryEICAS.canvas);
}

var setSecondaryEICASPage = func(page) {
	if (page == getprop("/instrumentation/eicas/display")) {
		setprop("/instrumentation/eicas/display", "");
	} else {
		setprop("/instrumentation/eicas/display", page);
	}
}