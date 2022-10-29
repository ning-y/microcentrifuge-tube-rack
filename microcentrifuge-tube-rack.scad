$fn = 72;

microcentrifuge_tube_rack(4, 6);

// The total height of the rack is rack_thickness+leg_height.
// Rendering this upside-down makes it easier to print.
module microcentrifuge_tube_rack(
        rows, columns,
        upside_down=true, hole_diameter=11.5, distance_between_holes=5,
        rack_thickness=3, leg_roundedness_r=1, leg_xy_length=15, leg_height=40) {

    upside_down_rotate_x = upside_down ? 180 : 0;
    upside_down_translate_y = upside_down ?
        rows*hole_diameter + (rows+1)*distance_between_holes : 0;
    upside_down_translate_z = upside_down ? rack_thickness + leg_height : 0;

    translate([0, upside_down_translate_y, upside_down_translate_z])
        rotate([upside_down_rotate_x])
    union() {
        // Render the top surface of the rack
        translate([0, 0, leg_height]) difference() {
            linear_extrude(rack_thickness)
                rounded_rectangle_2d(
                    columns*hole_diameter + (columns+1)*distance_between_holes,
                    rows*hole_diameter + (rows+1)*distance_between_holes,
                    leg_roundedness_r);
            for (i = [1:rows]) {
                for (j = [1:columns]) {
                    translate([
                            hole_diameter/2 +
                                j*distance_between_holes + (j-1)*hole_diameter,
                            hole_diameter/2 +
                                i*distance_between_holes + (i-1)*hole_diameter])
                        linear_extrude(rack_thickness)
                        circle(d=hole_diameter);
                }
            }
        }

        // Render the legs.
        linear_extrude(leg_height) union() {
            // Bottom-left corner
            rounded_rectangle_2d(
                leg_xy_length, 2*leg_roundedness_r, leg_roundedness_r);
            rounded_rectangle_2d(
                2*leg_roundedness_r, leg_xy_length, leg_roundedness_r);
            // Upper-left corner
            translate([
                0, rows*hole_diameter + (rows+1)*distance_between_holes -
                    2*leg_roundedness_r])
                rounded_rectangle_2d(
                    leg_xy_length, 2*leg_roundedness_r, leg_roundedness_r);
            translate([
                0, rows*hole_diameter + (rows+1)*distance_between_holes -
                    leg_xy_length])
              rounded_rectangle_2d(
                2*leg_roundedness_r, leg_xy_length, leg_roundedness_r);
            // Upper-right corner
            translate([
                columns*hole_diameter + (columns+1)*distance_between_holes -
                    leg_xy_length,
                rows*hole_diameter + (rows+1)*distance_between_holes -
                    2*leg_roundedness_r])
                rounded_rectangle_2d(
                    leg_xy_length, 2*leg_roundedness_r, leg_roundedness_r);
            translate([
                columns*hole_diameter + (columns+1)*distance_between_holes -
                    2*leg_roundedness_r,
                rows*hole_diameter + (rows+1)*distance_between_holes -
                    leg_xy_length])
                rounded_rectangle_2d(
                    2*leg_roundedness_r, leg_xy_length, leg_roundedness_r);
            // Bottom-right corner
            translate([
                columns*hole_diameter + (columns+1)*distance_between_holes -
                    leg_xy_length, 0])
                rounded_rectangle_2d(
                    leg_xy_length, 2*leg_roundedness_r, leg_roundedness_r);
            translate([
                columns*hole_diameter + (columns+1)*distance_between_holes -
                    2*leg_roundedness_r, 0])
                rounded_rectangle_2d(
                    2*leg_roundedness_r, leg_xy_length, leg_roundedness_r);
        }
    }
}

// Draws a two-dimensional rounded rectangle with dimensions x by y, where the
// radius of the rounded corner is r. The rounded rectangle is drawn in the
// positive-x and positive-y quandrant, with one corner at the origin (0, 0).
module rounded_rectangle_2d(x, y, r) {

    assert(x > 0); assert(y > 0); assert(r > 0);
    assert(x >= 2*r); assert(y >= 2*r);

    translate([r, r]) hull() {
        circle(r=r);
        translate([x-2*r,     0]) circle(r=r);
        translate([x-2*r, y-2*r]) circle(r=r);
        translate([    0, y-2*r]) circle(r=r);}
}
