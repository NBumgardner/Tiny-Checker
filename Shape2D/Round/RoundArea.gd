class_name RoundArea
extends Polygon2D



@export var Radin:float = 0:
	set(value):
		dataUpdated = false
		Radin = value
@export var Resolution:int = 20:
	set(value):
		dataUpdated = false
		Resolution = value

var dataUpdated:bool = false
var vertexs:PackedVector2Array = PackedVector2Array()



func _updateData():
	GenVertexs(Radin,Resolution,vertexs)
	polygon = vertexs
	dataUpdated = true

static func GenVertexs(radin:float,resolution:int,res:PackedVector2Array)->void:
	res.resize(resolution)
	var c = 0
	var dc = PI*2/resolution
	for i in resolution:
		res[i] = Vector2(sin(c),cos(c))*radin
		c += dc
	

func _ready() -> void:
	_updateData()



func _process(delta: float) -> void:
	if not dataUpdated:
		_updateData()
