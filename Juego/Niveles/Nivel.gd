class_name Nivel
extends Node2D
##Atributo Onready
onready var contenedor_proyectiles:Node
##metodo
func _ready() -> void:
	conectar_seniales()
	


##metodo custom
func conectar_seniales()-> void:
	Eventos.connect("disparo",self,"_on_disparo")


func crear_contenedores()-> void:
	contenedor_proyectiles = Node.new()
	contenedor_proyectiles.name="ContenedorProyectiles"
	add_child(contenedor_proyectiles)

func _on_disparo(proyectil:Proyectil) -> void:
	add_child(proyectil)
