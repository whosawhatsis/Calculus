// File phaseSpace.scad
// Plots Lotka–Volterra equations in phase space
// (c) 2018-2022 Rich Cameron, for the book Make:Calculus
// Licensed under a Creative Commons, Attribution,
// CC-BY 4.0 international license, per
// https://creativecommons.org/licenses/by/4.0/
// Attribute to Rich Cameron, at
// repository github.com/whosawhatsis/Calculus

xyfactor = 25;
zfactor = 200;

a = 2/3;
b = 4/3;
p = 1;
q = 1;

function f(x, y) = zfactor * exp(-((b * (y + 0) / xyfactor - a * ln((y + 0) / xyfactor) + q * (x + 0) / xyfactor - p * ln((x + 0) / xyfactor))));
//function f(x, y) = zfactor * pow((y + .001) / xyfactor, a) * exp(-b * (y + .001) / xyfactor) * pow((x + .001) / xyfactor, p) * exp(-q * (x + .001) / xyfactor); // alternate form

starts = [[.4, .6], [.4, 1.2], [1.2, 0.6], [1.2, 2.2]];

orbitheight = .4;

t = 0; //Thickness along z axis. t = 0 gives a flat base at z = 0
range = [90, 90]; //Range of [x, y] values to graph. Also controls those dimensions of the exported model.
res = 1; //Surface resolution in mm. Higher numbers produce a smoother surface, but take longer to generate.
originmarker = 0; //radius of an octahedral cutout placed at [0, 0, 0] to mark the origin. Set to zero to disable.

s = [round((range[0] - res/2) / res), round(range[1] / res * 2 / sqrt(3))];
seg = [range[0] / (s[0] - .5), range[1] / s[1]];

function r(x, y, cx = range[0]/2, cy = range[1]/2) = sqrt(pow(cx - x, 2) + pow(cy - y, 2));
function theta(x, y, cx = range[0]/2, cy = range[1]/2) = atan2((cy - y), (cx - x));
function zeronan(n) = (n == n) ? n : 0;

points = concat(
	[for(y = [0:s[1]], x = [0:s[0]]) [
		seg[0] * min(max(x - (y % 2) * .5, 0), s[0] - .5),
		seg[1] * y,
		zeronan(f(seg[0] * min(max(x - (y % 2) * .5, 0), s[0] - .5), seg[1] * y))
	]], [for(y = [0:s[1]], x = [0:s[0]]) [
		seg[0] * min(max(x - (y % 2) * .5, 0), s[0] - .5),
		seg[1] * y,
		t ? zeronan(f(seg[0] * min(max(x - (y % 2) * .5, 0), s[0] - .5), seg[1] * y)) - t : 0
	]]
);
*for(i = points) translate(i) cube(.1, center = true);
	
function order(point, reverse) = [for(i = [0:2]) point[reverse ? 2 - i : i]];
function mirror(points, offset) = [for(i = [0, 1], point = points) order(point + (i ? [0, 0, 0] : [offset, offset, offset]), i)];

polys = concat(
	mirror(concat([
		for(x = [0:s[0] - 1], y = [0:s[1] - 1]) [
			x + (s[0] + 1) * y,
			x + 1 + (s[0] + 1) * y,
			x + 1 - (y % 2) + (s[0] + 1) * (y + 1)
		]
	], [
		for(x = [0:s[0] - 1], y = [0:s[1] - 1]) [
			x + (y % 2) + (s[0] + 1) * y,
			x + 1 + (s[0] + 1) * (y + 1),
			x + (s[0] + 1) * (y + 1)
		]
	]), len(points) / 2),
	mirror([for(x = [0:s[0] - 1], i = [0, 1]) order([
		x + (i ? 0 : 1 + len(points) / 2),
		x + 1,
		x + len(points) / 2
	], i)], len(points) / 2 - s[0] - 1),
	mirror([for(y = [0:s[1] - 1], i = [0, 1]) order([
		y * (s[0] + 1) + (i ? 0 : (s[0] + 1) + len(points) / 2),
		y * (s[0] + 1) + (s[0] + 1),
		y * (s[0] + 1) + len(points) / 2
	], 1 - i)], s[0])
);

//echo(points);

difference() {
	union() {
		for(start = starts) scale([1, 1, (f(start[0] * xyfactor, start[1] * xyfactor) + orbitheight) / .001]) intersection() {
			cube([range[0], range[1], .001]);
			translate([0, 0, -f(start[0] * xyfactor, start[1] * xyfactor)]) polyhedron(points, polys);
		}
		polyhedron(points, polys, convexity = 5);
	}
	if(originmarker) hull() for(i = [0, 1]) mirror([0, 0, i]) cylinder(r = originmarker, r2 = 0, h = originmarker, $fn = 4);
}