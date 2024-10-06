class_name MouseMain
extends Node2D


var line:Line2D
var back:Polygon2D
var follow:FloatFollowCounter
var RF:FloatFollowCounter
var mode1:PackedVector2Array
var mode2:PackedVector2Array
var mode:int = 1



func _init() -> void:
	z_index = 30
	back = Polygon2D.new()
	back.color = Color(0,0,0,1)
	add_child(back)
	
	line = Line2D.new()
	add_child(line)
	line.default_color = Color(1,1,1,1)
	line.width = 3
	line.closed = true
	follow = FloatFollowCounter.new()
	follow.Speed = 3
	RF= FloatFollowCounter.new()
	RF.Speed = 3
	GenV()

func GenV():
	var l :float= 60
	var t1 = Vector2(0,0)
	var t2 = UFV.V2Rotate(Vector2(l,0),PI/6)
	var t3 = UFV.V2Rotate(Vector2(l*1.25,0),PI*7/24)
	var t33 = UFV.V2Rotate(Vector2(l*0.75,0),PI*7/24)
	var t4 = UFV.V2Rotate(Vector2(0,l),-PI/12)
	mode1.append(t1)
	mode1.append(t2*0.6)
	mode1.append(t3*0.6)
	mode1.append(t4*0.6)
	mode2.append(t1)
	mode2.append(t2)
	mode2.append(t33)
	mode2.append(t4)


func Mode1():
	mode = 1
	follow.End = 1
	RF.End = 0
	
func Mode2(r:float = 0):
	mode = 2
	follow.End = 0
	RF.End = r
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Mode2()

func SetV(t:float):
	var res = PackedVector2Array()
	for i in mode1.size():
		res.append(mode1[i].lerp(mode2[i],t))
	line.points = res
	back.polygon = res
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !follow.Finish:
		follow.Update(delta)
		SetV(follow.Data())
	if !RF.Finish:
		RF.Update(delta)
		rotation = RF.Data()
		
