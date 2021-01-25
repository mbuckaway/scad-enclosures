/*
Design file for OpenSCAD
Grommet for Filament with thread and lid
*/

// Enable/disable items
grommet_enable = 0;
cap_enable = 0;
clamp_enable = 1;

// printer parameter
printer_xy_width = 0.4;
show_sep_dist = 1.0;

// blocking distance of inner and outer grommet. should be 1.0 less than real mount thickness
mount_thickness = 0.0;

// grommet parameter
grommet_diameter = 40.0;
filament_diameter = 1.75;
grommet_filament_diameter = 3*filament_diameter;
grommet_fn = 30;

// part dimensions
inner_handle_diameter = 30.0;
inner_handle_length = 6.0;
inner_thread_diameter = 16.0;
inner_thread_length = 6.0;
inner_thread_angle = 0;

outer_handle_diameter = 30.0;
outer_handle_length = 6.0;
outer_thread_diameter = 22.0;
outer_thread_length = 8.0;
outer_thread_angle = 180;

clamp_inner_length = 4.0;
clamp_cap_length = 7.0;
clamp_fn = 40;
clamp_nsegments = 3;
clamp_spring_modulus = 2.0;

cap_handle_diameter = 30.0;
cap_handle_length = 6.0;
cap_top_length = 1.6;

// thread parameter
thread_depth = 1.5;
thread_modulus = 3.0;
thread_spacing = 0.6;
thread_fn = 40;

// handle parameter
handle_depth = 1.5;
handle_modulus = 5.0;
handle_fn = 40;

// derived parameter
grommet_pos_offset = 10.0 + 0.75*mount_thickness;
clamp_cap_diameter = outer_thread_diameter - thread_depth - 2*thread_spacing;
clamp_filament_diameter = 1.0*filament_diameter;
handle_chamfer_length = 1.0*handle_depth;
thread_chamfer_length = 1.0*thread_depth;



module thread_cutout(diameter, length, depth, modulus, start_angle, clipping) {
   intersection() {

      poly = [[0.5*diameter + depth, 0.0], [0.5*diameter, 0.45*modulus], [0.5*diameter - depth, 0.0], [0.5*diameter, -0.45*modulus]];
      npoly = len(poly);
      nseg = ceil(thread_fn * (length / modulus + 1));
     
      phpoints = [
         for (iseg = [0:nseg]) 
            let (
               a = iseg / nseg * 360 * (length / modulus + 1) + start_angle,
               dxdx = cos(a), 
               dydx = sin(a)
            )
            for (ipoint = [0:npoly-1])
               let (
                  x = dxdx * poly[ipoint][0], 
                  y = dydx * poly[ipoint][0],
                  z = (iseg / nseg - 0.5) * (length + modulus) + poly[ipoint][1]
               )
               [x, y, z]
      ];
      nphpoints = (nseg + 1) * npoly;

      phfaces_1 = [[for (ip = [0 : 1 : (npoly - 1)]) ip]];
      phfaces_2 = [[for (ip = [((nseg + 1) * npoly - 1) : -1 : nseg * npoly + 0]) ip]];
      phfaces_3 = [
         for (iseg = [0:(nseg-1)])
            for (ipoint = [0:npoly-1])
               [
                  (ipoint + 0) % npoly + (iseg + 0) * npoly, 
                  (ipoint + 0) % npoly + (iseg + 1) * npoly, 
                  (ipoint + 1) % npoly + (iseg + 1) * npoly
               ]
      ];      
      phfaces_4 = [
         for (iseg = [0:(nseg-1)])
            for (ipoint = [0:npoly-1])
               [
                  (ipoint + 0) % npoly + (iseg + 0) * npoly, 
                  (ipoint + 1) % npoly + (iseg + 1) * npoly,
                  (ipoint + 1) % npoly + (iseg + 0) * npoly 
               ]
      ];      
      phfaces = concat(phfaces_1, phfaces_2, phfaces_3, phfaces_4);
      polyhedron(points = phpoints, faces = phfaces, convexity = 10);
            
      if (clipping)
         cube([2*diameter, 2*diameter, length], center = true);
   }
}
module handle_cutout(diameter, length, depth, _modulus) {
   ncutouts = ceil(3.141592654 * diameter / _modulus);
   modulus = 3.141592654 * diameter / ncutouts;
   
   for (icutout = [1:1:ncutouts]) {
      rotate([0, 0, icutout * 360 / ncutouts])
         translate([0.5*diameter, 0.0, 0.0])
            linear_extrude(height = length, center = true)
               polygon([[-depth, -0.05*modulus], [-depth, 0.05 * modulus], [0.0, 0.45*modulus], [0.0, -0.45*modulus]]);
   }
}
   

