fn interpolacionLineal t p1 p2 =(
	V = p2-p1
	return (p1+((normalize V)*(((length V)/100)*t)))
)

fn interpolacionCuadratica t p1 p2 p3 =(
	q1 = interpolacionLineal t p1 p2
	q2 = interpolacionLineal t p2 p3
	return (interpolacionLineal t q1 q2)
)

fn interpolacionCubica t p1 p2 p3 p4 =(
	r1 = interpolacionCuadratica t p1 p2 p3
	r2 = interpolacionCuadratica t p2 p3 p4
	return (interpolacionLineal t r1 r2)
)

s = Sphere radius:4 pos:[0,0,0] wireColor:red
b1 =Box pos:[-50,-50,0] width:5 length:5 height:5 wireColor:green
b2 =Box pos:[-50,25,0] width:5 length:5 height:5 wireColor:green
b3 =Box pos:[50,-25,0] width:5 length:5 height:5 wireColor:green
b4 =Box pos:[25,50,0] width:5 length:5 height:5 wireColor:green

animate on(
	for t in 0 to 100 by 5 do(
		at time t (
			s.pos = interpolacionCubica t b1.pos b2.pos b3.pos b4.pos
		)
	)
	s.showTrajectory = on;
)
