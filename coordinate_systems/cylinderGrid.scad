// File cylinderGrid.scad
// Creates a cylinder and segments for a cylindrial coordinate system
// (c) 2019-2022 Rich Cameron, for the book Make:Calculus
// Licensed under a Creative Commons, Attribution,
// CC-BY 4.0 international license, per
// https://creativecommons.org/licenses/by/4.0/
// Attribute to Rich Cameron, at
// repository github.com/whosawhatsis/Calculus

segments = false; // true to generate segments, false to generate grid

grid = 15;
grid_angle = 360 / 4 / 3;
size = 3;

$fs = .2;
$fa = 2;

if(segments) {
	%grid();
	for(i = [0:size - 1]) translate([i + 1, 1, 0]) segment(i);
} else {
	grid();
	for(i = [0:size - 1]) %segment(i);
}

module grid() difference() {
	linear_extrude(grid * size * 2, center = true, convexity = 5) difference() {
		circle(grid * size);
		for(a = [0:grid_angle:359]) rotate(a) translate([grid * size, 0, 0]) circle(1, $fn = 4);
	}
	*intersection_for(i = [0, 1]) mirror([i, i, 0]) intersection_for(i = [0, 1]) mirror([i, 0, i]) cylinder(r = 1, h = 3, $fn = 4, center = true);
	linear_extrude(grid * size * 2, convexity = 5) {
		square(grid * size * 2);
		for(i = [0, 1]) mirror([i, -i, 0]) for(x = [1:size - 1]) translate([x * grid, 0, 0]) circle(1, $fn = 4);
		circle(1);
	}
	hull() for(i = [0, 1]) mirror([0, 0, i]) cylinder(r = 1, r2 = 0, h = 1);
	for(i = [-1, 1]) translate([0, 0, i * grid * size]) {
		rotate_extrude() difference() {
			union() for(x = [0:size - 1]) translate([x * grid, 0, 0]) circle(1, $fn = 4);
			translate([-1, 0, 0]) square(2, center = true);
		}
		for(a = [0:grid_angle:179]) rotate(a) mirror([1, 0, 1]) linear_extrude(grid * size * 2, center = true, convexity = 5) circle(1, $fn = 4);
	}
	for(z = [-size:size]) translate([0, 0, z * grid]) rotate_extrude() translate([size * grid, 0, 0]) circle(1, $fn = 4);
	intersection() {
		rotate_extrude() difference() {
			union() for(x = [0:size]) translate([x * grid, 0, 0]) circle(1, $fn = 4);
			translate([-1, 0, 0]) square(2, center = true);
		}
		linear_extrude(2, center = true) square(grid * size * 2);
	}
	for(z = [0:size - 1]) translate([0, 0, z * grid]) for(a = [0:grid_angle:90]) rotate(a) mirror([1, 0, -1]) linear_extrude(grid * size * 2, convexity = 5) circle(1, $fn = 4);
}

module segment(choord = 0) difference() {
	linear_extrude(grid) difference() {
		intersection() {
			difference() {
				circle((choord + 1) * grid);
				circle(choord * grid);
			}
			square(grid * size * 2);
			rotate(grid_angle - 90) square(grid * size * 2);
		}
		for(a = [0, grid_angle]) rotate(a) for(x = [1:size]) translate([x * grid, 0, 0]) circle(1, $fn = 4);
		circle(1);
	}
	for(i = [0, 1]) translate([0, 0, i * grid]) {
		rotate_extrude() difference() {
			for(x = [0:size]) translate([x * grid, 0, 0]) circle(1, $fn = 4);
			translate([-1, 0, 0]) square(2, center = true);
		}
		for(a = [0:grid_angle:179]) rotate(a) mirror([1, 0, 1]) linear_extrude(grid * size * 2, center = true, convexity = 5) circle(1, $fn = 4);
	}
}