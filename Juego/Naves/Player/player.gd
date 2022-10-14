class_name Player
extends RigidBody2D
 ##Export
export var potenciar_motor:int =20
export var potenciar_rotacion:int =20
export var estela_maxima:int=150


##Atributos
var empuje:Vector2 =Vector2.ZERO
var direc_rotacion:int =0

##Aributos Onready
onready var canion:canion=$canion
onready var laser:Rayolaser =$LaserBeam2D
onready var estela1 :estela=$posicionTrail/Trail2D
onready var estela2 :estela=$posicionTrail2/Trail2D
onready var Motor_SFX:Motor=$SFXMotor


## Metodos 
func _unhandled_input(event: InputEvent) -> void:
	#Disparo Rayo
	if event.is_action_pressed("disparo secundario"):
		laser.set_is_casting(true)
	
	if event.is_action_released("disparo secundario"):
		laser.set_is_casting(false)
	
	##Control Estela1
	if event.is_action_pressed("mover_adelante"):
		estela1.set_max_points(estela_maxima)
	elif event.is_action_pressed("mover_atras"):
		estela1.set_max_points(0)
		
	
	##control Estela2
	if event.is_action_pressed("mover_adelante"):
		estela2.set_max_points(estela_maxima)
		Motor_SFX.sonido_on()
	elif event.is_action_pressed("mover_atras"):
		estela2.set_max_points(0)
		Motor_SFX.sonido_on()
	if (event.is_action_released("mover_adelante")or event.is_action_released("mover_atras")):
		Motor_SFX.sonido_off()




func _integrate_forces(_state: Physics2DDirectBodyState) -> void:
	rad2deg(rotation)
	empuje.rotated(rotation)
	apply_central_impulse(empuje.rotated(rotation))
	apply_torque_impulse(direc_rotacion * potenciar_rotacion)


func _process(_delta: float) -> void:
	player_input()
	


## Metodos custom
func player_input()-> void:
	##empuje
	empuje = Vector2.ZERO
	if Input.is_action_pressed("mover_adelante"):
		empuje=Vector2(potenciar_motor,0)
	elif Input.is_action_pressed("mover_atras"):
		empuje=Vector2(-potenciar_motor,0)
	##rotacion 
	direc_rotacion = 0 
	if  Input.is_action_pressed("rotar_antihorario"):
		direc_rotacion -=1
	elif Input.is_action_pressed("rotar_horario"):
		direc_rotacion +=1
	##disparo 
	if Input.is_action_pressed("disparo_principal"):
		canion.set_esta_disparando(true)
	if Input.is_action_just_released("disparo_principal"):
		canion.set_esta_disparando(false)
