class_name MousePart
extends Node2D

var line:Line2D
var back:Polygon2D
var follow:V2BounceCounter
var RF:FloatFollowCounter


func _init() -> void:
	var res = PackedVector2Array()
	var l :float= 15
	var t1 = Vector2(0,0)
	var t2 = UFV.V2Rotate(Vector2(l,0),PI/6)
	var t3 = UFV.V2Rotate(Vector2(l*1.25,0),PI*7/24)
	var t4 = UFV.V2Rotate(Vector2(0,l),-PI/12)
	res.append(t1)
	res.append(t2)
	res.append(t3)
	res.append(t4)
	
	z_index = 29
	back = Polygon2D.new()
	back.color = Color(0,0,0,1)
	add_child(back)
	back.polygon = res
	
	line = Line2D.new()
	add_child(line)
	line.default_color = Color(1,1,1,1)
	line.width = 3
	line.closed = true
	line.points = res
	follow = V2BounceCounter.new()
	follow.Decay = 1.2
	RF= FloatFollowCounter.new()
	RF.Speed = 3

# Called when the node enters the scene tree for the first time.
func SetData(p:Vector2,r:float):
	RF.End = r
	follow.End = p

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !follow.Finish:
		follow.Update(delta)
		position = follow.Data()
	if !RF.Finish:
		RF.Update(delta)
		rotation = RF.Data()
