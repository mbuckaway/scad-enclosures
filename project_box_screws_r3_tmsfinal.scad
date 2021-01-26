$fn=50;
// Trail Status Monitor Box
// This box provides a 1W LED mounting panel, a light sensor hole, an WIFI antenna hole,
// a power cable hole, and place to mount the ESP32 board. The top panel screws to the
// base for security and provide mounting holes for the entire box.
// The box provides holes for LEN lenses from Alliexpress: https://www.aliexpress.com/item/32978356485.html?spm=a2g0s.9042311.0.0.66e04c4dbgmVUf
show = 0;
box_enable = 1;
top_enable = 0;
ledmount_enable = 1;
fillets_enable = 1;
fillets_esp_enable = 0;
lightsensor_enable = 1;
words_enable = 0;
lensholder_enable = 1;

//40mm x 60 board size

inside_width = 70;
//inside_length = 165;
inside_length = 140;
//inside_height = 60;
inside_height = 0;
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

// The lid can have a lip on it for attached to another surface
// This is the size of that lip
lid_screw_lip_size = 15;
lid_screw_lip_screw_size = 5;
// The side of the box has a hole for the wifi antenna.
// Set to zero to disable.
antenna_holesize=7;
//antenna_holesize=0;
antenna_offset=15;

// LED Mount Parameters
ledmount_radius = 1;
ledmount_thickness = 3;                
ledmount_width = 40;
ledmount_length = 110;
ledmount_offset = 0;
ledmount_screwmount_height = 7;
ledmount_distance = 13;
ledmount_screw_size = 3.2;
ledmount_spacing = 26;

lensholder_radius = 1;
lensholder_thickness = 3;                
lensholder_width = 40;
lensholder_length = 110;
led_holder_offset = 15;
lensholder_screw_offset = 28;
lensholder_holesize = 21;
lensholder_cutout_dia = 24;

led_holesize=19.7;
led_bezelsize=24;
led_offset=45;
led_spacing=ledmount_spacing;

//lightsensor_holesize=17;
lightsensor_holesize=0;

power_holesize=18;
//power_holesize=0;

screwmount_height = ledmount_screwmount_height+18;
screwmount_length = ledmount_length-10;
screwmount_width = ledmount_width-10;
screwmount_offset_x = 29;
screwmount_offset_y = 25;
screwmount_screw_dia = 1.25;

screwmount_length_esp = 125;
screwmount_width_esp = 45;
screwmount_height_esp = screwmount_height+7;
//screwmount_offset_esp_x = 14;
//screwmount_offset_esp_y = 30;

screwmount_length_lh = lensholder_length - 56;
screwmount_width_lh = lensholder_width - 10;
screwmount_height_lh = 4;

outside_width = inside_width + thickness * 2;
outside_length = inside_length + thickness * 2;
od = screw_dia * 2.5;

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

module filletposts()
{
    postoffset_length = screwmount_length;
    postoffset_width = screwmount_width;
    post1 = [0, 0, 0];
    post2 = [0, postoffset_length, 0];
    post3 = [postoffset_width, 0, 0];
    post4 = [postoffset_width, postoffset_length, 0];
    translate(post1) screwmount(screwmount_height, screwmount_screw_dia, 4, 1);
    translate(post2) screwmount(screwmount_height, screwmount_screw_dia, 4, 1);
    translate(post3) screwmount(screwmount_height, screwmount_screw_dia, 4, 1);
    translate(post4) screwmount(screwmount_height, screwmount_screw_dia, 4, 1);
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

module box_screw(id, od, height){
    difference(){
        union(){
            cylinder(d=od, h=height, $fs=0.2);
            translate([-od/2, -od/2, 0])
                cube([od/2,od,height], false);
            translate([-od/2, -od/2, 0])
                cube([od,od/2,height], false);
        }
        cylinder(d=id, h=height, $fn=6);
    }
}

module rounded_box(x,y,z,r){
    translate([r,r,r])
    minkowski(){
        cube([x-r*2,y-r*2,z-r*2]);
        sphere(r=r, $fs=0.1);
    }
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
            translate ([inside_width/6,25,thickness/3]) 
                rotate([180,0,0])
                linear_extrude(thickness/3)
                text("Hydrocut", size=10);
            translate ([inside_width/4,inside_length-10,thickness/3]) 
                rotate([180,0,0])
                linear_extrude(thickness/3)
                text("Status", size=10);
        }
    }

    translate([inside_width/2-11,led_offset-10, thickness]) filletposts();
    //translate([inside_width/2-18,led_offset-22, thickness]) filletpostsesp();
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

