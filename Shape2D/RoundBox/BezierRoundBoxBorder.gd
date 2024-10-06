@tool
class_name BezierRoundBoxBorder
extends Line2D


@export var Size:Vector2:
	set(value):
		dataUpdated = false
		Size = value
@export var Radin:float = 0:
	set(value):
		dataUpdated = false
		Radin = value
@export var CornerWeight:Vector2 = Vector2(0.7,0.7):
	set(value):
		dataUpdated = false
		CornerWeight = value
@export var EdgeWeight:float = 0.3:
	set(value):
		dataUpdated = false
		EdgeWeight = value
@export var CornerResolution:int = 5:
	set(value):
		dataUpdated = false
		CornerResolution = value
@export var EdgeResolution:int = 8:
	set(value):
		dataUpdated = false
		EdgeResolution = value

@export var dataUpdated:bool = false
var vertexs:PackedVector2Array = PackedVector2Array()



func SetSize(size:Vector2):
	if size.x<=0 or size.y<=0:
		visible = false
	else:
		visible = true
		Size = size
		
func SetRadin(r:float):
	Radin = r
	
func SetColor(c:Color):
	default_color = c

func _updateData():
	BezierRoundBoxArea.GenVertexs(Size,Radin,EdgeWeight,CornerWeight,EdgeResolution,CornerResolution,vertexs)
	points = vertexs
	dataUpdated = true


func _ready() -> void:
	closed = true
	_updateData()



func _process(delta: float) -> void:
	if not dataUpdated:
		_updateData()
