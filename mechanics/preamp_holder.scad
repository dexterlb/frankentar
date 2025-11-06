$fs = 0.2;
use <lib.scad>;

pcb_mounting_pole_height = 15;
pcb_mounting_pole_diam = 8.5;
pcb_hole_dist_x = 50;
pcb_hole_dist_y = 40;
window_size_x = 40;
window_size_y = 25;

mounting_hole_dist_x = 30;
mounting_hole_dist_y = 36;

pcb_nut_slot_depth = 2;
mounting_nut_slot_depth = 2;

base_height = 7;

module pcb_mounting_hole() {
    union() {
        translate([0, 0, -0.1])
        linear_extrude(pcb_mounting_pole_height + 0.2)
        circle(d=3.1);

        translate([0, 0, pcb_mounting_pole_height - pcb_nut_slot_depth])
        rotate([0, 180, 0])
        m3_nut_slot();
    }
}

module mounting_hole() {
    union() {
        translate([0, 0, -0.1])
        linear_extrude(base_height + 0.2)
        circle(d=4.1);

        translate([0, 0, mounting_nut_slot_depth])
        m4_nut_slot();
    }
}

module pcb_mounting_pole() {
    difference() {
        linear_extrude(pcb_mounting_pole_height)
        circle(d=pcb_mounting_pole_diam);
        pcb_mounting_hole();
    }
}

module pcb_mounting_poles() {
    translate([-pcb_hole_dist_x * 0.5, -pcb_hole_dist_y * 0.5, 0]) pcb_mounting_pole();
    translate([ pcb_hole_dist_x * 0.5, -pcb_hole_dist_y * 0.5, 0]) pcb_mounting_pole();
    translate([-pcb_hole_dist_x * 0.5,  pcb_hole_dist_y * 0.5, 0]) pcb_mounting_pole();
    translate([ pcb_hole_dist_x * 0.5,  pcb_hole_dist_y * 0.5, 0]) pcb_mounting_pole();
}

module mounting_holes() {
    translate([-mounting_hole_dist_x * 0.5, -mounting_hole_dist_y * 0.5, 0]) mounting_hole();
    translate([ mounting_hole_dist_x * 0.5, -mounting_hole_dist_y * 0.5, 0]) mounting_hole();
    translate([-mounting_hole_dist_x * 0.5,  mounting_hole_dist_y * 0.5, 0]) mounting_hole();
    translate([ mounting_hole_dist_x * 0.5,  mounting_hole_dist_y * 0.5, 0]) mounting_hole();
}

module base() {
    difference() {
        squillinder(
            pcb_hole_dist_x + pcb_mounting_pole_diam + 0.2,
            pcb_hole_dist_y + pcb_mounting_pole_diam + 0.2,
            pcb_mounting_pole_diam * 0.6,
            base_height
        );

        translate([0, 0, -0.1])
        squillinder(
            window_size_x, window_size_y,
            pcb_mounting_pole_diam * 0.6,
            base_height + 0.2
        );

        mounting_holes();
    }
}

union() {
    pcb_mounting_poles();
    base();
}
