// 0=none (library mode), 1=main box, 2=lid, 3=both
mode=3;

inside_width = 100;
inside_length = 300;
inside_height = 70;
wall_thickness = 4;                  
// must be less than half inside_width and inside_length 
corner_radius = 10;

// thickness of the top of the lid
lid_thickness = 4;
// depth of the internal ledge that fit in the box
lid_ledge_depth = 5;
// set this to a positive value if your printed lid is too big for the box, negative value if it is too loose
lid_lip_tolerance = 0; // 0.3;

// Holes
// 0=disable holes, 1=enable holes
lid_holes = 0;
// 0=disable holes, 1=enable holes
left_holes = 0;
// 0=disable holes, 1=enable holes
right_holes = 0;
// 0=disable holes, 1=enable holes
bottom_holes = 0;

lid_hole_side_offset = 30;
left_hole_side_offset = 15;
right_hole_side_offset = 15;
bottom_hole_side_offset = 20;

hole_separation = 12;
hole_diameter = 6;
// 0=aligned holes, 1=alternate holes
hole_alternate_shift = 0;

outside_width = inside_width + wall_thickness * 2;
outside_length = inside_length + wall_thickness * 2;

module rounded_box(x,y,z,r){
    translate([r, r, 0]) {
        linear_extrude(z) {
            minkowski(){
                square([x-r*2,y-r*2]);
                if(r > 0)
                    circle(r, $fn=max(40, 4*corner_radius));
            }
        }
    }
}

module cylinder_array(width, length, height, offset) {
    hole_count_x = round((width-hole_separation-offset) / hole_separation)+1;
    hole_count_y = round((length-hole_separation-offset) / hole_separation)+1;
    //echo ([hole_count_x, hole_count_y]);
    
    hole_area_width = (hole_count_x-1) * (hole_separation);
    hole_area_length = (hole_count_y-1) * (hole_separation) + (hole_alternate_shift ? hole_separation/2 : 0);

    translate ([(width-hole_area_width)/2, (length-hole_area_length)/2, -height*0.1]) {
        //create holes
        for (i=[0:hole_count_x-1]) {
            //echo(i*hole_separation);
            for (j=[0:hole_count_y-1]) {
                translate ([i*hole_separation, j*hole_separation+(hole_alternate_shift ? hole_separation/2*(i%2) : 0), 0]) {
                    cylinder(height*1.2, hole_diameter/2, hole_diameter/2, $fn=40, false);
                }
            }
        }
    }
}

module main_box(){
    difference() {
        rounded_box(outside_width, outside_length, inside_height + wall_thickness, corner_radius);

        translate([wall_thickness, wall_thickness, wall_thickness]) {
            rounded_box(inside_width, inside_length, inside_height + wall_thickness*1.2, corner_radius);
        }

        // Edge to compensate printing inaccuracies on lid lip's base
        translate([wall_thickness-0.3, wall_thickness-0.3, inside_height+wall_thickness-0.6]) {
            color([0.8, 0.2, 0.2]) {
                rounded_box(inside_width+0.6, inside_length+0.6, 1, corner_radius);
            }
        }
        
        if(bottom_holes)
            cylinder_array(outside_width, outside_length, wall_thickness, bottom_hole_side_offset);
    
        rotate([0, 90, 0]) {
            if(left_holes) {
                translate([-inside_height-wall_thickness, wall_thickness, 0]) {
                    cylinder_array(inside_height, inside_length, wall_thickness, left_hole_side_offset);
                }
            }
            if(right_holes) {
                translate([-inside_height-wall_thickness, wall_thickness, inside_width+wall_thickness]) {
                    cylinder_array(inside_height, inside_length, wall_thickness, right_hole_side_offset);
                }
            }
        }
    }
}

module lid() {
    union() {
        difference() {
            //Lid
            rounded_box(outside_width, outside_length, lid_thickness, corner_radius);
        
            if(lid_holes) {
                cylinder_array(outside_width, outside_length, lid_thickness, lid_hole_side_offset);
            }
        }
        
        //Lip
        lip_width = inside_width - lid_lip_tolerance;
        lip_length = inside_length - lid_lip_tolerance;
        translate([(outside_width - lip_width)/2,(outside_length - lip_length)/2, lid_thickness * 0.99]) {
            difference(){
                color([0.2, 0.8, 0.2]) {
                    rounded_box(lip_width, lip_length, lid_ledge_depth, corner_radius);
                }
                translate([wall_thickness, wall_thickness, -lid_ledge_depth*0.1]) {
                    rounded_box(lip_width-wall_thickness*2, lip_length-wall_thickness*2, lid_ledge_depth*1.2, corner_radius);
                }
            }
        }
    }
}

module assembly () {
    main_box();
    translate([-outside_width-2,0,0]) {
        lid();
    }
}

if (mode == 1) {
    main_box();
} else if (mode == 2) {
    lid();
} else if (mode == 3) {
     assembly();
}
