// Snap Assembly Cable Grommet, August 2019
// Federico Hatoum
// adapted from design by Randy Ohman, aka TallTeacherGuy aka JSTEM...January 2018

// VERSION: 5.4

// Unlike the grommet by Randy Ohman, which was designed to be tough and hold pieces of
// tarp together, this grommet is meant to allow running a cable through it.
// There are three parts to a grommet set: 
// 1. Grommet
// 2. Snap
// 3. Cable passthrough plug (gasket)


// gapSize affects the height of the grommet. It's the space between the grommet and the snap:
// typical gap sizes:
// 0 mm: for plastic or thin cloth
// 1 mm: for the screen of a screen door, or thin metal
// 5 mm: for a piece of glass (ex: terrarium)


/* [Main] */

// Gap between grommet and snap (thickness of material the grommet will go through)
gapSize=1; // [0:20]

// Outer diameter of main bore (mm)
grommetBoreDiameter=40; // [10:50]
// Thickness of wall around main bore (mm)
wallThickness=2; // [1:4]
// Width of flange at Grommet base (mm)
flangeWidth=5; // [3:10]
// Plug Hole Type
plugHoleType = "cylinder"; // [none, rectangle, cylinder]


/* [Cylindrical Plug Hole] */

// Cylindrical Plug Hole Diameter (mm)
plugCylinderDiameter = 20; // [4:40]


/* [Rectangular Plug Hole] */

// Rectangular Plug Hole width (mm)
plugRectangleWidth = 6; // [1:10]
// Rectangular Plug Hole height (mm)
plugRectangleHeight = 2; // [1.0:5.0]


/* [Hidden] */

snapH=8;     // full height of snap // leave at 8
// grommet height
grommetH=snapH + gapSize; // grommet height is dependant on snap height and requested gap size


// Radius of main bore (mm)
grommetInnerR=(grommetBoreDiameter - (wallThickness * 2)) / 2;

// radius of the snap flange (mm)
flangeRad=grommetInnerR + wallThickness + flangeWidth;
// length of grommet slits (mm)
grommetSlitL = grommetInnerR + (wallThickness * 1.4);
// width of grommet slits (mm)
grommetSlitT = 1.2;


// fit flange: rotate extrude a right triangle on 
// inside base of grommet and outside base of plug
// height of fit flange
fitFlangeH=2; // don't change
// width of fit flange
fitflangeWidth=2; // don't change
// clearance for fit flange
fitFlangeClearance=0.05; 

// thickness of flanges around pieces (grommet, snap and plug) (mm)
flangeT=2; // don't change

// variables for snap
clear = 0.7; // "magic" clearance value used for snap // don't change 
snapwall = 1.5 * wallThickness;
snaphght = snapH - flangeT;
torrad = .6 * wallThickness;

// variables for plug
plugHoleTypes = ["none","rectangle","cylinder"];
plugH = grommetH + flangeT;
plugclear = 0.1; // tolerance factor for plug
plugSlitL = (grommetInnerR * 2) + (wallThickness * 2); // length of plug slit (mm)
plugSlitT = 0.2; // thickness/height of plug slit (mm)

plugCylRad = plugCylinderDiameter / 2; 

// This shouldn't matter...but if you change the order of the module calls below, it causes the generation of STL
// files which look fine until you slice them, and then parts of the structures go missing.
plug();
grommet();
snap();

module grommet(){
    
    difference(){
        
        
        union() {
            // grommet main bore
            difference(){
                // we move up the "cursor" the thickness of the flange
                translate([0,0,flangeT])
                // We substract a smaller cylinder from a larger one, leaving a tube with a wall 
                // thickness of wallThickness
                cylinder(h=grommetH-flangeT,r=wallThickness+grommetInnerR,$fn=360);
                cylinder(h=grommetH+flangeT,r=grommetInnerR,$fn=360);

            }

            // adding the outer flange and inner fit flange around base of grommet
            difference(){
                // outer flange
                cylinder(h=flangeT,r=flangeRad, $fn=360);
                // next cylinder is subtracted from the larger cylinder that forms the flange
                cylinder(h=flangeT, r=wallThickness+grommetInnerR-fitflangeWidth, $fn=360);
                
                // inner fit flange
                rotate_extrude(convexity=10, $fn=360)
                translate([grommetInnerR - fitFlangeClearance, 0, 0])
                polygon([[0,0], [0,fitFlangeH + fitFlangeClearance], [fitflangeWidth + fitFlangeClearance,0]]);
            }

            // toroid at top of grommet for snap action
            translate([0,0,grommetH])
            rotate_extrude(convexity = 10, $fn = 100)
            translate([wallThickness + grommetInnerR - 0.4 * torrad, 0, 0])
            circle(r = torrad, $fn = 100);
        }
        
        // 5 slits in side of grommet walls to make it easier to apply snap,
        // specially useful with rigid filaments
        translate([0,0,flangeT]) {
            for(i=[0:4]){
                rotate([0,0,i*72]) {
                    cube([grommetSlitL, grommetSlitT, grommetH + wallThickness * 0.1]);
                }
            }
        }
    }
}

module snap(){
    translate([2.25*flangeRad,0,0]){

        //snap main cylinder
        difference(){
            cylinder(h=0.55 * snapH,r=wallThickness + grommetInnerR + (0.3 * torrad) + (1.5 * wallThickness),$fn=100);
            cylinder(h=0.55 * snapH,r=wallThickness + grommetInnerR + clear,$fn=100);
        }

        //adding the flange
        difference(){
            cylinder(h=flangeT,r=flangeRad,$fn=360);
            cylinder(h=flangeT,r=wallThickness+grommetInnerR+.3*torrad+1.5*wallThickness,$fn=360);
        }

        //toroid on snap for snap action
        translate([0,0,0.5 * snapH])
        rotate_extrude(convexity = 10, $fn = 100)
        translate([wallThickness + grommetInnerR + (1.2 * torrad), 0, 0])
        circle(r = torrad, $fn = 100);
    }
}

module plug(){
                
    // move over entire plug so that it doesn't overlap with other pieces
    translate([4.5*flangeRad,0,0]) {
        
        difference() {
            union() {
                //plug main cylinder
                cylinder(h=plugH,r=grommetInnerR - plugclear, $fn=100);
                
                //adding the fit flange at bottom of plug
                rotate_extrude(convexity=10, $fn=100)
                translate([grommetInnerR - plugclear, 0, 0])
                polygon([[0,0], [0,fitFlangeH], [fitflangeWidth,0]]);
                
                //toroid on plug for snap action
                translate([0,0,plugH])
                rotate_extrude(convexity = 10, $fn = 100)
                translate([wallThickness + grommetInnerR - 2.2 * torrad, 0, 0])
                circle(r = (torrad * 0.8), $fn = 100);
            }
         
            // only add slit for plugs with rectangular and cylindrical holes
            if (plugHoleType != plugHoleTypes[0]) {
            
                if (plugHoleType == plugHoleTypes[1]) {
                    //cable passthrough rectangle
                    translate([0, 0, plugH/2]) {
                        cube([plugRectangleWidth, plugRectangleHeight, plugH], true);
                    }
                } else if (plugHoleType == plugHoleTypes[2]) {
                    translate([0, 0, 0]) {
                        cylinder(h=plugH, r=plugCylRad);
                    }
                }
                
                //slit through one side of plug
                translate([0, 0, plugH/2]) {
                    cube([plugSlitL, plugSlitT, plugH * 2], true);
                }
            }
        }
        

    }
}
