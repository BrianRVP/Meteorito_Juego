class_name Player
extends RigidBody2D
 
export var potenciar_motor:int =20
export var potenciar_rotacion:int =20

var empuje:Vector2 =Vector2.ZERO
var direc_rotacion:int =0

## Metodos 
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	rad2deg(rotation)
	empuje.rotated(rotation)
	apply_central_impulse(empuje.rotated(rotation))
	apply_torque_impulse(direc_rotacion * potenciar_rotacion)






func _process(delta: float) -> void:
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
