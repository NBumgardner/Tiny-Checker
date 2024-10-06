@tool
class_name BezierLine
extends Line2D





@export var Resolution:int = 20:
	set(value):
		dataUpdated = false
		Resolution = value
@export var Loop:bool =false:
	set(value):
		dataUpdated = false
		Loop = value
@export var PointList:PackedVector2Array = PackedVector2Array()
		
@export var dataUpdated:bool = false
var vertexs:PackedVector2Array = PackedVector2Array()



func _updateData():
	GenVertexs(PointList,Resolution,Loop,vertexs)
	points = vertexs
	closed = Loop
	dataUpdated = true

static func GenVertexs(p:PackedVector2Array,resolution:int,loop:bool,res:PackedVector2Array)->void:
	var t:int = p.size()/3
	if t<2:
		return 
	if loop:
		res.resize(t*resolution)
	else:
		res.resize((t-1)*resolution+1)
	for i in t-1:
		GenRawSegmentVertexs(p[i*3+1],p[i*3+2],p[i*3+3],p[i*3+4],resolution+1,res,i*resolution)
	if loop:
		GenRawSegmentVertexs(p[(t-1)*3+1],p[(t-1)*3+2],p[0],p[1],resolution+1,res,(t-1)*resolution)
	else:
		res[-1] = p[(t-1)*3+1]
		


static func GenSegmentVertexs(v1:Vector2,v2:Vector2,v3:Vector2,v4:Vector2,resolution:int,res:PackedVector2Array,offi:int = 0)->void:
	if resolution<1:
		resolution = 2
	var t:float = 0
	var dt:float = 1.0/(resolution-1)
	for i in resolution:
		res[i+offi] = v1.bezier_interpolate(v2,v3,v4,t)
		t+=dt

static func GenRawSegmentVertexs(v1:Vector2,v2:Vector2,v3:Vector2,v4:Vector2,resolution:int,res:PackedVector2Array,offi:int = 0)->void:
	if resolution<1:
		resolution = 2
	var t:float = 0
	var dt:float = 1.0/(resolution-1)
	for i in resolution-1:
		res[i+offi] = v1.bezier_interpolate(v2,v3,v4,t)
		t+=dt
	

func _ready() -> void:
	_updateData()



func _process(delta: float) -> void:
	if not dataUpdated:
		_updateData()