module inner_grommet() {
   intersection() {
      // grommet
      translate([0.0, 0.0, grommet_pos_offset])
         rotate_extrude(convexity = 10, $fn = grommet_fn)
            translate([0.5*(grommet_diameter + grommet_filament_diameter), 0.0, 0.0])
               rotate([0, 0, 90])
                  circle(d = grommet_diameter, $fn = grommet_fn, center = true);
      // shape
      union() {
         // inner handle
         translate([0.0, 0.0, 0.0])
            difference() {
               union() {
                  translate([0.0, 0.0, 0.5*handle_chamfer_length])
                     cylinder(d1 = inner_handle_diameter - handle_depth, d2 = inner_handle_diameter + handle_depth, h = handle_chamfer_length, $fn = handle_fn, center = true);
                  translate([0.0, 0.0, 0.5*inner_handle_length])
                     cylinder(d = inner_handle_diameter + handle_depth, h = inner_handle_length - 2*handle_chamfer_length, $fn = handle_fn, center = true);
                  translate([0.0, 0.0, inner_handle_length - 0.5*handle_chamfer_length])
                     cylinder(d1 = inner_handle_diameter + handle_depth, d2 = inner_handle_diameter - handle_depth, h = handle_chamfer_length, $fn = handle_fn, center = true);
               }
               translate([0.0, 0.0, 0.5*inner_handle_length])
                  handle_cutout(inner_handle_diameter + handle_depth, inner_handle_length, handle_depth, handle_modulus);
            }
         // inner thread
         translate([0.0, 0.0, inner_handle_length])
            difference() {
               union() {
                  translate([0.0, 0.0, 0.5*(inner_thread_length + mount_thickness)])
                     cylinder(d = inner_thread_diameter + thread_depth - thread_spacing, h = inner_thread_length + mount_thickness, $fn = thread_fn, center = true);
                  translate([0.0, 0.0, inner_thread_length + mount_thickness + 0.25*((inner_thread_diameter + thread_depth - thread_spacing))])
                     cylinder(d1 = inner_thread_diameter + thread_depth - thread_spacing, d2 = 0.0, h = 0.5*(inner_thread_diameter + thread_depth - thread_spacing), $fn = thread_fn, center = true);
               }
               translate([0.0, 0.0, 0.5*(inner_thread_length + mount_thickness + thread_depth)])
                  thread_cutout(inner_thread_diameter + thread_depth - thread_spacing, inner_thread_length + mount_thickness + thread_depth, thread_depth, thread_modulus, inner_thread_angle, false);
            }
         }
   }
}

