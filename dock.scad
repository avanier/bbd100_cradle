// Includes
include <BOSL/constants.scad>;
use <BOSL/transforms.scad>;
use <BOSL/shapes.scad>;

phone_x=75.50;
phone_z=153.00;
phone_y=8.95;

dock_angle=-9;

phone_tolerance=2;
base_wall=5;
base_z=70;

// If we're working on the model, we render the phone
// placeholder and the model is transparent.
// If we're rendering, the phone is not shown and the
// model is opaque.
preview_phone = true;
display_phone = $preview ? preview_phone: false;

// Where the phone is, depending on how angled the base is
trig_offset = ( base_z * tan(dock_angle / 2) * -1 ) + base_wall + ( phone_tolerance / 2 );

module phone(extra_dim = [0,0,0]) {
  cube([phone_x, phone_y, phone_z] + extra_dim);
};

if (display_phone) {
  color("gold") {
    move([phone_x / -2, trig_offset, base_z / 2]) {
      rotate(dock_angle, [1, 0, 0]) {
        phone();
      };
    };
  };
};


module base() {


  difference() {
    // Front box
    rotate([dock_angle, 0, 0]) {
      cube([
        phone_x + phone_tolerance + (base_wall * 2),
        phone_y + phone_tolerance + (base_wall * 2),
        base_z
      ]);
    };

    // Phone shaped hole
    move([base_wall, trig_offset, base_z / 2]) {
      rotate(dock_angle, [1, 0, 0]) phone([phone_tolerance, phone_tolerance, 0]);
    };

    cutout_ratio = 3/64;

    // Front cutout
    move([base_wall + ( phone_tolerance / 2 ) + (phone_x * (cutout_ratio / 2)), trig_offset - phone_y, (base_z / 2)]) {
      rotate(dock_angle, [1, 0, 0]) phone([-phone_x * cutout_ratio, 0, (phone_z / 16)]);
    };

    // Back cutout
    back_cutout_width = 20;
    move([(base_wall + (phone_tolerance + phone_x) / 2) - (back_cutout_width / 2), (phone_y + phone_tolerance + trig_offset) / 2, base_wall]) {
      cube([back_cutout_width, (phone_y + ( base_wall * 2) + phone_tolerance + trig_offset), base_z / 2]);
    };

    // Floor clip
    move([0, 0, -base_z]) cube([
      1000,
      1000,
      base_z
    ]);
  };

  z_move = ( base_wall * tan(dock_angle / base_wall));
  difference() {
    cube([phone_x + phone_tolerance + (base_wall * 2), (phone_y + phone_tolerance + (base_wall * 2) + trig_offset) * 2, base_wall]);
    move([0, -base_wall, -z_move ]) {
      rotate(dock_angle, [1, 0, 0]) {
        cube([phone_x + phone_tolerance + (base_wall * 2), base_wall, 2*base_wall]);
      };
    };
    move([
      (phone_x + phone_tolerance + (base_wall * 2)) / 2,
      (phone_y + phone_tolerance + (base_wall * 2) + trig_offset - (phone_y + phone_tolerance + (base_wall * 2)) + trig_offset),
      base_wall / 2
      ]) {
      cylinder(h = base_wall, r=(phone_y + phone_tolerance + (base_wall * 2) + trig_offset) * 1.125, center = true);
    };
  }
};

color("cyan", display_phone ? 0.25 : 1) {
    move([(phone_x + phone_tolerance + (base_wall * 2)) / -2, 0, 0]) {
      base();
    };
};
