$fn = 20;
use <libraries/gopro_mounts_mooncactus.scad>

outside_length = 40;
outside_width = 26;
outside_height = 6;
inside_length = outside_length + 2;
inside_width = 18.1;
inside_height = 2;
space_width = 14;

clamp_offset = 60;
//clamp_dia = 31.8;
clamp_dia = 35;


// Enables the light mount
lightmount_enabled = 0;
// Use the gopro mount or the tab mount - 1 = gopro
gopro_tab_enabled = 0;
// Handlebar clamp mount
clamp_enabled = 0;
// Helmet platform mount
helmet_platform_enable = 0;
// Serfas Light mount
serfas_light_mount = 1;

module rounded_box(x,y,z,r){
    translate([r,r,r])
    minkowski(){
        cube([x-r*2,y-r*2,z-r*2]);
        sphere(r=r, $fs=0.1);
    }
}

if (lightmount_enabled)
{
    difference()
    {
        cube([outside_width,outside_length,outside_height]);
        translate([(outside_width-inside_width)/2,-1,outside_height-3.5]) cube([inside_width,inside_length,inside_height]);
        translate([6,-1,outside_height-2]) cube([space_width,inside_length,inside_height+2]);
        translate([5.75,-2,outside_height-2.5]) {
            rotate([0, 0, 65]) {
                cube([5,2,3]);
            }
        }
        translate([outside_width-4.5,0,outside_height-2.5]) {
            rotate([0, 0, 115]) {
                cube([5,2,3]);
            }
        }
    }
    translate([inside_width/2+1.5,outside_length-2,2]) rotate([0,90,0]) cylinder(h=5,r=1);

    if (gopro_tab_enabled)
    {
        // Create a "triple" gopro connector
        translate([outside_width/2,outside_length/2,-10]) rotate([90,0,90]) gopro_connector("double");
    }
    else
    {
        difference()
        {
            union()
            {
                translate([outside_width/2-8,outside_length/2-7.5,-7]) cube([6,15,7]);
                translate([outside_width/2-8,outside_length/2,-7]) rotate([0,90,0]) cylinder(h=6,d=15);
            }
            translate([outside_width/2-8,outside_length/2,-7]) rotate([0,90,0]) cylinder(h=7,d=5);
            translate([outside_width/2-12,outside_length/2,-7]) rotate([0,90,0]) cylinder(h=7,d=9);
        }
        translate([inside_width/2+1.25,outside_length/2,-4]) rotate([0,0,0]) cylinder(h=3,r=1);
        translate([inside_width/2+1.25,outside_length/2,-13]) rotate([0,0,0]) cylinder(h=3,r=1);
        translate([inside_width/2+1.25,outside_length/2-3,-7]) rotate([90,0,0]) cylinder(h=3,r=1);
        translate([inside_width/2+1.25,outside_length/2+6,-7]) rotate([90,0,0]) cylinder(h=3,r=1);
    }

}

if (clamp_enabled)
{
    translate([clamp_offset,0,0])
    gopro_bar_clamp(
        rod_d= clamp_dia, // rod diameter
        th= 5.0, // main thickness
        gap= 2.4, // space between the clamps
        screw_d= 4.25, // screw diameter
        screw_head_d= 8.2, // screw head diameter
        screw_nut_d= 8.01, // nut diameter from corner to corner
        screw_shoulder_th=5.5, // thickness of the shoulder on which the nut clamps
        screw_reversed=0	 // true to mirror the orientation of the clamp bolts
    );

    translate([clamp_offset,0,0]) gopro_connector("triple");
}

if (helmet_platform_enable)
{
    translate([100,0,0])
    {
        difference()
        {
            rounded_box(50, 50, 5, 1);
            translate ([5, 5, -1]) cube([5, 40, 7]);
            translate ([40, 5, -1]) cube([5, 40, 7]);
        }
        translate([17,17,0]) cube([16, 16, 15]);
        translate([25,25,25]) rotate([270, 0, 90]) gopro_connector("triple");
    }
}

if (serfas_light_mount)
{
    translate([180, 0, 0])
    {
        difference()
        {
            rounded_box(26, 23, 8, 2);
            translate ([5, 3, 3]) cube([15.5, 23, 5]);
            translate ([2.5, 2, 3]) cube([20.5, 23, 2.7]);
        }
        translate([9.5, 17, 2.0]) rotate([0,90,0]) cylinder(h=6,d=2.5);
        translate([12.5, 11.5,-10]) rotate([90,0,90]) gopro_connector("double");
    }
}