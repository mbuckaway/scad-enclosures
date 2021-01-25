length=20;//diameter for cylinders
width=20;
height=40;
thickness=2;
Number_of_dolls=10;
shape="cube";//"cylinder" or "cube"
$fn=50;
if(shape=="cube"){
        for(i=[0:Number_of_dolls-1])
                if(length-i*thickness>0&&width-i*thickness>0&&height/2-i*thickness/2>1){
                        
                        
                        
                        translate([0,width*i+5,-i*thickness/4]){
                                difference(){
                                        union(){
                                                cube([length-i*thickness,width-i*thickness,height/2-i*thickness/2],center=true);
                                                translate([0,0,thickness]){
                                                        cube([length-thickness/2-i*thickness,width-thickness/2-i*thickness,height/2-i*thickness/2],center=true);
                                                }
                                        }
                                        translate([0,0,thickness]){
                                                cube([length-thickness-i*thickness,width-thickness-i*thickness,height/2-i*thickness/2],center=true);
                                        }
                                }
                                translate([length+5,0,0]){
                                        difference(){
                                                union(){
                                                        cube([length-i*thickness,width-i*thickness,height/2-i*thickness/2],center=true);
                                                        translate([0,0,thickness]){
                                                                difference(){
                                                                        cube([length-i*thickness,width-i*thickness,height/2-i*thickness/2],center=true);
                                                                        cube([length-thickness/2-i*thickness,width-thickness/2-i*thickness,height/2-i*thickness/2],center=true);
                                                                }
                                                        }
                                                }
                                                translate([0,0,thickness]){
                                                        cube([length-thickness-i*thickness,width-thickness-i*thickness,height/2-i*thickness/2],center=true);
                                                }
                                        }
                                }
                        }
        }
}

if(shape=="cylinder"){
        for(i=[0:Number_of_dolls-1])
                if(length-i*thickness>0&&width-i*thickness>0&&height/2-i*thickness/2>1){
                        
                        
//cylinder(h = height, r1 = BottomRadius, r2 = TopRadius, center = true/false);                        
                        translate([0,width*i+5,-i*thickness/4]){
                                difference(){
                                        union(){
                                                cylinder(d=length-i*thickness,h=height/2-i*thickness/2,center=true);
                                                translate([0,0,thickness]){
                                                        cylinder(d=length-thickness/2-i*thickness,h=height/2-i*thickness/2,center=true);
                                                }
                                        }
                                        translate([0,0,thickness]){
                                                cylinder(d=length-thickness-i*thickness,h= height/2-i*thickness/2,center=true);
                                        }
                                }
                                translate([length+5,0,0]){
                                        difference(){
                                                union(){
                                                        cylinder(d=length-i*thickness,h=height/2-i*thickness/2,center=true);
                                                        translate([0,0,thickness]){
                                                                difference(){
                                                                        cylinder(d=length-i*thickness,h=height/2-i*thickness/2,center=true);
                                                                        cylinder(d=length-thickness/2-i*thickness,h=height/2-i*thickness/2,center=true);
                                                                }
                                                        }
                                                }
                                                translate([0,0,thickness]){
                                                        cylinder(d=length-thickness-i*thickness,h=height/2-i*thickness/2,center=true);
                                                }
                                        }
                                }
                        }
        }
}