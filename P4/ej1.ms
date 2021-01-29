Plane length:150 width:150 pos:[0, 0, 0]
esfera1 = Sphere pos:[50, 0, 5] radius: 5
esfera2 = Sphere pos:[25, 0, 5] radius: 5
esfera3 = Sphere pos:[0, 0, 5] radius: 5
esfera4 = Sphere pos:[-25, 0, 5] radius: 5
esfera5 = Sphere pos:[-50, 0, 5] radius: 5
pos_z = 5
animationRange = interval 0 200

animate on (
	for t in 0 to 100 by 25 do (
		at time t (
			esfera1.pos.z = pos_z
			esfera2.pos.z = pos_z
			esfera3.pos.z = pos_z
			esfera4.pos.z = pos_z
			esfera5.pos.z = pos_z
			pos_z += 30
			if ((mod t 2) != 0) then
				pos_z *= -1
		)
	)
)

moveKeys esfera2.pos.controller 20f
moveKeys esfera3.pos.controller 40f
moveKeys esfera4.pos.controller 60f
moveKeys esfera5.pos.controller 80f