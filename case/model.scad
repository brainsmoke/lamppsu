use <utils.scad>
use <pcb.scad>
use <mw_irm.scad>
e=.001;
$fn=200;

cover_border=0.8;
cover_hole=18;
bottom=0.8;
d_top=105;
d_bottom=100;
cover_h=41.;
cover_spacing=3;
rib_size_bottom=8;
rib_size_top=3;
rib_width = 0.8;
n_ribs=4;

screw_surface_thickness=2;

internal_fillet=2;

wire_thickness=5.7;
wire_bend_r = 5;

clamp_screw_size=3.3;
clamp_nut_size=5.7;

pcb_screw_holes = 3.3;

m=.3;

flute_thickness = 1.6;
flute_d1=wire_thickness+flute_thickness;
flute_d2=33;
flute_h=35;
flute_top_thickness=0.8;

flute_y = cover_h+3;

module nut_hex(h,d)
{
	r = d/sqrt(3);
	cylinder(h=h,r=r, $fn=6);
}

module wire()
{
	color("white")
	translate([0,0,38.75])
	{
		cylinder(h=200,d=wire_thickness);
		rotate([-90,0,-90])
		translate([-wire_bend_r,0,0])
		rotate_extrude(angle=90)
		translate([wire_bend_r,0])
		circle(d=wire_thickness);

		translate([0,wire_bend_r-e,-wire_bend_r])
		rotate([-90,0,0])
		cylinder(h=10,d=wire_thickness);
	}
}

module wire_keepout_extra()
{
	translate([0,0,38.75-wire_bend_r])
	{
		block([wire_thickness,wire_thickness,100],[0,1,-1]);
		rotate([-90,0,0])
		block([wire_thickness,wire_thickness,100],[0,-1,-1]);
	}
}

module cover()
{
	color("#e0e0e0")

	difference()
	{
		cylinder(h=cover_h,d1=d_top,d2=d_bottom);

		difference()
		{
			cylinder(h=cover_h,d1=d_top-2*cover_border,d2=d_bottom-2*cover_border);

			translate([0,0,cover_h-bottom])
			cylinder(h=bottom+e,d=max(d_bottom,d_top));

			difference()
			{
				union()
				{
					for (i=[0:n_ribs-1])
					rotate([0,0,360*i/n_ribs])
					block([max(d_bottom,d_top)/2, rib_width, cover_h], anchor=[-1,0,-1]);
				}
				cylinder(h=cover_h,d1=d_top-2*(cover_border+rib_size_top),d2=d_bottom-2*(cover_border+rib_size_bottom));

			}
		}

		cylinder(h=cover_h+e,d=cover_hole);

		translate([0,0,-e])
		cylinder(h=cover_spacing+e,d=max(d_bottom,d_top)+e);

	cover_latches();
	}

}

module internal_space(m)
{
	difference()
	{
			cylinder(h=cover_h,r1=d_top/2-cover_border-m,r2=d_bottom/2-cover_border-m);

			translate([0,0,cover_h-bottom-m])
			cylinder(h=bottom+m+e,d=max(d_bottom,d_top));
	}
}

module at_irm()
{
	on_pcb_2()
	translate([0,4.5,0])
	children();
}

module clamp_outer_shape()
{

	hull()
	{
	for (i=[1,-1])
	translate([i*36,0,cover_h-bottom-6-m])
	rotate([90,0,0])
	cylinder(h=20,r=6,center=true);

	for (i=[1,-1])
	on_pcb_2()
	translate([i*39,0,0])
	rotate([90,0,0])
	cylinder(h=20,r=6,center=true);

	}
}