module lid(){
    difference(){
        union(){
        //Lid.
        difference(){
            translate([0,-lid_screw_lip_size,0])
                rounded_box(outside_width, outside_length+lid_screw_lip_size*2, thickness * 4, radius);
            translate([0,-lid_screw_lip_size, thickness + extra_lid_thickness])
                cube([outside_width, outside_length+lid_screw_lip_size*2, inside_height + thickness * 4]);
        }
        //Lip
        lip_tol = 0.5;
        lip_width = inside_width - lip_tol;
        lip_length = inside_length - lip_tol;
        translate([(outside_width - lip_width)/2,(outside_length - lip_length)/2, thickness * 0.99])
            difference(){
                cube([lip_width, lip_length, thickness]);
                translate([thickness, thickness, 0])
                    cube([lip_width-thickness*2, lip_length-thickness*2, thickness]);
        }
        
        intersection(){
            union(){
            translate([od/2 + thickness, od/2 + thickness, thickness])
                box_screw(screw_dia, od, thickness);
            translate([inside_width - od/2 + thickness, od/2 + thickness, thickness])
                rotate([0,0,90])
                    box_screw(screw_dia, od, thickness);
            translate([inside_width - od/2 + thickness, inside_length - od/2 + thickness, thickness])
                rotate([0,0,180])
                    box_screw(screw_dia, od, thickness);
            translate([od/2 + thickness, inside_length - od/2 + thickness, thickness])
                rotate([0,0,270])
                    box_screw(screw_dia, od, thickness);
            }
            translate([thickness + lip_tol, thickness + lip_tol, 0])
            cube([lip_width-lip_tol,lip_length-lip_tol, 200]);
        }

        }
        
        union(){
            translate([od/2 + thickness, od/2 + thickness, thickness])
                cylinder(h = thickness * 4, d = screw_loose_dia, center=true, $fs=0.2);
            translate([inside_width - od/2 + thickness, od/2 + thickness, thickness])
                cylinder(h = thickness * 4, d = screw_loose_dia, center=true, $fs=0.2);
            translate([inside_width - od/2 + thickness, inside_length - od/2 + thickness, thickness])
                cylinder(h = thickness * 4, d = screw_loose_dia, center=true, $fs=0.2);
            translate([od/2 + thickness, inside_length - od/2 + thickness, thickness])
                cylinder(h = thickness * 4, d = screw_loose_dia, center=true, $fs=0.2);
        }
        // Draw the lip screw holes
        if (lid_screw_lip_size>0)
        {
            union() {
                translate([10, lid_screw_lip_size-22, 0])
                    cylinder(h = thickness * 4, d = lid_screw_lip_screw_size, center=true, $fs=0.2);            
                translate([inside_width-od/2, lid_screw_lip_size-22, 0])
                    cylinder(h = thickness * 4, d = lid_screw_lip_screw_size, center=true, $fs=0.2);            
                translate([inside_width-od/2, inside_length+13, 0])
                    cylinder(h = thickness * 4, d = lid_screw_lip_screw_size, center=true, $fs=0.2);            
                translate([10, inside_length+13, 0])
                    cylinder(h = thickness * 4, d = lid_screw_lip_screw_size, center=true, $fs=0.2);            
            }
        }

    }
}

