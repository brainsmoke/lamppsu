
e=.001;

use <utils.scad>

module for_each_row(n, pitch)
{
	for (i=[0:n-1])
	translate([(i-(n-1)/2)*pitch, 0, 0])
	children();
}

module pcb_wago(n)
{
	pitch = 5;

	w = (n-1) * pitch + 7.4;
	h = 16.7;
	d = 16.3;
	color("#c0c0c0")
	difference()
	{
		translate([-(3.6+pitch*(n-1)/2),-(5.2+4.1),0])
		block([w,d,h],anchor=[-1,-1,-1]);

		for_each_row(n, pitch)
		{
			translate([0,-3,h-4])
			block([pitch-.8,d,4+e],anchor=[0,0,-1]);
			
			translate([0,-2.5,3])
			chamfer_block([pitch-.5,d,6],anchor=[0,0,-1],r=1);
		}
	}
		
	// pins
	for_each_row(n, pitch)
	{
		for (y=[-4.1,4.1])
		translate([0, y, -4])
		cylinder(h=4+e,d=0.8);

	}

	color("#ff7700")
	for_each_row(n, pitch)
	translate([0,-12.2,h-3])
	block([pitch-1,14,3],anchor=[0,-1,-1]);
}

preview()
{
	color("green")
	{
		translate([0,0,-1.6])
		cylinder(h=1.6,d=90);
	}
	pcb_wago(3);
}

