class_name Motor
extends AudioStreamPlayer2D

##Export
export var tiempo_transicion: float= 0.6
export var volumen_apagado :float = -30.0

##atributos onready
onready var tween_sonido:Tween=$Tween

##atributos
var volumen_original:float


##Metodos
func _ready() -> void:
	volumen_original=volume_db
	volume_db=volumen_apagado

func sonido_on() -> void:
	if not playing :
		play()
	efecto_transicion(volume_db,volumen_original)

func sonido_off() -> void:
	efecto_transicion(volume_db,volumen_apagado)

func efecto_transicion(desde_Vol:float,hasta_vol:float) -> void:
	tween_sonido.interpolate_property(self,"volume_db",desde_Vol,hasta_vol,tiempo_transicion,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	tween_sonido.start()
