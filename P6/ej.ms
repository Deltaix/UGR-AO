esfera = $Sphere001
suelo = $Plane001
cubo = $Box001

deletekeys esfera

ini = 0
fin = 200

fn getCollision t = (
	return IntersectRay suelo (ray (at time t cubo.pos) [0, 0, -1])
)

animate on (
	for t in ini to fin by 1 do (
		collisionT = getCollision t
		posT = collisionT.pos + collisionT.dir * esfera.radius
		
		at time t esfera.pos = posT
			
		if t > ini do (
			if t < fin then (
				collisionT1 = getCollision (t+1)
				posT1 = collisionT1.pos + collisionT1.dir * esfera.radius
			) else (
				collisionT1 = getCollision ini
				posT1 = collisionT1.pos + collisionT1.dir * esfera.radius
			)
			
			diff = posT1 - posT
			len = Length diff
			vec = diff / len
			
			rotAxis = cross vec collisionT.dir
			angulo = 360 * len / (esfera.radius * 2 * pi)
			rotDiff = quat angulo rotAxis
			
			rotEuler = QuatToEuler rotDiff
			at time t rotate esfera rotEuler
		)
	)
)