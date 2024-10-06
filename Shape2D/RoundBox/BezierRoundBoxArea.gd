@tool
class_name BezierRoundBoxArea
extends Polygon2D


@export var Size:Vector2:
	set(value):
		dataUpdated = false
		Size = value
@export var Radin:float = 0:
	set(value):
		dataUpdated = false
		Radin = value
@export var CornerWeight:Vector2= Vector2(0.7,0.7):
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

func SetRadin(radin:float):
	Radin = radin

func SetColor(c:Color):
	color = c


func _updateData():
	GenVertexs(Size,Radin,EdgeWeight,CornerWeight,EdgeResolution,CornerResolution,vertexs)
	polygon = vertexs
	dataUpdated = true


static func GenVertexs(size:Vector2,radin:float,edgeWeight:float,conerWeight:Vector2,bezierResolution:int,conerResolution:int,res:PackedVector2Array)->void:

	if (size.x<=radin*2 and size.y<radin*2):
		RoundArea.GenVertexs(UFM.MinVector2(size),conerResolution*4+4,res)
	elif (size.x<=radin*2 and size.y>radin*2):
		res.resize(conerResolution*4+bezierResolution*4+2)
		var ch:float = PI/4*conerWeight.y
		var tem:Vector2
		radin = size.x/2
		var tx = size.x/2-radin*1.7
		if tx<0:
			tx = 0
		var ty = size.y/2-radin*1.7
		if ty<0:
			ty = 0
		var edgeLepse = Vector2(tx/size.x*2,ty/size.y*2)
		GenRawConerVertex(0,0,ch,radin,Vector2(size.x/2-radin,size.y/2-radin),conerResolution+2,res,0)
		tem = Vector2(size.x/2-radin+cos(ch)*radin,size.y/2-radin+sin(ch)*radin)
		var dh:float = (size.x/2-tem.x)/tan(ch)
		BezierLine.GenSegmentVertexs(tem,Vector2(size.x/2,tem.y-dh),Vector2(size.x/2,(size.y/2-radin)*((1-edgeLepse.y)*edgeWeight+edgeLepse.y)),Vector2(size.x/2,(size.y/2-radin)*edgeLepse.y),bezierResolution,res,conerResolution+1)
		tem = Vector2(size.x/2-radin+cos(ch)*radin,-size.y/2+radin-sin(ch)*radin)
		BezierLine.GenRawSegmentVertexs(Vector2(size.x/2,(size.y/2-radin)*-edgeLepse.y),Vector2(size.x/2,(size.y/2-radin)*((1-edgeLepse.y)*-edgeWeight-edgeLepse.y)),Vector2(size.x/2,tem.y+dh),tem,bezierResolution,res,conerResolution+bezierResolution+1)
		GenRawConerVertex(1,ch,0,radin,Vector2(size.x/2-radin,-size.y/2+radin),conerResolution+2,res,conerResolution+bezierResolution*2)
		GenRawConerVertex(2,0,ch,radin,Vector2(-size.x/2+radin,-size.y/2+radin),conerResolution+2,res,conerResolution*2+bezierResolution*2+1)
		tem = Vector2(-size.x/2+radin-cos(ch)*radin,-size.y/2+radin-sin(ch)*radin)
		BezierLine.GenSegmentVertexs(tem,Vector2(-size.x/2,tem.y+dh),Vector2(-size.x/2,(size.y/2-radin)*((1-edgeLepse.y)*-edgeWeight-edgeLepse.y)),Vector2(-size.x/2,(size.y/2-radin)*-edgeLepse.y),bezierResolution,res,conerResolution*3+bezierResolution*2+2)
		tem = Vector2(-size.x/2+radin-cos(ch)*radin,size.y/2-radin+sin(ch)*radin)
		BezierLine.GenRawSegmentVertexs(Vector2(-size.x/2,(size.y/2-radin)*edgeLepse.y),Vector2(-size.x/2,(size.y/2-radin)*((1-edgeLepse.y)*edgeWeight+edgeLepse.y)),Vector2(-size.x/2,tem.y-dh),tem,bezierResolution,res,conerResolution*3+bezierResolution*3+2)
		GenRawConerVertex(3,ch,0,radin,Vector2(-size.x/2+radin,size.y/2-radin),conerResolution+2,res,conerResolution*3+bezierResolution*4+1)
		
	elif (size.x>radin*2 and size.y<=radin*2):
		res.resize(conerResolution*4+bezierResolution*4+2)
		var cw:float = PI/4*conerWeight.x
		var tem:Vector2
		radin = size.y/2
		tem = Vector2(size.x/2-radin+sin(cw)*radin,size.y/2-radin+cos(cw)*radin)
		var dw:float = (size.y/2-tem.y)/tan(cw)
		var tx = size.x/2-radin*1.7
		if tx<0:
			tx = 0
		var ty = size.y/2-radin*1.7
		if ty<0:
			ty = 0
		var edgeLepse = Vector2(tx/size.x*2,ty/size.y*2)
		BezierLine.GenRawSegmentVertexs(Vector2((size.x/2-radin)*edgeLepse.x,size.y/2),Vector2((size.x/2-radin)*((1-edgeLepse.x)*edgeWeight+edgeLepse.x),size.y/2),Vector2(tem.x-dw,size.y/2),tem,bezierResolution,res,0)
		GenRawConerVertex(0,cw,0,radin,Vector2(size.x/2-radin,size.y/2-radin),conerResolution+2,res,bezierResolution-1)
		GenRawConerVertex(1,0,cw,radin,Vector2(size.x/2-radin,-size.y/2+radin),conerResolution+2,res,conerResolution+bezierResolution)
		tem = Vector2(size.x/2-radin+sin(cw)*radin,-size.y/2+radin-cos(cw)*radin)
		BezierLine.GenSegmentVertexs(tem,Vector2(tem.x-dw,-size.y/2),Vector2((size.x/2-radin)*((1-edgeLepse.x)*edgeWeight+edgeLepse.x),-size.y/2),Vector2((size.x/2-radin)*edgeLepse.x,-size.y/2),bezierResolution,res,conerResolution*2+bezierResolution+1)
		tem = Vector2(-size.x/2+radin-sin(cw)*radin,-size.y/2+radin-cos(cw)*radin)
		BezierLine.GenRawSegmentVertexs(Vector2((size.x/2-radin)*-edgeLepse.x,-size.y/2),Vector2((size.x/2-radin)*((1-edgeLepse.x)*-edgeWeight-edgeLepse.x),-size.y/2),Vector2(tem.x+dw,-size.y/2),tem,bezierResolution,res,conerResolution*2+bezierResolution*2+1)
		GenRawConerVertex(2,cw,0,radin,Vector2(-size.x/2+radin,-size.y/2+radin),conerResolution+2,res,conerResolution*2+bezierResolution*3)
		GenRawConerVertex(3,0,cw,radin,Vector2(-size.x/2+radin,size.y/2-radin),conerResolution+2,res,conerResolution*3+bezierResolution*3+1)
		tem = Vector2(-size.x/2+radin-sin(cw)*radin,size.y/2-radin+cos(cw)*radin)
		BezierLine.GenSegmentVertexs(tem,Vector2(tem.x+dw,size.y/2),Vector2((size.x/2-radin)*((1-edgeLepse.x)*-edgeWeight-edgeLepse.x),size.y/2),Vector2((size.x/2-radin)*-edgeLepse.x,size.y/2),bezierResolution,res,conerResolution*4+bezierResolution*3+2)

	else:
		res.resize(8*bezierResolution+conerResolution*4)
		var ch:float = PI/4*conerWeight.y
		var cw:float = PI/4*conerWeight.x
		var tem:Vector2
		tem = Vector2(size.x/2-radin+sin(cw)*radin,size.y/2-radin+cos(cw)*radin)
		var dw:float = (size.y/2-tem.y)/tan(cw)
		var tx = size.x/2-radin*1.7
		if tx<0:
			tx = 0
		var ty = size.y/2-radin*1.7
		if ty<0:
			ty = 0
		var edgeLepse = Vector2(tx/size.x*2,ty/size.y*2)
		BezierLine.GenRawSegmentVertexs(Vector2((size.x/2-radin)*edgeLepse.x,size.y/2),Vector2((size.x/2-radin)*((1-edgeLepse.x)*edgeWeight+edgeLepse.x),size.y/2),Vector2(tem.x-dw,size.y/2),tem,bezierResolution,res,0)
		GenRawConerVertex(0,cw,ch,radin,Vector2(size.x/2-radin,size.y/2-radin),conerResolution+2,res,bezierResolution-1)
		tem = Vector2(size.x/2-radin+cos(ch)*radin,size.y/2-radin+sin(ch)*radin)
		var dh:float = (size.x/2-tem.x)/tan(ch)
		BezierLine.GenSegmentVertexs(tem,Vector2(size.x/2,tem.y-dh),Vector2(size.x/2,(size.y/2-radin)*((1-edgeLepse.y)*edgeWeight+edgeLepse.y)),Vector2(size.x/2,(size.y/2-radin)*edgeLepse.y),bezierResolution,res,conerResolution+bezierResolution)
		tem = Vector2(size.x/2-radin+cos(ch)*radin,-size.y/2+radin-sin(ch)*radin)
		BezierLine.GenRawSegmentVertexs(Vector2(size.x/2,(size.y/2-radin)*-edgeLepse.y),Vector2(size.x/2,(size.y/2-radin)*((1-edgeLepse.y)*-edgeWeight-edgeLepse.y)),Vector2(size.x/2,tem.y+dh),tem,bezierResolution,res,conerResolution+bezierResolution*2)
		GenRawConerVertex(1,ch,cw,radin,Vector2(size.x/2-radin,-size.y/2+radin),conerResolution+2,res,conerResolution+bezierResolution*3-1)
		tem = Vector2(size.x/2-radin+sin(cw)*radin,-size.y/2+radin-cos(cw)*radin)
		BezierLine.GenSegmentVertexs(tem,Vector2(tem.x-dw,-size.y/2),Vector2((size.x/2-radin)*((1-edgeLepse.x)*edgeWeight+edgeLepse.x),-size.y/2),Vector2((size.x/2-radin)*edgeLepse.x,-size.y/2),bezierResolution,res,conerResolution*2+bezierResolution*3)
		tem = Vector2(-size.x/2+radin-sin(cw)*radin,-size.y/2+radin-cos(cw)*radin)
		BezierLine.GenRawSegmentVertexs(Vector2((size.x/2-radin)*-edgeLepse.x,-size.y/2),Vector2((size.x/2-radin)*((1-edgeLepse.x)*-edgeWeight-edgeLepse.x),-size.y/2),Vector2(tem.x+dw,-size.y/2),tem,bezierResolution,res,conerResolution*2+bezierResolution*4)
		GenRawConerVertex(2,cw,ch,radin,Vector2(-size.x/2+radin,-size.y/2+radin),conerResolution+2,res,conerResolution*2+bezierResolution*5-1)
		tem = Vector2(-size.x/2+radin-cos(ch)*radin,-size.y/2+radin-sin(ch)*radin)
		BezierLine.GenSegmentVertexs(tem,Vector2(-size.x/2,tem.y+dh),Vector2(-size.x/2,(size.y/2-radin)*((1-edgeLepse.y)*-edgeWeight-edgeLepse.y)),Vector2(-size.x/2,(size.y/2-radin)*-edgeLepse.y),bezierResolution,res,conerResolution*3+bezierResolution*5)
		tem = Vector2(-size.x/2+radin-cos(ch)*radin,size.y/2-radin+sin(ch)*radin)
		BezierLine.GenRawSegmentVertexs(Vector2(-size.x/2,(size.y/2-radin)*edgeLepse.y),Vector2(-size.x/2,(size.y/2-radin)*((1-edgeLepse.y)*edgeWeight+edgeLepse.y)),Vector2(-size.x/2,tem.y-dh),tem,bezierResolution,res,conerResolution*3+bezierResolution*6)
		GenRawConerVertex(3,ch,cw,radin,Vector2(-size.x/2+radin,size.y/2-radin),conerResolution+2,res,conerResolution*3+bezierResolution*7-1)
		tem = Vector2(-size.x/2+radin-sin(cw)*radin,size.y/2-radin+cos(cw)*radin)
		BezierLine.GenSegmentVertexs(tem,Vector2(tem.x+dw,size.y/2),Vector2((size.x/2-radin)*((1-edgeLepse.x)*-edgeWeight-edgeLepse.x),size.y/2),Vector2((size.x/2-radin)*-edgeLepse.x,size.y/2),bezierResolution,res,conerResolution*4+bezierResolution*7)
		
		
static func GenConerVertex(dir:int,offc:float,offcE:float,radin:float,position:Vector2,resolution:int,res:PackedVector2Array,offi:int)->void:
	var c:float = PI/2*dir+offc
	var dc:float = (PI/2-offc-offcE)/(resolution-1)
	for i in resolution:
		res[i+offi] = Vector2(sin(c),cos(c))*radin+position
		c+=dc
		
static func GenRawConerVertex(dir:int,offc:float,offcE:float,radin:float,position:Vector2,resolution:int,res:PackedVector2Array,offi:int)->void:
	var c:float = PI/2*dir+offc
	var dc:float = (PI/2-offc-offcE)/(resolution-1)
	for i in resolution-1:
		res[i+offi] = Vector2(sin(c),cos(c))*radin+position
		c+=dc


func _ready() -> void:
	_updateData()



func _process(delta: float) -> void:
	if not dataUpdated:
		_updateData()
