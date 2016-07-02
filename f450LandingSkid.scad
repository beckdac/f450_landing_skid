// Requires OpenSCAD 2016.3+
use <BezierScad/BezierScad.scad>;

/* [Main] */

// select part
part = "assembly";
//part = "tFitting";
//part = "arrowShaft";
//part = "mountPlate";

/* [Misc] */
plateThickness = 4;	// thickness of mount plate
partThickness = 3;	// thickness of walls (not mount plate) 
iFitAdjust = .4;	// interference fit adjustment for 3D printer
cylHeightExt = .1;	// for overcutting on differences so they render correctly, nothing more, some small positive value
M3D = 3.1;			// M3 screw diameter
// render quality
$fn = 64; // [24:low quality, 48:development, 64:production]

/* [tFitting] */
tFittingCaptureLength = 30;

/* [arrowShaft] */
arrowShaftOD = 7.7;
arrowShaftThickness = 1;
arrowShaftID = arrowShaftOD - 2 * arrowShaftThickness;

/* [mountPlate] */
mountPlateScrewD = 4;
mountPlateScrewSep = 33.5; // tbm
upperArmLength = 100;


render_part();

module render_part() {
	if (part == "assembly") {
		assembly();
	} else if (part == "tFitting") {
		tFitting();
	} else if (part == "arrowShaft") {
		arrowShaft();
	} else if (part == "mountPlate") {
		mountPlate();
	} else {
		// invalid value
	}
}

module assembly() {
	//arrowShaft(100);
	//tFitting();
	mountPlate();
}

module tFitting() {
  difference() {
	union() {
		/* horizontal of T */
		difference() {
			cube([arrowShaftOD + 2 * partThickness,
				arrowShaftOD + 2 * partThickness,
				tFittingCaptureLength], center=true);
			cylinder(h=tFittingCaptureLength + cylHeightExt,
				d=arrowShaftOD, center=true);
		}
		/* perpendicular */
		difference() {
		  translate([0,
				tFittingCaptureLength / 4 + ((arrowShaftOD + 2 * partThickness) / 2),
				0])
		   rotate([90, 0, 0])
			difference() {
				cube([arrowShaftOD + 2 * partThickness,
					arrowShaftOD + 2 * partThickness,
					tFittingCaptureLength], center=true);
				cylinder(h=tFittingCaptureLength + cylHeightExt,
					d=arrowShaftOD, center=true);
			}
		 // remove T
		 cylinder(h=tFittingCaptureLength + cylHeightExt,
				d=arrowShaftOD + 2 * partThickness, center=true);
		}
		translate([0, partThickness + arrowShaftOD / 2, 0])
		rotate([0, 90, 0]) {
			cube([arrowShaftOD + 2 * partThickness,
				2 * partThickness,
				arrowShaftOD + 2 * partThickness], center=true);
		}
	}
			translate([(arrowShaftOD + 2 * partThickness) / 2
					- iFitAdjust / 2
					,
				arrowShaftOD + 2 * partThickness,
				0])
			cube([arrowShaftOD + 2 * partThickness + cylHeightExt,
				3.2 * (arrowShaftOD + 2 * partThickness),
				tFittingCaptureLength * 1.1], center=true);
		translate([0, partThickness + arrowShaftOD / 2, 0])
			rotate([0, 90, 0])
				cylinder(h=arrowShaftOD + 2 * partThickness + cylHeightExt,
					d=M3D, center=true);
  }
}

module arrowShaft(arrowShaftLength) {
	difference() {
		cylinder(h=arrowShaftLength, d=arrowShaftOD, center=true);
		cylinder(h=arrowShaftLength + cylHeightExt, d=arrowShaftID, center=true);
	}
}

module mountPlate() {
	difference() {
		union() {
			cube([mountPlateScrewSep + 4 * mountPlateScrewD,
				4 * mountPlateScrewD,
				plateThickness], center=true);
			hull() {
			}
			for (i = [-1,1]) {
				x = 60;
			#	translate([i * (mountPlateScrewSep + 4 * mountPlateScrewD) /2, 
					mountPlateScrewD * 2, 0])
			#	rotate([90, 0, 0])
				BezWall([
						[0, 0],
						[i * x, 0],
						[i * x, -x * 2]
					], width = plateThickness, height = 4 * mountPlateScrewD, steps = 32, centered=true);
			}
			/* horizontal of T */
			for (i = [-1, 1])
				translate([i * (mountPlateScrewSep + 4 * mountPlateScrewD) / 2,
					, 0, plateThickness / 2  -(arrowShaftOD + 2 * partThickness) / 2])
				rotate([90, 0, 0])
				difference() {
					hull() {
						cylinder(h=4 * mountPlateScrewD,
							d=arrowShaftOD + 2 * partThickness, center=true);
						translate([-i * (4 * mountPlateScrewD),
								(arrowShaftOD + 2 * partThickness) / 2,
								0])
							#cylinder(h=4 * mountPlateScrewD,
								d=.00001, center=true);
					}
					cylinder(h=4 * mountPlateScrewD + cylHeightExt,
						d=arrowShaftOD, center=true);
			}
		}
		for (i=[-1, 1])
			translate([i * mountPlateScrewSep / 2, 0, 0])
				cylinder(h=plateThickness + cylHeightExt, d=mountPlateScrewD, center=true);
	}
}
