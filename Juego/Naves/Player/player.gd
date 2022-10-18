class_name Player
extends RigidBody2D

enum ESTADO{SPAWN,VIVO,INVENCIBLE,MUERTO}

 ##Export
export var potenciar_motor:int =20
export var potenciar_rotacion:int =20
export var estela_maxima:int=150


##Atributos
var empuje:Vector2 =Vector2.ZERO
var direc_rotacion:int =0
var estado_actual:int =ESTADO.SPAWN

##Aributos Onready
onready var canion:canion=$canion
onready var laser:Rayolaser =$LaserBeam2D
onready var estela1 :estela=$posicionTrail/Trail2D
onready var estela2 :estela=$posicionTrail2/Trail2D
onready var Motor_SFX:Motor=$SFXMotor
onready var colisionador:CollisionShape2D=$CollisionShape2D


## Metodos 
func _ready() -> void:
	controlador_estado(estado_actual)

func _unhandled_input(event: InputEvent) -> void:
	if not esta_input_activo():
		return
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
	if not esta_input_activo():
		return
	
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

func controlador_estado(nuevo_estado:int)->void:
	match nuevo_estado:
		ESTADO.INVENCIBLE:
			colisionador.set_deferred("disabled",true)
		ESTADO.SPAWN:
			colisionador.set_deferred("disabled",true)
			canion.set_puede_disparar(false)
		ESTADO.VIVO:
			colisionador.set_deferred("disabled",false)
			canion.set_puede_disparar(true)
		ESTADO.MUERTO:
			colisionador.set_deferred("disabled",true)
			canion.set_puede_disparar(true)
			queue_free()
		_:
			print("Error de estado")
	estado_actual = nuevo_estado

func esta_input_activo()->bool:
	if estado_actual in [ESTADO.MUERTO,ESTADO.SPAWN]:
		return false
	return true 

##señales internas
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "spawn":
		controlador_estado(ESTADO.VIVO)
