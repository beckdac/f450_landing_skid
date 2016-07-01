// Requires OpenSCAD 2016.3+

/* [Main] */

// select part
part = "assembly";
//part = "tFitting";
//part = "arrowShaft";
//part = "mountPlate";

/* [Misc] */
plateThickness = 4;	// thickness of mount plate
partThickness = 4;	// thickness of walls (not mount plate) 
iFitAdjust = .4;	// interference fit adjustment for 3D printer
cylHeightExt = .1;	// for overcutting on differences so they render correctly, nothing more, some small positive value
// render quality
$fn = 64; // [24:low quality, 48:development, 64:production]

/* [tFitting] */
tFittingCaptureLength = 30;

/* [arrowShaft] */
arrowShaftOD = 7.7;
arrowShaftThickness = 1;
arrowShaftID = arrowShaftOD - 2 * arrowShaftThickness;

/* [mountPlate] */

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
	tFitting(40);
}

module tFitting(tAngle) {
	//rotate([0, 0, tAngle])
	union() {
		/* horizontal of T */
		difference() {
			cylinder(h=tFittingCaptureLength,
				d=arrowShaftOD + 2 * partThickness, center=true);
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
				cylinder(h=tFittingCaptureLength,
					d=arrowShaftOD + 2 * partThickness, center=true);
				cylinder(h=tFittingCaptureLength + cylHeightExt,
					d=arrowShaftOD, center=true);
			}
		 // remove T
		 cylinder(h=tFittingCaptureLength + cylHeightExt,
				d=arrowShaftOD + 2 * partThickness, center=true);
		}
		translate([0, partThickness + arrowShaftOD / 2, 0])
		rotate([0, 90, 0])
			cube([2 * partThickness,
				2 * partThickness,
				arrowShaftOD + 2 * partThickness], center=true);
	}
}

module mountPlate() {

}

module arrowShaft(arrowShaftLength) {
	difference() {
		cylinder(h=arrowShaftLength, d=arrowShaftOD, center=true);
		cylinder(h=arrowShaftLength + cylHeightExt, d=arrowShaftID, center=true);
	}
}

module mountPlate() {

}