module outer_grommet() {
   intersection() {
      // grommet
      translate([0.0, 0.0, grommet_pos_offset - mount_thickness])
         rotate_extrude(convexity = 10, $fn = grommet_fn)
            translate([0.5*(grommet_diameter + grommet_filament_diameter), 0.0, 0.0])
               rotate([0, 0, 90])
                  circle(d = grommet_diameter, $fn = grommet_fn, center = true);
      // shape
      translate([0.0, 0.0, inner_handle_length]) {
         // body, threads and handles
         difference() {
            // outer shape
            union() {
               // outer handle
               difference() {
                  // outer handle cylinders
                  union() {
                     translate([0.0, 0.0, 0.5*handle_chamfer_length])
                        cylinder(d1 = outer_handle_diameter - handle_depth, d2 = outer_handle_diameter + handle_depth, h = handle_chamfer_length, $fn = handle_fn, center = true);
                     translate([0.0, 0.0, 0.5*outer_handle_length])
                        cylinder(d = outer_handle_diameter + handle_depth, h = outer_handle_length - 2*handle_chamfer_length, $fn = handle_fn, center = true);
                     translate([0.0, 0.0, outer_handle_length - 0.5*handle_chamfer_length])
                        cylinder(d1 = outer_handle_diameter + handle_depth, d2 = outer_handle_diameter - handle_depth, h = handle_chamfer_length, $fn = handle_fn, center = true);
                  }
                  // outer handle cutout
                  translate([0.0, 0.0, 0.5*outer_handle_length])
                     handle_cutout(outer_handle_diameter + handle_depth, outer_handle_length, handle_depth, handle_modulus);
               }
               // outer thread
               translate([0.0, 0.0, outer_handle_length])
                  difference() {
                     // outer thread cylinders
                     union() {
                        translate([0.0, 0.0, 0.5 * outer_thread_length - 0.5*thread_chamfer_length])
                           cylinder(d = outer_thread_diameter + thread_depth - thread_spacing, h = outer_thread_length - thread_chamfer_length, $fn = thread_fn, center = true);
                        translate([0.0, 0.0, outer_thread_length - 0.5*thread_chamfer_length])
                           cylinder(d1 = outer_thread_diameter + thread_depth - thread_spacing, d2 = outer_thread_diameter - thread_depth - thread_spacing, h = thread_chamfer_length, $fn = thread_fn, center = true);
                     }
                     // outer thread cutout
                     translate([0.0, 0.0, 0.5*outer_thread_length])
                        thread_cutout(outer_thread_diameter + thread_depth - thread_spacing, outer_thread_length, thread_depth, thread_modulus, outer_thread_angle, false);
                  }
            } // end outer shape

            // inner thread
            translate([0.0, 0.0, 0.5*thread_chamfer_length])
               cylinder(d1 = inner_thread_diameter + thread_depth + thread_spacing, d2 = inner_thread_diameter - thread_depth + thread_spacing, h = thread_chamfer_length, $fn = thread_fn, center = true);
            translate([0.0, 0.0, 0.5*(inner_thread_length + thread_chamfer_length + 0.5*(inner_thread_diameter + thread_depth + thread_spacing))])
               cylinder(d = inner_thread_diameter - thread_depth + thread_spacing, h = inner_thread_length - thread_chamfer_length + 0.5*(inner_thread_diameter + thread_depth + thread_spacing), $fn = thread_fn, center = true);
            translate([0.0, 0.0, 0.5*(inner_thread_length + thread_depth)])
               thread_cutout(inner_thread_diameter - thread_depth + thread_spacing, inner_thread_length + thread_depth, thread_depth, thread_modulus, inner_thread_angle, false);
         }
         // fill upper part of inner thread
         translate([0.0, 0.0, inner_thread_length])
            difference() {
               translate([0.0, 0.0, 0.5*(outer_handle_length + outer_thread_length - inner_thread_length)])
                  cylinder(d = inner_thread_diameter + thread_depth + thread_spacing, h = (outer_handle_length + outer_thread_length - inner_thread_length), $fn = thread_fn, center = true);
               translate([0.0, 0.0, 0.5*thread_depth])
                  cylinder(d1 = inner_thread_diameter + thread_depth + thread_spacing, d2 = inner_thread_diameter - thread_depth + thread_spacing, h = thread_depth, $fn = thread_fn, center = true);
               translate([0.0, 0.0, 0.25*(inner_thread_diameter + thread_depth + thread_spacing)])
                  cylinder(d1 = inner_thread_diameter + thread_depth + thread_spacing, d2 = 0.0, h = 0.5*(inner_thread_diameter + thread_depth + thread_spacing), $fn = thread_fn, center = true);
            }
      }
   }
}

