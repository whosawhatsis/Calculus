// File derivativeintegral.scad
// Plots two perpendicular curves
// d(x) is the derivative of f(x) and
// f(x) is the integral of d(x)
// the numerically calculated  integral and derivative are
// shown in red for comparison, but not printed
// (c) 2018-2022 Rich Cameron, for the book Make:Calculus
// Licensed under a Creative Commons, Attribution,
// CC-BY 4.0 international license, per
// https://creativecommons.org/licenses/by/4.0/
// Attribute to Rich Cameron, at
// repository github.com/whosawhatsis/Calculus

function custom_f(x) = sin(rad2deg(x)) / 2 + x;
function custom_d(x) = cos(rad2deg(x)) / 2 + 1;

xmin = 0;
xmax = 2;
xmark = .2;
xunit = 0; //scale of x axis in mm

steps = 100;
thick = 1.6;

flip = false;
vasewidth = 0;
base = 0;

c = true; // use +c to make the calculated integral match (does not affect STL)


func = "custom"; // ["custom", "x^2 / 2", "sin(x)", "e^(x / 2)", "e^x", "x^2 / 2 - 4.5", "x^3 / 12 - x", "x^2 / 4 - 1", "-cos(x) * sin(y) + 1.5, x = 0", "-cos(x) * sin(y) + 1.5, x = 4", "-cos(x) * sin(y) + 1.5, y = 5", "x^3 / 6 - x - .5", "9.6/16 * x^2 (lego)", "-e^(-2 * x) / 2 + .5", "sin(x) / 2 + x"]

{} // end customizer

unit = xunit ? xunit : 100 / abs(xmax - xmin);
step = (xmax - xmin) / steps;

function f(x) = unit * (
	(func == "x^2 / 2") ? pow(x, 2) / 2:
	(func == "sin(x)") ? sin(rad2deg(x)):
	(func == "e^(x / 2)") ? .5 * exp(x / 2):
	(func == "e^x") ? .5 * exp(x):
	(func == "x^2 / 2 - 4.5") ? pow(x, 2) / 2 - 4.5:
	(func == "x^3 / 12 - x") ? pow(x, 3) / 12 - x:
	(func == "x^2 / 4 - 1") ? pow(x, 2) / 4 - 1:
	(func == "-cos(x) * sin(y) + 1.5, x = 0") ? -cos(rad2deg(0)) * sin(rad2deg(x)) + 1.5:
	(func == "-cos(x) * sin(y) + 1.5, x = 4") ? -cos(rad2deg(4)) * sin(rad2deg(x)) + 1.5:
	(func == "-cos(x) * sin(y) + 1.5, y = 5") ? -cos(rad2deg(x)) * sin(rad2deg(5)) + 1.5:
	(func == "x^3 / 6 - x - .5") ? pow(x, 3) / 6 - x - .5:
	(func == "9.6/16 * x^2 (lego)") ? 9.6/16 * pow(x, 2):
	(func == "-e^(-2 * x) / 2 + .5") ? -exp(-2 * x) / 2 + .5:
	(func == "sin(x) / 2 + x") ? sin(rad2deg(x)) / 2 + x:
	custom_f(x)); // default
/**/

function d(x) = unit * (
	(func == "x^2 / 2") ? x:
	(func == "sin(x)") ? cos(rad2deg(x)):
	(func == "e^(x / 2)") ? .5 * exp(x / 2) / 2:
	(func == "e^x") ? .5 * exp(x):
	(func == "x^2 / 2 - 4.5") ? x:
	(func == "x^3 / 12 - x") ? pow(x, 2) / 4 - 1:
	(func == "x^2 / 4 - 1") ? pow(x, 1) / 2:
	(func == "-cos(x) * sin(y) + 1.5, x = 0") ? -cos(rad2deg(0)) * cos(rad2deg(x)):
	(func == "-cos(x) * sin(y) + 1.5, x = 4") ? -cos(rad2deg(4)) * cos(rad2deg(x)):
	(func == "-cos(x) * sin(y) + 1.5, y = 5") ? sin(rad2deg(x)) * sin(rad2deg(5)):
	(func == "x^3 / 6 - x - .5") ? pow(x, 2) / 2 - 1:
	(func == "9.6/16 * x^2 (lego)") ? 9.6/16 * 2 * x:
	(func == "-e^(-2 * x) / 2 + .5") ? exp(-2 * x):
	(func == "sin(x) / 2 + x") ? cos(rad2deg(x)) / 2 + 1:
	custom_d(x)); // default


x = [for(x = [xmin:step:xmax + step / 2]) x];
integral = integrate([for(x = x) d(x) * step], (c ? f(xmin) : 0) - step * d(0));
f = [for(x = x) [unit * x, f(x)]];
d = [for(x = x) [unit * x, d(x)]];
_f = [for(i = [0 : len(integral) - 1]) [unit * x[i], integral[i]]];
_d = [for(x = x) [unit * x, (f(x + step / 2) - f(x - step / 2)) / step]];
	
