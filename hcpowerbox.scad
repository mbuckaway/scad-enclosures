$fn = 20;

//scale=.2;
scale=1;
length=600*scale;
width=450*scale;
height=300*scale;
thickness=20*scale;
panel_length=300*scale;
panel_height=200*scale;
space=4*scale;
space_offset=8*scale;
hoffset=100*scale;
lid_height=40*scale;

module rounded_box(x,y,z,r){
    translate([r,r,r])
    minkowski(){
        cube([x-r*2,y-r*2,z-r*2]);
        sphere(r=r, $fs=0.1);
    }
}

difference()
{
    cube([length, width, height]);
    translate([thickness, thickness, thickness]) cube([length - thickness*2, width - thickness*2, height - thickness+10]);
    translate([(length-panel_length)/2, thickness/1.25, (height-panel_height)/2]) rotate([90, 0, 0]) cube([panel_length, panel_height, thickness*2]);
}

difference()
{
    translate([-thickness, width+hoffset, 0]) cube([length+thickness+space, width+thickness+space, lid_height]);
    translate([space+space_offset, width+hoffset+thickness+space+space_offset, thickness]) cube([length-thickness*2-space, width-thickness*2-space, lid_height]);
}