module wire_clamp()
{
	difference()
	{
		union()
		{
			intersection()
			{
				clamp_outer_shape();

				union()
				{
					translate([0,-5.5,0])
					block([200,screw_surface_thickness,200],anchor=[0,-1,0]);

					on_pcb_2()
					translate([0,-5.5,0])
					block([200,11,screw_surface_thickness],anchor=[0,-1,-1]);

					hull()
				{
					intersection()
					{
						at_irm()
						irm_30_cover(m=.5+1.5);

						translate([0,-5.5+screw_surface_thickness,0])
						block([200,internal_fillet,200],anchor=[0,-1,0]);
					}
					intersection()
					{
						at_irm()
						irm_30_cover(m=.5+1.5+internal_fillet);

						translate([0,-5.5+screw_surface_thickness-e,0])
						block([200,e,200],anchor=[0,-1,0]);
					}
				}

					intersection()
					{
						at_irm()
						irm_30_cover(m=.5+1.5);

						translate([0,-5.5,0])
						block([200,11,200],anchor=[0,-1,0]);
					}

			for (i=[-1, 1])
			difference()
			{
				translate([i*39,-5.5,25])
				block([8.1,11,screw_surface_thickness],anchor=[0,-1,-1]);

				translate([i*64,-4,20])
				rotate([0,0,i*42])
				block([30.5,30,30],anchor=[0,-1,0]);
			}


				}
			}

			translate([0,-5,30])
			block([28,14,9.9],anchor=[0,-1,-1]);

			for (x=[-30,30])
			difference()
			{
				translate([x,-5.5,30])
				block([screw_surface_thickness,11,9.9],anchor=[0,-1,-1]);

				translate([x,-4,40.4])
				rotate([137,0,0])
				block([30,30,30],anchor=[0,0,1]);
			}


		}

		union()
		{
			for (x=[-10,10])
			translate([x,5,40])
			rotate([120,0,0])
			{
				block([8+e,20,10],anchor=[0,0,1]);
				translate([0,-2.5,-e])
				cylinder(h=200+e,d=clamp_screw_size);

				translate([0,-2.5,8.5])
				nut_hex(h=200, d=clamp_nut_size);
			}
			at_irm()
			irm_30_cover(m=.5);
			on_pcb_2()
			block([200,200,100],anchor=[0,0,1]);

			wire();

			for (x=[-40,40])
			translate([x,0,0])
			cylinder(h=40,d=pcb_screw_holes);
		}
	}
}


module clamp_split()
{
	translate([0,-1.3,42])
	rotate([120,0,0])
	block([28+e,50,50], anchor=[0,0,1]);
}


module clamp_base()
{
	difference()
	{
		wire_clamp();
		clamp_split();
	}
}

module clamp_clamp()
{
	intersection()
	{
		difference()
		{
			wire_clamp();
			wire_keepout_extra();
		}
		clamp_split();
	}
}


module print_cover()
{
	translate([0,0,cover_h])
	rotate([180,0,0])
	cover();
}

module print_clamp_clamp()
{
	rotate([-120,0,0])
	translate([0,0,cover_h-bottom-m])
	rotate([180,0,0])
	clamp_clamp();
}

module print_clamp_base()
{
	rotate([90,0,0])
	translate([0,5,0])
	rotate([180,0,0])
	on_pcb_2()
	rotate([180,0,0])
	clamp_base();
}


module cover_latch()
{
	difference()
	{
		on_pcb()
		union()
		{
			translate([35,0,0])
			block([15,8,3.6], anchor=[-1,0,-1]);
			translate([46.8,0,0])
			block([3.2,8,8], anchor=[-1,0,-1]);
		}

		translate([55,0,6])
		rotate([0,45,0])
		cube([10,5,10], center=true);

		translate([40,0,0])
		cylinder(h=10,d=pcb_screw_holes);

		on_pcb_2()
		translate([0,0,-1.6])
		cylinder(h=1.6,d=90);
	}
}

module print_cover_latch()
{
	rotate([180,0,0])
	on_pcb()
	rotate([180,0,0])
	cover_latch();
}

module cover_latches()
{
	for (r=[0,90,180,270])
	rotate([0,0,r])
	cover_latch();
}


module flute()
{

	color("#c0c0c0")
	difference()
	{

		translate([0, 0, flute_y])
		{
			cylinder(h=flute_top_thickness+e, d=flute_d2);
			translate([0, 0, flute_top_thickness])
			rotate_extrude($fn = 100)
			intersection()
			{
				square([flute_d2/2,flute_h-flute_top_thickness]);
			difference()
			{
				union()
				{
					translate([flute_d2/2, flute_h-flute_top_thickness])
					scale([flute_d2/2-flute_d1/2+flute_thickness, flute_h-flute_top_thickness+flute_thickness])
	    	    	circle(r=1, $fn = 100);
					translate([flute_d2/2-6, 0])
					square([3,3]);
				}
				translate([flute_d2/2, flute_h-flute_top_thickness])
				scale([flute_d2/2-flute_d1/2, flute_h-flute_top_thickness])
				circle(r=1, $fn = 100);

			}
			}
		}
		wire();
	}
}

module print_flute()
{
	translate([0, 0,-flute_y])
	flute();
}

preview()
{
	clamp_base();

	translate([0,0,20])
	clamp_clamp();
	translate([0,0,20])
	flute();

	wire();
	pcb_stack();

	translate([110,0,0])
	{
		cover();
		flute();
		wire();
	}

	cover_latches();

}

