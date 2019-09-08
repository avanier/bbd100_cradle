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
base_z=85;

// If we're working on the model, we render the phone
// placeholder and the model is transparent.
// If we're rendering, the phone is not shown and the
// model is opaque.
preview_phone = true;
display_phone = $preview ? preview_phone: false;

// Where the phone is, depending on how angled the base is... I think.
trig_offset = ( base_z * tan(dock_angle / 2) * -1 ) + base_wall + ( phone_tolerance / 2 );

module phone(extra_dim = [0,0,0]) {
  cube([phone_x, phone_y, phone_z] + extra_dim);
};

$fs=0.04;

base_dims = [
  phone_x + phone_tolerance + (base_wall * 2),
  phone_y + phone_tolerance + (base_wall * 2)
];

phone_origin = [
  phone_x / -2,
  trig_offset,
  (base_z / 2) + ((base_dims[1] / 2) * tan(dock_angle))
];

if (display_phone) {
  color("gold") {
    // This position is wrong, it needs another y trig offset
    move(phone_origin) {
      rotate(dock_angle, [1, 0, 0]) {
        phone();
      };
    };
  };
};

module base() {
  round2d(2) {
    square(base_dims, true);
  };
};

phone_holder_dims = [
  phone_x + phone_tolerance,
  phone_y + phone_tolerance
];

module phone_holder() {
  base();
};

front_cutout_width = (phone_x + phone_tolerance) * 0.75;

back_cutout_dimensions = [
  20,
  base_dims[1] * 0.75,
  85 / 2
];

phone_cutout = [
  phone_x + phone_tolerance,
  phone_y + phone_tolerance
];

color("cyan", 0.5) {
  difference() {
    rotate(dock_angle, [1,0,0]) {
      move([0, base_dims[1] / 2, 0]) {
        difference() {
          linear_extrude(base_z / 2) {
            base();
          };
          // Back cable cutout
          move([back_cutout_dimensions[0] * -0.5,(base_dims[1] - back_cutout_dimensions[1]) * -0.5,0]) {
            cube(back_cutout_dimensions);
          };
        };
        move([0, 0, base_z / 2]) {
          linear_extrude( base_z / 2 ) {
            difference() {
              phone_holder();
              // Center cutout
              move([-front_cutout_width / 2, -base_dims[1] / 2]) {
                square(front_cutout_width, base_dims[1] / 2);
              };
              // Phone cutout
              move([phone_cutout[0] / -2, phone_cutout[1] / -2, 0]) {
                square(phone_cutout);
              };
            };
          };
        };
      };
    };
    // Base circular cutout
    rotate(90, [1,0,0]) {
      cylinder(r = (base_z / 2) - 10, h = 60, center = true);
    };
    // Trim off base angle
    move([0, base_dims[1] / 2, - 10]) {
      cube([base_dims[0], base_dims[1] + 5, 20], center = true);
    };
    // Trim off top angle
    move([0, base_dims[1], base_z + 5.65]) {
      cube([base_dims[0], base_dims[1] + 5, 20], center = true);
    };
  };
  // Semi-circular back support
  move([0,base_dims[1], 0]) {
    linear_extrude(base_wall) {
      difference() {
        // Outer circle
        circle(r = (base_dims[0] / 2));
        // Inner circle hole
        circle(r = (base_z / 2) - 10);
        // Trim off the front part
        move([0, -25 - 2, 0]) {
          square(size=[base_dims[0], 50], center=true);
        };
      };
    };
  };
};

// color("cyan") {
//   
//     rotate(dock_angle, [1,0,0]) {
//   };
// };

//// Beyond this is code to delete
//////////////////////////////////

// module base() {


//   difference() {
//     // Front box
//     rotate([dock_angle, 0, 0]) {
//       cube([
//         phone_x + phone_tolerance + (base_wall * 2),
//         phone_y + phone_tolerance + (base_wall * 2),
//         base_z
//       ]);
//     };

//     // Phone shaped hole
//     move([base_wall, trig_offset, base_z / 2]) {
//       rotate(dock_angle, [1, 0, 0]) phone([phone_tolerance, phone_tolerance, 0]);
//     };

//     cutout_ratio = 3/64;

//     // Front cutout
//     move([base_wall + ( phone_tolerance / 2 ) + (phone_x * (cutout_ratio / 2)), trig_offset - phone_y, (base_z / 2)]) {
//       rotate(dock_angle, [1, 0, 0]) phone([-phone_x * cutout_ratio, 0, (phone_z / 16)]);
//     };

//     // Back cutout
//     back_cutout_width = 20;
//     move([(base_wall + (phone_tolerance + phone_x) / 2) - (back_cutout_width / 2), (phone_y + phone_tolerance + trig_offset) / 2, base_wall]) {
//       cube([back_cutout_width, (phone_y + ( base_wall * 2) + phone_tolerance + trig_offset), base_z / 2]);
//     };

//     // Floor clip
//     move([0, 0, -base_z]) cube([
//       1000,
//       1000,
//       base_z
//     ]);
//   };

//   z_move = ( base_wall * tan(dock_angle / base_wall));
//   difference() {
//     cube([phone_x + phone_tolerance + (base_wall * 2), (phone_y + phone_tolerance + (base_wall * 2) + trig_offset) * 2, base_wall]);
//     move([0, -base_wall, -z_move ]) {
//       rotate(dock_angle, [1, 0, 0]) {
//         cube([phone_x + phone_tolerance + (base_wall * 2), base_wall, 2*base_wall]);
//       };
//     };
//     move([
//       (phone_x + phone_tolerance + (base_wall * 2)) / 2,
//       (phone_y + phone_tolerance + (base_wall * 2) + trig_offset - (phone_y + phone_tolerance + (base_wall * 2)) + trig_offset),
//       base_wall / 2
//       ]) {
//       cylinder(h = base_wall, r=(phone_y + phone_tolerance + (base_wall * 2) + trig_offset) * 1.125, center = true);
//     };
//   }
// };

// color("cyan", display_phone ? 0.25 : 1) {
//     move([(phone_x + phone_tolerance + (base_wall * 2)) / -2, 0, 0]) {
//       base();
//     };
// };
