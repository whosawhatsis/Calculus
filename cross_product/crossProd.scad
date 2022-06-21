// File crossProd.scad
// Creates a triangle connecting two segments and a perpendicular
// cylinder with a height proportional to the area
// for visualizing how cross product varies with angle
// (c) 2019-2022 Rich Cameron, for the book Make:Calculus
// Licensed under a Creative Commons, Attribution,
// CC-BY 4.0 international license, per
// https://creativecommons.org/licenses/by/4.0/
// Attribute to Rich Cameron, at
// repository github.com/whosawhatsis/Calculus

angle = 120;  // angle between vectors, degrees
width = 3;
$fs = .2;
$fa = 2;

hull() {
    translate([0, -width/2, 0]) cube([60, width, 1]);
    rotate([0, 0, angle]) translate([0, -width/2, 0]) cube([60, width, 1]);
 }

translate([0, -width/2, 0]) cube([60, width, 7]);
rotate([0, 0, angle]) translate([0, -width/2, 0]) cube([60, width, 9]);

// height of the cross-product 
 
cylinder(r = 4, h = 60 * sin(angle));