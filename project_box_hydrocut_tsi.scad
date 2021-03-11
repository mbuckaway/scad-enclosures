$fn=50;

use <libraries/screwmount.scad>
use <libraries/enclosureslib.scad>

// Trail Status Monitor Box
// This box provides a 1W LED mounting panel, a light sensor hole, an WIFI antenna hole,
// a power cable hole, and place to mount the ESP32 board. The top panel screws to the
// base for security and provide mounting holes for the entire box.
// The box provides holes for LEN lenses from Alliexpress: https://www.aliexpress.com/item/32978356485.html?spm=a2g0s.9042311.0.0.66e04c4dbgmVUf
show = 1;
box_enable = 1;
top_enable = 0;
ledmount_enable = 0;
fillets_enable = 0;
fillets_esp_enable = 0;
lightsensor_enable = 0;
words_enable = 1;
lensholder_enable = 0;

//40mm x 60 board size

inside_width = 70;
inside_length = 175;
//inside_length = 140;
inside_height = 60;
//inside_height = 0;
//Wall thickness
thickness = 3;  
//Fillet radius. This should not be larger than thickness.
radius = 1;                     
//Diameter of the holes that screws thread into. 
screw_dia = 2.5;                  
//Diameter of the holes on the lid (should be larger than the diameter of your screws)
screw_loose_dia = 3.2;
//Only use this if the lip on your lid is detached from the lid! This is a hack to work around odd union() behaviour.
extra_lid_thickness = 0;        //Extra lid thickness above thickness. 
                                //You may want to tweak this to account for large chamfer radius.

outside_width = inside_width + thickness * 2;
outside_length = inside_length + thickness * 2;
od = screw_dia * 2.5;

//lightsensor_holesize=17;
lightsensor_holesize=0;
led_holesize=0;
led_offset=45;
led_spacing=26;

//power_holesize=12;
power_holesize=0;

// The lid can have a lip on it for attached to another surface
// This is the size of that lip
lid_screw_lip_size = 15;
lid_screw_lip_screw_size = 5;
// The side of the box has a hole for the wifi antenna.
// Set to zero to disable.
antenna_holesize=7;
//antenna_holesize=0;
antenna_offset=15;

module textlines(line1, line2)
{
            translate ([0,0,thickness+5]) 
                rotate([180,0,0])
                linear_extrude(thickness+10)
                text(line1, size=8, halign="center", font="Liberation Sans:style=Bold");
            translate ([0,10,thickness+5])
                rotate([180,0,0])
                linear_extrude(thickness+10)
                text(line2, size=8, halign="center", font="Liberation Sans:style=Bold");
}

module filletpostsesp()
{
    postoffset_length = screwmount_length_esp;
    postoffset_width = screwmount_width_esp;
    post1 = [0, 0, 0];
    post2 = [0, postoffset_length, 0];
    post3 = [postoffset_width, 0, 0];
    post4 = [postoffset_width, postoffset_length, 0];
    translate(post1) screwmount(screwmount_height_esp, screwmount_screw_dia, 4, 1);
    translate(post2) screwmount(screwmount_height_esp, screwmount_screw_dia, 4, 1);
    translate(post3) screwmount(screwmount_height_esp, screwmount_screw_dia, 4, 1);
    translate(post4) screwmount(screwmount_height_esp, screwmount_screw_dia, 4, 1);
}

module filletpostslensholder()
{
    postoffset_length = screwmount_length_lh;
    postoffset_width = screwmount_width_lh;
    post1 = [0, 0, 0];
    post2 = [0, postoffset_length, 0];
    post3 = [postoffset_width, 0, 0];
    post4 = [postoffset_width, postoffset_length, 0];
    translate(post1) screwmount(screwmount_height_lh, screwmount_screw_dia, 3, 0);
    translate(post2) screwmount(screwmount_height_lh, screwmount_screw_dia, 3, 0);
    translate(post3) screwmount(screwmount_height_lh, screwmount_screw_dia, 3, 0);
    translate(post4) screwmount(screwmount_height_lh, screwmount_screw_dia, 3, 0);
}

