class_name PawnPartical
extends Node2D

var initposition:Vector2
var initSpeed:Vector2
var rotateSpeed:float
var duration:float = 1
var g:float = 400
var firstFrame:bool = true

func _init(tl:Texture,tb:Texture,cl:Color,cb:Color):
	var tem = Sprite2D.new()
	tem.texture = tb
	tem.self_modulate = cb
	add_child(tem)
	tem = Sprite2D.new()
	tem.self_modulate = cl
	tem.texture = tl
	add_child(tem)

# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position+=initSpeed*delta
	if firstFrame:
		position = initposition
		firstFrame = false
	initSpeed.y+=g*delta
	if position.y>=0:
		Bounce()
	duration-=delta
	rotation+=rotateSpeed*delta
	if duration<=0:
		queue_free()
		
		
func Bounce():
	position.y = 0
	initSpeed.y *=-1
	initSpeed*=0.6
	
