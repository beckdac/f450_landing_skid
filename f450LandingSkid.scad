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
skidHeight = 140;
arrowShaftCurveTrans = .17;
// below taken from https://www.metricmcc.com/catalog/Ch1/1-32.pdf
mountPlateScrewCapD = 7 + iFitAdjust;
mountPlateScrewCapHeight = 4;

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
			for (i = [-1,1]) {
			 difference() {
			  union() {
				translate([i * (mountPlateScrewSep + 4 * mountPlateScrewD) /2, 
						mountPlateScrewD * 2, 0])
					rotate([90, 0, 0]) {
						BezWall([
								[0, 0],
								[i * skidHeight / 3.5, 0],
								[i * skidHeight / 2, -skidHeight * .9],
								[i * skidHeight / 2, -skidHeight]
							], widthCtls = [plateThickness, plateThickness, plateThickness, 3 * plateThickness ],
							height = 4 * mountPlateScrewD, steps = 32, centered=true);
					}
				// bracing arm
				translate([i * (mountPlateScrewSep + 4 * mountPlateScrewD) /2, 
						mountPlateScrewD * 2, 0])
					rotate([90, 0, 0]) {
						BezWall([
								[0, - plateThickness],
								[i * skidHeight / 3.5, 0],
								[i * skidHeight / 2, -skidHeight * .9],
								[i * skidHeight / 2, -skidHeight]
							], widthCtls = [3 * plateThickness, 3 * plateThickness, 3 * plateThickness, 3 * plateThickness ],
							height =  plateThickness, steps = 32, centered=true);
					}
				translate([i * skidHeight / 2 + i * skidHeight * (arrowShaftCurveTrans), 
						0, -skidHeight])
					rotate([90, 0, 0]) {
						difference() {
							cylinder(h=4 * mountPlateScrewD,
								d=arrowShaftOD + 2 * partThickness, center=true);
							cylinder(h=4 * mountPlateScrewD + cylHeightExt,
							d=arrowShaftOD, center=true);
						}
					}
			  }
				translate([i * skidHeight / 2 + i * skidHeight * (arrowShaftCurveTrans), 
						0, -skidHeight])
					rotate([90, 0, 0]) {
							cylinder(h=4 * mountPlateScrewD + cylHeightExt,
							d=arrowShaftOD, center=true);
					}
			 }
			}
			/* horizontal of T */
			for (i = [-1, 1])
				translate([i * (mountPlateScrewSep + 4 * mountPlateScrewD) / 2,
					0, plateThickness / 2  -(arrowShaftOD + 2 * partThickness) / 2])
				rotate([90, 0, 0])
				difference() {
					hull() {
						cylinder(h=4 * mountPlateScrewD,
							d=arrowShaftOD + 2 * partThickness, center=true);
						translate([-i * (4 * mountPlateScrewD),
								(arrowShaftOD + 2 * partThickness) / 2,
								0])
							cylinder(h=4 * mountPlateScrewD,
								d=.00001, center=true);
					}
					cylinder(h=4 * mountPlateScrewD + cylHeightExt,
						d=arrowShaftOD, center=true);
			}
		}
		for (i=[-1, 1]) {
			translate([i * mountPlateScrewSep / 2, 0, 0])
				cylinder(h=plateThickness * 10 + cylHeightExt, d=mountPlateScrewD, center=true);
			translate([i * mountPlateScrewSep / 2, 0, - 1.7 * plateThickness])
				cylinder(h=mountPlateScrewCapHeight * 2, d=mountPlateScrewCapD, center=true);
		}
		for (i = [-1, 1])
			translate([i * (mountPlateScrewSep + 4 * mountPlateScrewD) / 2,
				0, plateThickness / 2  -(arrowShaftOD + 2 * partThickness) / 2])
			rotate([90, 0, 0])
					cylinder(h=4 * mountPlateScrewD + cylHeightExt,
						d=arrowShaftOD, center=true);
	}
}
