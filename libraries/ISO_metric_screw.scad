$fn = 90;

function base_face (D_maj, H) = [for(angle = [0: 360/$fn: 360-360/$fn]) [
    cos(angle)*(D_maj/2 + H/8 - abs((angle-180)/180* H)),
    sin(angle)*(D_maj/2 + H/8 - abs((angle-180)/180* H))
  ]];

module rod(D_maj = 8, P = 1.25, h = 20) {
  H = P * sin(60);
  /* linear extude thread */
  linear_extrude(height = h, twist = -h/P*360)
    intersection() {
      polygon(base_face(D_maj, H));
      circle(d = D_maj);
    }
}

module nut(D_maj = 8, P = 1.25, h = 20, extra = 1) {
  H = P * sin(60);
  linear_extrude(height = h, twist = -h/P*360)
    difference() {
      circle(d = D_maj + 2*(H/8) + 2*extra);
      polygon(base_face(D_maj, H));
      circle(d = D_maj - 2*(5*H/8));
    }
}

nut();
translate([10,0])
  rod();