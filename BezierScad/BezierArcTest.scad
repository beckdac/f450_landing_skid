use <BezierScad.scad>;

BezArc([
  [-10,-1],
  [-10, -6],
  [-1, -1],
  [-5, -10],
  [-1,-10]
  ], [-1,-1], steps = 32, heightCtls = [1,2,10,2,1]);

difference() {
translate([25,0,0]) 
    BezArc([
      [-10, 0],
      [-10, -6],
      [-1, -1],
      [-5, -10],
      [0,-10]
      ], focalPoint = [0,0], steps = 30, heightCtls = [5,7,8,7,5]);
 translate([28,0,0]) 
    BezArc([
      [-10, 0],
      [-10, -6],
      [-1, -1],
      [-5, -10],
      [0,-10]
      ], focalPoint = [0,0], steps = 30, heightCtls = [6,8,9,8,6]);
}