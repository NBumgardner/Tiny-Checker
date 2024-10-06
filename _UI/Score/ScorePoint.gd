class_name ScorePoint
extends Node2D

var Back:Polygon2D
var Left:bool
var size:Vector2

func SetColor(c:Color):
	Back.color = c


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_index =-1
	var res:PackedVector2Array = PackedVector2Array()
	var d =  15
	if !Left:
		d = -15
	res.append(Vector2(-size.x/2-d,-size.y/2))
	res.append(Vector2(size.x/2-d,-size.y/2))
	res.append(Vector2(size.x/2+d,size.y/2))
	res.append(Vector2(-size.x/2+d,size.y/2))
	
	var ttt = Polygon2D.new()
	ttt.color = Color(0,0,0,1)
	ttt.polygon = res
	Back = ttt
	add_child(ttt)
	
	ttt =Line2D.new()
	ttt.points = res
	ttt.width = 3
	ttt.default_color = Color(1,1,1,1)
	ttt.closed = true
	add_child(ttt)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
