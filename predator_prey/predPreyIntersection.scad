// File predPreyIntersection.scad
// Plots Lotka–Volterra equations in 3D space
// (c) 2018-2022 Rich Cameron, for the book Make:Calculus
// Licensed under a Creative Commons, Attribution,
// CC-BY 4.0 international license, per
// https://creativecommons.org/licenses/by/4.0/
// Attribute to Rich Cameron, at
// repository github.com/whosawhatsis/Calculus

timestep = .1;
oversample = 30;
length = 20;

xyscale = 25;
zscale = 6;

originmarker = 0;
line = 0; //slow
minthick = 1;

a = 2/3;
b = 4/3;
p = 1;
q = 1;
K = 0; //set to zero to disable (infinite carrying capacity)

//start = [p/q, a/b];
start = [0.6, 0.4];

axis = [1, 0, 0];

$fs = .2;
$fa = 2;

//function x(x, y) = x + timestep / oversample * (a * x - b * x * y); //basic  prey equation
function x(x, y) = x + timestep / oversample * (a * x * (K ? (1 - x / K) : 1) - b * x * y); //prey with carrying capacity if K != 0
function y(x, y) = y + timestep / oversample * (-p * y + q * x * y); //predators
function vx(x, y) = a * x - b * x * y;
function vy(x, y) = -p * y + q * x * y;

function xy(sample = length, values = [start]) = (sample <= 0) ? values : xy(sample - timestep / oversample, concat([[
		x(values[0][0], values[0][1])
	,
		y(values[0][0], values[0][1])
		]], values));

xy = xy();

*%for(z = [0:oversample:len(xy) - 1]) translate([100 * xy[steps * oversample - z][0], 100 * xy[steps * oversample - z][1], z / oversample]) cube(1);


difference() {
	union() {
		intersection() {
			rotate([0, -90, -90]) linear_extrude(1000, convexity = 10) polygon(concat([for(z = [0:oversample:len(xy) - 1]) [(floor((len(xy) - 1) / oversample) - z / oversample) * timestep * zscale, xyscale * xy[z][0]]], [[0, 0], [floor((len(xy) - 1) / oversample) * timestep * zscale, 0]]));
			mirror([1, -1, 0]) rotate([0, -90, -90]) linear_extrude(1000, convexity = 10) polygon(concat([for(z = [0:oversample:len(xy) - 1]) [(floor((len(xy) - 1) / oversample) - z / oversample) * timestep * zscale, xyscale * xy[z][1]]], [[0, 0], [floor((len(xy) - 1) / oversample) * timestep * zscale, 0]]));
			*linear_extrude((len(xy) - 1) / oversample * zscale, convexity = 5) {
				square([c/d * xyscale, a/b * xyscale]);
				hull() for(z = [0:oversample:len(xy) - 1]) translate([c/d * xyscale, a/b * xyscale, 0]) mirror([(xy[z][0] < c/d) ? 1 : 0, 0, 0]) mirror([0, (xy[z][1] < a/b) ? 1 : 0, 0]) square([abs(xy[z][0] - c/d), abs(xy[z][1] - a/b)] * xyscale);
			}
		}
		if(line) intersection() {
			cube([1000, 1000, floor((len(xy) - 1) / oversample) * timestep * zscale]);
			for(z = [0:oversample:len(xy) - 2]) hull() for(z = [z, z + oversample]) translate([xyscale * xy[z][0], xyscale * xy[z][1], (floor((len(xy) - 1) / oversample) - z / oversample) * timestep * zscale]) sphere(line / 2);
		}
		if(minthick) intersection() {
			cube([1000, 1000, floor((len(xy) - 1) / oversample) * timestep * zscale]);
			for(z = [0:oversample:len(xy) - 2]) hull() for(z = [z, z + oversample]) 
			translate([0, 0, (floor((len(xy) - 1) / oversample) - z / oversample) * timestep * zscale]) {
				linear_extrude(minthick, center = true) hull() {
					translate([xyscale * max([0, xy[z][0] - xy[z][1]]), xyscale * max([0, xy[z][1] - xy[z][0]]), 0]) square(minthick / sqrt(2));
					translate([xyscale * xy[z][0] - minthick / 2, xyscale * xy[z][1] - minthick / 2, 0]) rotate(180) square(minthick / sqrt(2));
				}
				linear_extrude(.001, center = true) hull() {
					translate([xyscale * max([0, xy[z][0] - xy[z][1]]), xyscale * max([0, xy[z][1] - xy[z][0]]), 0]) square(minthick / sqrt(2));
					translate([xyscale * xy[z][0], xyscale * xy[z][1], 0]) rotate(180) square(minthick / sqrt(2));
				}
			}
		}
	}
	if(originmarker) hull() for(i = [0, 1]) mirror([0, 0, i]) cylinder(r = originmarker, r2 = 0, h = originmarker, $fn = 4);
}

function integrate(v, c = 0, sum = []) = (len(v) == len(sum)) ? sum : integrate(v, c, concat(sum, [len(sum) ? sum[len(sum) - 1] + v[len(sum)] : v[0] + c]));