// File cartesianGrid.scad
// Creates a cube and segments for a cartesian coordinate system
// (c) 2019-2022 Rich Cameron, for the book Make:Calculus
// Licensed under a Creative Commons, Attribution,
// CC-BY 4.0 international license, per
// https://creativecommons.org/licenses/by/4.0/
// Attribute to Rich Cameron, at
// repository github.com/whosawhatsis/Calculus

segments = false; // true to generate segments, false to generate grid
 
grid = 15;//size of each cube, mm
size = 3; // size of one-quarter of overall demonstration cube

if(segments) {
	%grid();
	segment();
} else {
	grid();
	%segment();
}

module grid() difference() {
	linear_extrude(grid * size * 2, center = true, convexity = 5) difference() {
		square(grid * size * 2, center = true);
		for(i = [0, 1]) mirror([i, -i, 0]) for(i = [0, 1]) mirror([i, i, 0]) for(x = [-size:size]) translate([x * grid, grid * size, 0]) circle(1, $fn = 4);
	}
	for(i = [0, 1], j = [0, 1], k = [0, 1]) mirror([0, 0, k]) mirror([-k, k, 0]) mirror([i, i, 0]) mirror([j, 0, j])  mirror([0, 1, 1]) linear_extrude(grid * size * 2, center = true) for(x = [-size:size]) translate([x * grid, grid * size, 0]) circle(1, $fn = 4);
	intersection_for(i = [0, 1]) mirror([i, i, 0]) intersection_for(i = [0, 1]) mirror([i, 0, i]) cylinder(r = 1, h = 3, $fn = 4, center = true);
	for(i = [0, 1], j = [0, 1]) mirror([j, -j, 0]) mirror([i, 0, -i]) linear_extrude(grid * size * 2, convexity = 5) {
		square(grid * size * 2);
		for(i = [0, 1]) mirror([i, -i, 0]) for(x = [0:size - 1]) translate([x * grid, 0, 0]) circle(1, $fn = 4);
	}
}

module segment() difference() {
	linear_extrude(grid) difference() {
		square(grid);
		for(x = [0, 1], y = [0, 1]) translate([x * grid, y * grid, 0]) circle(1, $fn = 4);
	}
	for(i = [0, 1]) mirror([i, -i, 0]) for(i = [0, 1]) mirror([1, 0, -1]) linear_extrude(grid) for(x = [0, 1], y = [0, 1]) translate([x * grid, y * grid, 0]) circle(1, $fn = 4);
}