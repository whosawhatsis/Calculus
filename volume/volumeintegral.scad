// File volumeintegral.scad
// Demonstration shape for integral of a product
// (c) 2022 Rich Cameron, for the book Make:Calculus
// Licensed under a Creative Commons, Attribution,
// CC-BY 4.0 international license, per
// https://creativecommons.org/licenses/by/4.0/
// Attribute to Rich Cameron, at
// repository github.com/whosawhatsis/Calculus

zmax = 50;
step = .1;

//function x(z) = 5 * (sqrt(z)  + 10);
function x(z) = z/2 +20;
function y(z) = (1/50) *(z*z +  2500); 

//function x(z) = 10 * cos(z * 10) + 20;
//function y(z) = .01 * pow(z - 50, 2) + 10;

intersection() {
	rotate([0, -90, 0]) linear_extrude(1000, convexity = 5) polygon(concat([[zmax, 0], [0, 0]], [for(z = [0:step:zmax]) [z, x(z)]]));
	rotate([0, -90, 90]) mirror([0, 0, 1]) linear_extrude(1000, convexity = 5) polygon(concat([[zmax, 0], [0, 0]], [for(z = [0:step:zmax]) [z, y(z)]]));
}