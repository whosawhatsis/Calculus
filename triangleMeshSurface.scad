// File triangleMeshSurface.scad
// Creates a 3D surface z = f(x, y)
// (c) 2018-2022 Rich Cameron, for the book Make:Calculus
// Licensed under a Creative Commons, Attribution,
// CC-BY 4.0 international license, per
// https://creativecommons.org/licenses/by/4.0/
// Attribute to Rich Cameron, at
// repository github.com/whosawhatsis/Calculus

t = 0; //Thickness along z axis. t = 0 gives a flat base at z = 0
unit = 1;
range = [90, 90]; //Range of [x, y] values to graph. Also controls those dimensions of the exported model.
res = .5; //Surface resolution in mm. Higher numbers produce a smoother surface, but take longer to generate.
originmarker = 0; //radius of an octahedral cutout placed at [0, 0, 0] to mark the origin. Set to zero to disable.
blockymode = false;

//Surface for limits in Chapter 3
/*
t = 2.4;
zscale = 48;
unit = 1;
range = [64, 64];
center = [range[0]/2, range[1]/2];
function f(x, y) = (y - center[1]) * pow(x - center[0], 3) / range[1] / pow(range[0] / 2, 3) * zscale + zscale / 2 + 1;
/**/

//Surface for partial derivatives in Chapter 5
/*
unit = 20;
range = unit * [4, 5];
function f(x, y) = unit * (-cos(x / unit * 180 / PI) * sin(y / unit * 180 / PI) + 1.5);
/**/

//Surface for double integral in Chapter 7
/*
range = [50, 100];
function f(x, y) = x * y / 50;
/**/

//Surface for double integral in Chapter 7 (french fry method)
/*
res = 4;
blockymode = true;
range = [50, 100];
function f(x, y) = x * y / 50;
/**/

//Logistic function surface in Chapter 8
/*
Pzero = 1;
a = 0.2; //rate
function f(x, y) = (y + 10) / (1 + ((y + 10) / Pzero - 1) * exp(-a * x));
/**/

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
		if(blockymode) for(x = [0:res:range[0]], y = [0:res:range[1]]) translate([x, y, 0]) cube([res, res, f(x, y)]);
		else polyhedron(points, polys, convexity = 5);
	}
	if(originmarker) hull() for(i = [0, 1]) mirror([0, 0, i]) cylinder(r1 = originmarker, r2 = 0, h = originmarker, $fn = 4);
}