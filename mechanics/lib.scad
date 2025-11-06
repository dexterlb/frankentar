
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

module m4_nut_slot() {
    linear_extrude(3.5)
    minkowski() {
        circle(d=1);
        regular_ngon(n=6, r=7.7*0.5);
    }
}

module m3_nut_slot() {
    linear_extrude(2.8)
    minkowski() {
        circle(d=0.8);
        regular_ngon(n=6, r=6.1*0.5);
    }
}
