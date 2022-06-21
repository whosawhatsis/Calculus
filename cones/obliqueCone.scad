// File obliqueCone.scad
// Creates a hollow oblique cone (or pyramid) based on 
// volume and height
// (c) 2016-2022 Rich Cameron, for the book Make:Calculus
// Licensed under a Creative Commons, Attribution,
// CC-BY 4.0 international license, per
// https://creativecommons.org/licenses/by/4.0/
// Attribute to Rich Cameron, at
// repository github.com/whosawhatsis/Calculus

// enter these three variables:

v = 50000; // volume in cubic mm (cc * 1000)
h = 90; // height in mm
n = 300; // number of sides (not including bottom)

wall = 1;
tol = .2;
lid = true;
lip = .25;
ball = 0;
offset = [30, 0];

// STL files don't have curves, so a cone must be approximated by using a large number for n. Depending on size, you'll want to find a value for area that results in a side length (check the console output) around 0.2-0.5mm. Sides shorter than this will not look smoother noticeably smoother once printed.

// the rest is calculated...

a = v / h * 3; // base-sectional area
s = 2 * sqrt(a * tan(180 / n) / n);
apothem = (2 * a / n / s);
r = apothem / cos(180 / n);

difference() {
	union() {
		hull() {
			translate([0, 0, h]) mirror([0, 0, 1]) cylinder(r = 0 + wall, $fn = n, h = .0001);
			translate(offset) cylinder(r = r + wall, $fn = n, h = .0001);
		}
		if(ball) translate([0, 0, h - ball / 2 * cos(asin(2 * wall / ball))]) intersection() {
			sphere(ball / 2, $fs = .2, $fa = 2);
		}
	}
	difference() {
		linear_extrude(h * 2, scale = 0, center = true) translate(offset * 2) circle(r * 2, $fn = n);
		linear_extrude(1, center = true) translate(offset) difference() {
			circle(r * 2, $fn = n);
			circle(r - wall, $fn = n);
		}
	}
}

echo(str("base-sectional area: ", a)); // base-sectional area
echo(str("side: ", s)); // side
echo(str("radius: ", r)); // radius
if((n % 2)) echo(str("radius + apothem: ", r + apothem)); // radius + apothem (only calculated for an odd number of sides)
echo(str("apothem: ", apothem)); // apothem
echo(str("circumscribed circle area: ", PI * pow(r, 2))); // circumscribed circle area
echo(str("inscribed circle area: ", PI * pow(apothem, 2))); // inscribed circle area
echo(str("polygon area: ", .5 * n * s * r * cos(180 / n))); // polygon area