
e=.001;

use <utils.scad>

module fuse_ptf75()
{
	color("#77dd77")
	{
	block([24.4,9.4,11.5+1.8],anchor=[0,0,-1]);
	translate([0,0,-3.5])
	cylinder(h=3.5+e,d=2.6);
	}

	for (x=[-7.5,7.5])
	translate([x,0,-3.5])
	cylinder(h=3.5+e,d=0.8);
	
}

preview()
{
	color("green")
	{
		translate([0,0,-1.6])
		cylinder(h=1.6,d=90);
	}
	fuse_ptf75();

}

