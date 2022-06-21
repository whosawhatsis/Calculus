// File revolution.scad
// Creates volumes of revolution from a function
// along with the matching curve
// both pieces have a hole for a wire to allow rotation
// (c) 2021-2022 Rich Cameron, for the book Make:Calculus
// Licensed under a Creative Commons, Attribution,
// CC-BY 4.0 international license, per
// https://creativecommons.org/licenses/by/4.0/
// Attribute to Rich Cameron, at
// repository github.com/whosawhatsis/Calculus

function f(x) = x;
//function f(x) = exp(x);
//function f(x) = pow(x, 1/3);

xmin = 0;
xmax = 2;
xunit = 30; //scale of x axis in mm

steps = 100;
flip = true;

wall = 4; //width of 2D line 
thick = 4; // thickness of 2D line
hole = 2; // size of pivot hole
clearance = .3; //clearance between 2D and 3D shape 

$fs = .2;
$fa = 2;

for (x = [xmin:(xmax - xmin) / steps:xmax]) assert(f(x) >= 0, "function must be positive for xmin <= x <= xmax");

translate([0, wall + clearance + 1 + xunit * max([for(x = [xmin:(xmax - xmin) / steps:xmax]) f(x)]), 0]) frame();
translate([0, 0, flip ? xunit * (xmax - xmin) : 0]) mirror([0, 0, flip ? 1 : 0]) revolution();

module shape() {
	translate([0, -xunit * xmin, 0]) polygon(xunit * concat([[0, xmax], [0, xmin]], [for (x = [xmin:(xmax - xmin) / steps:xmax]) [f(x), x]]));
}

module frame() translate([0, 0, thick / 2]) {
	difference() {
		union() {
			for(i = [0, 1]) translate([0, -clearance + i * (xunit * (xmax - xmin) + wall + clearance * 2), 0]) rotate([90, 0, 0]) linear_extrude(wall, convexity = 5) mirror([1, 0, 0]) intersection() {
				circle(wall);
				square([wall * 2, thick], center = true);
			};
			linear_extrude(thick, center = true, convexity = 5) difference() {
				offset(wall + clearance) shape();
				translate([0, -(wall + clearance + 1), 0]) mirror([1, 0, 0]) square([wall + clearance + 1, xunit * (xmax - xmin) + (wall + clearance + 1) * 2]);
				offset(clearance) shape();
			}
		}
		rotate([90, 0, 0]) cylinder(r = hole / 2, h = 1000, center = true);
	}
	#%linear_extrude(.1) shape();
}

module revolution(bottom = false) rotate_extrude() intersection() {
	mirror([0, bottom ? 1 : 0, 0]) shape();
	translate([hole / 2, 0, 0]) square(1000); 
}