module ledmount(){
    difference()
    {
        rounded_box(ledmount_width, ledmount_length, ledmount_thickness, ledmount_radius);
        // Holes in top for screws
        translate([ledmount_width-5, ledmount_length-5, 0])
            cylinder(h = ledmount_thickness * 2, d = ledmount_screw_size, center=true, $fs=0.2);            
        translate([5, ledmount_length-5, 0])
            cylinder(h = ledmount_thickness * 2, d = ledmount_screw_size, center=true, $fs=0.2);            
        translate([ledmount_width-5, 5, 0])
            cylinder(h = ledmount_thickness * 2, d = ledmount_screw_size, center=true, $fs=0.2);            
        translate([5, 5, 0])
            cylinder(h = ledmount_thickness * 2, d = ledmount_screw_size, center=true, $fs=0.2);            
    }
    // Screw posts
    for (i = [0:3])
    {
        post1 = [ledmount_width/2-ledmount_distance/2-.5, ledmount_spacing*i+15, ledmount_thickness];
        post2 = [ledmount_width/2+ledmount_distance/2-.5, ledmount_spacing*i+15, ledmount_thickness];
        translate(post1) screwmount(ledmount_screwmount_height, screwmount_screw_dia, 3, 1);
        translate(post2) screwmount(ledmount_screwmount_height, screwmount_screw_dia, 3, 1);
    }
}

module lensholder(){
    difference()
    {
        rounded_box(lensholder_width, lensholder_length, lensholder_thickness, lensholder_radius);

        // Holes in top for screws
        translate([5, lensholder_screw_offset, 1])
            cylinder(h = lensholder_thickness * 2, d = ledmount_screw_size, center=true, $fs=0.2);            
        translate([lensholder_width-5, lensholder_screw_offset, 1])
            cylinder(h = lensholder_thickness * 2, d = ledmount_screw_size, center=true, $fs=0.2);

        translate([lensholder_width-5, lensholder_length-lensholder_screw_offset, 1])
            cylinder(h = lensholder_thickness * 2, d = ledmount_screw_size, center=true, $fs=0.2);            
        translate([5, lensholder_length-lensholder_screw_offset, 1])
            cylinder(h = lensholder_thickness * 2, d = ledmount_screw_size, center=true, $fs=0.2);            

        // Corner cutout
        translate([0, 0, 1])
            cylinder(h = lensholder_thickness * 2, d = lensholder_cutout_dia, center=true, $fs=0.2);            
        translate([lensholder_width, 0, 1])
            cylinder(h = lensholder_thickness * 2, d = lensholder_cutout_dia, center=true, $fs=0.2);            
        translate([lensholder_width, lensholder_length, 1])
            cylinder(h = lensholder_thickness * 2, d = lensholder_cutout_dia, center=true, $fs=0.2);            
        translate([0, lensholder_length, 1])
            cylinder(h = lensholder_thickness * 2, d = lensholder_cutout_dia, center=true, $fs=0.2);            

        // LED LEN holes
        translate([lensholder_width/2,led_holder_offset,thickness-1])
            cylinder(h = thickness*2, d = lensholder_holesize, center=true, $fs=0.2);    
        translate([lensholder_width/2,led_holder_offset+led_spacing,thickness-1])
            cylinder(h = thickness*2, d = lensholder_holesize, center=true, $fs=0.2);    
        translate([lensholder_width/2,led_holder_offset+led_spacing*2,thickness-1])
            cylinder(h = thickness*2, d = lensholder_holesize, center=true, $fs=0.2);    
        translate([lensholder_width/2,led_holder_offset+led_spacing*3,thickness-1])
            cylinder(h = thickness*2, d = lensholder_holesize, center=true, $fs=0.2);    

    }
}

if (box_enable) main_box();
if (top_enable) translate([-outside_width-5,0,0]) lid();
//if (ledmount_enable) translate([-outside_width*1.75,0,0]) ledmount();
if (ledmount_enable && !show) translate([-50,0,0]) ledmount();
//if (ledmount_enable && show) translate([19,30,0]) ledmount();
if (ledmount_enable && show) translate([19,30,screwmount_height_esp-6]) ledmount();
if (lensholder_enable && !show) translate([-100, 0, 0]) lensholder();
if (lensholder_enable && show) translate([19, 30, thickness+2]) lensholder();
