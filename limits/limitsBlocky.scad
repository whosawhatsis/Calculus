// File limitsBlocky.scad
// demonstrates breaking a surface function f(x, y) into blocks
// using a variable resolution
// (c) 2017-2022 Rich Cameron, for the book Make:Calculus
// Licensed under a Creative Commons, Attribution,
// CC-BY 4.0 international license, per
// https://creativecommons.org/licenses/by/4.0/
// Attribute to Rich Cameron, at
// repository github.com/whosawhatsis/Calculus

res = 16; // [4, 8, 16, 32, 64, 128]
    // resolution in x and y dimensions
zscale = 48;//scaling factor for the height of the surface
range = [64, 64]; //size, in mm, of the surface in x and y dimensions

center = [range[0]/2, range[1]/2]; //puts (0, 0) at the model's center

//The function definition
function f(x, y) = zscale * pow(x - center[0], 3) * (y - center[1]) /
	(range[1] * pow(range[0] / 2, 3))
	+ zscale / 2 + 1;
/* 
Next we create the rectangular solids and move them to the 
	correct (x,y) position 
*/
for(x = [0:res - 1], y = [0:res - 1])
 	translate([range[0] * x / res, range[1] * y / res, 0])
		cube([range[0] / res + .001,
			range[1] / res + .001,
				f(range[0] * (x + .5) / res, range[1] * (y + .5) / res)
]);