/* Hidden */
$fn=100;
bed_x=235;
bed_y=235;
layerh = 0.28;


module circle() {
	cylinder(h=layerh, d=20);
}
module line() {
    linear_extrude(height = 10, center = true, convexity = 10, twist = 0)
    {
        translate([2, 0, 0])
            circle(r = 1);    
    }
}

circle();
line();