module clamp() {
   // shape
      // body, threads and handles
   difference() {
      union() {
         difference() {
            translate([0.0, 0.0, inner_handle_length + outer_handle_length + outer_thread_length - clamp_inner_length])
               translate([0.0, 0.0, 0.5*clamp_inner_length + 1*1.0])
                  cylinder(d = min([clamp_cap_diameter - 4*clamp_spring_modulus, inner_thread_diameter - thread_depth - thread_spacing]), h = clamp_inner_length + 2*1.0, $fn = grommet_fn, center = true);
            translate([0.0, 0.0, grommet_pos_offset - mount_thickness])
               rotate_extrude(convexity = 10, $fn = grommet_fn)
                  translate([0.5*(grommet_diameter + grommet_filament_diameter), 0.0, 0.0])
                     rotate([0, 0, 90])
                        circle(d = grommet_diameter, center = true, $fn = grommet_fn);
         }
         translate([0.0, 0.0, inner_handle_length + outer_handle_length + outer_thread_length - clamp_inner_length])
            translate([0.0, 0.0, clamp_inner_length + 0.5*clamp_cap_length + 1*1.0])
               cylinder(d = clamp_cap_diameter, h = clamp_cap_length - 2*1.0, $fn = clamp_fn, center = true);
      }

      translate([0.0, 0.0, inner_handle_length + outer_handle_length + outer_thread_length - clamp_inner_length])
         translate([0.0, 0.0, 0.25*clamp_cap_length])
            cylinder(d1 = 2 * clamp_filament_diameter, d2 = 0 * clamp_filament_diameter, h = 0.5*clamp_cap_length, $fn = 4*clamp_nsegments, center = true);

      translate([0.0, 0.0, inner_handle_length + outer_handle_length + outer_thread_length + clamp_cap_length])
         translate([0.0, 0.0, -0.25*clamp_cap_length])
            cylinder(d1 = 0 * clamp_filament_diameter, d2 = 2 * clamp_filament_diameter, h = 0.5*clamp_cap_length, $fn = 4*clamp_nsegments, center = true);


      difference() {
         cylinder(d = clamp_cap_diameter - 2*clamp_spring_modulus, h = 100.0, $fn = clamp_fn, center = true);
         cylinder(d = clamp_cap_diameter - 3*clamp_spring_modulus, h = 100.0, $fn = clamp_fn, center = true);
         for (isegment = [0:1:clamp_nsegments-1]) {
            rotate([0, 0, (isegment + 0.6) * 360 / clamp_nsegments])
               translate([0.5*clamp_cap_diameter, 0.0, 0.0])
                  cube([clamp_cap_diameter, 0.2 / clamp_nsegments * 3.141592654 * (clamp_cap_diameter - 2.5*clamp_spring_modulus), 100.0], center = true);
         }
      }      
      intersection() {
         difference() {
            cylinder(d = clamp_cap_diameter - 3*clamp_spring_modulus, h = 100.0, $fn = clamp_fn, center = true);
            cylinder(d = clamp_cap_diameter - 4*clamp_spring_modulus, h = 100.0, $fn = clamp_fn, center = true);
         }
         for (isegment = [0:1:clamp_nsegments-1]) {
            rotate([0, 0, (isegment + 0.3) * 360 / clamp_nsegments])
               translate([0.5*clamp_cap_diameter, 0.0, 0.0])
                  cube([clamp_cap_diameter, 0.4 / clamp_nsegments * 3.141592654 * (clamp_cap_diameter - 3.5*clamp_spring_modulus), 100.0], center = true);
         }
      }      
      difference() {
         cylinder(d = clamp_cap_diameter - 4*clamp_spring_modulus, h = 100.0, $fn = clamp_fn, center = true);
         cylinder(d = clamp_cap_diameter - 5*clamp_spring_modulus, h = 100.0, $fn = clamp_fn, center = true);
         for (isegment = [0:1:clamp_nsegments-1]) {
            rotate([0, 0, (isegment + 0.0) * 360 / clamp_nsegments])
               translate([0.5*clamp_cap_diameter, 0.0, 0.0])
                  cube([clamp_cap_diameter, 0.2 / clamp_nsegments * 3.141592654 * (clamp_cap_diameter - 4.5*clamp_spring_modulus), 100.0], center = true);
         }
      }

      intersection() {
         cylinder(d = clamp_cap_diameter - 4.5*clamp_spring_modulus, h = 100.0, $fn = clamp_fn, center = true);
         union() {
            for (isegment = [0:1:clamp_nsegments-1]) {
               rotate([0, 0, (isegment + 0.5) * 360 / clamp_nsegments])
                  translate([0.25*(clamp_cap_diameter - 4.5*clamp_spring_modulus), 0.0, 0.0])
                     cube([0.5*(clamp_cap_diameter - 4.5*clamp_spring_modulus), 1.5*printer_xy_width, 100.0], center = true);
            }
         }
      }
   }
}


