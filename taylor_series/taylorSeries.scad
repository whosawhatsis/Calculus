// File taylorSeries.scad
// Plots series expansions of sin, cos and e^x
// showing increasing numbers of terms along the z axis
// (c) 2019-2022 Rich Cameron, for the book Make:Calculus
// Licensed under a Creative Commons, Attribution,
// CC-BY 4.0 international license, per
// https://creativecommons.org/licenses/by/4.0/
// Attribute to Rich Cameron, at
// repository github.com/whosawhatsis/Calculus

func = 0; // [0:Sin, 1:Cos, 2:e^x]

thick = 1.2;
steps = 20;
clip = 40;

highlight = 6;

xstep = .1;
zstep = 2;

{} // end customizer

range = (func == 2) ? [-8, 4] : [-4 * PI, 4 * PI];
xyscale = (func == 2) ? 8 : 4;
 
$fs = .2;
$fa = 2;

color([1, .5, 1]) linear_extrude(zstep * (steps)) intersection() {
	union() for(x = [range[0]:xstep:range[1]]) hull() for(x = [x, x + xstep]) translate([xyscale * x, xyscale * (func ? (func == 2) ? exp(x) : cos(x * 180 / PI) : sin(x * 180 / PI)), 0]) circle(thick / 2);
	translate([xyscale * range[0], -clip, 0]) square([xyscale * (range[1] - range[0]), clip * 2]);
}

intersection() {
	union() for(i = [0:steps - 1]) color((!(i % 2) ? [1, 0, 0] : [0, .5, 1.]) * (1 - (floor(i / 2) % 2) * .7), alpha = .4) linear_extrude((i + 1) * zstep, convexity = steps) intersection() {
		offset(1) translate([xyscale * range[0], -clip, 0]) square([xyscale * (range[1] - range[0]), clip * 2]);
		union() {
			polygon(concat([for(x = [0:xstep:range[1] + xstep]) [xyscale * x, xyscale * (func ? (func == 2) ? series_exp(x, i) : series_cos(x, i) : series_sin(x, i))]], [for(x = [-range[1] - xstep:xstep:xstep]) [xyscale * -x, xyscale * (func ? (func == 2) ? exp(-x) + thick  / 2 / 2 / xyscale : cos(-x * 180 / PI) - thick / 2 / 2 / xyscale * pow(-1, i) : sin(-x * 180 / PI) - thick / 2 / 2 / xyscale * pow(-1, i))]]));
			if(range[0] < 0) polygon(concat([for(x = [.0001:xstep:-range[0] + xstep]) [xyscale * -x, xyscale * (func ? (func == 2) ? series_exp(-x, i) : series_cos(-x, i) : series_sin(-x, i))]], [for(x = [range[0] - xstep:xstep:xstep]) [xyscale * x, xyscale * (func ? (func == 2) ? exp(x) + thick / 2 / 2 / xyscale * ((i % 2) ? 1 : -1) : cos(x * 180 / PI) - thick / 2 / 2 / xyscale * pow(-1, i) : sin(x * 180 / PI) + thick / 2 / 2 / xyscale * pow(-1, i))]]));
		}
	}
	color([.5, .5, .5]) translate([xyscale * range[0], -clip, -1]) linear_extrude(zstep * steps + 2, convexity = steps) square([xyscale * (range[1] - range[0]), clip * 2]);
}

if(highlight) color([0, 0, 0, .7]) %translate([0, 0, zstep * highlight]) linear_extrude(thick * 2, center = true) intersection() {
	union() for(x = [range[0]:xstep:range[1]]) hull() for(x = [x, x + xstep]) translate([xyscale * x, xyscale * (func ? (func == 2) ? series_exp(x, highlight - 1) : series_cos(x, highlight - 1) : series_sin(x, highlight - 1)), 0]) circle(thick);
	translate([xyscale * range[0], -clip, 0]) square([xyscale * (range[1] - range[0]), clip * 2]);
}

function fact(n) = n ? n * fact(n - 1) : 1;

function series_sin(x, n) = pow(-1, n) * pow(x, n * 2 + 1) / fact(n * 2 + 1) + (n ? series_sin(x, n - 1) : 0);
function series_cos(x, n) = pow(-1, n) * pow(x, n * 2) / fact(n * 2) + (n ? series_cos(x, n - 1) : 0);
function series_exp(x, n) = pow(x, n) / fact(n) + (n ? series_exp(x, n - 1) : 0);

