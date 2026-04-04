
use <utils.scad>
use <wago.scad>
use <fuse.scad>
use <mw_irm.scad>

e=.001;
$fn=100;

pcb_height=1.6;
silk_height=.2;
stack_spacing=2.4;

module pcb_edges()
{
	difference()
	{
		cylinder(h=pcb_height, d=90);
		union()
		{
			for (r=[10,180+10])
			rotate([0,0,r])
			hull()
			{
				translate([0,-30,-e])
				cylinder(h=pcb_height+e*2, d=4);

				translate([0,-40,-e])
				cylinder(h=pcb_height+e*2, d=4);
			}
			hull()
			{
				for(x=[-5.5,9.5])
				for(y=[-19,-24])
				translate([x,y,-e])
				cylinder(h=pcb_height+e*2, d=4);
			}
		}
	}
}

module _pcb_holes(d)
{
	for (r=[0,90,180,270])
	rotate([0,0,r])
	translate([-40,0,-e])
	cylinder(h=pcb_height+e*2, d=d);
}

module lamp_psu()
{
	on_pcb()
	translate([0,0,stack_spacing])
	{
		color("green")
		difference()
		{
			pcb_edges();
			_pcb_holes(3.2);
		}

		color("white")
		on_pcb()
		translate([-45,-45,--e])
		linear_extrude(height=e+silk_height)
		import("silk.svg");
	}
}

module lamp_guard()
{
	color("green")
	difference()
	{
		pcb_edges();
		_pcb_holes(2.7);
	}
}

module on_pcb()
{
	translate([0,0,pcb_height])
	children();
}

module on_pcb_2()
{
	on_pcb()
	translate([0,0,stack_spacing])
	on_pcb()
	children();
}

module pcb_stack()
{
	lamp_guard();

	lamp_psu();

	on_pcb_2()
	{
		translate([15,32])
		rotate([0,0,-90])
		pcb_wago(2);

		translate([25,-23])
		rotate([0,0,-90])
		pcb_wago(2);

		translate([-22,-22])
		fuse_ptf75();

		translate([0,4.5])
		irm_30();
	}
}

preview()
pcb_stack();
