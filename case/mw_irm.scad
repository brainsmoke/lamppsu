
e=.001;

use <utils.scad>

module irm_30_cover(m=0)
{
	w=69.5;
	d=39;
	h=24;

	top_w=w-2;
	top_d=d-1.5;

	chamf=2;
    r=2;

	r1=r+m;
	r2=r+chamf+m;

	hull()
	{
		chamfer_block_z([w+m*2,d+m*2,e],anchor=[0,0,-1],r=chamf);

		for (d = [ [-1,-1], [-1,1], [1,-1], [1,1] ])
		translate([d.x*(top_w/2-chamf-r), d.y*(top_d/2+m), h-chamf-r])
		rotate([d.y*90,0,0])
		cylinder(h=chamf,r1=r1,r2=r2);
	}
}

module irm_30()
{
	color("#333333")
	irm_30_cover(0)

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
	#irm_30_cover(1);
}

