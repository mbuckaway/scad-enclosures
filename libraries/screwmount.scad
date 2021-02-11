module screwmount(mount_height, mount_dia, raduis, rounded)
{
    difference() {
        cylinder(r=raduis, h=mount_height-2);
        translate([0,0,-1]) cylinder(r=mount_dia, h=mount_height);
    }
    if (rounded)
    {
        rotate_extrude(convexity = 10)
            translate([2.5,0,0]) {
                intersection()
                {
                    square(5);
                    difference() {
                        square(5, center=true);
                        translate([2.5,2,5]) circle(2.0);
                    }
                }
            }
    }
}
