class_name Shower
extends Polygon2D


var f:FloatFollowCounter = FloatFollowCounter.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	f.Speed = 0.7
	SetRadin(0)



func Show():
	f.End = 2.5
	
func Hide():
	f.End= -0.1
	
func ShowInst():
	f.End = 2.5
	f.Cur = 2.5
	SetRadin(2.5)
	
func HideInst():
	f.End = -0.1
	f.Cur = -0.1
	SetRadin(0)
	
func SetRadin(r:float):
	var a:float = 0
	var da = PI/12
	var res = PackedVector2Array()
	for i in 24:
		res.append(UFV.V2Rotate(Vector2(0,500*r),a)+Vector2(1920/2,1080/2))
		a+=da
	polygon = res



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !f.Finish:
		f.Update(delta)
		var t = f.Data()
		if t<0:
			t = 0
		SetRadin(t)