module main_box(){
    difference(){
        //cube([outside_width, outside_length, inside_height + thickness * 2]);
        difference(){
            rounded_box(outside_width, outside_length, inside_height + thickness + 2, radius);
            translate([0,0,inside_height + thickness])
            cube([outside_width, outside_length, inside_height + thickness * 2]);
        }
        translate([thickness, thickness, thickness])
        cube([inside_width, inside_length, inside_height + thickness]);
        if (antenna_holesize>0)
        {
            translate([thickness/2,inside_length/2,inside_height-antenna_offset]) {
                rotate([0,90,0])
                cylinder(h = thickness*2, d = antenna_holesize, center=true, $fs=0.2);    
            }
        }
        if (led_holesize>0)
        {
            translate([inside_width/2+thickness,led_offset,thickness/2])
                cylinder(h = thickness*2, d = led_holesize, center=true, $fs=0.2);    
            translate([inside_width/2+thickness,led_offset, thickness*1.4])
                cylinder(h = thickness*2, d = led_bezelsize, center=true, $fs=0.2);    

            translate([inside_width/2+thickness,led_offset+led_spacing,thickness/2])
                cylinder(h = thickness*2, d = led_holesize, center=true, $fs=0.2);    
            translate([inside_width/2+thickness,led_offset+led_spacing,thickness*1.4])
                cylinder(h = thickness*2, d = led_bezelsize, center=true, $fs=0.2);    

            translate([inside_width/2+thickness,led_offset+led_spacing*2,thickness/2])
                cylinder(h = thickness*2, d = led_holesize, center=true, $fs=0.2);    
            translate([inside_width/2+thickness,led_offset+led_spacing*2,thickness*1.4])
                cylinder(h = thickness*2, d = led_bezelsize, center=true, $fs=0.2);    

            translate([inside_width/2+thickness,led_offset+led_spacing*3,thickness/2])
                cylinder(h = thickness*2, d = led_holesize, center=true, $fs=0.2);    
            translate([inside_width/2+thickness,led_offset+led_spacing*3,thickness*1.4])
                cylinder(h = thickness*2, d = led_bezelsize, center=true, $fs=0.2);    
        }
        if (lightsensor_enable>0)
        {
            translate([inside_width/2+10,thickness/2,inside_height/2+thickness])
            {
                rotate([90,0,180])
                {
                    translate([1, 0, -3]) cube([13, 7, thickness+3]);
                    cylinder(r=screwmount_screw_dia+.2, h=thickness+3, center=true, $fs=0.2);
                }
            }
        }

        if (power_holesize>0)
        {
            translate([inside_width/2+thickness,inside_length+thickness+thickness/2,inside_height/2+thickness]) {
                rotate([90,0,0])
                cylinder(h = thickness*2, d = power_holesize, center=true, $fs=0.2);    
            }
        }
        if (words_enable)
        {
            translate([inside_width/2, 30, 0]) textlines("All Trails", "Closed");
            translate([inside_width/2, 70, 0]) textlines("Glasgow", "Open");
            translate([inside_width/2, 110, 0]) textlines("Synders", "Open");
            translate([inside_width/2, 150, 0]) textlines("All Trails", "Open");
            //translate
        }
    }

    translate([inside_width/2-11,led_offset-10, thickness]) filletposts();
    translate([inside_width/2-18,led_offset-22, thickness]) filletpostsesp();
    translate([inside_width/2-11,led_offset+13, thickness]) filletpostslensholder();

    od = screw_dia * 2.5;
    
    translate([od/2+thickness,od/2+thickness, 0])
        box_screw(screw_dia, od, inside_height);
    
    translate([thickness+inside_width-od/2, od/2+thickness, 0])
        rotate([0,0,90])
            box_screw(screw_dia, od, inside_height);
    
    translate([thickness+inside_width-od/2, -od/2+thickness+inside_length, 0])
        rotate([0,0,180])
            box_screw(screw_dia, od, inside_height);
    
    translate([od/2 + thickness, -od/2+thickness+inside_length, 0])
        rotate([0,0,270])
            box_screw(screw_dia, od, inside_height);
}

if (box_enable) main_box();
