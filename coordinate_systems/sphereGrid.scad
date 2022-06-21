// File sphereGrid.scad
// Creates a dome and segments for a spherical coordinate system
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

if(segments) rotate([90, 0, 90]) {
	%grid();
	for(i = [0:size - 1], a = [0:89 / grid_angle]) translate([i + 1, 0, a + 1]) segment([i, a]);
} else {
	grid();
	for(i = [0:size - 1], a = [0:89 / grid_angle]) translate([0, 0, 0]) %segment([i, a]);
}

module grid() difference() {
	rotate_extrude() difference() {
		intersection() {
			circle(grid * size);
			square(grid * size);
		}
		for(x = [0:size - 1]) translate([x * grid, 0, 0]) circle(1, $fn = 4);
		for(a = [0:grid_angle:90]) rotate(a) translate([size * grid, 0, 0]) circle(1, $fn = 4);
	}
	for(a = [0:grid_angle:179]) rotate(a) mirror([1, 0, 1]) {
		rotate_extrude() translate([size * grid, 0, 0]) circle(1, $fn = 4);
		linear_extrude(grid * size * 2, center = true) circle(1, $fn = 4);
	}
	union() {
		intersection_for(i = [0, 1]) mirror([0, 1, 0]) mirror([i, i, 0]) mirror([0, 1, 1]) {
			rotate_extrude() {
				square(grid * size * 2);
				difference() {
					union() for(x = [0:size]) translate([x * grid, 0, 0]) circle(1, $fn = 4);
					translate([-1, 0, 0]) square(2, center = true);
				}
			}
			mirror([0, 1, 0]) for(a = [grid_angle:grid_angle:89]) rotate(a) {
				mirror([1, 0, 1]) linear_extrude(grid * size) circle(1, $fn = 4);
			}
		}
		linear_extrude(grid * size) circle(1);
		for(i = [0, 1]) mirror([i, -i, 0]) mirror([0, 0, 1]) mirror([0, 1, 1]) for(a = [grid_angle:grid_angle:89]) rotate(a) mirror([-1, 0, 1]) linear_extrude(grid * size) circle(1, $fn = 4);
	}
}

module segment(choord = [0, 0]) difference() {
	intersection() {
		rotate_extrude() intersection() {
			difference() {
				circle((choord[0] + 1) * grid);
				if(choord[0]) circle(choord[0] * grid);
				else circle(1);
			}
			rotate(choord[1] * grid_angle) square(grid * size * 2);
			rotate((choord[1] + 1) * grid_angle - 90) square(grid * size * 2);
		}
		linear_extrude(grid * size) intersection() {
			square(grid * size * 2);
			rotate(grid_angle - 90) square(grid * size * 2);
		}
	}
	linear_extrude(grid * size * 2, center = true) circle(1);
	rotate_extrude() for(a = [0:grid_angle:89]) rotate(a) for(x = [1:size]) translate([x * grid, 0, 0]) circle(1, $fn = 4);
	for(a = [0, grid_angle]) rotate(a) {
		mirror([0, 1, 1]) rotate_extrude() for(x = [1:size]) translate([x * grid, 0, 0]) circle(1, $fn = 4);
		mirror([0, 0, 1]) mirror([0, 1, 1]) for(a = [0:grid_angle:89]) rotate(a) mirror([-1, 0, 1]) linear_extrude(grid * size) circle(1, $fn = 4);
	}
}