module cap() {
   // shape
   translate([0.0, 0.0, inner_handle_length + outer_handle_length]) {
      // body, threads and handles
      difference() {
         // cap shape
         union() {
            // cap handle
            translate([0.0, 0.0, 0.5*(outer_thread_length + clamp_cap_length + cap_top_length - cap_handle_length)]) 
               cylinder(d = cap_handle_diameter - handle_depth, h = outer_thread_length + clamp_cap_length + cap_top_length - cap_handle_length, $fn = handle_fn, center = true);
            translate([0.0, 0.0, outer_thread_length + clamp_cap_length + cap_top_length - cap_handle_length]) { 
               difference() {
                  // cap handle cylinders
                  union() {
                     translate([0.0, 0.0, 0.5*handle_chamfer_length])
                        cylinder(d1 = cap_handle_diameter - handle_depth, d2 = cap_handle_diameter + handle_depth, h = handle_chamfer_length, $fn = handle_fn, center = true);
                     translate([0.0, 0.0, 0.5*cap_handle_length])
                        cylinder(d = cap_handle_diameter + handle_depth, h = cap_handle_length - 2*handle_chamfer_length, $fn = handle_fn, center = true);
                     translate([0.0, 0.0, cap_handle_length - 0.5*handle_chamfer_length])
                        cylinder(d1 = cap_handle_diameter + handle_depth, d2 = cap_handle_diameter - handle_depth, h = handle_chamfer_length, $fn = handle_fn, center = true);
                  }
                  // cap handle cutout
                  translate([0.0, 0.0, 0.5*cap_handle_length])
                     handle_cutout(cap_handle_diameter + handle_depth, cap_handle_length, handle_depth, handle_modulus);
               }
            }
         } // end cap shape

         // thread
         translate([0.0, 0.0, 0.5*thread_chamfer_length])
            cylinder(d1 = outer_thread_diameter + thread_depth + thread_spacing, d2 = outer_thread_diameter - thread_depth + thread_spacing, h = thread_chamfer_length, $fn = thread_fn, center = true);
         translate([0.0, 0.0, 0.5*(outer_thread_length + clamp_cap_length + thread_chamfer_length)])
            cylinder(d = outer_thread_diameter - thread_depth + thread_spacing, h = outer_thread_length + clamp_cap_length - thread_chamfer_length, $fn = thread_fn, center = true);
         translate([0.0, 0.0, 0.5*outer_thread_length])
           thread_cutout(outer_thread_diameter - thread_depth + thread_spacing, outer_thread_length, thread_depth, thread_modulus, outer_thread_angle, true);
      }
      // fill upper part of cap for printability
      translate([0.0, 0.0, outer_thread_length])
         difference() {
            translate([0.0, 0.0, 0.5*clamp_cap_length])
               cylinder(d = outer_thread_diameter + thread_depth + thread_spacing, h = clamp_cap_length, $fn = thread_fn, center = true);
            translate([0.0, 0.0, 0.5*thread_depth])
               cylinder(d1 = outer_thread_diameter + thread_depth + thread_spacing, d2 = outer_thread_diameter - thread_depth + thread_spacing, h = thread_depth, $fn = thread_fn, center = true);
            translate([0.0, 0.0, 0.5*(thread_depth + clamp_cap_length)])
               cylinder(d = outer_thread_diameter - thread_depth + thread_spacing, h = clamp_cap_length - thread_depth, $fn = thread_fn, center = true);
         }
   }
}

module show() {
   translate([0.0, 0.0, 0.0]) 
      difference() {
         union() {
            translate([0, 0, 0 * show_sep_dist])
               rotate([0, 0, 0 * (1*180 + 360 * show_sep_dist / thread_modulus)])
                  inner_grommet();
            translate([0, 0, mount_thickness + 1 * show_sep_dist])
               rotate([0, 0, 1*180 + 360 * (mount_thickness + 1*show_sep_dist) / thread_modulus])
                  outer_grommet();
            translate([0, 0, mount_thickness + 2 * show_sep_dist])
                  clamp();
            translate([0, 0, mount_thickness + 3 * show_sep_dist])
               rotate([0, 0, 0*180 + 360 * (mount_thickness + 3*show_sep_dist) / thread_modulus])
                  cap();
         }
         translate([-100.0/2, -100.0/2, 0.0]) 
            cube(100.0, center = true);
      }

/*
   translate([0.0, 60.0, 0.0]) 
   {
      translate([0.0, 0.0, 0.0])
         inner_grommet();
      translate([0.0, 0.0, 30.0])
         outer_grommet();
      translate([0.0, 0.0, 50.0])
         clamp();
      translate([0.0, 0.0, 80.0])
         cap();
   }         
*/
}

module print() {
   if (grommet_enable)
   {
      translate([-0.3 * (inner_handle_diameter + outer_handle_diameter), -0.3 * (inner_handle_diameter + cap_handle_diameter), 0.0])
         inner_grommet();

      translate([0.3 * (inner_handle_diameter + outer_handle_diameter), -0.3 * (outer_handle_diameter + clamp_cap_diameter), -inner_handle_length])
         outer_grommet();
   }
   if (cap_enable)
   {
      translate([-0.3 * (cap_handle_diameter + clamp_cap_diameter), 0.3 * (inner_handle_diameter + cap_handle_diameter), inner_handle_length + outer_handle_length + outer_thread_length + clamp_cap_length + cap_top_length])
         rotate([180, 0, 0])
            cap();
   }

   if (clamp_enable)
   {
      translate([0.3 * (cap_handle_diameter + clamp_cap_diameter), 0.3 * (outer_handle_diameter + clamp_cap_diameter), inner_handle_length + outer_handle_length + outer_thread_length + clamp_cap_length])
         rotate([180, 0, 0])
            clamp();
   }
}


// !show();
print();
