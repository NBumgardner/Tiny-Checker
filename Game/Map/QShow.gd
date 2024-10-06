class_name QShow
extends Node2D


var apha:FloatLinerCounter
var pb:V2BounceCounter
var OnDestory:bool = false
var Delay:float = 0

func _init(p:Vector2,d:float = 0) -> void:
	apha = FloatLinerCounter.new()
	apha.End = 1
	apha.Start = 0
	apha.LinerTime = 0.2
	pb = V2BounceCounter.new()
	pb.Decay = 0.5
	pb.Speed = 0.9
	pb.End = p
	pb.Cur = p+Vector2(100,0)
	modulate = Color(1,1,1,0)
	Delay = d
	
func Destory(d:float = 0):
	OnDestory = true
	apha.End = 0
	apha.Start = 1
	apha.Reset()
	pb.End = pb.End+Vector2(-100,0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Delay>0:
		Delay-=delta
		if Delay<=0:
			SoundManager.PlaySound("BShow")
	else:
		if !apha.Finish:
			apha.Update(delta)
			modulate = Color(1,1,1,apha.Data())
		else :
			if Destory():
				queue_free()
		if !pb.Finish:
			pb.Update(delta)
			position = pb.Data()
		
