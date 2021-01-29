Plane length:150 width:150 pos:[0, 0, 0]
esfera = Sphere radius:5 pos:[0, 0, 5]
cubo1 = Box pos:[-30, -30, 5] width:5 height:5 length:5
cubo2 = Box pos:[30, 30, 5] width:5 height:5 length:5
animationRange = interval 0 100

animate on (
	at time 25 (
		cubo2.pos = [30, 30, 35]
	)
	at time 50 (
		cubo1.pos = [30, -30, 5]
	)
	at time 75 (
		cubo2.pos = [-30, 50, 35]
	)
)

animate on for t in 0 to 100 by 15 do 
(
	at time t (
		esfera.pos.x = (cubo1.pos.x + cubo2.pos.x) / 2
		esfera.pos.y = (cubo1.pos.y + cubo2.pos.y) / 2
		esfera.pos.z = (cubo1.pos.z + cubo2.pos.z) / 2
	)
)