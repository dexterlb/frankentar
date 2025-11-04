$fs = 0.2;

holder_total_height = 22;
pickup_screw_dist = 77;
window_size_x = 69;
window_size_y = 38;
window_radius = 5;

flap_span = 85;
flap_size = 15;
flap_radius = 3;

flap_hole_diameter = 2.65;
flap_hole_dist = 79.7 - 1.9;
flap_hole_countersink_diameter = 4.5;
flap_hole_countersink_height = 2;

top_thickness = 4;

outer_size_x = 90;
outer_size_y = 50;

holder_rim_radius = 6;

mounting_hole_depth = 18;
mounting_hole_nut_height = 2;

cable_notch_height = 2.5;
cable_notch_width = 2.5;
cable_notch_radius = 1;
cable_notch_side_offset = -12;

module regular_ngon(n=6, r=10, rotate_deg=0) {
    if (n < 3) {
        echo("regular_ngon: n must be >= 3");
    } else {
        points = [ for (i = [0 : n-1])
            [ r * cos(rotate_deg + 360*i/n), r * sin(rotate_deg + 360*i/n) ]
        ];
        polygon(points);
    }
}

module squillinder(x, y, radius, height) {
    linear_extrude(height)
    minkowski() {
        square(
            [x - radius*2, y - radius*2],
            center = true
        );
        circle(r=radius);
    }
}

module mounting_hole_pole() {
    translate([0, 0, -0.1])
    linear_extrude(mounting_hole_depth + 0.1)
    circle(d=4);
}

module mounting_hole_nut() {
    translate([0, 0, mounting_hole_nut_height])
    linear_extrude(3.2)
    minkowski() {
        circle(d=1);
        regular_ngon(n=6, r=7.7*0.5);
    }
}

module mounting_hole() {
    union() {
        mounting_hole_pole();
        mounting_hole_nut();
    }
}

module mounting_holes() {
    off_x = outer_size_x * 0.5 - holder_rim_radius;
    off_y = outer_size_y * 0.5 - holder_rim_radius;

    union() {
        translate([-off_x, -off_y, 0]) mounting_hole();
        translate([ off_x, -off_y, 0]) mounting_hole();
        translate([-off_x,  off_y, 0]) mounting_hole();
        translate([ off_x,  off_y, 0]) mounting_hole();
    }
}

module window() {
    translate([0, 0, -0.1])
    squillinder(
        window_size_x, window_size_y,
        window_radius, holder_total_height + 0.2
    );
}

module hull() {
    squillinder(outer_size_x, outer_size_y, holder_rim_radius, holder_total_height);
}


module flaps_inset() {
    translate([0, 0, -0.1])
    squillinder(
        flap_span,
        flap_size,
        flap_radius,
        holder_total_height - top_thickness + 0.1
    );
}

module flap_hole() {
    union() {
        // the hole itself
        linear_extrude(holder_total_height + 0.1)
        circle(d=flap_hole_diameter);

        // countersink
        translate([0, 0, holder_total_height - flap_hole_countersink_height])
        linear_extrude(flap_hole_countersink_height + 0.1)
        circle(d=flap_hole_countersink_diameter);
    }
}

module cable_notch() {
    translate([window_size_x * 0.5 - 0.1, cable_notch_side_offset, 0])
    rotate([0, 90, 0])
    linear_extrude((outer_size_x - window_size_x) * 0.5 + 0.2)
    minkowski() {
        square(
            [(cable_notch_height - cable_notch_radius) * 2, (cable_notch_width - cable_notch_radius)], center=true);
        circle(r=cable_notch_radius);
    }
}

module flap_holes() {
    translate([-flap_hole_dist * 0.5, 0, 0]) flap_hole();
    translate([ flap_hole_dist * 0.5, 0, 0]) flap_hole();
}

module holder() {
    difference(){
        hull();
        union() {
            window();
            flaps_inset();
            flap_holes();
            mounting_holes();
            cable_notch();
        }
    }
}

module nut_view() {
    // used just for debugging, to see a where the nuts are (horizontal slice)
    difference() {
        holder();

        translate([0, 0, mounting_hole_nut_height + 2])
        linear_extrude(1000)
        square(1000, center=true);
    }
}

holder();
// nut_view();
// mounting_holes();
