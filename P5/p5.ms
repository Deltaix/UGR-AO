fn interpolacionLineal t len p1 p2 = (
	V = p2-p1
	return (p1+((normalize V)*(((length V)/len)*t)))
)

fn interpolacionCuadratica t len p1 p2 p3 = (
	q1 = interpolacionLineal t len p1 p2
	q2 = interpolacionLineal t len p2 p3
	return (interpolacionLineal t len q1 q2)
)

fn puntoMedio pos1 pos2 = (
	X = pos1.x
	Y = pos1.y
	Z = pos1.z

	return [X,Y,Z]
)

fn distancia pos1 pos2 = (
	return sqrt((pos1.x-pos2.x)^2 + (pos1.y-pos2.y)^2 + (pos1.z-pos2.z)^2)
)

fn Animar Traveler P1 P2 P3 stretchL stretchI stretchS AnguloL AnguloS Inicio Fin = (
	animate on
	(
		at time Inicio (
			Traveler.modifiers[#stretchSaltos].Stretch = stretchI
			Traveler.rotation.y = 0
		)
		
		at time (Inicio+((Fin-Inicio)/10)) (
			Traveler.modifiers[#stretchSaltos].Stretch = stretchS
			rotate Traveler (eulerangles 0 AnguloS 0)
		)
		
		at time ((Fin+Inicio)/2) (
			Traveler.modifiers[#stretchSaltos].Stretch = 0
			Traveler.rotation.y = 0
		)
		
		at time (Fin-((Fin-Inicio)/10)) (
			Traveler.modifiers[#stretchSaltos].Stretch = stretchL
			rotate Traveler (eulerangles 0 AnguloL 0)
		)
		
		at time Fin (
			Traveler.modifiers[#stretchSaltos].Stretch = stretchI
			Traveler.rotation.y = 0
		)
		
		for t in Inicio to Fin by 1 do
		(
			at time t
			(
				Traveler.pos = interpolacionCuadratica (t-Inicio) (Fin-Inicio) P1 P2 P3
			)
		)
		
	)
)

fn addStretch obj nombre = (
	for m in obj.modifiers do (
		if (m.name == nombre) do (
			deleteModifier obj m
		)
	)
	
	myStretch = Stretch()
	myStretch.name = nombre
	addmodifier obj myStretch	
)

rollout Saltos "Saltos" (
	group "Objetos" (
		label LActor "Actor:"
		button UI_SelectorActor "Selecciona actor y pulsa"
		label LObjetos "Puntos:"
		button UI_SelectorPuntos"Selecciona puntos y pulsa"
	)
	
	group "Squash and Stretch" (
		spinner UI_StretchS "Salida: " range:[-1,1,0.5] type:#Float
		spinner UI_StretchI "Colisión: " range:[-1,1,-0.25] type:#Float
		spinner UI_StretchL "Llegada: " range:[-1,1,0.4] type:#Float
	)
	
	group "Ángulo del salto" (
		spinner UI_AnguloS "Salida: " range:[-360,360,25] type:#Float
		spinner UI_AnguloL "Llegada: " range:[-360,360,-25] type:#Float
	)
	
	group "Animación" (
		spinner UI_IF "Comienzo: " range:[0,1000,0] type:#Integer
		spinner UI_FF "Duracion: " range:[5,1000,100] type:#Integer
	)
	
	button UI_CrearAnimacion "Crear animación"
	
	on UI_SelectorActor pressed do
	(
		objectsSelected = getCurrentSelection()
		
		if (objectsSelected.count == 0) then (
			UI_SelectorActor.text = "Selecciona al menos un objeto"
		) else (
			global Traveler = objectsSelected[1]
			UI_SelectorActor.text = Traveler.name
		)
	)
	
	on UI_SelectorPuntos pressed do
	(
		puntosSelected = getCurrentSelection()
		
		if (puntosSelected.count == 0) then (
			UI_SelectorPuntos.text = "Selecciona al menos un punto"
		) else (
			global puntos = #()
			for punto in puntosSelected do (
				append puntos punto
			)
			UI_SelectorPuntos.text = "Puntos establecidos"
		)
	)
	
	on UI_CrearAnimacion pressed do
	(
		if Traveler != undefined do
		(
			deletekeys Traveler
			Traveler.dir = [0,0,1]
			
			addStretch Traveler "stretchSaltos"
			
			inicio = UI_IF.value
			fin = UI_FF.value+inicio
			animationRange = interval 0 fin
			animate on (
				at time 0 ( 
					Traveler.pos = puntos[1].pos
					Traveler.modifiers[#stretchSaltos].Stretch = UI_StretchI.value
				)
			)
			
			intervalo = (fin-inicio)/(puntos.count-1) as integer
			fin = inicio+intervalo
			
			for i=1 to (puntos.count-1) do (
				pMedio = puntoMedio puntos[i].pos puntos[i+1].pos

				Animar Traveler puntos[i].pos pMedio puntos[i+1].pos \
					UI_StretchL.value UI_StretchI.value UI_StretchS.value \
					UI_AnguloL.value UI_AnguloS.value \
					inicio fin
				
				inicio = fin
				fin = inicio+intervalo
			)
			
			Traveler.showtrajectory = on
		)
    )
)

createDialog Saltos width:225 height:370 lockHeight:false lockWidth:false \
	style:#(#style_titlebar, #style_border, #style_sysmenu, \
		#style_minimizebox, #style_maximizebox, #style_resizing) 