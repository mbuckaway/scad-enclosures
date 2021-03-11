$fn = 20;
use <libraries/partslib.scad>

height = 10;

difference()
{
    pyramid(side=40, height=height, square=true, centerHorizontal=true, centerVertical=true);
    translate([0, 0, height-2]) sphere(d=10);
}
