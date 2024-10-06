@tool
class_name RoundSprite
extends Sprite2D


@export var Radin:float = 100:
	set(value):
		Radin = value
		var tem = value/500
		scale = Vector2(tem,tem)
@export var MainColor:Color = Color(1,1,1,1):
	set(value):
		MainColor = value
		self_modulate.r = value.r
		self_modulate.g = value.g
		self_modulate.b = value.b
		
@export var Apha:float = 1:
	set(value):
		Apha = value
		self_modulate.a = value
		
		
func _init(r:float = 100,c:Color = Color(1,1,1),a:float = 1):
	Radin = r
	MainColor = c
	Apha = a
	texture = load("res://Shape2D/RoundSprite/white_circle_1000x1000.png")
