// File stepSizeDecay.scad
// demonstrates numerical error produced by various step sizes
// using exponential decay function
// (c) 2019-2022 Rich Cameron, for the book Make:Calculus
// Licensed under a Creative Commons, Attribution,
// CC-BY 4.0 international license, per
// https://creativecommons.org/licenses/by/4.0/
// Attribute to Rich Cameron, at
// repository github.com/whosawhatsis/Calculus

a = -0.12; //exponential decay factor 
w = 5; //width in y direction of each iteration
offset = 25; // height in millimeters for f(x,step) = 0
 
// h = step in x direction - varied as a parameter
// f(x) is assumed to be an exponential here 
// And assumed to start at x = 0

for(i = [1:13]) translate([0, i * w, 0]) f(h = i);

module f(i = 0,  h, start = 30, end = 2 * 3 * 4 * 3) {
	cube([h, w, start + offset]);
	if (i < (end - h) )
        translate([h, 0, 0]) 
        f(i + h, h, start * (1 + h * a), end);
}