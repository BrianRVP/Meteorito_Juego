class_name canion
extends Node2D

##Atriburos_Export
export var proyectil:PackedScene=null
export var  cadencia_Disparo:float=0.7
export var  velocidad_proyectil:int =100
export var  danio_Proyectil:int=1 

##Atributos_onready
onready var timer_Enfriamiento :Timer=$TimerDeEnfriamiento
onready var disparoSFx : AudioStreamPlayer2D =$DisparoSFX
onready var esta_enfriado :bool =true
onready var esta_disparando:bool =false  setget set_esta_disparando

##Atributos
var puntos_disparos :Array=[]
var puede_disparar:bool=false setget set_puede_disparar

#setters y getters
func set_esta_disparando(disparando:bool)-> void:
	esta_disparando=disparando
func set_puede_disparar(duenio_puede:bool)->void:
	puede_disparar=duenio_puede
	

##Metodos
func _ready() -> void:
	almacenar_puntos_disparo()
	timer_Enfriamiento.wait_time=cadencia_Disparo

func _process(_delta: float) -> void:
	if esta_disparando and esta_enfriado:
		disparar()

##metodos custom 
func almacenar_puntos_disparo()-> void:
	for nodo in get_children():
		if nodo is Position2D:
			puntos_disparos.append(nodo)

func disparar()-> void:
	esta_enfriado=false
	timer_Enfriamiento.start()
	#disparoSFx.play()#opcion1
	for punto_disparo in puntos_disparos:
		disparoSFx.play()#opcion2
		var new_proyectil:Proyectil=proyectil.instance()
		new_proyectil.crear(punto_disparo.global_position,get_owner().rotation,velocidad_proyectil,danio_Proyectil)
		Eventos.emit_signal("disparo",new_proyectil)
		


func _on_TimerDeEnfriamiento_timeout() -> void:
	esta_enfriado = true
