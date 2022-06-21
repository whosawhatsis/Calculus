// File coneOfCylinders.scad
// Creates a cone (or pyramid) of stacked cylinders
// based on volume and height of the approximated cone
// (actual volume will be greater)
// (c) 2019-2022 Rich Cameron, for the book Make:Calculus
// Licensed under a Creative Commons, Attribution,
// CC-BY 4.0 international license, per
// https://creativecommons.org/licenses/by/4.0/
// Attribute to Rich Cameron, at
// repository github.com/whosawhatsis/Calculus

cylinders = 3;
offset = [0, 0];

v = 50000; // volume in cubic mm (cc * 1000)
h = 90; // height in mm
n = 300; // number of sides (not including bottom)

// STL files don't have curves, so a cone must be approximated by using a large number for n. Depending on size, you'll want to find a value for area that results in a side length (check the console output) around 0.2-0.5mm. Sides shorter than this will not look smoother noticeably smoother once printed.

// the rest is calculated...

a = v / h * 3; // base-sectional area
s = 2 * sqrt(a * tan(180 / n) / n);
apothem = (2 * a / n / s);
r = apothem / cos(180 / n);

for(i = [0:cylinders - 1]) translate([offset[0] * (1 - i / cylinders), offset[1] * (1 - i / cylinders), i * h / cylinders]) cylinder(r = r * (cylinders - i) / cylinders, h = h / cylinders, $fn = n);
	
	echo(str("base-sectional area: ", a)); // base-sectional area
	echo(str("side: ", s)); // side
	echo(str("radius: ", r)); // radius
	if((n % 2)) echo(str("radius + apothem: ", r + apothem)); // radius + apothem (only calculated for an odd number of sides)
	echo(str("apothem: ", apothem)); // apothem
	echo(str("circumscribed circle area: ", PI * pow(r, 2))); // circumscribed circle area
	echo(str("inscribed circle area: ", PI * pow(apothem, 2))); // inscribed circle area
	echo(str("polygon area: ", .5 * n * s * r * cos(180 / n))); // polygon area
