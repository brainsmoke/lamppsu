
e=.001;

use <utils.scad>

module irm_30()
{
	w=69.5;
	d=39;
	h=24;

	top_w=w-2;
	top_d=d-1.5;

	chamf=2;
    r=2;

	color("#333333")
	hull()
	{
		chamfer_block_z([w,d,e],anchor=[0,0,-1],r=chamf);

		for (d = [ [-1,-1], [-1,1], [1,-1], [1,1] ])
		translate([d.x*(top_w/2-chamf-r), d.y*top_d/2, h-chamf-r])
		rotate([d.y*90,0,0])
		cylinder(h=chamf,r1=r,r2=r+chamf);
	}

	anchor([w,d,h], [0,0,-1])
	for (p=[
		[4,39-4.5],
		[4,39-4.5-5.5],
		[4+61.5,39-4.5],
		[4+61.5,39-4.5-9],
	])
	translate(p)
	translate([0,0,-3.5])
	cylinder(h=3.5+e,d=1);
	
}

preview()
{
	color("green")
	{
		translate([0,0,-1.6])
		cylinder(h=1.6,d=90);
	}
	irm_30();
}

