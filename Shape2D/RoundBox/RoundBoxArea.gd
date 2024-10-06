@tool
class_name RoundBoxArea
extends Polygon2D


@export var Size:Vector2:
	set(value):
		dataUpdated = false
		Size = value
@export var Radin:float = 0:
	set(value):
		dataUpdated = false
		Radin = value
@export var CornerResolution:int = 5:
	set(value):
		dataUpdated = false
		CornerResolution = value

@export var dataUpdated:bool = false
var vertexs:PackedVector2Array = PackedVector2Array()



func _updateData():
	GenVertexs(Size,Radin,CornerResolution,vertexs)
	polygon = vertexs
	dataUpdated = true


static func GenVertexs(size:Vector2,radin:float,conerResolution:int,res:PackedVector2Array)->void:
	if (size.x<=radin*2 and size.y<radin*2):
		RoundArea.GenVertexs(UFM.MinVector2(size),conerResolution*4+4,res)
	elif (size.x<=radin*2 and size.y>radin*2):
		res.resize(6+conerResolution*4)
		GenConerVertex(0,size.x/2,Vector2(0,size.y/2),conerResolution+2,res,0)
		GenRawConerVertex(1,size.x/2,Vector2(0,-size.y/2),conerResolution+2,res,conerResolution+2)
		GenConerVertex(2,size.x/2,Vector2(0,-size.y/2),conerResolution+2,res,2*conerResolution+3)
		GenRawConerVertex(3,size.x/2,Vector2(0,size.y/2),conerResolution+2,res,3*conerResolution+5)
	elif (size.x>radin*2 and size.y<=radin*2):
		res.resize(6+conerResolution*4)
		GenRawConerVertex(0,size.y/2,Vector2(0,size.x/2),conerResolution+2,res,0)
		GenConerVertex(1,size.y/2,Vector2(0,size.x/2),conerResolution+2,res,conerResolution+1)
		GenRawConerVertex(2,size.y/2,Vector2(0,-size.x/2),conerResolution+2,res,2*conerResolution+3)
		GenConerVertex(3,size.y/2,Vector2(0,-size.x/2),conerResolution+2,res,3*conerResolution+4)
	else:
		res.resize(8+conerResolution*4)
		GenConerVertex(0,radin,Vector2(size.x/2-radin,size.y/2-radin),conerResolution+2,res,0)
		GenConerVertex(1,radin,Vector2(size.x/2-radin,-size.y/2+radin),conerResolution+2,res,conerResolution+2)
		GenConerVertex(2,radin,Vector2(-size.x/2+radin,-size.y/2+radin),conerResolution+2,res,2*conerResolution+4)
		GenConerVertex(3,radin,Vector2(-size.x/2+radin,size.y/2-radin),conerResolution+2,res,3*conerResolution+6)
		
		
		
static func GenConerVertex(dir:int,radin:float,position:Vector2,resolution:int,res:PackedVector2Array,offi:int)->void:
	var c:float = PI/2*dir
	var dc:float = PI/2/(resolution-1)
	for i in resolution:
		res[i+offi] = Vector2(sin(c),cos(c))*radin+position
		c+=dc
		
static func GenRawConerVertex(dir:int,radin:float,position:Vector2,resolution:int,res:PackedVector2Array,offi:int)->void:
	var c:float = PI/2*dir
	var dc:float = PI/2/(resolution-1)
	for i in resolution-1:
		res[i+offi] = Vector2(sin(c),cos(c))*radin+position
		c+=dc

func _ready() -> void:
	_updateData()



func _process(delta: float) -> void:
	if not dataUpdated:
		_updateData()