$fs = .2;
$fa = 2;

if(thick) {
	rotate([flip ? 180 : 0, 0, 0]) {
		translate([0, 0, flip ? -unit * (xmax - xmin) : 0]) {
			3d();
			if(vasewidth) vase();
		}
		translate([0, 0, flip ? base : 0]) base(base);
	}
}
else {
	2d();
	%3d(1);
}

module 2d() difference() {
	union() {
		intersection() {
			union() for(m = [0, 1]) mirror([0, m, 0]) f_poly();
			translate([-1000, 0, 0]) square(2000);
		}
		intersection() {
			union() for(m = [0, 1]) mirror([0, m, 0]) d_poly();
			translate([-1000, -2000, 0]) square(2000);
		}
	}
	for(x = [ceil(xmin + step):xmax - step]) translate([x * unit, 0, 0]) square([.0001, 1000], center = true);
}
module 3d(thick = thick) translate([0, 0, unit * xmax]) rotate([0, 90 ,0]) {
	difference() {
		union() {
			linear_extrude(thick, center = true) f_poly();
			rotate([90, 0, 0]) linear_extrude(thick, center = true) d_poly();
		rotate([0, 90, 0]) translate([0, 0, xmin * unit]) cylinder(r = thick / 2, h = (xmax - xmin) * unit);
		}
		if(ceil(xmin + step) < (xmax - step)) for(x = [ceil(xmin):xmax - step]) translate([x * unit, 0, 0]) cube([1, 1000, 1000], center = true);
	}
		
	#%translate([0, 0, xmark / 2]) linear_extrude(thick, center = true) f_poly(_f);
	#%rotate([90, 0, 0]) translate([0, 0, -xmark / 2]) linear_extrude(thick, center = true) d_poly(_d);
		
	if(ceil(xmin + step) < (xmax - step)) 
	intersection() {
		union() {
			translate([0, 0, xmark]) linear_extrude(thick, center = true) f_poly();
			rotate([90, 0, 0]) translate([0, 0, -xmark]) linear_extrude(thick, center = true) d_poly();
			rotate([0, 90, 0]) translate([-xmark, xmark, xmin * unit]) cylinder(r = thick / 2, h = (xmax - xmin) * unit);
		}
		union() for(x = [ceil(xmin + step):xmax - step]) translate([x * unit, 0, 0]) cube([1, 1000, 1000], center = true);
	}
}

module f_poly(f = f) offset((xmax - xmin) / 100) offset(-(xmax - xmin) / 101) polygon(concat(f, [[max(x) * unit, 0], [min(x) * unit, 0]]));
module d_poly(d = d) offset((xmax - xmin) / 100) offset(-(xmax - xmin) / 101) polygon(concat(d, [[max(x) * unit, 0], [min(x) * unit, 0]]));

module vase() translate([0, 0, unit * xmax]) rotate([0, 90, -90]) {
	for(i = [0, 1]) translate([0, 0, i * (vasewidth + thick)]) linear_extrude(thick, center = true) {
		for(i = [1, -1]) translate([0, thick * i, 0]) d_poly();
		translate([unit * xmin, -thick, 0]) square([unit * (xmax - xmin), thick * 2]);
	}
	linear_extrude(vasewidth + thick, convexity = 5) for(i = [-1, 1]) {
		difference() {
			union() {
				translate([0, thick * i, 0]) d_poly();
				translate([unit * xmin, -thick, 0]) square([unit * (xmax - xmin), thick * 2]);
			}
			d_poly();
		}
	}
	echo([for(x = [xmin:xmax]) f(x)]);
	echo([for(x = [xmin:xmax]) f(x) * unit * vasewidth / 1000]);
}


module base(height = 0) if(height) mirror([0, 0, 1]) linear_extrude(height) offset(thick / 3)  offset(-thick / 3) hull() {
	square(thick, center = true);
	translate([0, max([for(x = x) f(x)]), 0]) square([thick, .01], center = true);
	translate([0, min([for(x = x) f(x)]), 0]) square([thick, .01], center = true);
	translate([max([for(x = x) d(x)]), 0, 0]) square([.01, thick], center = true);
	translate([min([for(x = x) d(x)]), 0, 0]) square([.01, thick], center = true);
	if(vasewidth) {
		translate([0, -vasewidth / 2 - thick / 2, 0]) square([thick * 2, thick * 2 + vasewidth], center = true);
		translate([max([for(x = x) d(x)]), -vasewidth / 2 - thick / 2, 0]) square([thick * 2, thick * 2 + vasewidth], center = true);
		translate([min([for(x = x) d(x)]), -vasewidth / 2 - thick / 2, 0]) square([thick * 2, thick * 2 + vasewidth], center = true);
	}
}

function integrate(v, c = 0, sum = []) = (len(v) == len(sum)) ? sum : integrate(v, c, concat(sum, [len(sum) ? sum[len(sum) - 1] + v[len(sum)] : v[0] + c]));

function rad2deg(radians) = radians * 180 / PI;