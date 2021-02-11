$fn=50;

dia = 110;
tooldia = 31;
model = 0;
height = 10;
curved = 1;

if (model)
{
    %translate([-34, -65, -20]) 
        rotate([0, 0, 20])
            import("knob.stl");
}
// Simpler code with same result
module roundedcube2(xx, yy, height, radius)
{
    translate([0,0,height/2])
    hull()
    {
        translate([radius,radius,0])
        cylinder(height,radius,radius,true);

        translate([xx-radius,radius,0])
        cylinder(height,radius,radius,true);

        translate([xx-radius,yy-radius,0])
        cylinder(height,radius,radius,true);

        translate([radius,yy-radius,0])
        cylinder(height,radius,radius,true);
    }
}

module tool()
{
    difference()
    {
        cylinder(h=height, d=dia);
        translate([-1, 3, 0])
        {
            hull()
            {
                translate([-1, 22, -1]) cylinder(h=height+2, d=tooldia);
                translate([24, -15, -1]) cylinder(h=height+2, d=tooldia);
                translate([-20,-20, -1]) cylinder(h=height+2, d=tooldia);
            }
        }
    }
}
module handle()
{
    translate([-15, -170, 0]) cube([30, 120, 10]);
    translate([15, -170, 5]) rotate([0, 90, 90]) cylinder(h=120, d=10);
    translate([-15, -170, 5]) rotate([0, 90, 90]) cylinder(h=120, d=10);
    translate([-15, -170, 5]) rotate([0, 90, 0]) cylinder(h=30, d=10);
    translate([12, -171, 5]) rotate([0, 90, 45]) cylinder(h=6.5, d=10);
    translate([-16, -167, 5]) rotate([0, 90, -45]) cylinder(h=5.5, d=10);
    //translate([0, -170, 0]) cylinder(h=10, d=30);
}

tool();
handle();
